import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectPill extends StatelessWidget {
  final String text;
  final Widget? leading;
  final bool selected;
  final VoidCallback onTap;

  const SelectPill({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color:
                  selected ? const Color(0xFF0A70FF) : const Color(0xFFE6EAF2),
              width: selected ? 1.6 : 1.0,
            ),
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
