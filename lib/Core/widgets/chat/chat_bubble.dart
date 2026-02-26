import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage msg;
  final String botIconAsset;

  const ChatBubble({
    super.key,
    required this.msg,
    required this.botIconAsset,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleRadius = 16.r;

    if (!msg.fromBot) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(top: 12.h),
          padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
          constraints: BoxConstraints(maxWidth: 250.w),
          decoration: BoxDecoration(
            color: const Color(0xFF0A70FF),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(bubbleRadius),
              topRight: Radius.circular(bubbleRadius),
              bottomLeft: Radius.circular(bubbleRadius),
              bottomRight: Radius.circular(6.r),
            ),
          ),
          child: Text(
            msg.text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 18 / 12,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F0FF),
              borderRadius: BorderRadius.circular(10.r),
            ),
            // ✅ GÜNCELLENDİ: Image.asset yerine SvgPicture.asset kullanıldı
            child: SvgPicture.asset(
              botIconAsset,
              fit: BoxFit.contain,
              // Eğer ikon çok koyu gelirse rengini buradan zorlayabilirsin:
              // colorFilter: const ColorFilter.mode(Color(0xFF0A70FF), BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x140B2B6B),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      height: 18 / 12,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  if (msg.actionText != null) ...[
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          msg.actionText!,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0A70FF),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.open_in_new_rounded,
                          size: 14.sp,
                          color: const Color(0xFF0A70FF),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
