import 'package:flutter/material.dart';

class TapOutsideToClose extends StatelessWidget {
  final VoidCallback onClose;
  final Widget child;

  const TapOutsideToClose({
    super.key,
    required this.onClose,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}
