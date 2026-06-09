class CourseModel {
  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.teacher,
    required this.courseType,
    required this.location,
    required this.courseHours,
    required this.startDate,
    required this.level,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final String description;
  final String teacher;
  final String courseType;
  final String location;
  final int courseHours;
  final DateTime? startDate;
  final String level;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      teacher: json['teacher'] as String? ?? '',
      courseType: json['courseType'] as String? ?? '',
      location: json['location'] as String? ?? '',
      courseHours: (json['courseHours'] as num?)?.toInt() ?? 0,
      startDate: DateTime.tryParse(json['startDate'] as String? ?? ''),
      level: json['level'] as String? ?? '',
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
    required this.courseType,
    required this.location,
    required this.courseHours,
    required this.startDate,
    required this.level,
    this.imageUrl,
  });

  final String title;
  final String description;
  final String teacher;
  final String courseType;
  final String location;
  final int courseHours;
  final DateTime startDate;
  final String level;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'teacher': teacher,
      'courseType': courseType,
      'location': location,
      'courseHours': courseHours,
      'startDate': _dateOnly(startDate),
      'level': level,
      'imageUrl': imageUrl,
    };
  }
}

class UpdateCourseRequest {
  const UpdateCourseRequest({
    required this.title,
    required this.description,
    required this.teacher,
    required this.courseType,
    required this.location,
    required this.courseHours,
    required this.startDate,
    required this.level,
    this.imageUrl,
  });

  final String title;
  final String description;
  final String teacher;
  final String courseType;
  final String location;
  final int courseHours;
  final DateTime startDate;
  final String level;
  final String? imageUrl;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'teacher': teacher,
      'courseType': courseType,
      'location': location,
      'courseHours': courseHours,
      'startDate': _dateOnly(startDate),
      'level': level,
      'imageUrl': imageUrl,
    };
  }
}

String _dateOnly(DateTime date) {
  return DateTime(
    date.year,
    date.month,
    date.day,
  ).toIso8601String().split('T').first;
}
