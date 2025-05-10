import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  final _storage = GetStorage();
  final _themeKey = 'isDarkMode';

  // Observable to track theme state
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved theme preference
    if (_storage.read(_themeKey) != null) {
      final isDarkMode = _storage.read(_themeKey) as bool;
      themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }

  // Toggle theme between light and dark mode
  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      _storage.write(_themeKey, true);
    } else {
      themeMode.value = ThemeMode.light;
      _storage.write(_themeKey, false);
    }
    Get.changeThemeMode(themeMode.value);
  }

  // Check if dark mode is active
  bool get isDarkMode => themeMode.value == ThemeMode.dark;
}
