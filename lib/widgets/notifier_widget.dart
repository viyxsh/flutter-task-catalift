import 'package:flutter/material.dart';

class NotifierWidget extends StatefulWidget {
  final String message;
  final Duration duration;
  final Color backgroundColor;
  final Color textColor;

  const NotifierWidget({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 2),
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
  });

  @override
  NotifierWidgetState createState() => NotifierWidgetState();

  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60.0, 
        left: 16.0,
        right: 16.0,
        child: Material(
          color: Colors.transparent,
          child: NotifierWidget(
            message: message,
            duration: duration,
            backgroundColor: backgroundColor,
            textColor: textColor,
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

class NotifierWidgetState extends State<NotifierWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0), 
      end: Offset.zero, 
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    Future.delayed(widget.duration - const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          widget.message,
          style: TextStyle(
            color: widget.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}