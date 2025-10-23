// lib/services/shared_preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Llaves usadas para almacenar valores
  static const String _keyGridSize = 'grid_size';
  static const String _keyMainColor = 'main_color'; // guardaremos hex

  Future<void> saveGridSize(int size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyGridSize, size);
  }

  Future<int> loadGridSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyGridSize) ?? 8; // valor por defecto
  }

  Future<void> saveMainColor(String colorHex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMainColor, colorHex);
  }

  Future<String?> loadMainColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMainColor); // puede ser null -> manejar default
  }
}
