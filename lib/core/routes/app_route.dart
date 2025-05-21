class AppRoute {
  static const String home = '/';
  static const String carDetail = '/car-detail';

  static String getCarDetailRoute(String carId) => '$carDetail/$carId';
}