import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A0B2B6B),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => onSend(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 18 / 12,
                    color: const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Type a message...",
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      height: 18 / 12,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onSend,
            child: Container(
              width: 46.w,
              height: 46.w,
              decoration: const BoxDecoration(
                color: Color(0xFF0A70FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send_rounded,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
