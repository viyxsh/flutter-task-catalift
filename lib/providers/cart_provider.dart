import 'package:flutter/foundation.dart';
import 'package:flutter_task_catalift/models/course.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_task_catalift/data/course_data.dart';

class CartProvider extends ChangeNotifier {
  final List<Course> _cartItems = [];
  static const String _cartKey = 'cart_items';

  CartProvider() {
    _loadCartItems();
  }

  List<Course> get cartItems => List.unmodifiable(_cartItems);

  Future<void> _loadCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? courseIds = prefs.getStringList(_cartKey);
      if (courseIds != null) {
        _cartItems.clear();
        for (var id in courseIds) {
          final course = allCoursesMap[id];
          if (course != null) {
            _cartItems.add(course);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart items: $e');
    }
  }

  Future<void> _saveCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> courseIds = _cartItems.map((item) => item.id).toList();
      await prefs.setStringList(_cartKey, courseIds);
    } catch (e) {
      debugPrint('Error saving cart items: $e');
    }
  }

  void addItem(Course course) {
    if (!_cartItems.any((item) => item.id == course.id)) {
      _cartItems.add(course);
      _saveCartItems();
      notifyListeners();
    }
  }

  void removeItem(String courseId) {
    _cartItems.removeWhere((item) => item.id == courseId);
    _saveCartItems();
    notifyListeners();
  }

  bool isInCart(Course course) {
    return _cartItems.any((item) => item.id == course.id);
  }

  double getTotalPrice() {
    return _cartItems.fold(0.0, (sum, item) => sum + item.price);
  }
}