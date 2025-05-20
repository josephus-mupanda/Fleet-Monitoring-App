import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

void showSuccessToast(BuildContext context, String message) {
  MotionToast.success(
    title: const Text(
      'Success!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    description: Text(message),
    animationDuration: const Duration(seconds: 1),
    animationCurve: Curves.bounceIn,
    animationType: AnimationType.slideInFromTop,
    dismissable: false,
  ).show(context);
}

void showErrorToast(BuildContext context, String message) {
  MotionToast.error(
    title: const Text(
      'Error!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    description: Text(message),
    //position: MotionToastPosition.top,
    animationDuration: const Duration(seconds: 1),
    animationCurve: Curves.bounceIn,
    animationType: AnimationType.slideInFromTop,
    dismissable: false,
  ).show(context);
}
void showWarningToast(BuildContext context, String message) {
  MotionToast.warning(
    title: const Text(
      'Warning!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    description: Text(message),
    //position: MotionToastPosition.top,
    animationDuration: const Duration(seconds: 1),
    animationCurve: Curves.bounceIn,
    animationType: AnimationType.slideInFromTop,
    dismissable: false,
  ).show(context);
}
