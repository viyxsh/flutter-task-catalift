import 'package:flutter/material.dart';
import 'package:flutter_task_catalift/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_catalift/models/course.dart';
import 'package:flutter_task_catalift/utils/theme.dart';
import 'package:flutter_task_catalift/widgets/course_card.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_task_catalift/widgets/notifier_widget.dart';

class CartScreen extends StatelessWidget {
  final void Function(int) navigateToScreen;

  const CartScreen({
    super.key,
    required this.navigateToScreen,
  });

  void _showPaymentDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return _PaymentDialog(cartProvider: cartProvider);
      },
    );
  }

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
          Lottie.asset(
            'assets/animations/empty_cart.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            repeat: true,
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
                    NotifierWidget.show(
                      context,
                      message: 'Course removed from cart',
                      backgroundColor: AppTheme.primaryColor,
                      textColor: Colors.white,
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
                      _showPaymentDialog(context, cartProvider);
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

class _PaymentDialog extends StatefulWidget {
  final CartProvider cartProvider;

  const _PaymentDialog({required this.cartProvider});

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _startPaymentProcess();
  }

  void _startPaymentProcess() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        widget.cartProvider.clearCart();
        Navigator.of(context).pop();
        NotifierWidget.show(
          context,
          message: 'Purchase completed! Cart cleared.',
          backgroundColor: AppTheme.primaryColor,
          textColor: Colors.white,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            isLoading
                ? 'assets/animations/loading_payment.json'
                : 'assets/animations/tick_success.json',
            width: 250,
            height: 250,
            fit: BoxFit.contain,
            repeat: isLoading,
            onLoaded: (composition) {
              debugPrint('Animation loaded: ${isLoading ? "loading_payment.json" : "tick_success.json"}');
              debugPrint('Duration: ${composition.duration.inSeconds} seconds');
            },
          ),
        ],
      ),
    );
  }
}