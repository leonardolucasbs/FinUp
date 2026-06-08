class SubscriptionModel {
  const SubscriptionModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int userId;
  final int courseId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isActive => status.toUpperCase() == 'ACTIVE';

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      courseId: (json['courseId'] as num).toInt(),
      status: json['status'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class CreateSubscriptionRequest {
  const CreateSubscriptionRequest({
    required this.userId,
    required this.courseId,
  });

  final int userId;
  final int courseId;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'courseId': courseId,
    };
  }
}
