import 'package:fleet_monitoring_app/core/routes/app_route.dart';
import 'package:fleet_monitoring_app/screens/components/search_widget.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../core/config/constants.dart';
import '../core/config/preferences.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';
import 'car_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  String _searchQuery = '';
  String? _statusFilter; // 'Moving', 'Parked', or null
  CameraPosition _initialCamera =
  const CameraPosition(target: LatLng(-1.95, 30.06), zoom: 13);

  // preload marker icons
  late BitmapDescriptor _movingIcon;
  late BitmapDescriptor _parkedIcon;

  // ── Restore last camera pos ──────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
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
    _movingIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    _parkedIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  }


  // ── Persist camera pos on move ───────────────────────────────────────────
  void _onCameraMove(CameraPosition position) {
    Preferences.setLastMapPosition(
      position.target.latitude,
      position.target.longitude,
      position.zoom,
    );
  }

  // ── Build marker set ─────────────────────────────────────────────────────
  Set<Marker> _buildMarkers(List<Car> cars) {
    return cars.map((car) {
      final icon = car.status == 'Moving' ? _movingIcon : _parkedIcon;
      return Marker(
        markerId: MarkerId(car.id.toString()),
        position: LatLng(car.latitude, car.longitude),
        infoWindow: InfoWindow(title: car.name, snippet: '${car.speed} km/h'),
        icon: icon,
        onTap: () {
          Navigator.pushNamed(context,
              AppRoute.carDetail, arguments: car.id);
        },
      );
    }).toSet();
  }

  // ── Search + filter logic ────────────────────────────────────────────────
  List<Car> _applySearchAndFilter(List<Car> cars) {
    final provider = context.read<CarProvider>();

    List<Car> list = provider.search(_searchQuery);
    if (_statusFilter != null) {
      list = list.where((c) => c.status == _statusFilter).toList();
    }
    return list;
  }

  // ── Follow tracked car ───────────────────────────────────────────────────
  void _maybeFollowTracked(CarProvider provider) {
    final id = provider.trackedCarId;
    if (id == null || _mapController == null) return;
    final car = provider.getCarById(id);
    if (car == null) return;

    _mapController!.animateCamera(
      CameraUpdate.newLatLng(LatLng(car.latitude, car.longitude)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Let provider know our BuildContext so it can show toasts if needed
    context.read<CarProvider>().setContext(context);
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer<CarProvider>(
          builder: (_, provider, __) {
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
              
                  // SEARCH BAR
                  Positioned(
                    top: Constants.kDefaultPadding,
                    left: Constants.kDefaultPadding,
                    right: Constants.kDefaultPadding,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Constants.kDefaultPadding),
                      child: Row(
                        children: [
                          Expanded(
                            child: SearchWidget(
                              hintText: 'Search a car by name or ID',
                              keyboardType: TextInputType.name,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                                ),
                                onPressed: () {},
                              ),
                              onChanged: (v) => setState(() => _searchQuery = v),
              
                              validator: (String? value) {},
                            ),
                          ),
                          const SizedBox(width: Constants.kDefaultPadding,),
                          // ── FILTER BUTTON ──────────────────────────────────────
                          Positioned(
                            top: 80,
                            right: 16,
                            child: FloatingActionButton.small(
                              heroTag: 'filterBtn',
                              backgroundColor:  Theme.of(context).cardColor,
                              onPressed: () async {
                                final choice = await showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Theme.of(context).cardColor,
                                  builder: (BuildContext context) {
                                    return  _FilterSheet(current: _statusFilter);
                                  },
                                );
              
                                if (choice != null) {
                                  setState(() => _statusFilter = choice == 'All'
                                      ? null
                                      : choice);
                                }
                              },
                              child: const Icon(Icons.filter_list,color: Colors.white, ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              
                  // if (provider.isLoading)
                  //   const Positioned(
                  //     bottom: 20,
                  //     left: 0,
                  //     right: 0,
                  //     child: Center(child: CircularProgressIndicator()),
                  //   ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom‑sheet for status filter
// ─────────────────────────────────────────────────────────────────────────────
class _FilterSheet extends StatelessWidget {
  final String? current;

  const _FilterSheet({required this.current});

  @override
  Widget build(BuildContext context) {
    final items = ['All', 'Moving', 'Parked'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items.map((e) {
        return ListTile(
          // leading: ,
          title: Text(e, style: Theme.of(context).textTheme.bodyMedium),
          trailing:
          current == (e == 'All' ? null : e) ? const Icon(Icons.check) : null,
          onTap: () => Navigator.pop(context, e),
        );
      }).toList(),
    );
  }
}
