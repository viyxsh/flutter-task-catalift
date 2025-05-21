class Course {
  final String id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final int enrollments;
  final bool isHighlyEnrolled;
  final String imagePath;
  final int lessons;
  final String category;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.enrollments,
    required this.isHighlyEnrolled,
    required this.imagePath,
    required this.lessons,
    required this.category,
  });
}