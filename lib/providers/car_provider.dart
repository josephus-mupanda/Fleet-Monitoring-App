import 'dart:async';
import 'package:flutter/material.dart';
import '../core/config/preferences.dart';
import '../core/utils/toast.dart';
import '../models/car.dart';
import '../services/car_service.dart';

class CarProvider with ChangeNotifier {
  List<Car> _cars = [];
  bool _isLoading = false;
  String? _error;
  String? _trackedCarId;

  List<Car> get cars => _cars;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get trackedCarId => _trackedCarId;

  final CarService _carService = CarService();
  Timer? _pollingTimer;
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  CarProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadCachedData();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _context = null;
    super.dispose();
  }

  Future<void> _loadCachedData() async {
    try {
      final cachedCars = await Preferences.getCachedCars();
      if (cachedCars != null) {
        _cars = cachedCars;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Cache load error: $e');
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) => _safeFetchCars());
    _safeFetchCars();
  }

  Future<void> _safeFetchCars() async {
    if (_context != null && _context!.mounted) {
      await fetchCars(_context!);
    }
  }

  Future<void> fetchCars(BuildContext context) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final cars = await _carService.getCars(context);
      if (cars != null) {
        _cars = cars;
        _error = null;
        await Preferences.setCachedCars(cars);
      } else if (_cars.isEmpty) {
        _error = 'Failed to load cars';
        if (context.mounted) {
          showErrorToast(context, "Failed to load cars");
        }
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Fetch error: $e');
      if (context.mounted && _cars.isEmpty) {
        showErrorToast(context, 'Error: ${e.toString()}');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void trackCar(String carId) {
    _trackedCarId = carId;
    notifyListeners();
  }

  void stopTracking() {
    _trackedCarId = null;
    notifyListeners();
  }

  Car? getCarById(String id) {
    try {
      return _cars.firstWhere((car) => car.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Car> filterByStatus(String? status) {
    if (status == null || status.isEmpty) return _cars;
    return _cars.where((car) => car.status == status).toList();
  }

  List<Car> search(String query) {
    if (query.isEmpty) return _cars;
    final q = query.toLowerCase();
    return _cars.where((car) =>
    car.name.toLowerCase().contains(q) ||
        car.id.toLowerCase().contains(q)).toList();
  }
}
