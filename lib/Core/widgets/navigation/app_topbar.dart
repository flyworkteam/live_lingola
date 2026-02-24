import 'package:flutter/material.dart';
import '../../Theme/ui_metrics.dart';

class AppTopBar extends StatelessWidget {
  final Widget? left;
  final Widget? center;
  final Widget? right;

  const AppTopBar({
    super.key,
    this.left,
    this.center,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        UIMetrics.screenHPad,
        UIMetrics.topPad,
        UIMetrics.screenHPad,
        0,
      ),
      child: SizedBox(
        height: UIMetrics.topIconBox,
        child: Row(
          children: [
            SizedBox(width: UIMetrics.topIconBox, child: left),
            Expanded(child: Center(child: center)),
            SizedBox(width: UIMetrics.topIconBox, child: right),
          ],
        ),
      ),
    );
  }
}

class TopCircleBtn extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const TopCircleBtn({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: SizedBox(
        width: UIMetrics.topIconBox,
        height: UIMetrics.topIconBox,
        child: Center(child: child),
      ),
    );
  }
}
