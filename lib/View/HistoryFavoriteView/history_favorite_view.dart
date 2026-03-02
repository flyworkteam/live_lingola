import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Core/Utils/assets.dart';
import '../../Core/widgets/navigation/bottom_nav_item_tile.dart';

class HistoryFavoriteView extends StatefulWidget {
  final int initialTab;

  const HistoryFavoriteView({super.key, this.initialTab = 0});

  @override
  State<HistoryFavoriteView> createState() => _HistoryFavoriteViewState();
}

class _HistoryFavoriteViewState extends State<HistoryFavoriteView> {
  late int _tab;
  String _query = '';

  final List<_HFItem> _history = [
    _HFItem(
      fromCode: 'TR',
      toCode: 'EN',
      title: 'Bu akşam yemeğe çıkıyor muyuz?',
      subtitle: 'Are we going out for dinner tonight?',
      time: '14:20',
      starred: false,
    ),
    _HFItem(
      fromCode: 'EN',
      toCode: 'TR',
      title: 'Where is the nearest subway station?',
      subtitle: 'En yakın metro istasyonu nerede?',
      time: '11:05',
      starred: true,
    ),
    _HFItem(
      fromCode: 'TR',
      toCode: 'DE',
      title: 'Bize yardım ettiğiniz için teşekkürler',
      subtitle: 'Vielen Dank für Ihre Hilfe.',
      time: '09:12',
      starred: true,
    ),
  ];

  final List<_HFItem> _favorite = [
    _HFItem(
      fromCode: 'TR',
      toCode: 'EN',
      title: 'Bu akşam yemeğe çıkıyor muyuz?',
      subtitle: 'Are we going out for dinner tonight?',
      time: '14:20',
      starred: true,
    ),
    _HFItem(
      fromCode: 'EN',
      toCode: 'TR',
      title: 'Where is the nearest subway station?',
      subtitle: 'En yakın metro istasyonu nerede?',
      time: '11:05',
      starred: true,
    ),
    _HFItem(
      fromCode: 'TR',
      toCode: 'DE',
      title: 'Bize yardım ettiğiniz için teşekkürler',
      subtitle: 'Vielen Dank für Ihre Hilfe.',
      time: '09:12',
      starred: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab.clamp(0, 1);
  }

  List<_HFItem> get _activeList => _tab == 0 ? _history : _favorite;

  void _toggleStar(int index) {
    setState(() {
      _activeList[index].starred = !_activeList[index].starred;
    });
  }

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0xFF000000).withOpacity(0.35),
      builder: (context) => const _ClearConfirmDialog(),
    );

    if (confirmed == true) {
      setState(() {
        if (_tab == 0) {
          _history.clear();
        } else {
          _favorite.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _activeList.where((e) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return e.title.toLowerCase().contains(q) ||
          e.subtitle.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    width: 40.w,
                    height: 40.w,
                    child: Center(
                      child: SvgPicture.asset(
                        AppAssets.icBack2,
                        width: 16.sp,
                        height: 16.sp,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF0F172A),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "History & Favorite",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40.w),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x140B2B6B),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.icSearch,
                    width: 18.sp,
                    height: 18.sp,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF94A3B8),
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w300,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              height: 44.h,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF2F9),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SegmentBtn(
                      title: 'History',
                      active: _tab == 0,
                      onTap: () => setState(() => _tab = 0),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _SegmentBtn(
                      title: 'Favorite',
                      active: _tab == 1,
                      onTap: () => setState(() => _tab = 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: _confirmClear,
                  child: Text(
                    'Clear history',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0A70FF),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 18.h),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final item = filtered[i];
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _HFCard(
                    item: item,
                    onStarTap: () {
                      final realIndex = _activeList.indexOf(item);
                      if (realIndex != -1) _toggleStar(realIndex);
                    },
                  ),
                );
              },
            ),
          ),
          BottomNavBar(
            currentIndex: 0,
            onTap: (i) {
              if (i == 0) Navigator.pop(context);
            },
            homeAsset: AppAssets.navHome,
            chatAsset: AppAssets.navChat,
            micAsset: AppAssets.navMic,
            cameraAsset: AppAssets.navCamera,
            outerBottomPadding: 20,
          ),
        ],
      ),
    );
  }
}

class _ClearConfirmDialog extends StatelessWidget {
  const _ClearConfirmDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 273.w,
        height: 199.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF9EA9B8),
              blurRadius: 10,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 14.h),
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: const Color(0xFFE7F0FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.icClean,
                  width: 40.w,
                  height: 40.w,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF0A70FF),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                'Clear History',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Are you sure you want to\nclear your history?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                fontSize: 11.sp,
                color: const Color(0xFF475569),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 55.w, right: 18.w, bottom: 16.h),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context, false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(50.r),
                    onTap: () => Navigator.pop(context, true),
                    child: Container(
                      width: 116.w,
                      height: 28.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A70FF),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Clear',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          color: Colors.white,
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
    );
  }
}

class _HFItem {
  final String fromCode;
  final String toCode;
  final String title;
  final String subtitle;
  final String time;
  bool starred;

  _HFItem({
    required this.fromCode,
    required this.toCode,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.starred,
  });
}

class _SegmentBtn extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;

  const _SegmentBtn({
    required this.title,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: active
              ? const [
                  BoxShadow(
                    color: Color(0x140B2B6B),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: active ? const Color(0xFF0A70FF) : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    );
  }
}

class _HFCard extends StatelessWidget {
  final _HFItem item;
  final VoidCallback onStarTap;

  const _HFCard({required this.item, required this.onStarTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140B2B6B),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LangPill(code: item.fromCode),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_rounded,
                size: 18.sp,
                color: const Color(0xFF0F172A),
              ),
              SizedBox(width: 8.w),
              _LangPill(code: item.toCode),
              const Spacer(),
              InkWell(
                onTap: onStarTap,
                child: Icon(
                  item.starred ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 22.sp,
                  color: item.starred
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            item.title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            item.subtitle,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0A70FF),
            ),
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              item.time,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  final String code;
  const _LangPill({required this.code});

  String get _flagName {
    switch (code.toUpperCase()) {
      case 'TR':
        return 'Turkish';
      case 'EN':
        return 'English';
      case 'DE':
        return 'German';
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F0FF),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/flags/$_flagName.png',
            width: 16.w,
            height: 16.w,
          ),
          SizedBox(width: 6.w),
          Text(
            code,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
