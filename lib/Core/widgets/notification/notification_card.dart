import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotifItem item;

  const NotificationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFDEE5F7),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bildirim kategori ikonu ve arka planı
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Center(
              child: Image.asset(
                item.iconAsset,
                width: 28.w,
                height: 28.w,
                fit: BoxFit.contain,
              ),
            ),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık ve durum (zaman/okunmamış işareti) satırı
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),

                    // Okunmamış bildirimi işaretçisi ve zaman bilgisi
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (item.unread) ...[
                          Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0A70FF),
                            ),
                          ),
                          SizedBox(height: 1.h),
                        ],
                        Text(
                          item.time,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                // Bildirim içeriği
                Text(
                  item.body,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.sp,
                    height: 1.25,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                ),

                if (item.action != null) ...[
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.action!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0A70FF),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18.sp,
                        color: const Color(0xFF0A70FF),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
