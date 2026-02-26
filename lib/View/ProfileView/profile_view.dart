import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Core/Theme/app_colors.dart';
import '../../Core/Routes/app_routes.dart';
import '../../Core/Utils/assets.dart';

import '../ProfileView/ProfileSettingsView/profile_settings_view.dart';
import '../ProfileView/ShareFriendView/share_friend_view.dart';
import '../ProfileView/FaqView/faq_view.dart';
import '../ProfileView/LanguageSelectView/select_language_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProPill extends StatelessWidget {
  final String iconPath;
  final String text;
  const _ProPill({required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFFFDE75), Color(0xFFFEEEAD)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 20.w,
            height: 20.w,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 10.w),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: const Color(0xFFF59E0B),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileViewState extends State<ProfileView> {
  static const String _avatarPath = 'assets/images/logout/Alex.png';

  static const String _icProfile = AppAssets.icProfile;
  static const String _icNotification = AppAssets.icProfileNotification;
  static const String _icAppLang = AppAssets.icAppLang;
  static const String _icPrivacy = AppAssets.icPrivacy;
  static const String _icTerms = AppAssets.icTerms;
  static const String _icShareFriend = AppAssets.icShareFriend;
  static const String _icRate = AppAssets.icRate;
  static const String _icFaq = AppAssets.icFaq;
  static const String _icSupport = AppAssets.icSupport;
  static const String _icFeedback = AppAssets.icFeedback;
  static const String _icLogout = AppAssets.icLogout;
  static const String _icPro = AppAssets.icPro;

  static const double _iconSize = 23;

  bool _notificationsOn = true;

  void _pushSlide(Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final tween =
              Tween(begin: const Offset(1, 0), end: Offset.zero).chain(
            CurveTween(curve: Curves.easeOutCubic),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _openProfileSettings() => _pushSlide(const ProfileSettingsView());
  void _openShareFriend() => _pushSlide(const ShareFriendView());
  void _openFaq() => _pushSlide(const FaqView());
  void _openLanguage() => _pushSlide(const SelectLanguageView());

  Future<void> _showLogoutDialog() async {
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'logout',
      barrierColor: Colors.black.withOpacity(.10),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, anim1, anim2) {
        return SafeArea(
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.transparent),
              ),
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 330.w,
                    padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 18.h),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFEF4F4), Color(0xFFFFFFFF)],
                        stops: [0.0, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 62.w,
                          height: 62.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 34.w,
                              height: 34.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE3E3),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  _icLogout,
                                  width: 22.w,
                                  height: 22.w,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFFF87171),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Text(
                          "You are about to log out",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "See you again soon! We'll miss your\nbreathing exercises.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                            height: 1.0,
                            color: const Color(0xFF0F172A).withOpacity(.70),
                          ),
                        ),
                        SizedBox(height: 22.h),
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEA3B4A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            child: Text(
                              "Log out",
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(false),
                          borderRadius: BorderRadius.circular(12.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.0,
                                color: const Color(0xFF0A70FF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim, _, child) {
        final curved =
            CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );

    if (!mounted) return;

    if (confirmed == true) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: ClampingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(12.r),
                        child: SizedBox(
                          width: 44.w,
                          height: 44.w,
                          child: Center(
                            child: SvgPicture.asset(
                              AppAssets.icBack,
                              width: 24.w,
                              height: 24.w,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Profile",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 44.w),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  Center(
                    child: Container(
                      width: 106.w,
                      height: 106.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: ClipOval(
                          child: Image.asset(
                            _avatarPath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.person,
                              color: const Color(0xFF0F172A),
                              size: _iconSize.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Center(
                    child: Text(
                      "Alex Johnson",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Center(
                    child: Text(
                      "Free Version",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        height: 26 / 12,
                        color: const Color(0x80000000),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(18.r),
                    child: Container(
                      height: 92.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.r),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF21B6FF),
                            Color(0xFF0A70FF),
                            Color(0xFF0057FF),
                          ],
                          stops: [0.0, 0.55, 1.0],
                        ),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0A70FF).withOpacity(.25),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Unlimited access to\nall features",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.sp,
                                height: 20 / 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.3,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const _ProPill(iconPath: _icPro, text: "Pro"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  _sectionTitle("ACCOUNT SETTINGS"),
                  SizedBox(height: 8.h),
                  _whiteCard(
                    Column(
                      children: [
                        _assetTile(
                          iconBg: const Color(0xFFEAF2FF),
                          assetPath: _icProfile,
                          title: "Profile Settings",
                          onTap: _openProfileSettings,
                        ),
                        _divider(),
                        _assetSwitchTile(
                          iconBg: const Color(0xFFF4ECFF),
                          assetPath: _icNotification,
                          title: "Notifications",
                          value: _notificationsOn,
                          onChanged: (v) =>
                              setState(() => _notificationsOn = v),
                        ),
                        _divider(),
                        _assetTile(
                          iconBg: const Color(0xFFE9FBF4),
                          assetPath: _icAppLang,
                          title: "App Language",
                          onTap: _openLanguage,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  _sectionTitle("GENERAL"),
                  SizedBox(height: 8.h),
                  _whiteCard(
                    Column(
                      children: [
                        _assetTile(
                          iconBg: const Color(0xFFE9FBF4),
                          assetPath: _icPrivacy,
                          title: "Privacy Policy",
                          onTap: () {},
                        ),
                        _divider(),
                        _assetTile(
                          iconBg: const Color(0xFFEFF6FF),
                          assetPath: _icTerms,
                          title: "Terms of Service",
                          onTap: () {},
                        ),
                        _divider(),
                        _assetTile(
                          iconBg: const Color(0xFFEFF6FF),
                          assetPath: _icShareFriend,
                          title: "Share Friend",
                          onTap: _openShareFriend,
                        ),
                        _divider(),
                        _assetTile(
                          iconBg: const Color(0xFFFFF2E6),
                          assetPath: _icRate,
                          title: "Rate Us",
                          onTap: () {},
                        ),
                        _divider(),
                        _assetTile(
                          iconBg: const Color(0xFFEFF2F9),
                          assetPath: _icFaq,
                          title: "F.A.Q.",
                          onTap: _openFaq,
                        ),
                        _divider(),
                        _assetTile(
                          iconBg: const Color(0xFFEFF6FF),
                          assetPath: _icSupport,
                          title: "Support",
                          onTap: () {},
                        ),
                        _divider(),
                        _assetTile(
                          iconBg: const Color(0xFFFFF7ED),
                          assetPath: _icFeedback,
                          title: "Feedback",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),
                  InkWell(
                    borderRadius: BorderRadius.circular(14.r),
                    onTap: _showLogoutDialog,
                    child: Container(
                      height: 52.h,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEFF0),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: const Color(0xFFFFD6D9)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 34.w,
                            height: 34.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                _icLogout,
                                width: 22.w,
                                height: 22.w,
                                fit: BoxFit.contain,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFFF87171),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            "Çıkış Yap",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Text(
                      "version 2.1.0",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        color: Colors.black.withOpacity(.35),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          height: 1.0,
          letterSpacing: 0,
          color: const Color(0x80000000),
        ),
      ),
    );
  }

  Widget _whiteCard(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDEE5F7).withOpacity(.75),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFEFF2F9),
      indent: 14.w,
      endIndent: 14.w,
    );
  }

  TextStyle get _tileTitleStyle => TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 1.0,
        letterSpacing: -0.3,
        color: const Color(0xFF0F172A),
      );

  Widget _assetTile({
    required Color iconBg,
    required String assetPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  assetPath,
                  width: _iconSize.w,
                  height: _iconSize.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(child: Text(title, style: _tileTitleStyle)),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFF94A3B8),
              size: _iconSize.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _assetSwitchTile({
    required Color iconBg,
    required String assetPath,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                assetPath,
                width: _iconSize.w,
                height: _iconSize.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(child: Text(title, style: _tileTitleStyle)),
          Transform.scale(
            scale: 0.95,
            child: Switch(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
