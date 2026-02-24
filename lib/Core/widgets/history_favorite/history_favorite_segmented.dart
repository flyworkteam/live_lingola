import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryFavoriteSegmented extends StatelessWidget {
  final int index; // 0 history, 1 favorite
  final ValueChanged<int> onChanged;

  const HistoryFavoriteSegmented({
    super.key,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F9),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _SegBtn(
            text: "History",
            active: index == 0,
            onTap: () => onChanged(0),
          ),
          _SegBtn(
            text: "Favorite",
            active: index == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _SegBtn extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _SegBtn({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: active
                ? const [
                    BoxShadow(
                      color: Color(0x140B2B6B),
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    )
                  ]
                : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: active ? const Color(0xFF0A70FF) : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    );
  }
}
