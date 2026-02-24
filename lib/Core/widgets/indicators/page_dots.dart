import 'package:flutter/material.dart';
import '../../Theme/app_colors.dart';

class PageDots extends StatelessWidget {
  final int count;
  final int index;

  const PageDots({
    super.key,
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
