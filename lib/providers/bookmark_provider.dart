import 'package:flutter/material.dart';
import 'package:flutter_task_catalift/models/course.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_task_catalift/data/course_data.dart';

class BookmarkProvider extends ChangeNotifier {
  final List<Course> _bookmarkedCourses = [];
  static const String _bookmarkKey = 'bookmarked_courses';

  BookmarkProvider() {
    _loadBookmarkedCourses();
  }

  List<Course> get bookmarkedCourses => _bookmarkedCourses;

  // Load bookmarked courses from SharedPreferences (IDs only)
  Future<void> _loadBookmarkedCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? courseIds = prefs.getStringList(_bookmarkKey);
      if (courseIds != null) {
        _bookmarkedCourses.clear();
        for (var id in courseIds) {
          final course = allCoursesMap[id];
          if (course != null) {
            _bookmarkedCourses.add(course);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading bookmarked courses: $e');
    }
  }

  // Save bookmarked course IDs to SharedPreferences
  Future<void> _saveBookmarkedCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> courseIds = _bookmarkedCourses.map((item) => item.id).toList();
      await prefs.setStringList(_bookmarkKey, courseIds);
    } catch (e) {
      debugPrint('Error saving bookmarked courses: $e');
    }
  }

  bool isBookmarked(Course course) {
    return _bookmarkedCourses.any((item) => item.id == course.id);
  }

  void toggleBookmark(Course course) {
    if (isBookmarked(course)) {
      _bookmarkedCourses.removeWhere((item) => item.id == course.id);
    } else {
      _bookmarkedCourses.add(course);
    }
    _saveBookmarkedCourses();
    notifyListeners();
  }
}