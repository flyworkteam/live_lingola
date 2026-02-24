import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavItem {
  final IconData? icon;
  final String? assetPath;

  const BottomNavItem.icon({required this.icon}) : assetPath = null;
  const BottomNavItem.asset({required this.assetPath}) : icon = null;
}

class BottomNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<BottomNavItem> items;

  const BottomNavBar({
    super.key,
    required this.index,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 18.w,
        right: 18.w,
        bottom: (bottomPad > 0 ? bottomPad : 12.h),
        top: 10.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        height: 66.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A0F172A),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(items.length, (i) {
            final selected = i == index;

            return InkWell(
              onTap: () => onChanged(i),
              borderRadius: BorderRadius.circular(18.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 56.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF0A70FF).withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Center(
                  child: _NavIcon(
                    item: items[i],
                    selected: selected,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final BottomNavItem item;
  final bool selected;

  const _NavIcon({
    required this.item,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF0A70FF) : const Color(0xFF94A3B8);

    if (item.assetPath != null) {
      return Image.asset(
        item.assetPath!,
        width: 22.w,
        height: 22.w,
        color: color,
        fit: BoxFit.contain,
      );
    }

    return Icon(item.icon, color: color, size: 24.sp);
  }
}
