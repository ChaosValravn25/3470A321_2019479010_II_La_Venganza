import 'package:flutter/material.dart';
import 'package:la_venganza/services/shared_preferences_service.dart';
import 'package:la_venganza/services/file_storage_service.dart';

/// Clase que maneja el estado global de configuración del usuario.
/// Aquí se integran tanto SharedPreferences (para configuraciones ligeras)
/// como almacenamiento de archivos (para respaldos del estado o configuraciones).
class ConfigurationData extends ChangeNotifier {
  final SharedPreferencesService _prefs;
  final FileStorageService _fileStorage;

  // Variables internas del modelo
  Color _mainColor = Colors.green;
  int _gridSize = 8;
  bool _isLoading = true;

  // Getters públicos
  Color get mainColor => _mainColor;
  int get gridSize => _gridSize;
  bool get isLoading => _isLoading;

  String get mainColorString =>
      _mainColor.toString().split('(')[1].split(')')[0];

  /// Constructor que inicializa con los servicios de persistencia
  ConfigurationData(this._prefs, this._fileStorage) {
    _loadFromPrefsAndFile();
  }

  /// 🔸 Carga inicial combinada:
  /// Lee datos desde SharedPreferences y verifica si existe respaldo en archivo.
  Future<void> _loadFromPrefsAndFile() async {
    try {
      _isLoading = true;
      notifyListeners();

      // 1️⃣ Intentamos cargar configuración desde SharedPreferences
      final size = await _prefs.loadGridSize();
      final colorHex = await _prefs.loadMainColor();

      // 2️⃣ Si hay respaldo en archivo, lo priorizamos
      final fileData = await _fileStorage.readConfiguration();
      if (fileData != null) {
        _gridSize = fileData['gridSize'] ?? size;
        final fileColor = fileData['mainColor'];
        if (fileColor != null) {
          final hex = fileColor.replaceFirst('#', '');
          _mainColor = Color(int.parse('0x$hex'));
        }
      } else {
        // Si no hay respaldo, usamos datos de SharedPreferences
        _gridSize = size;
        if (colorHex != null) {
          final hex = colorHex.replaceFirst('#', '');
          _mainColor = Color(int.parse('0x$hex'));
        } else {
          _mainColor = Colors.green;
        }
      }

      // 3️⃣ Guardamos de nuevo ambos orígenes para mantener sincronizados
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

  /// Cambia el tamaño de la grilla y actualiza tanto en memoria como en persistencia.
  void setGridSize(int newSize) {
    _gridSize = newSize;
    _prefs.saveGridSize(newSize);
    _fileStorage.saveConfiguration(
      gridSize: newSize,
      mainColor: _mainColor.value.toRadixString(16),
    );
    notifyListeners();
  }

  /// Cambia el color principal y lo sincroniza en ambos tipos de almacenamiento.
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

  /// Guarda todo el estado actual en un archivo externo (respaldo manual).
  Future<void> backupToFile() async {
    await _fileStorage.saveConfiguration(
      gridSize: _gridSize,
      mainColor: _mainColor.value.toRadixString(16),
    );
    debugPrint("💾 Respaldo de configuración guardado correctamente");
  }

  /// Restaura el estado desde el archivo (si existe).
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
}
