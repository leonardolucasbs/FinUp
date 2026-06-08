class CourseModel {
  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.teacher,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final String description;
  final String teacher;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      teacher: json['teacher'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class CreateCourseRequest {
  const CreateCourseRequest({
    required this.title,
    required this.description,
    required this.teacher,
    this.imageUrl,
  });

  final String title;
  final String description;
  final String teacher;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'teacher': teacher,
      'imageUrl': imageUrl,
    };
  }
}

class UpdateCourseRequest {
  const UpdateCourseRequest({
    required this.title,
    required this.description,
    required this.teacher,
    this.imageUrl,
  });

  final String title;
  final String description;
  final String teacher;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'teacher': teacher,
      'imageUrl': imageUrl,
    };
  }
}
