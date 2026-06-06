class ContentModel {
  const ContentModel({
    required this.id,
    required this.title,
    required this.likes,
    required this.type,
    required this.description,
    required this.imageUrl,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final int likes;
  final String type;
  final String description;
  final String? imageUrl;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get typeLabel {
    return switch (type) {
      'NOTES' => 'Nota',
      'NEWS' => 'Noticia',
      'ARTICLES' => 'Artigo',
      _ => 'Outro',
    };
  }

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? 'OTHERS',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      userId: (json['userId'] as num).toInt(),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
