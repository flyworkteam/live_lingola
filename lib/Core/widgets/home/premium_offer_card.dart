import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lingola_app/Core/Utils/assets.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

class PremiumOfferCard extends StatelessWidget {
  final VoidCallback? onTap;

  const PremiumOfferCard({
    super.key,
    this.onTap,
  });

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    const double imageWidth = 110;
    const double imageRight = 16;
    const double imageTop = 8;
    const double imageBottom = 0;
    const double textRightPadding = 138;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleTap(context),
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: 150.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 6),
                blurRadius: 16,
                color: Color(0x220B2B6B),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              Positioned(
                right: imageRight.w,
                top: imageTop.h,
                bottom: imageBottom.h,
                child: SizedBox(
                  width: imageWidth.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(22.r),
                      bottomRight: Radius.circular(22.r),
                    ),
                    child: Image.asset(
                      'assets/images/home/premium_girl.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  18.w,
                  16.h,
                  textRightPadding.w,
                  16.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF03B7FF), Color(0xFF0A70FF)],
                      ).createShader(bounds),
                      child: Text(
                        l10n.unlimitedLiveTranslation,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                          letterSpacing: -0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      l10n.removeDailyLimits,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.09,
                        letterSpacing: -1.0,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    InkWell(
                      onTap: () => _handleTap(context),
                      borderRadius: BorderRadius.circular(999.r),
                      child: Container(
                        height: 30.h,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment(1.0, -0.2),
                            end: Alignment(-1.0, 0.8),
                            colors: [
                              Color(0xFF03B7FF),
                              Color(0xFF2EC9FF),
                              Color(0xFF0A70FF),
                            ],
                            stops: [0.1939, 0.45, 0.8061],
                          ),
                          borderRadius: BorderRadius.circular(999.r),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x2603B7FF),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4.w),
                                child: SvgPicture.asset(
                                  AppAssets.icPremium,
                                  fit: BoxFit.contain,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Flexible(
                              child: Text(
                                l10n.getPremium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
