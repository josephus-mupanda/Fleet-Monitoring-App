class AppRoute {
  static const String home = '/';
  static const String carDetail = '/car-detail';
  static const String settings = '/settings';

  static String getCarDetailRoute(String carId) => '$carDetail/$carId';
}