import 'package:flutter/material.dart';
import 'package:flutter_task_catalift/screens/cart_screen.dart';
import 'package:flutter_task_catalift/screens/home_screen.dart';
import 'package:flutter_task_catalift/screens/profile_screen.dart';
import 'package:flutter_task_catalift/widgets/app_bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'ALL';

  void _updateSelectedCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _navigateToScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen(),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _getScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          selectedCategory: _selectedCategory,
          onCategoryChanged: _updateSelectedCategory,
          navigateToScreen: _navigateToScreen,
        );
      case 1:
        return CartScreen(
          navigateToScreen: _navigateToScreen,
        );
      case 2:
        return ProfileScreen(
          navigateToScreen: _navigateToScreen,
        );
      default:
        return HomeScreen(
          selectedCategory: _selectedCategory,
          onCategoryChanged: _updateSelectedCategory,
          navigateToScreen: _navigateToScreen,
        );
    }
  }
}