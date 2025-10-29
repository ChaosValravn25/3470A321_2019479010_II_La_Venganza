import 'package:flutter/material.dart';
import 'package:la_venganza/services/shared_preferences_service.dart';
import 'package:la_venganza/services/file_storage_service.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
class ConfigurationData extends ChangeNotifier {
  final SharedPreferencesService _prefs;
  final FileStorageService _fileStorage;

  // 🔹 Nuevas variables del Lab 8
  double _backgroundOpacity = 0.5;
  String? _backgroundImagePath; // Ruta de fondo seleccionada por el usuario

  // 🔹 Variables existentes del Lab 7
  Color _mainColor = Colors.green;
  int _gridSize = 8;
  bool _isLoading = true;
  final List<String> _imagePaths = []; // Lista de imágenes creadas

  ConfigurationData(this._prefs, this._fileStorage) {
    _loadFromPrefsAndFile();
  }

  // 🔸 Getters
  double get backgroundOpacity => _backgroundOpacity;
  String? get backgroundImagePath => _backgroundImagePath;
  Color get mainColor => _mainColor;
  int get gridSize => _gridSize;
  bool get isLoading => _isLoading;
  List<String> get imagePaths => _imagePaths;
  String? get lastImagePath => _imagePaths.isNotEmpty ? _imagePaths.last : null;

  String get mainColorString =>
      _mainColor.toString().split('(')[1].split(')')[0];

  // 🔸 Carga inicial combinada: SharedPreferences + Archivo local
  Future<void> _loadFromPrefsAndFile() async {
    try {
      _isLoading = true;
      notifyListeners();

      final size = await _prefs.loadGridSize();
      final colorHex = await _prefs.loadMainColor();
      final opacity = await _prefs.loadBackgroundOpacity();
      final bgPath = await _prefs.loadBackgroundImagePath();

      _backgroundOpacity = opacity ?? 0.5;
      _backgroundImagePath = bgPath;

      // 🔹 Intentamos leer también desde archivo de respaldo (persistencia adicional)
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

      // 🔹 Guardamos respaldo actualizado
      await _prefs.saveGridSize(_gridSize);
      await _prefs.saveMainColor(_mainColor.value.toRadixString(16));
      await _fileStorage.saveConfiguration(
        gridSize: _gridSize,
        mainColor: _mainColor.value.toRadixString(16),
        opacity: _backgroundOpacity,
        backgroundPath: _backgroundImagePath,
      );
    } catch (e) {
      debugPrint("⚠️ Error al cargar configuración: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔸 Setters actualizados con persistencia y notificación

  void setBackgroundOpacity(double value) {
    _backgroundOpacity = value;
    _prefs.saveBackgroundOpacity(value);
    _fileStorage.saveConfiguration(
      gridSize: _gridSize,
      mainColor: _mainColor.value.toRadixString(16),
      opacity: value,
      backgroundPath: _backgroundImagePath,
    );
    notifyListeners();
  }

  void setBackgroundImagePath(String? path) {
    _backgroundImagePath = path;
    _prefs.saveBackgroundImagePath(path ?? '');
    _fileStorage.saveConfiguration(
      gridSize: _gridSize,
      mainColor: _mainColor.value.toRadixString(16),
      opacity: _backgroundOpacity,
      backgroundPath: path,
    );
    notifyListeners();
  }

  void setGridSize(int newSize) {
    _gridSize = newSize;
    _prefs.saveGridSize(newSize);
    _fileStorage.saveConfiguration(
      gridSize: newSize,
      mainColor: _mainColor.value.toRadixString(16),
      opacity: _backgroundOpacity,
      backgroundPath: _backgroundImagePath,
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
      opacity: _backgroundOpacity,
      backgroundPath: _backgroundImagePath,
    );
    notifyListeners();
  }

   /// 📤 Permite compartir el archivo de configuración guardado (respaldo JSON)
  Future<void> shareBackupFile() async {
    try {
      final filePath = await _fileStorage.getConfigFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        final xFile = XFile(file.path, mimeType: 'application/json');
        await Share.shareXFiles(
          [xFile],
          text: '📦 Respaldo de configuración de La Venganza',
        );
        debugPrint("✅ Archivo de respaldo compartido desde: ${file.path}");
      } else {
        debugPrint("⚠️ No existe archivo de respaldo para compartir");
      }
    } catch (e) {
      debugPrint("⚠️ Error al compartir el archivo de respaldo: $e");
    }
  }

  // 🔹 Métodos de respaldo y restauración de configuración (mantiene Lab 7)
  Future<void> backupToFile() async {
    await _fileStorage.saveConfiguration(
      gridSize: _gridSize,
      mainColor: _mainColor.value.toRadixString(16),
      opacity: _backgroundOpacity,
      backgroundPath: _backgroundImagePath,
    );
    debugPrint("💾 Respaldo de configuración guardado correctamente");
  }

  Future<void> restoreFromFile() async {
    final fileData = await _fileStorage.readConfiguration();
    if (fileData != null) {
      _gridSize = fileData['gridSize'] ?? 8;
      final fileColor = fileData['mainColor'];
      final opacity = fileData['opacity'];
      final bgPath = fileData['backgroundPath'];

      if (fileColor != null) {
        final hex = fileColor.replaceFirst('#', '');
        _mainColor = Color(int.parse('0x$hex'));
      }

      _backgroundOpacity = opacity ?? 0.5;
      _backgroundImagePath = bgPath;

      notifyListeners();
      debugPrint("🔁 Configuración restaurada desde archivo local");
    } else {
      debugPrint("⚠️ No se encontró archivo de respaldo");
    }
  }

  // 🔹 Registro de creaciones guardadas (Lab 7)
  void addCreation(String filePath) {
    _imagePaths.add(filePath);
    notifyListeners();
  }
}
