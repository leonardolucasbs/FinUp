import 'dart:convert';
import 'dart:typed_data';

class ContentModel {
  const ContentModel({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.imageData,
    required this.imageContentType,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final String type;
  final String description;
  final String imageData;
  final String imageContentType;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get hasImage => imageData.trim().isNotEmpty;

  Uint8List? get imageBytes {
    if (!hasImage) return null;
    try {
      return base64Decode(imageData);
    } on FormatException {
      return null;
    }
  }

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
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageData: json['imageData'] as String? ?? '',
      imageContentType: json['imageContentType'] as String? ?? '',
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

class CreateContentRequest {
  const CreateContentRequest({
    required this.title,
    required this.description,
    required this.type,
    required this.userId,
    this.imageBytes,
    this.imageFileName,
  });

  final String title;
  final String description;
  final String type;
  final int userId;
  final Uint8List? imageBytes;
  final String? imageFileName;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'userId': userId,
    };
  }
}

class UpdateContentRequest {
  const UpdateContentRequest({
    required this.title,
    required this.description,
    required this.type,
    this.imageBytes,
    this.imageFileName,
  });

  final String title;
  final String description;
  final String type;
  final Uint8List? imageBytes;
  final String? imageFileName;

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'type': type};
  }
}

class CreateSavedContentRequest {
  const CreateSavedContentRequest({
    required this.userId,
    required this.contentId,
  });

  final int userId;
  final int contentId;

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'contentId': contentId};
  }
}

class SavedContentModel {
  const SavedContentModel({
    required this.id,
    required this.userId,
    required this.contentId,
  });

  final int id;
  final int userId;
  final int contentId;

  factory SavedContentModel.fromJson(Map<String, dynamic> json) {
    return SavedContentModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      contentId: (json['contentId'] as num).toInt(),
    );
  }
}
