
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/car.dart';
import '../core/config/app_config.dart';
import '../core/utils/toast.dart';

class CarService {
  Future<List<Car>?> getCars(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse(AppConfig.carsEndpoint),
        headers: {'Accept': 'application/json'},
      );

      if (!context.mounted) return null;

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Car.fromJson(json)).toList();
      } else {
        showWarningToast(context, "Failed to load cars (${response.statusCode})");
        return null;
      }
    } catch (e) {
      if (context.mounted) {
        showErrorToast(context, "Network error: ${e.toString()}");
      }
      return null;
    }
  }
}