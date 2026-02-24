import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GreetingPill extends StatelessWidget {
  const GreetingPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12.r,
            backgroundColor: Colors.white.withOpacity(0.9),
            child:
                Icon(Icons.person, size: 14.sp, color: const Color(0xFF0A70FF)),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good Morning",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.0)),
              SizedBox(height: 2.h),
              Text("Hi, Jhon",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.0)),
            ],
          )
        ],
      ),
    );
  }
}
