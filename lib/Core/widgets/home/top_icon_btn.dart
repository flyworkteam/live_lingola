import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopIconBtn extends StatelessWidget {
  final String svgPath;
  final VoidCallback onTap;

  const TopIconBtn({super.key, required this.svgPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SvgPicture.asset(
        svgPath,
        width: 16.w,
        height: 16.w,
        colorFilter: const ColorFilter.mode(
          Color(0xFF0A70FF),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
