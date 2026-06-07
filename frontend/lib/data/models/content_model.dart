class ContentModel {
  const ContentModel({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.imageUrl,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final String type;
  final String description;
  final String imageUrl;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
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
    this.imageUrl,
  });

  final String title;
  final String description;
  final String type;
  final int userId;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'userId': userId,
      'imageUrl': imageUrl,
    };
  }
}

class UpdateContentRequest {
  const UpdateContentRequest({
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
  });

  final String title;
  final String description;
  final String type;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'imageUrl': imageUrl,
    };
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
    return {
      'userId': userId,
      'contentId': contentId,
    };
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
