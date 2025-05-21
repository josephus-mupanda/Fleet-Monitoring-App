import 'package:fleet_monitoring_app/core/routes/app_route.dart';
import 'package:fleet_monitoring_app/core/utils/images.dart';
import 'package:fleet_monitoring_app/screens/components/search_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../core/config/constants.dart';
import '../core/config/preferences.dart';
import '../core/utils/loading.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  bool _iconsReady = false;
  String _searchQuery = '';
  String? _statusFilter; // 'Moving', 'Parked', or null
  CameraPosition _initialCamera = const CameraPosition(target: LatLng(-1.95, 30.06), zoom: 13);

  // preload marker icons
  BitmapDescriptor _movingIcon  = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _parkedIcon  = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _trackedIcon = BitmapDescriptor.defaultMarker;

  // ── Restore last camera pos
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoadingDialog(context);

    });
    _loadIcons();
    final pos = Preferences.getLastMapPosition();
    if (pos != null) {
      _initialCamera = CameraPosition(
        target: LatLng(pos['lat']!, pos['lng']!),
        zoom: pos['zoom']!,
      );
    }
  }

  Future<void> _loadIcons() async {
    if (kIsWeb) {
      _movingIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(48, 48)), ImagePath.movingCar,);
      _parkedIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(48, 48)), ImagePath.parkedCar,);
      _trackedIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(48, 48)), ImagePath.trackedCar,);

    } else {
      _movingIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      _parkedIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
      _trackedIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    }
    if (context.mounted) Navigator.of(context).pop();
    setState(() => _iconsReady = true);
  }

  // Persist camera pos on move
  void _onCameraMove(CameraPosition position) {
    Preferences.setLastMapPosition(
      position.target.latitude,
      position.target.longitude,
      position.zoom,
    );
  }

  // Build marker set
  Set<Marker> _buildMarkers(List<Car> cars) {
    final provider = context.read<CarProvider>();
    final trackedId = provider.trackedCarId;

    return cars.map((car) {
      final isTracked = car.id == trackedId;
      final icon = isTracked
          ? _trackedIcon
          : car.status == 'Moving'
          ? _movingIcon
          : _parkedIcon;

      return Marker(
        markerId: MarkerId(car.id.toString()),
        position: LatLng(car.latitude, car.longitude),
        infoWindow: InfoWindow(title: car.name, snippet: '${car.speed} km/h'),
        icon: icon,
        onTap: () {
          Navigator.pushNamed(context, AppRoute.carDetail, arguments: car.id);
        },
      );
    }).toSet();
  }

  // Search + filter logic
  List<Car> _applySearchAndFilter(List<Car> cars) {
    final provider = context.read<CarProvider>();

    List<Car> list = provider.search(_searchQuery);
    if (_statusFilter != null) {
      list = list.where((c) => c.status == _statusFilter).toList();
    }
    return list;
  }

  // Follow tracked car
  void _maybeFollowTracked(CarProvider provider) {
    final id = provider.trackedCarId;
    if (id == null || _mapController == null) return;

    final car = provider.getCarById(id);
    if (car == null) return;

    _mapController!.animateCamera(
      CameraUpdate.newLatLng(LatLng(car.latitude, car.longitude),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    context.read<CarProvider>().setContext(context);

    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer<CarProvider>(
          builder: (context, provider, __) {
            _maybeFollowTracked(provider);
            final cars = _applySearchAndFilter(provider.cars);
            return RefreshIndicator(
              onRefresh: () async {
                await provider.fetchCars(context);
              },
              child: Stack(
                children: [
                  ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        // MAP
                        child: GoogleMap(
                          initialCameraPosition: _initialCamera,
                          myLocationEnabled: true,
                          markers: _buildMarkers(cars),
                          onMapCreated: (c) => _mapController = c,
                          onCameraMove: _onCameraMove,
                        ),
                      ),
                    ],
                  ),

                  //SEARCH BAR
                  Positioned(
                    top: Constants.kDefaultPadding,
                    left: Constants.kDefaultPadding,
                    right: Constants.kDefaultPadding + 56,
                    child: SearchWidget(
                      hintText: 'Search by name or ID',
                      keyboardType: TextInputType.text,
                      onChanged: (v) => setState(() => _searchQuery = v),
                    ),
                  ),

                  // FILTER FAB
                  Positioned(
                    top: Constants.kDefaultPadding,
                    right: Constants.kDefaultPadding,
                    child: FloatingActionButton.small(
                      heroTag: 'filterBtn',
                      backgroundColor: theme.cardColor,
                      onPressed: () async {
                        final choice = await showModalBottomSheet<String?>(
                          context: context,
                          backgroundColor: theme.cardColor,
                          builder: (_) => _FilterSheet(current: _statusFilter),
                        );
                        if (choice != null) {
                          setState(() =>
                          _statusFilter = choice == 'All' ? null : choice);
                        }
                      },
                      child: Icon(Icons.filter_list,
                          color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Bottom‑sheet for status filter
// -----------------------------
class _FilterSheet extends StatelessWidget {
  final String? current;
  const _FilterSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('All', Icons.list_alt, Colors.orange),
      ('Moving', Icons.directions_car_filled, Colors.green),
      ('Parked', Icons.directions_car_filled, Colors.blue),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items.map((e) {
          final label = e.$1;
          final icon = e.$2;
          final color = e.$3;
          final selected = current == (label == 'All' ? null : label);

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
            trailing: selected ? Icon(Icons.check, color: color) : null,
            onTap: () => Navigator.pop(context, label),
          );
        }).toList(),
      ),
    );
  }
}
