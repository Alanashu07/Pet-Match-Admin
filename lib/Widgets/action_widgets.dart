import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ActionWidgets extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final bool isCircle;
  final Widget? child;
  final VoidCallback onTap;
  const ActionWidgets({super.key, required this.color, this.icon, required this.onTap, this.isCircle = true, this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(12),
          color: color.withOpacity(0.2),
          border: Border.all(color: color)
        ),
        child: child ?? Icon(icon, color: color, size: 30,),
      ),
    );
  }
}
