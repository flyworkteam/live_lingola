// lib/View/NotificationView/notifications_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../HomeView/home_and_notifications_view.dart';

import '../../Core/Theme/app_colors.dart';
import '../../Core/widgets/notification/notification_card.dart';
import '../../Core/widgets/notification/notification_section_label.dart';
import '../../Core/widgets/notification/selectable_notification_row.dart';
import '../../Models/notification_model.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  bool _deleteMode = false;
  final Set<String> _selectedIds = <String>{};

  final List<NotifItem> _items = const [
    NotifItem(
      id: 't1',
      section: NotifSection.today,
      iconBg: Color(0xFFE7F0FF),
      iconAsset: 'assets/images/notificationspage/notification-status.png',
      iconColor: Color(0xFF0A70FF),
      title: 'New Translation Ready',
      body:
          'Your audio translation file has been\nsuccessfully converted to text and translated.',
      time: '10 min. ago',
      unread: true,
    ),
    NotifItem(
      id: 't2',
      section: NotifSection.today,
      iconBg: Color(0xFFFFE9D6),
      iconAsset: 'assets/images/notificationspage/ticket-star.png',
      iconColor: Color(0xFFFF8A00),
      title: 'A Special Offer Awaits You',
      body: 'Upgrade to Premium for unlimited photo\ntranslations at 50% off.',
      time: '2h ago',
      unread: true,
      action: 'SEE THE OPPORTUNITY',
    ),
    NotifItem(
      id: 'y1',
      section: NotifSection.yesterday,
      iconBg: Color(0xFFE7F7EF),
      iconAsset: 'assets/images/notificationspage/Robot.png',
      iconColor: Color(0xFF10B981),
      title: 'Ai Chat ile Sohbet et',
      body: 'AI chat ile aklına takılan sorular\nanında yanıt bul.',
      time: '2:20 PM',
      unread: false,
    ),
  ];

  late final List<NotifItem> _mutableItems = List<NotifItem>.from(_items);

  void _removeByIds(Set<String> ids) {
    setState(() {
      _mutableItems.removeWhere((e) => ids.contains(e.id));
      _selectedIds.clear();
      _deleteMode = false;
    });
  }

  void _toggleDeleteModeOrDeleteSelected() {
    if (!_deleteMode) {
      setState(() {
        _deleteMode = true;
        _selectedIds.clear();
      });
      return;
    }

    if (_selectedIds.isEmpty) {
      setState(() {
        _deleteMode = false;
        _selectedIds.clear();
      });
      return;
    }

    _removeByIds(Set<String>.from(_selectedIds));
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
    final topPad = MediaQuery.of(context).padding.top;

    final today =
        _mutableItems.where((e) => e.section == NotifSection.today).toList();
    final yesterday = _mutableItems
        .where((e) => e.section == NotifSection.yesterday)
        .toList();

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
                      borderRadius: BorderRadius.circular(999),
                      child: SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18.sp,
                          color: Colors.white,
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
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: _toggleDeleteModeOrDeleteSelected,
                      borderRadius: BorderRadius.circular(999),
                      child: SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: Icon(
                          !_deleteMode
                              ? Icons.delete_outline_rounded
                              : (_selectedIds.isEmpty
                                  ? Icons.close_rounded
                                  : Icons.delete_outline_rounded),
                          size: 22.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22.h),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: EdgeInsets.only(
                      bottom: 14.h + MediaQuery.of(context).padding.bottom,
                    ),
                    children: [
                      if (today.isNotEmpty) ...[
                        const NotificationSectionLabel(
                          text: 'Today',
                          isOnBlue: true,
                        ),
                        SizedBox(height: 10.h),
                        ...today.map(
                          (e) => Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: SelectableNotificationRow(
                              deleteMode: _deleteMode,
                              selected: _selectedIds.contains(e.id),
                              onSelectToggle: () {
                                setState(() {
                                  if (_selectedIds.contains(e.id)) {
                                    _selectedIds.remove(e.id);
                                  } else {
                                    _selectedIds.add(e.id);
                                  }
                                });
                              },
                              child: NotificationCard(item: e),
                            ),
                          ),
                        ),
                      ],
                      if (yesterday.isNotEmpty) ...[
                        SizedBox(height: 6.h),
                        const NotificationSectionLabel(
                          text: 'Yesterday',
                          isOnBlue: false,
                        ),
                        SizedBox(height: 10.h),
                        ...yesterday.map(
                          (e) => Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: SelectableNotificationRow(
                              deleteMode: _deleteMode,
                              selected: _selectedIds.contains(e.id),
                              onSelectToggle: () {
                                setState(() {
                                  if (_selectedIds.contains(e.id)) {
                                    _selectedIds.remove(e.id);
                                  } else {
                                    _selectedIds.add(e.id);
                                  }
                                });
                              },
                              child: NotificationCard(item: e),
                            ),
                          ),
                        ),
                      ],
                      if (_mutableItems.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 60.h),
                          child: Center(
                            child: Text(
                              "No notifications",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.85),
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
}
