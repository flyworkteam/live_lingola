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
    return Row(
      children: [
        if (deleteMode) ...[
          InkWell(
            onTap: onSelectToggle,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFFF3B30) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFFFF3B30)
                      : Colors.white.withOpacity(0.9),
                  width: 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(
                selected ? Icons.remove_rounded : Icons.circle_outlined,
                size: selected ? 18.sp : 14.sp,
                color: selected ? Colors.white : Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          SizedBox(width: 10.w),
        ],
        Expanded(child: child),
      ],
    );
  }
}
