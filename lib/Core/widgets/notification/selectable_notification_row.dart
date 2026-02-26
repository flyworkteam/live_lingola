import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectableNotificationRow extends StatelessWidget {
  final bool deleteMode;
  final bool selected;
  final VoidCallback onSelectToggle;
  final Widget child;

  const SelectableNotificationRow({
    super.key,
    required this.deleteMode,
    required this.selected,
    required this.onSelectToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (deleteMode)
          Positioned(
            top: -6.h,
            left: -6.w,
            child: GestureDetector(
              onTap: onSelectToggle,
              child: Container(
                width: 22.w,
                height: 22.w,
                decoration: const BoxDecoration(
                    color: Color(0xFFFF3B30), shape: BoxShape.circle),
                child: Center(
                    child: Container(
                        width: 10.w, height: 2.h, color: Colors.white)),
              ),
            ),
          ),
      ],
    );
  }
}
