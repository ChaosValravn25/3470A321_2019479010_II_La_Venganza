import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/pixel_art.dart';

class PixelArtRepository {
  final String _folderName = 'pixel_arts';

  Future<Directory> _getFolder() async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/$_folderName');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    return folder;
  }

  Future<File> _fileForId(String id) async {
    final folder = await _getFolder();
    return File('${folder.path}/$id.json');
  }

  Future<void> save(PixelArt art) async {
    final file = await _fileForId(art.id);
    await file.writeAsString(art.toJson());
  }

  Future<PixelArt?> load(String id) async {
    final file = await _fileForId(id);
    if (await file.exists()) {
      final content = await file.readAsString();
      return PixelArt.fromJson(content);
    }
    return null;
  }

  Future<List<PixelArt>> listAll() async {
    final folder = await _getFolder();
    final files = folder.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
    final List<PixelArt> arts = [];
    for (final f in files) {
      try {
        final content = await f.readAsString();
        arts.add(PixelArt.fromJson(content));
      } catch (_) {}
    }
    arts.sort((a, b) => b.lastModifiedAt.compareTo(a.lastModifiedAt));
    return arts;
  }

  Future<void> delete(String id) async {
    final file = await _fileForId(id);
    if (await file.exists()) await file.delete();
  }
}
