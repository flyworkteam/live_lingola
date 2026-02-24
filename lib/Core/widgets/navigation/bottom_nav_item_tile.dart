import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  final String homeAsset;
  final String chatAsset;
  final String micAsset;
  final String cameraAsset;

  final Color activeColor;
  final Color inactiveColor;

  final double outerBottomPadding;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.homeAsset,
    required this.chatAsset,
    required this.micAsset,
    required this.cameraAsset,
    this.activeColor = const Color(0xFF0A70FF),
    this.inactiveColor = const Color(0xFF0F172A),
    this.outerBottomPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, outerBottomPadding.h),
        child: Container(
          height: 62.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999.r),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFDEE5F7),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(homeAsset, 0),
              _item(chatAsset, 1),
              _item(micAsset, 2),
              _item(cameraAsset, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(String asset, int index) {
    final bool active = currentIndex == index;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => onTap(index),
      child: SizedBox(
        width: 60.w,
        height: 62.h,
        child: Center(
          child: Image.asset(
            asset,
            width: 24.w,
            height: 24.w,
            fit: BoxFit.contain,
            color: active ? activeColor : inactiveColor,
          ),
        ),
      ),
    );
  }
}
