class Car {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final double speed;
  final String status;
  final DateTime lastUpdated;

  Car({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.status,
    required this.lastUpdated,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as int,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      status: json['status'] as String,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'status': status,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  String toString() => 'Car $id: $name ($status)';
}