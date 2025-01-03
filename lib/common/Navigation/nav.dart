import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationService {
  static void to({
    required Widget screen,
    Transition? transition,
    Duration? duration,
    Curve? curve,
    dynamic arguments,
  }) {
    Get.to(
      () => screen,
      transition: transition ?? Transition.fade,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
      arguments: arguments,
    );
  }

  static void off({
    required Widget screen,
    Transition? transition,
    Duration? duration,
    Curve? curve,
    dynamic arguments,
  }) {
    Get.off(
      () => screen,
      transition: transition ?? Transition.rightToLeft,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
      arguments: arguments,
    );
  }

  static void offAll({
    required Widget screen,
    Transition? transition,
    Duration? duration,
    Curve? curve,
    dynamic arguments,
  }) {
    Get.offAll(
      () => screen,
      transition: transition ?? Transition.upToDown,
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve ?? Curves.easeInOut,
      arguments: arguments,
    );
  }

  static void back({dynamic result}) {
    Get.back(result: result);
  }
}
