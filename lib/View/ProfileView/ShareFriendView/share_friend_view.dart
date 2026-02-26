import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../Core/Utils/assets.dart';

class ShareFriendView extends StatefulWidget {
  const ShareFriendView({super.key});

  @override
  State<ShareFriendView> createState() => _ShareFriendViewState();
}

class _ShareFriendViewState extends State<ShareFriendView> {
  final String _link = "https://lingolalive.app/invite?friend=alex_johnson";

  void _copy() async {
    await Clipboard.setData(ClipboardData(text: _link));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Link copied", style: TextStyle(fontFamily: 'Lato')),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        color: Colors.transparent,
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.icBack,
                            width: 24.w,
                            height: 24.w,
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Share with Friend",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                        height: 26 / 20,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: 24.w),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              Center(
                child: Image.asset(
                  "assets/images/logout/sharefriend.png",
                  width: 300.w,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.people_alt_outlined,
                      size: 100,
                      color: Colors.grey),
                ),
              ),
              SizedBox(height: 35.h),
              Text(
                "Share with Friend",
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                  height: 1.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Invite your friends and enjoy\ntranslate together",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                  height: 1.0,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 32.h),
              Container(
                width: 298.w,
                height: 173.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFD4D4D4), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "LINK",
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        letterSpacing: 1.4,
                        color: const Color(0xFF7D7D7D),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      width: 260.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(color: const Color(0xFFEFEFEF)),
                        color: const Color(0xFFF9F9F9),
                      ),
                      child: Text(
                        _link,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 14.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    GestureDetector(
                      onTap: _copy,
                      child: Container(
                        width: 260.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/logout/copy_link.png",
                              width: 18.w,
                              height: 18.h,
                              color: Colors.white,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.copy,
                                      color: Colors.white, size: 18),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Copy the link",
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
