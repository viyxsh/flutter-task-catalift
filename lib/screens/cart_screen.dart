import 'package:flutter/material.dart';
import 'package:flutter_task_catalift/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_catalift/models/course.dart';
import 'package:flutter_task_catalift/utils/theme.dart';
import 'package:flutter_task_catalift/widgets/course_card.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatelessWidget {
  final void Function(int) navigateToScreen;

  const CartScreen({
    super.key,
    required this.navigateToScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartCourses = cartProvider.cartItems;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Cart',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: cartCourses.isEmpty
              ? _buildEmptyCart(context)
              : _buildCartList(context, cartCourses, cartProvider),
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Add Lottie animation
          Lottie.asset(
            'assets/animations/empty_cart.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            repeat: true, // Loop the animation
          ),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTextColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              navigateToScreen(0);
            },
            style: AppTheme.primaryButtonStyle,
            child: const Text(
              'Explore Courses',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartList(BuildContext context, List<Course> cartCourses, CartProvider cartProvider) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: cartCourses.length,
            itemBuilder: (context, index) {
              final course = cartCourses[index];
              return CourseCard(
                course: course,
                onTap: () {},
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppTheme.lightTextColor,
                  ),
                  onPressed: () {
                    cartProvider.removeItem(course.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Course removed from cart'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total (${cartCourses.length} ${cartCourses.length == 1 ? 'item' : 'items'})',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.lightTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${cartProvider.getTotalPrice()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Proceeding to checkout...'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    style: AppTheme.primaryButtonStyle,
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}