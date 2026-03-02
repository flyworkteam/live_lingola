import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Core/Utils/assets.dart';
import '../../Core/widgets/navigation/bottom_nav_item_tile.dart';

class FrequentlyTermsView extends StatefulWidget {
  const FrequentlyTermsView({super.key});

  @override
  State<FrequentlyTermsView> createState() => _FrequentlyTermsViewState();
}

class _FrequentlyTermsViewState extends State<FrequentlyTermsView> {
  String _query = '';

  final List<_TermItem> _items = [
    _TermItem(
      fromCode: 'TR',
      toCode: 'EN',
      title: 'Bu akşam yemeğe çıkıyor muyuz?',
      subtitle: 'Are we going out for dinner tonight?',
      time: '14:20',
    ),
    _TermItem(
      fromCode: 'EN',
      toCode: 'TR',
      title: 'Where is the nearest subway station?',
      subtitle: 'En yakın metro istasyonu nerede?',
      time: '11:05',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _items.where((e) {
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
                      "Frequently Terms",
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
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 18.h),
              itemCount: filtered.length,
              itemBuilder: (context, i) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _TermCard(item: filtered[i]),
              ),
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

class _TermCard extends StatelessWidget {
  final _TermItem item;
  const _TermCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
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

class _TermItem {
  final String fromCode;
  final String toCode;
  final String title;
  final String subtitle;
  final String time;

  _TermItem({
    required this.fromCode,
    required this.toCode,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}
