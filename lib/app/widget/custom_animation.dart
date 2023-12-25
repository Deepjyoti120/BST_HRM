import 'package:flutter/material.dart';

class DAnimation extends StatelessWidget {
  const DAnimation(
      {super.key,
      required this.visible,
      required this.child,
      this.curve = Curves.easeInOutBack});
  final bool visible;
  final Widget child;
  final Curve curve;
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: curve,
      alignment: Alignment.center,
      child: Visibility(
        visible: visible,
        maintainState: true,
        child: child,
      ),
    );
  }
}
