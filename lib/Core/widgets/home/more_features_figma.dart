import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingola_app/Core/Utils/assets.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

import 'big_action_card.dart';

class MoreFeaturesFigma extends StatelessWidget {
  final VoidCallback? onHistoryTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onFrequentlyTap;

  const MoreFeaturesFigma({
    super.key,
    this.onHistoryTap,
    this.onFavoriteTap,
    this.onFrequentlyTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.moreFeatures,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 12.h),
        InkWell(
          borderRadius: BorderRadius.circular(26.r),
          onTap: onFrequentlyTap,
          child: Container(
            width: double.infinity,
            height: 110.h,
            padding: EdgeInsets.fromLTRB(18.w, 14.h, 14.w, 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26.r),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F0B2B6B),
                  blurRadius: 18,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF03B7FF),
                            Color(0xFF0A70FF),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          l10n.frequentlyUsed,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.6,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        l10n.reviewMostFrequentlyUsedTerms,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.05,
                          letterSpacing: -0.9,
                          color: const Color(0xFF0B1220),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                SizedBox(
                  width: 74.w,
                  height: 74.w,
                  child: SvgPicture.asset(
                    AppAssets.icFrequently,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(
              child: BigActionCard(
                title: l10n.history,
                active: false,
                iconAsset: AppAssets.icHistory,
                onTap: onHistoryTap,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: BigActionCard(
                title: l10n.favorite,
                active: true,
                iconAsset: AppAssets.icFavorite,
                onTap: onFavoriteTap,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
