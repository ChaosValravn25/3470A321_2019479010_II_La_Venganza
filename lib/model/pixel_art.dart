import 'dart:convert';

class PixelArt {
  final String id;
  final String authorId;
  final String title;
  final String description;
  final Map<String, dynamic> size; // e.g. {"rows":8,"cols":8}
  final List<String> palette; // list of hex strings like "#ff00ff"
  final String gridData; // JSON string of nested arrays or compact form
  final DateTime createdAt;
  final DateTime lastModifiedAt;

  PixelArt({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.size,
    required this.palette,
    required this.gridData,
    required this.createdAt,
    required this.lastModifiedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'title': title,
      'description': description,
      'size': size,
      'palette': palette,
      'gridData': gridData,
      'createdAt': createdAt.toIso8601String(),
      'lastModifiedAt': lastModifiedAt.toIso8601String(),
    };
  }

  factory PixelArt.fromMap(Map<String, dynamic> m) {
    return PixelArt(
      id: m['id'],
      authorId: m['authorId'],
      title: m['title'],
      description: m['description'],
      size: Map<String, dynamic>.from(m['size']),
      palette: List<String>.from(m['palette'] ?? []),
      gridData: m['gridData'],
      createdAt: DateTime.parse(m['createdAt']),
      lastModifiedAt: DateTime.parse(m['lastModifiedAt']),
    );
  }

  String toJson() => jsonEncode(toMap());
  factory PixelArt.fromJson(String source) => PixelArt.fromMap(jsonDecode(source));
}
