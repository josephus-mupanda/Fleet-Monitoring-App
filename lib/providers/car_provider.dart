import 'package:flutter/material.dart';
import '../models/car.dart';
import '../services/api_service.dart';
import '../services/preferences.dart';

class CarProvider with ChangeNotifier {
  List<Car> _cars = [];
  bool _isLoading = false;
  String? _error;
  String? _trackedCarId;

  List<Car> get cars => _cars;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get trackedCarId => _trackedCarId;

  final ApiService _apiService = ApiService();

  CarProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadCachedData();
    _startPolling();
  }

  Future<void> _loadCachedData() async {
    try {
      final cachedCars = await Preferences.getCachedCars();
      if (cachedCars != null && cachedCars.isNotEmpty) {
        _cars = cachedCars;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cached data: $e');
    }
  }

  void _startPolling() {
    fetchCars();
    Timer.periodic(AppConfig.locationUpdateInterval, (timer) => fetchCars());
  }

  Future<void> fetchCars() async {
    _setLoading(true);

    try {
      final newCars = await _apiService.fetchCars();
      _cars = newCars;
      _error = null;
      await Preferences.setCachedCars(newCars);
    } catch (e) {
      _error = e.toString();
      if (_cars.isEmpty) {
        final cachedCars = await Preferences.getCachedCars();
        if (cachedCars != null) {
          _cars = cachedCars;
        }
      }
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void trackCar(String carId) {
    _trackedCarId = carId;
    notifyListeners();
  }

  void stopTracking() {
    _trackedCarId = null;
    notifyListeners();
  }

  List<Car> filterCars(String? status) {
    if (status == null) return _cars;
    return _cars.where((car) => car.status == status).toList();
  }

  List<Car> searchCars(String query) {
    if (query.isEmpty) return _cars;
    return _cars.where((car) =>
    car.name.toLowerCase().contains(query.toLowerCase()) ||
        car.id.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}