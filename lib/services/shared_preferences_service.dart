// lib/services/shared_preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Llaves usadas para almacenar valores
  static const String _keyGridSize = 'grid_size';
  static const String _keyMainColor = 'main_color'; // guardaremos hex
  static const String _keyBackgroundOpacity = 'backgroundOpacity';
  static const String _keyBackgroundImagePath = 'backgroundImagePath';

  Future<void> saveGridSize(int size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyGridSize, size);
  }

  Future<int> loadGridSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyGridSize) ?? 8;
  }

  Future<void> saveMainColor(String colorHex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMainColor, colorHex);
  }

  Future<String?> loadMainColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMainColor);
  }
   // 🔹 Nuevos métodos LAB 8: Opacidad de fondo
  Future<void> saveBackgroundOpacity(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyBackgroundOpacity, value);
  }

  Future<double?> loadBackgroundOpacity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyBackgroundOpacity);
  }

  // 🔹 Nuevos métodos LAB 8: Imagen de fondo
  Future<void> saveBackgroundImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBackgroundImagePath, path);
  }

  Future<String?> loadBackgroundImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBackgroundImagePath);
  }
}
