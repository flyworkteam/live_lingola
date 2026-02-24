import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Core/Theme/ui_metrics.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        UIMetrics.screenHPad,
        8.h,
        UIMetrics.screenHPad,
        12.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: UIMetrics.inputHeight,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(UIMetrics.inputRadius),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1F0B2B6B),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 18 / 12,
                    color: const Color(0xFF0F172A),
                  ),
                  cursorColor: const Color(0xFF0A70FF),
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
          SizedBox(width: 10.w),
          InkWell(
            onTap: onSend,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: UIMetrics.sendBtnSize,
              height: UIMetrics.sendBtnSize,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0A70FF),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x260A70FF),
                    blurRadius: 14,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.send_rounded,
                size: UIMetrics.sendIconSize,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
