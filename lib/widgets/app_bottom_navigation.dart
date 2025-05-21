import 'package:flutter/material.dart';
import 'package:flutter_task_catalift/utils/theme.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), 
            blurRadius: 15, 
            spreadRadius: 1, 
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.whiteColor,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.lightTextColor,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: currentIndex == 0 ? 28 : 24, 
            ),
            activeIcon: Icon(
              Icons.home,
              size: 28, 
              color: AppTheme.primaryColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart_outlined,
              size: currentIndex == 1 ? 28 : 24,
            ),
            activeIcon: Icon(
              Icons.shopping_cart,
              size: 28,
              color: AppTheme.primaryColor,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: currentIndex == 2 ? 28 : 24,
            ),
            activeIcon: Icon(
              Icons.person,
              size: 28,
              color: AppTheme.primaryColor,
            ),
            label: 'You',
          ),
        ],
      ),
    );
  }
}