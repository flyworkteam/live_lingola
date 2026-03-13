import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:lingola_app/l10n/app_localizations.dart';

import '../../Core/Utils/assets.dart';
import '../../Core/widgets/navigation/bottom_nav_item_tile.dart';
import '../../Riverpod/Providers/current_user_provider.dart';

class FrequentlyTermsView extends ConsumerStatefulWidget {
  const FrequentlyTermsView({super.key});

  @override
  ConsumerState<FrequentlyTermsView> createState() =>
      _FrequentlyTermsViewState();
}

class _FrequentlyTermsViewState extends ConsumerState<FrequentlyTermsView> {
  static const String _baseUrl = "https://livelingolaapp.fly-work.com";

  String _query = '';
  bool _isLoading = false;

  List<_TermItem> _items = [];

  String? get _currentFirebaseUid {
    final user = ref.read(currentUserProvider);
    final uid = user?['firebase_uid']?.toString().trim();

    if (uid == null || uid.isEmpty) return null;
    return uid;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadFrequentlyUsedTerms);
  }

  Future<void> _loadFrequentlyUsedTerms() async {
    final l10n = AppLocalizations.of(context)!;
    final firebaseUid = _currentFirebaseUid;

    debugPrint('FREQUENT TERMS FIREBASE UID: $firebaseUid');

    if (firebaseUid == null) {
      if (!mounted) return;
      setState(() => _items = []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userNotFound)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = "$_baseUrl/translate/frequently-used/$firebaseUid";
      debugPrint('FREQUENT TERMS URL: $url');

      final response = await http.get(Uri.parse(url));

      debugPrint('FREQUENT TERMS STATUS: ${response.statusCode}');
      debugPrint('FREQUENT TERMS BODY: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic data = jsonDecode(response.body);
        final List<dynamic> items = _extractItems(data);

        if (!mounted) return;
        setState(() {
          _items = items
              .map((e) => _TermItem.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.couldNotLoadFrequentlyUsedTerms)),
        );
      }
    } catch (e) {
      debugPrint('FREQUENT TERMS ERROR: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.couldNotLoadFrequentlyUsedTerms)),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<dynamic> _extractItems(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data["items"] is List) return data["items"] as List<dynamic>;
      if (data["rows"] is List) return data["rows"] as List<dynamic>;
      if (data["data"] is List) return data["data"] as List<dynamic>;
      if (data["terms"] is List) return data["terms"] as List<dynamic>;
    }
    if (data is List) return data;
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.watch(currentUserProvider);

    final filtered = _items.where((e) {
      if (_query.trim().isEmpty) return true;
      final q = _query.toLowerCase();
      return e.title.toLowerCase().contains(q) ||
          e.subtitle.toLowerCase().contains(q) ||
          e.fromCode.toLowerCase().contains(q) ||
          e.toCode.toLowerCase().contains(q);
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
                      l10n.frequentlyTermsTitle,
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
                        hintText: l10n.search,
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : filtered.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noFrequentlyUsedTermsFound,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      )
                    : ListView.builder(
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
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F0FF),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'x${item.usageCount}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0A70FF),
                  ),
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
      case 'IT':
        return 'Italian';
      case 'FR':
        return 'French';
      case 'ES':
        return 'Spanish';
      case 'JP':
        return 'Japanese';
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
  final int usageCount;

  _TermItem({
    required this.fromCode,
    required this.toCode,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.usageCount,
  });

  factory _TermItem.fromJson(Map<String, dynamic> json) {
    final sourceLanguage = (json['source_language'] ?? '').toString();
    final targetLanguage = (json['target_language'] ?? '').toString();

    return _TermItem(
      fromCode: _languageToCode(sourceLanguage),
      toCode: _languageToCode(targetLanguage),
      title: (json['source_text'] ?? '').toString(),
      subtitle: (json['translated_text'] ?? '').toString(),
      time: _formatTime(
        (json['last_used_at'] ?? json['created_at'] ?? '').toString(),
      ),
      usageCount: _parseInt(json['usage_count']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse('${value ?? 0}') ?? 0;
  }

  static String _languageToCode(String value) {
    switch (value.toLowerCase()) {
      case 'turkish':
        return 'TR';
      case 'english':
        return 'EN';
      case 'german':
        return 'DE';
      case 'italian':
        return 'IT';
      case 'french':
        return 'FR';
      case 'spanish':
      case 'spain':
        return 'ES';
      case 'japanese':
        return 'JP';
      default:
        return value.isEmpty ? 'EN' : value.substring(0, 2).toUpperCase();
    }
  }

  static String _formatTime(String raw) {
    if (raw.isEmpty) return '--:--';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return '--:--';

    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
