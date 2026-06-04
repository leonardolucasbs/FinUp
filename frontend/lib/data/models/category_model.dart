class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.userId,
  });

  final int id;
  final String name;
  final int userId;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      userId: (json['userId'] as num).toInt(),
    );
  }
}
