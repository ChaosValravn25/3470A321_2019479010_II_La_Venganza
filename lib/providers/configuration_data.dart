import 'package:flutter/material.dart';
import 'package:la_venganza/services/shared_preferences_service.dart';


class ConfigurationData extends ChangeNotifier {
  final SharedPreferencesService _prefs;

  Color _mainColor = Colors.green;
  int _gridSize = 8;
  bool _isLoading = true;

  Color get mainColor => _mainColor;
  int get gridSize => _gridSize;
  bool get isLoading => _isLoading;

  String get mainColorString => _mainColor.toString().split('(')[1].split(')')[0];

   ConfigurationData(this._prefs) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      _isLoading = true;
      notifyListeners();

      final size = await _prefs.loadGridSize();
      final colorHex = await _prefs.loadMainColor();

      _gridSize = size;
      if (colorHex != null) {
        // colorHex expected: "#ff00ff" or "ff00ff" (ajusta si guardas con 0xff)
        final hex = colorHex.replaceFirst('#', '');
        _mainColor = Color(int.parse('0x$hex'));
      } else {
        _mainColor = Colors.green; // default
      }
    } catch (e) {
      // manejar error si hace falta
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

   void setGridSize(int newSize) {
    _gridSize = newSize;
    _prefs.saveGridSize(newSize);
    notifyListeners();
  }

  void setMainColor(Color color) {
    _mainColor = color;
    // guardamos hex sin 0x para leer más fácil
    final hex = color.value.toRadixString(16);
    _prefs.saveMainColor(hex);
    notifyListeners();
  }
}
