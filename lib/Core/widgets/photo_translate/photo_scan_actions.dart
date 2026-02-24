import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoScanActions extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;

  const PhotoScanActions({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onGalleryTap,
          child: Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F0B2B6B),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.photo_library_outlined,
              size: 18.sp,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ),
        SizedBox(width: 18.w),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onCameraTap,
          child: Container(
            width: 56.w,
            height: 56.w,
            decoration: const BoxDecoration(
              color: Color(0xFFE7F0FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF0A70FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
