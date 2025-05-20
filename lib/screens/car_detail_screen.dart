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
      appBar: AppBar(title: const Text('Car Details')),
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
                children: [
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
                            backgroundColor: Theme
                                .of(context)
                                .cardColor,
                            radius: 25,
                            child: Icon(
                              FeatherIcons.user,
                              size: 25,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(width: Constants.kDefaultPadding),
                          Text(
                            '${car.name} Details',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  // ── Info row ───────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(car.name,
                          style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Chip(
                        label: Text(car.status),
                        backgroundColor:
                        car.status == 'Moving' ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.speed, size: 18),
                      const SizedBox(width: 4),
                      Text('${car.speed.toStringAsFixed(0)} km/h'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Mini‑map ──────────────────────────────────────────
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
                  const Spacer(),

                  // ── Track / Stop button ──────────────────────────────
                  ElevatedButton.icon(
                    onPressed: () {
                      if (isTracked) {
                        provider.stopTracking();
                      } else {
                        provider.trackCar(carId);
                        Navigator.pop(context); // go back to map
                      }
                    },
                    icon: Icon(isTracked ? Icons.pause : Icons.play_arrow),
                    label: Text(isTracked ? 'Stop Tracking' : 'Track This Car'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
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

