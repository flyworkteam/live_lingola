import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../Core/Utils/assets.dart';

class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  static const double _iconPx = 24;

  final _nameCtrl = TextEditingController(text: "Alex Johnson");
  final _mailCtrl = TextEditingController(text: "alex.johnson@icloud.com");
  int _age = 28;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mailCtrl.dispose();
    super.dispose();
  }

  TextStyle get _titleStyle => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        fontSize: 20.sp,
        height: 26 / 20,
        color: const Color(0xFF0F172A),
      );

  TextStyle get _labelStyle => TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.w700,
        fontSize: 14.sp,
        height: 1.0,
        color: const Color(0xFF64748B),
      );

  TextStyle get _inputTextStyle => TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.w700,
        fontSize: 14.sp,
        height: 1.0,
        color: const Color(0xFF0F172A),
      );

  TextStyle get _mailTextStyle => TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.w700,
        fontSize: 14.sp,
        height: 1.0,
        color: const Color(0xFF5F8486),
      );

  TextStyle get _saveTextStyle => TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 16.sp,
        height: 24 / 16,
        color: Colors.white,
      );

  TextStyle get _dialogTitleStyle => TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.w700,
        fontSize: 18.sp,
        height: 1.0,
        color: const Color(0xFF0F172A),
      );

  TextStyle get _dialogDescStyle => TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.w300,
        fontSize: 14.sp,
        height: 1.0,
        color: const Color(0xFF0F172A).withOpacity(.70),
      );

  TextStyle get _dialogDeleteBtnStyle => TextStyle(
        fontFamily: 'Lato',
        fontWeight: FontWeight.w500,
        fontSize: 14.sp,
        height: 1.0,
        color: Colors.white,
      );

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Poppins')),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'delete',
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
                    width: 320.w,
                    padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 16.h),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFEF4F4), Color(0xFFFFFFFF)],
                      ),
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppAssets.icDeleteAccount,
                              width: 32.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Are you sure you want to\ndelete your account?",
                          textAlign: TextAlign.center,
                          style: _dialogTitleStyle,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "This action cannot be undone, and all\nyour history and data will be\npermanently deleted.",
                          textAlign: TextAlign.center,
                          style: _dialogDescStyle,
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: double.infinity,
                          height: 44.h,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEA3B4A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.icBin,
                                  width: 20.w,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "Delete Account",
                                  style: _dialogDeleteBtnStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
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
                                fontFamily: 'Poppins',
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2563EB),
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
    );

    if (!mounted) return;
    if (confirmed == true) {
      _toast("Delete Account (demo)");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            18.w, MediaQuery.of(context).padding.top + 10.h, 18.w, 0),
        child: Column(
          children: [
            SizedBox(
              height: 56.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(12.r),
                      child: SizedBox(
                        width: 44.w,
                        height: 44.w,
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.icBack,
                            width: _iconPx.sp,
                            height: _iconPx.sp,
                            colorFilter: const ColorFilter.mode(
                                Color(0xFF0F172A), BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text("Profile Settings", style: _titleStyle),
                  SizedBox(width: 44.w),
                ],
              ),
            ),
            SizedBox(height: 6.h),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: ClampingScrollPhysics()),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 86.w,
                                      height: 86.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(3.w),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: ClipOval(
                                            child: Image.asset(
                                              "assets/images/logout/Alex.png",
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(Icons.person,
                                                      size: 40),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 2.w,
                                      bottom: 2.w,
                                      child: InkWell(
                                        onTap: () => _toast("Change Photo"),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        child: Container(
                                          width: 26.w,
                                          height: 26.w,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF5F8486),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              AppAssets.icEditCamera,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.srcIn),
                                              width: 14.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Change Photo",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF5F8486),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 18.h),
                          _Label("Full Name", style: _labelStyle),
                          SizedBox(height: 8.h),
                          _InputPill(
                            controller: _nameCtrl,
                            hint: "Full Name",
                            leadingIcon: AppAssets.icInputUser,
                            trailingIcon: null,
                            enabled: true,
                            iconPx: _iconPx,
                            textStyle: _inputTextStyle,
                          ),
                          SizedBox(height: 14.h),
                          _Label("E-mail", style: _labelStyle),
                          SizedBox(height: 8.h),
                          _InputPill(
                            controller: _mailCtrl,
                            hint: "E-mail",
                            leadingIcon: AppAssets.icInputMail,
                            trailingIcon: AppAssets.icInputLock,
                            enabled: false,
                            iconPx: _iconPx,
                            textStyle: _mailTextStyle,
                          ),
                          SizedBox(height: 14.h),
                          _Label("Age", style: _labelStyle),
                          SizedBox(height: 8.h),
                          _DropdownPill(
                            leadingIcon: AppAssets.icInputAge,
                            value: _age,
                            items: List<int>.generate(83, (i) => i + 18),
                            onChanged: (v) => setState(() => _age = v),
                            iconPx: _iconPx,
                            textStyle: _inputTextStyle,
                          ),
                          const Spacer(),
                          SizedBox(height: 28.h),
                          SizedBox(
                            height: 54.h,
                            child: ElevatedButton(
                              onPressed: () => _toast("Saved"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1677FF),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.icSave,
                                    width: _iconPx.sp,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text("Save", style: _saveTextStyle),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          InkWell(
                            onTap: _showDeleteAccountDialog,
                            borderRadius: BorderRadius.circular(12.r),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.icDeleteAccount,
                                    width: 18.w,
                                    colorFilter: const ColorFilter.mode(
                                        Color(0xFFEF4444), BlendMode.srcIn),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Delete Account",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      height: 1.0,
                                      color: const Color(0xFFEF4444),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final TextStyle style;
  const _Label(this.text, {required this.style});

  @override
  Widget build(BuildContext context) => Text(text, style: style);
}

class _InputPill extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String leadingIcon;
  final String? trailingIcon;
  final bool enabled;
  final double iconPx;
  final TextStyle textStyle;

  const _InputPill({
    required this.controller,
    required this.hint,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.enabled,
    required this.iconPx,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            leadingIcon,
            width: iconPx.sp,
            colorFilter:
                const ColorFilter.mode(Color(0xFF1677FF), BlendMode.srcIn),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              style: textStyle,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                hintStyle: textStyle.copyWith(color: const Color(0xFF94A3B8)),
              ),
            ),
          ),
          if (trailingIcon != null) ...[
            SvgPicture.asset(
              trailingIcon!,
              colorFilter:
                  const ColorFilter.mode(Color(0xFF94A3B8), BlendMode.srcIn),
              width: iconPx.sp,
            ),
          ],
        ],
      ),
    );
  }
}

class _DropdownPill extends StatelessWidget {
  final String leadingIcon;
  final int value;
  final List<int> items;
  final ValueChanged<int> onChanged;
  final double iconPx;
  final TextStyle textStyle;

  const _DropdownPill({
    required this.leadingIcon,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.iconPx,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            leadingIcon,
            width: iconPx.sp,
            colorFilter:
                const ColorFilter.mode(Color(0xFF1677FF), BlendMode.srcIn),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: value,
                isExpanded: true,
                icon: SvgPicture.asset(AppAssets.icBack, width: iconPx.sp),
                items: items
                    .map((e) => DropdownMenuItem<int>(
                          value: e,
                          child: Text("$e", style: textStyle),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
