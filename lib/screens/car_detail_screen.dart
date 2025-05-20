import 'package:flutter/material.dart';

class CarDetailScreen extends StatefulWidget {

  final String carId;

  const CarDetailScreen({super.key, required this.carId});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
