import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingora_app/View/PhotoTranslateView/photo_translate_view.dart';

import '../../Core/Theme/app_colors.dart';
import '../../Core/Utils/assets.dart';

import '../../Core/widgets/home/feature_btn.dart';
import '../../Core/widgets/home/greeting_pill.dart';
import '../../Core/widgets/home/more_features_figma.dart';
import '../../Core/widgets/home/premium_offer_card.dart';
import '../../Core/widgets/home/quick_action_data.dart';
import '../../Core/widgets/home/quick_action_item.dart';
import '../../Core/widgets/home/top_icon_btn.dart';

import '../../Core/widgets/navigation/bottom_nav_item_tile.dart';

import '../NotificationView/notifications_view.dart';
import '../HistoryFavoriteView/history_favorite_view.dart';
import '../FrequentlyTermsView/frequently_terms_view.dart';
import '../TranslationView/VoiceTranslationView/voice_translate_view.dart';
import '../TranslationView/TextTranslationView/text_translation_view.dart';

import '../ProfileView/profile_view.dart';
import '../ChatView/ai_chat_view.dart';

class HomeAndNotificationsView extends StatefulWidget {
  const HomeAndNotificationsView({super.key});

  @override
  State<HomeAndNotificationsView> createState() =>
      _HomeAndNotificationsViewState();
}

class _HomeAndNotificationsViewState extends State<HomeAndNotificationsView> {
  int _index = 0;

  void _goToTab(int i) => setState(() => _index = i);

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
              position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  void _openNotifications() => _pushSlide(const NotificationsView());

  void _openHistoryFavorite({required int initialTab}) =>
      _pushSlide(HistoryFavoriteView(initialTab: initialTab));

  void _openFrequentlyTerms() => _pushSlide(const FrequentlyTermsView());

  void _openProfile() => _pushSlide(const ProfileView());

  void _openAiChat() {
    _pushSlide(const AiChatView());
  }

  void _handleQuickActionTap(dynamic data) {
    final String title = ((data.title ?? '') as String).toLowerCase();

    if (title.contains('ai') || title.contains('chat')) {
      _openAiChat();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeTab(
        onNotificationsTap: _openNotifications,
        onHistoryTap: () => _openHistoryFavorite(initialTab: 0),
        onFavoriteTap: () => _openHistoryFavorite(initialTab: 1),
        onFrequentlyTap: _openFrequentlyTerms,
        onVoiceTap: () => _goToTab(2),
        onPhotoTap: () => _goToTab(3),
        onTextTap: () => _goToTab(1),
        onProfileTap: _openProfile,
        onQuickActionTap: _handleQuickActionTap,
      ),
      TextTranslationView(
        onBackToHome: () => _goToTab(0),
      ),
      VoiceTranslateView(
        onBackToHome: () => _goToTab(0),
      ),
      PhotoTranslateView(
        onBackToHome: () => _goToTab(0),
      ),
    ];

    final safeIndex = _index.clamp(0, pages.length - 1);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration:
                  const BoxDecoration(gradient: AppColors.primaryGradient),
            ),
          ),
          pages[safeIndex],
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: safeIndex,
        onTap: _goToTab,
        homeAsset: AppAssets.navHome,
        chatAsset: AppAssets.navChat,
        micAsset: AppAssets.navMic,
        cameraAsset: AppAssets.navCamera,
        outerBottomPadding: 20,
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final VoidCallback onNotificationsTap;
  final VoidCallback onHistoryTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onFrequentlyTap;

  final VoidCallback onVoiceTap;
  final VoidCallback onPhotoTap;
  final VoidCallback onTextTap;

  final VoidCallback onProfileTap;

  final void Function(dynamic data) onQuickActionTap;

  const _HomeTab({
    required this.onNotificationsTap,
    required this.onHistoryTap,
    required this.onFavoriteTap,
    required this.onFrequentlyTap,
    required this.onVoiceTap,
    required this.onPhotoTap,
    required this.onTextTap,
    required this.onProfileTap,
    required this.onQuickActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: ClampingScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 10.h),
                Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(30.r),
                      onTap: onProfileTap,
                      child: const GreetingPill(),
                    ),
                    const Spacer(),
                    Container(
                      width: 29.w,
                      height: 29.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: TopIconBtn(
                          svgPath: AppAssets.icNotification,
                          onTap: onNotificationsTap,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      width: 29.w,
                      height: 29.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: TopIconBtn(
                          svgPath: AppAssets.icSettings,
                          onTap: onProfileTap,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Let’s start translating into\nyour desired language",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22.sp,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FeatureBtn(
                      svgPath: AppAssets.icMicFeature,
                      title: "Instant Voice\nTranslation",
                      onTap: onVoiceTap,
                    ),
                    FeatureBtn(
                      svgPath: AppAssets.icCameraFeature,
                      title: "Instant Photo\nTranslation",
                      onTap: onPhotoTap,
                    ),
                    FeatureBtn(
                      svgPath: AppAssets.icTextFeature,
                      title: "Instant Text\nTranslation",
                      onTap: onTextTap,
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                const PremiumOfferCard(),
                SizedBox(height: 18.h),
                MoreFeaturesFigma(
                  onHistoryTap: onHistoryTap,
                  onFavoriteTap: onFavoriteTap,
                  onFrequentlyTap: onFrequentlyTap,
                ),
                SizedBox(height: 18.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 120.h + bottomPadding),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, i) => QuickActionItem(
                  data: quickActions[i],
                  onTap: () => onQuickActionTap(quickActions[i]),
                ),
                childCount: quickActions.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14.h,
                crossAxisSpacing: 14.w,
                childAspectRatio: 2.85,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
