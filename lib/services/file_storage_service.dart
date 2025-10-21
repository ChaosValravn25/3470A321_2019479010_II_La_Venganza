import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Servicio que maneja la lectura y escritura de archivos de configuración
/// en el almacenamiento local del dispositivo.
/// Implementa el uso de rutas seguras mediante `path_provider`.
class FileStorageService {
  /// Nombre del archivo donde se almacenará la configuración.
  final String _fileName = "configuration_data.json";

  /// Obtiene el directorio local de documentos de la aplicación.
  /// Este método garantiza que la app use una ruta válida
  /// en Android, iOS, Windows o Linux.
  Future<Directory> _getAppDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir;
  }

  /// Obtiene la ruta completa del archivo JSON donde se guardará la configuración.
  Future<File> _getConfigFile() async {
    final directory = await _getAppDirectory();
    final filePath = "${directory.path}/$_fileName";
    return File(filePath);
  }

  // ---------------------------------------------------------------------------
  // 🔹 MÉTODOS PRINCIPALES
  // ---------------------------------------------------------------------------

  /// Guarda la configuración actual en formato JSON dentro de un archivo local.
  /// Los datos incluyen el tamaño de grilla y el color principal de la app.
  Future<void> saveConfiguration({
    required int gridSize,
    required String mainColor,
  }) async {
    try {
      final file = await _getConfigFile();

      // Creamos un mapa con los datos a guardar
      final data = {
        "gridSize": gridSize,
        "mainColor": mainColor,
        "timestamp": DateTime.now().toIso8601String(),
      };

      // Convertimos el mapa a JSON y lo escribimos en el archivo
      await file.writeAsString(jsonEncode(data));
      // ignore: avoid_print
      print("💾 Archivo guardado en: ${file.path}");
    } catch (e) {
      // ignore: avoid_print
      print("⚠️ Error al guardar archivo de configuración: $e");
    }
  }

  /// Lee la configuración almacenada en el archivo JSON.
  /// Si no existe, retorna null.
  Future<Map<String, dynamic>?> readConfiguration() async {
    try {
      final file = await _getConfigFile();

      if (await file.exists()) {
        final contents = await file.readAsString();
        final jsonData = jsonDecode(contents) as Map<String, dynamic>;
        // ignore: avoid_print
        print("📖 Configuración cargada desde archivo: ${file.path}");
        return jsonData;
      } else {
        // ignore: avoid_print
        print("⚠️ No se encontró archivo de configuración, se usará default.");
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print("⚠️ Error al leer archivo de configuración: $e");
      return null;
    }
  }

  /// Elimina el archivo de configuración si existe.
  Future<void> deleteConfiguration() async {
    try {
      final file = await _getConfigFile();

      if (await file.exists()) {
        await file.delete();
        // ignore: avoid_print
        print("🗑️ Archivo de configuración eliminado.");
      } else {
        // ignore: avoid_print
        print("ℹ️ No hay archivo para eliminar.");
      }
    } catch (e) {
      // ignore: avoid_print
      print("⚠️ Error al eliminar archivo: $e");
    }
  }

  /// Obtiene la ruta actual del archivo de configuración.
  Future<String> getConfigFilePath() async {
    final file = await _getConfigFile();
    return file.path;
  }
}
