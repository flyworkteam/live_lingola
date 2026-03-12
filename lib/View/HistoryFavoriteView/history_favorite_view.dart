import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Core/Utils/assets.dart';
import '../../Core/widgets/navigation/bottom_nav_item_tile.dart';
import '../../Riverpod/Providers/current_user_provider.dart';

class HistoryFavoriteView extends ConsumerStatefulWidget {
  final int initialTab;

  const HistoryFavoriteView({super.key, this.initialTab = 0});

  @override
  ConsumerState<HistoryFavoriteView> createState() =>
      _HistoryFavoriteViewState();
}

class _HistoryFavoriteViewState extends ConsumerState<HistoryFavoriteView> {
  static const String _baseUrl = "http://127.0.0.1:4000";

  late int _tab;
  String _query = '';

  bool _isLoading = false;
  bool _isActionLoading = false;

  List<_HFItem> _history = [];
  List<_HFItem> _favorite = [];

  String? get _currentFirebaseUid {
    final user = ref.read(currentUserProvider);
    final uid = user?['firebase_uid']?.toString().trim();

    if (uid == null || uid.isEmpty) return null;
    return uid;
  }

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab.clamp(0, 1);
    Future.microtask(_loadCurrentTab);
  }

  List<_HFItem> get _activeList => _tab == 0 ? _history : _favorite;

  Future<void> _loadCurrentTab() async {
    final l10n = AppLocalizations.of(context)!;
    final firebaseUid = _currentFirebaseUid;

    debugPrint('HF CURRENT FIREBASE UID: $firebaseUid');
    debugPrint('HF CURRENT TAB: $_tab');

    if (firebaseUid == null) {
      if (!mounted) return;
      setState(() {
        _history = [];
        _favorite = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userNotFound)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_tab == 0) {
        final items = await _fetchHistory(firebaseUid);
        if (!mounted) return;
        setState(() => _history = items);
      } else {
        final items = await _fetchFavorites(firebaseUid);
        if (!mounted) return;
        setState(() => _favorite = items);
      }
    } catch (e) {
      debugPrint('HF LOAD ERROR: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.couldNotLoadData)),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<List<_HFItem>> _fetchHistory(String firebaseUid) async {
    final url = "$_baseUrl/translate/history/$firebaseUid";
    debugPrint('HF HISTORY URL: $url');

    final response = await http.get(Uri.parse(url));

    debugPrint('HF HISTORY STATUS: ${response.statusCode}');
    debugPrint('HF HISTORY BODY: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("History request failed");
    }

    final dynamic data = jsonDecode(response.body);
    final List<dynamic> items = _extractItems(data);

    return items
        .map((e) => _HFItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<_HFItem>> _fetchFavorites(String firebaseUid) async {
    final url = "$_baseUrl/translate/favorites/$firebaseUid";
    debugPrint('HF FAVORITES URL: $url');

    final response = await http.get(Uri.parse(url));

    debugPrint('HF FAVORITES STATUS: ${response.statusCode}');
    debugPrint('HF FAVORITES BODY: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("Favorites request failed");
    }

    final dynamic data = jsonDecode(response.body);
    final List<dynamic> items = _extractItems(data);

    return items
        .map((e) => _HFItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  List<dynamic> _extractItems(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data["items"] is List) return data["items"] as List<dynamic>;
      if (data["rows"] is List) return data["rows"] as List<dynamic>;
      if (data["data"] is List) return data["data"] as List<dynamic>;
      if (data["history"] is List) return data["history"] as List<dynamic>;
      if (data["favorites"] is List) return data["favorites"] as List<dynamic>;
    }
    if (data is List) return data;
    return [];
  }

  Future<void> _changeTab(int value) async {
    if (_tab == value) return;
    setState(() => _tab = value);
    await _loadCurrentTab();
  }

  Future<void> _toggleStar(_HFItem item) async {
    final l10n = AppLocalizations.of(context)!;

    if (item.id == null) return;

    setState(() => _isActionLoading = true);

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/translate/favorite"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "translation_id": item.id,
          "is_favorite": !item.starred,
        }),
      );

      debugPrint('HF TOGGLE FAVORITE STATUS: ${response.statusCode}');
      debugPrint('HF TOGGLE FAVORITE BODY: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          item.starred = !item.starred;

          if (_tab == 0) {
            final favIndex = _favorite.indexWhere((e) => e.id == item.id);
            if (item.starred) {
              if (favIndex == -1) {
                _favorite.insert(0, item.copyWith(starred: true));
              }
            } else {
              if (favIndex != -1) {
                _favorite.removeAt(favIndex);
              }
            }
          } else {
            if (!item.starred) {
              _favorite.removeWhere((e) => e.id == item.id);
              final histIndex = _history.indexWhere((e) => e.id == item.id);
              if (histIndex != -1) {
                _history[histIndex].starred = false;
              }
            }
          }
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.favoriteUpdateFailed)),
        );
      }
    } catch (e) {
      debugPrint('HF TOGGLE FAVORITE ERROR: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.favoriteUpdateFailed)),
      );
    } finally {
      if (mounted) {
        setState(() => _isActionLoading = false);
      }
    }
  }

  Future<void> _confirmClear() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color(0xFF000000).withValues(alpha: 0.35),
      builder: (context) => _ClearConfirmDialog(
        title: _tab == 0 ? l10n.clearHistoryTitle : l10n.clearFavoriteTitle,
        description: _tab == 0
            ? l10n.clearHistoryDescription
            : l10n.clearFavoriteDescription,
      ),
    );

    if (confirmed == true) {
      await _clearCurrentTab();
    }
  }

  Future<void> _clearCurrentTab() async {
    final firebaseUid = _currentFirebaseUid;
    if (firebaseUid == null) return;

    setState(() => _isActionLoading = true);

    try {
      final endpoint = _tab == 0
          ? "$_baseUrl/translate/history/$firebaseUid"
          : "$_baseUrl/translate/favorites/$firebaseUid";

      debugPrint('HF CLEAR URL: $endpoint');

      final response = await http.delete(Uri.parse(endpoint));

      debugPrint('HF CLEAR STATUS: ${response.statusCode}');
      debugPrint('HF CLEAR BODY: ${response.body}');

      if (!mounted) return;

      setState(() {
        if (_tab == 0) {
          _history.clear();
        } else {
          _favorite.clear();
        }
      });
    } catch (e) {
      debugPrint('HF CLEAR ERROR: $e');
      if (!mounted) return;
      setState(() {
        if (_tab == 0) {
          _history.clear();
        } else {
          _favorite.clear();
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isActionLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ref.watch(currentUserProvider);

    final filtered = _activeList.where((e) {
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
                      l10n.historyFavoriteTitle,
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
                      title: l10n.historyTab,
                      active: _tab == 0,
                      onTap: () => _changeTab(0),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _SegmentBtn(
                      title: l10n.favoriteTab,
                      active: _tab == 1,
                      onTap: () => _changeTab(1),
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
                  _tab == 0 ? l10n.today : l10n.favoriteTab,
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
                    _tab == 0 ? l10n.clearHistory : l10n.clearFavorite,
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : filtered.isEmpty
                    ? Center(
                        child: Text(
                          _tab == 0
                              ? l10n.noHistoryFound
                              : l10n.noFavoritesFound,
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
                        itemBuilder: (context, i) {
                          final item = filtered[i];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _HFCard(
                              item: item,
                              onStarTap: _isActionLoading
                                  ? null
                                  : () => _toggleStar(item),
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
  final String title;
  final String description;

  const _ClearConfirmDialog({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                title,
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
              description,
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
                      l10n.cancel,
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
                        l10n.clear,
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
  final int? id;
  final String fromCode;
  final String toCode;
  final String title;
  final String subtitle;
  final String time;
  bool starred;

  _HFItem({
    required this.id,
    required this.fromCode,
    required this.toCode,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.starred,
  });

  factory _HFItem.fromJson(Map<String, dynamic> json) {
    final sourceLanguage = (json['source_language'] ?? '').toString();
    final targetLanguage = (json['target_language'] ?? '').toString();

    return _HFItem(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      fromCode: _languageToCode(sourceLanguage),
      toCode: _languageToCode(targetLanguage),
      title: (json['source_text'] ?? '').toString(),
      subtitle: (json['translated_text'] ?? '').toString(),
      time: _formatTime((json['created_at'] ?? '').toString()),
      starred: _parseBool(json['is_favorite']),
    );
  }

  _HFItem copyWith({
    int? id,
    String? fromCode,
    String? toCode,
    String? title,
    String? subtitle,
    String? time,
    bool? starred,
  }) {
    return _HFItem(
      id: id ?? this.id,
      fromCode: fromCode ?? this.fromCode,
      toCode: toCode ?? this.toCode,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      starred: starred ?? this.starred,
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    return value.toString() == '1' || value.toString().toLowerCase() == 'true';
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
  final VoidCallback? onStarTap;

  const _HFCard({
    required this.item,
    required this.onStarTap,
  });

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
