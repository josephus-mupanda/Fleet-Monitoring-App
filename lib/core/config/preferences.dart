import 'package:shared_preferences/shared_preferences.dart';
import '../models/car.dart';
import 'dart:convert';

class Preferences {
  static SharedPreferences? _preferences;

  // Keys
  static const _keyCachedCars = 'cached_cars';
  static const _keyThemeMode = 'theme_mode';
  static const _keyLastLocationLat = 'last_location_lat';
  static const _keyLastLocationLng = 'last_location_lng';
  static const _keyLastLocationZoom = 'last_location_zoom';

  // Initialize
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Cars data
  static Future setCachedCars(List<Car> cars) async {
    final carsJson = cars.map((car) => jsonEncode({
      'id': car.id,
      'name': car.name,
      'latitude': car.latitude,
      'longitude': car.longitude,
      'speed': car.speed,
      'status': car.status,
      'lastUpdated': car.lastUpdated.toIso8601String(),
    })).toList();

    await _preferences?.setStringList(_keyCachedCars, carsJson);
  }

  static Future<List<Car>?> getCachedCars() async {
    final carsJson = _preferences?.getStringList(_keyCachedCars);
    if (carsJson == null) return null;

    return carsJson.map((jsonString) {
      final json = jsonDecode(jsonString);
      return Car(
        id: json['id'],
        name: json['name'],
        latitude: json['latitude'].toDouble(),
        longitude: json['longitude'].toDouble(),
        speed: json['speed'].toDouble(),
        status: json['status'],
        lastUpdated: DateTime.parse(json['lastUpdated']),
      );
    }).toList();
  }

  // Theme
  static Future setThemeMode(bool isDark) async {
    await _preferences?.setBool(_keyThemeMode, isDark);
  }

  static bool? getThemeMode() {
    return _preferences?.getBool(_keyThemeMode);
  }

  // Map position
  static Future setLastMapPosition(double lat, double lng, double zoom) async {
    await _preferences?.setDouble(_keyLastLocationLat, lat);
    await _preferences?.setDouble(_keyLastLocationLng, lng);
    await _preferences?.setDouble(_keyLastLocationZoom, zoom);
  }

  static Map<String, double>? getLastMapPosition() {
    final lat = _preferences?.getDouble(_keyLastLocationLat);
    final lng = _preferences?.getDouble(_keyLastLocationLng);
    final zoom = _preferences?.getDouble(_keyLastLocationZoom);

    if (lat == null || lng == null || zoom == null) return null;

    return {
      'lat': lat,
      'lng': lng,
      'zoom': zoom,
    };
  }

  // Clear all preferences
  static Future clear() async {
    await _preferences?.clear();
  }
}