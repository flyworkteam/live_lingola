import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../HomeView/home_and_notifications_view.dart';

import '../../Core/Theme/app_colors.dart';
import '../../Core/Utils/assets.dart';
import '../../Core/widgets/notification/notification_card.dart';
import '../../Core/widgets/notification/selectable_notification_row.dart';
import '../../Models/notification_model.dart';
import '../../Riverpod/Providers/notifications_inbox_provider.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> {
  bool _deleteMode = false;

  void _deleteOne(String id) {
    ref.read(notificationsInboxProvider.notifier).removeNotification(id);
  }

  void _toggleDeleteMode() {
    setState(() {
      _deleteMode = !_deleteMode;
    });
  }

  void _onBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeAndNotificationsView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(notificationsInboxProvider);

    final topPad = MediaQuery.of(context).padding.top;
    final today = items.where((e) => e.section == NotifSection.today).toList();
    final yesterday =
        items.where((e) => e.section == NotifSection.yesterday).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration:
                  const BoxDecoration(gradient: AppColors.primaryGradient),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, topPad + 10.h, 18.w, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: _onBack,
                      child: SvgPicture.asset(
                        AppAssets.icBack,
                        width: 18.sp,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Notifications",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: _toggleDeleteMode,
                      child: _deleteMode
                          ? Icon(
                              Icons.close_rounded,
                              size: 24.sp,
                              color: Colors.white,
                            )
                          : SvgPicture.asset(
                              AppAssets.icTrash,
                              width: 22.sp,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 20.h),
                    children: [
                      if (today.isNotEmpty) ...[
                        _buildSectionLabel("Today", true),
                        SizedBox(height: 10.h),
                        ...today.map((e) => _buildRow(e)),
                      ],
                      if (yesterday.isNotEmpty) ...[
                        SizedBox(height: 10.h),
                        _buildSectionLabel("Yesterday", false),
                        SizedBox(height: 10.h),
                        ...yesterday.map((e) => _buildRow(e)),
                      ],
                      if (items.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 100.h),
                          child: Center(
                            child: Text(
                              "No notifications",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, bool isToday) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: isToday ? 0 : 2.w),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          height: 26 / 12,
          color: const Color(0x80000000),
        ),
      ),
    );
  }

  Widget _buildRow(NotifItem e) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h, left: _deleteMode ? 8.w : 0),
      child: SelectableNotificationRow(
        deleteMode: _deleteMode,
        selected: false,
        onSelectToggle: () => _deleteOne(e.id),
        child: NotificationCard(item: e),
      ),
    );
  }
}
