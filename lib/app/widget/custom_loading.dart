import 'package:flutter/material.dart';

class DLoading extends StatelessWidget {
  const DLoading({super.key, this.size = 24, this.color});
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Center(
        child: CircularProgressIndicator(
          color: color ?? Colors.white,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
