class User {
  final String id;
  final String name;
  final String email;
  final String profileImagePath;
  final String bio;
  final List<String> enrolledCourseIds;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImagePath,
    required this.bio,
    this.enrolledCourseIds = const [],
  });
}

final User currentUser = User(
  id: '1',
  name: 'Viya Sharma',
  email: 'viyasharma@gmail.com',
  profileImagePath: 'assets/images/profile.png',
  bio: 'Passionate about learning and growing in the tech industry. Currently focused on mobile app development and data science.',
);