import 'package:fleet_monitoring_app/screens/components/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../core/config/constants.dart';
import '../models/car.dart';
import '../providers/car_provider.dart';

class CarDetailScreen extends StatelessWidget {
  final String carId;
  const CarDetailScreen({super.key, required this.carId});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints(maxWidth: Constants.kMaxWidth ?? double.infinity),
        child: Consumer<CarProvider>(
          builder: (_, provider, __) {
            final Car? car = provider.getCarById(carId);
            if (car == null) {
              return const Center(child: Text('Car not found'));
            }
            final bool isTracked = provider.trackedCarId == carId;
            return SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Padding(
                      padding: const EdgeInsets.all(Constants.kDefaultPadding/2),
                      child: Row(
                        children: [
                          BackButton(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                          CircleAvatar(
                            backgroundColor: Theme.of(context).cardColor,
                            radius: 25,
                            child: Icon(
                              Icons.directions_car_filled,
                              size: 25,
                              color:  car.status == 'Moving' ? Colors.green : Colors.blue
                            ),
                          ),
                          const SizedBox(width: Constants.kDefaultPadding),
                          Text(
                            "${car.name}'s Details",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          Chip(
                            label: Text(car.status,
                              style: TextStyle(
                                color: car.status == 'Moving' ?
                                Colors.green : Colors.blue
                              ),
                            ),
                            backgroundColor: car.status == 'Moving' ? Colors.green.withOpacity(0.15) : Colors.blue.withOpacity(0.15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ── Info row ───────────────────────────────────────────
                  Expanded(
                    child: Container(
                      height: size.height,
                      width: size.width,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Constants.kDefaultPadding),
                        child: ListView(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.speed, size: 18),
                                const SizedBox(width: 4),
                                Text('${car.speed.toStringAsFixed(0)} km/h'),
                              ],
                            ),
                            const SizedBox(height: Constants.kDefaultPadding),
                            SizedBox(
                              height: 200,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(car.latitude, car.longitude),
                                  zoom: 16,
                                ),
                                markers: {
                                  Marker(
                                    markerId: MarkerId(car.id.toString()),
                                    position: LatLng(car.latitude, car.longitude),
                                    infoWindow: InfoWindow(title: car.name),
                                  ),
                                },
                                zoomControlsEnabled: false,
                                myLocationButtonEnabled: false,
                                liteModeEnabled: true, // lightweight map
                              ),
                            ),
                            const SizedBox(height: Constants.kDefaultPadding),
                            const Spacer(),
                            // ── Track / Stop button ──────────────────────────────
                            AppButton(
                              onPressed: (){
                                if (isTracked) {
                                  provider.stopTracking();
                                } else {
                                  provider.trackCar(carId);
                                  Navigator.pop(context);
                                }
                              },
                              color: isTracked? Theme.of(context).primaryColor: Theme.of(context).colorScheme.background,
                              text: isTracked ? 'Stop Tracking' : 'Track This Car',
                            )
                          ],
                        ),
                      ),
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

