import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../models/car.dart';
import '../providers/car_provider.dart';

class CarDetailScreen extends StatelessWidget {
  final int carId;
  const CarDetailScreen({super.key, required this.carId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Details')),
      body: Consumer<CarProvider>(
        builder: (_, provider, __) {
          final Car? car = provider.getCarById(carId);
          if (car == null) {
            return const Center(child: Text('Car not found'));
          }

          final bool isTracked = provider.trackedCarId == carId;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
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
    );
  }
}

