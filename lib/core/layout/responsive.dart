import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  // Helper function to check if the device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 650;
  }

  // Helper function to check if the device is tablet
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 650 && MediaQuery.of(context).size.width < 1100;
  }

  // Helper function to check if the device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop;
        }
        else if (constraints.maxWidth >= 650) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
