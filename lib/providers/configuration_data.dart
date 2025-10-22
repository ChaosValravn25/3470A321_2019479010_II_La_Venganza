import 'package:flutter/material.dart';
import 'package:la_venganza/services/shared_preferences_service.dart';
import 'package:la_venganza/services/file_storage_service.dart';

class ConfigurationData extends ChangeNotifier {
  final SharedPreferencesService _prefs;
  final FileStorageService _fileStorage;

  Color _mainColor = Colors.green;
  int _gridSize = 8;
  bool _isLoading = true;
  final List<String> _imagePaths = []; // Mantengo como lista mutable

  ConfigurationData(this._prefs, this._fileStorage) {
    _loadFromPrefsAndFile();
  }

  Color get mainColor => _mainColor;
  int get gridSize => _gridSize;
  bool get isLoading => _isLoading;
  List<String> get imagePaths => _imagePaths;
  String? get lastImagePath => _imagePaths.isNotEmpty ? _imagePaths.last : null;

  String get mainColorString =>
      _mainColor.toString().split('(')[1].split(')')[0];

  Future<void> _loadFromPrefsAndFile() async {
    try {
      _isLoading = true;
      notifyListeners();

      final size = await _prefs.loadGridSize();
      final colorHex = await _prefs.loadMainColor();

      final fileData = await _fileStorage.readConfiguration();
      if (fileData != null) {
        _gridSize = fileData['gridSize'] ?? size;
        final fileColor = fileData['mainColor'];
        if (fileColor != null) {
          final hex = fileColor.replaceFirst('#', '');
          _mainColor = Color(int.parse('0x$hex'));
        }
      } else {
        _gridSize = size;
        if (colorHex != null) {
          final hex = colorHex.replaceFirst('#', '');
          _mainColor = Color(int.parse('0x$hex'));
        } else {
          _mainColor = Colors.green;
        }
      }

      await _prefs.saveGridSize(_gridSize);
      await _prefs.saveMainColor(_mainColor.value.toRadixString(16));
      await _fileStorage.saveConfiguration(
        gridSize: _gridSize,
        mainColor: _mainColor.value.toRadixString(16),
      );
    } catch (e) {
      debugPrint("⚠️ Error al cargar configuración: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setGridSize(int newSize) {
    _gridSize = newSize;
    _prefs.saveGridSize(newSize);
    _fileStorage.saveConfiguration(
      gridSize: newSize,
      mainColor: _mainColor.value.toRadixString(16),
    );
    notifyListeners();
  }

  void setMainColor(Color color) {
    _mainColor = color;
    final hex = color.value.toRadixString(16);
    _prefs.saveMainColor(hex);
    _fileStorage.saveConfiguration(
      gridSize: _gridSize,
      mainColor: hex,
    );
    notifyListeners();
  }

  Future<void> backupToFile() async {
    await _fileStorage.saveConfiguration(
      gridSize: _gridSize,
      mainColor: _mainColor.value.toRadixString(16),
    );
    debugPrint("💾 Respaldo de configuración guardado correctamente");
  }

  Future<void> restoreFromFile() async {
    final fileData = await _fileStorage.readConfiguration();
    if (fileData != null) {
      _gridSize = fileData['gridSize'] ?? 8;
      final fileColor = fileData['mainColor'];
      if (fileColor != null) {
        final hex = fileColor.replaceFirst('#', '');
        _mainColor = Color(int.parse('0x$hex'));
      }
      notifyListeners();
      debugPrint("🔁 Configuración restaurada desde archivo");
    } else {
      debugPrint("⚠️ No se encontró archivo de respaldo");
    }
  }

  void addCreation(String filePath) {
    _imagePaths.add(filePath);
    notifyListeners();
  }
}