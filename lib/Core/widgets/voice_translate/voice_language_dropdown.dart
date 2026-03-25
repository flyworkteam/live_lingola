import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VoiceLanguageDropdown extends StatelessWidget {
  final String selectedCode;
  final List<String> languages;
  final String Function(String code) localizedNameBuilder;
  final String Function(String code) flagAssetBuilder;
  final ValueChanged<String> onSelected;

  const VoiceLanguageDropdown({
    super.key,
    required this.selectedCode,
    required this.languages,
    required this.localizedNameBuilder,
    required this.flagAssetBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 360.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140B2B6B),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: languages.length,
        separatorBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFE6EBF3),
          ),
        ),
        itemBuilder: (context, index) {
          final code = languages[index];
          final isSelected = code == selectedCode;

          return InkWell(
            onTap: () => onSelected(code),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  _Flag(flagAssetBuilder(code)),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      localizedNameBuilder(code),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_rounded,
                      size: 24.sp,
                      color: const Color(0xFF0A70FF),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final String assetPath;

  const _Flag(this.assetPath);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26.w,
      height: 18.h,
      child: assetPath.toLowerCase().endsWith('.svg')
          ? SvgPicture.asset(
              assetPath,
              width: 26.w,
              height: 18.h,
              fit: BoxFit.cover,
            )
          : Image.asset(
              assetPath,
              width: 26.w,
              height: 18.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => SizedBox(
                width: 26.w,
                height: 18.h,
              ),
            ),
    );
  }
}
