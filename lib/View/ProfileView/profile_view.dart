// lib/View/ProfileView/profile_view.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/Theme/app_colors.dart';
import '../../Core/Routes/app_routes.dart';

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
          Image.asset(
            iconPath,
            width: 20.w,
            height: 20.w,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.lock_rounded,
              size: 20.sp,
              color: const Color(0xFFF59E0B),
            ),
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
  // ------- asset paths (assets/images/logout)
  static const String _avatarPath = 'assets/images/logout/Alex.png';

  static const String _icProfile = 'assets/images/logout/profile.png';
  static const String _icNotification = 'assets/images/logout/notification.png';
  static const String _icAppLang = 'assets/images/logout/app_language.png';

  static const String _icPrivacy = 'assets/images/logout/privacy.png';
  static const String _icTerms = 'assets/images/logout/terms_of_service.png';
  static const String _icShareFriend = 'assets/images/logout/share.png';
  static const String _icRate = 'assets/images/logout/rate.png';
  static const String _icFaq = 'assets/images/logout/faq.png';
  static const String _icSupport = 'assets/images/logout/support.png';
  static const String _icFeedback = 'assets/images/logout/feedback.png';

  static const String _icLogout = 'assets/images/logout/logout.png';
  static const String _icPro = 'assets/images/logout/pro.png';

  static const double _iconSize = 23; // all icons 23x23

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

  // taps
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
                      // background: linear-gradient(180deg, #FEF4F4 0%, #FFFFFF 100%);
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFEF4F4), Color(0xFFFFFFFF)],
                        stops: [0.0, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(22.r),
                      //  box-shadow: 0px 0px 4px 0px #00000040;
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000), // #00000040
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // TOP ICON (assets/images/logout/logout.png)
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
                                child: ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFFF87171),
                                    BlendMode.srcIn,
                                  ),
                                  child: Image.asset(
                                    _icLogout,
                                    width: 22.w,
                                    height: 22.w,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.logout_rounded,
                                      color: const Color(0xFFF87171),
                                      size: _iconSize.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),

                        // Lato Bold 18
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

                        // Lato Light 14
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

    if (confirmed == true) {
      // ignore: use_build_context_synchronously
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

                  // TOP BAR
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(12.r),
                        child: SizedBox(
                          width: 44.w,
                          height: 44.w,
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: _iconSize.sp,
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

                  // AVATAR
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

                  // PRO CARD (wave kaldırıldı)
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

                  // LOGOUT BUTTON
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
                              child: Image.asset(
                                _icLogout,
                                width: 22.w,
                                height: 22.w,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.logout_rounded,
                                  color: const Color(0xFFF87171),
                                  size: _iconSize.sp,
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

  // ---- helpers

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
                child: Image.asset(
                  assetPath,
                  width: _iconSize.w,
                  height: _iconSize.w,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.image_not_supported_outlined,
                    size: _iconSize.sp,
                    color: const Color(0xFF94A3B8),
                  ),
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
              child: Image.asset(
                assetPath,
                width: _iconSize.w,
                height: _iconSize.w,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  size: _iconSize.sp,
                  color: const Color(0xFF94A3B8),
                ),
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
