import 'package:flutter/material.dart';
import 'package:flutter_task_catalift/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Catalift',
        theme: AppTheme.themeData,
        debugShowCheckedModeBanner: false,
        home: const MainScreen(),
      ),
    );
  }
}