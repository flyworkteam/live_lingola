import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'quick_action_data.dart';

class QuickActionItem extends StatelessWidget {
  final QuickActionData data;
  final VoidCallback? onTap;

  const QuickActionItem({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: const [
            BoxShadow(
                color: Color(0xFFDEE5F7), blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: data.tileColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Image.asset(data.iconAsset),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A))),
            ),
          ],
        ),
      ),
    );
  }
}
