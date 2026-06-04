class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.username,
  });

  final int id;
  final String fullName;
  final String username;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }
}
