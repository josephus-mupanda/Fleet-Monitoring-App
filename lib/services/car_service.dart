import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../core/config/app_config.dart';
import '../core/utils/toast.dart';

class CarService {
  final String baseUrl = AppConfig.apiBaseUrl;
  Future<http.Response?> getCars (BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (!context.mounted) return null;

      if (response.statusCode == 200) {
        return response; // Successfully retrieved all cars
      } else {
        showWarningToast(context, "Failed to retrieve guidelines. Please try again later.");
      }
    } catch (e) {
      showErrorToast(context, "An error occurred. Please check your connection.");
    }
    return null;
  }
}