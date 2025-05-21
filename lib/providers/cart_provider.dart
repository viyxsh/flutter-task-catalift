import 'package:flutter/foundation.dart';
import 'package:flutter_task_catalift/models/course.dart';

class CartProvider extends ChangeNotifier {
  final List<Course> _cartItems = [];

  List<Course> get cartItems => List.unmodifiable(_cartItems);

  void addItem(Course course) {
    if (!_cartItems.any((item) => item.id == course.id)) {
      _cartItems.add(course);
      notifyListeners();
    }
  }

  void removeItem(String courseId) {
    _cartItems.removeWhere((item) => item.id == courseId);
    notifyListeners();
  }

  bool isInCart(Course course) {
    return _cartItems.any((item) => item.id == course.id);
  }

  double getTotalPrice() {
    return _cartItems.fold(0.0, (sum, item) => sum + item.price);
  }
}