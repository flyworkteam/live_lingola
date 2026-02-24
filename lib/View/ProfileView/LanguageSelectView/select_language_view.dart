import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectLanguageView extends StatefulWidget {
  const SelectLanguageView({super.key});

  @override
  State<SelectLanguageView> createState() => _SelectLanguageViewState();
}

class _SelectLanguageViewState extends State<SelectLanguageView> {
  int _selected = 0;

  final List<_Lang> _langs = const [
    _Lang("Turkish", "assets/images/flags/Turkish.png", "🇹🇷"),
    _Lang("English", "assets/images/flags/English.png", "🇬🇧"),
    _Lang("German", "assets/images/flags/German.png", "🇩🇪"),
    _Lang("Italian", "assets/images/flags/Italian.png", "🇮🇹"),
    _Lang("French", "assets/images/flags/French.png", "🇫🇷"),
    _Lang("Japanese", "assets/images/flags/Japanese.png", "🇯🇵"),
    _Lang("Spanish", "assets/images/flags/Spanish.png", "🇪🇸"),
    _Lang("Russian", "assets/images/flags/Russian.png", "🇷🇺"),
    _Lang("Korean", "assets/images/flags/Korean.png", "🇰🇷"),
    _Lang("Hindi", "assets/images/flags/Hindi.png", "🇮🇳"),
    _Lang("Portuguese", "assets/images/flags/Portuguese.png", "🇵🇹"),
  ];

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Poppins')),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 18.h + bottomPad),
          child: Column(
            children: [
              // Üst Bar - Select Language (Poppins 20px, Medium)
              _TopBar(
                title: "Select Language",
                onBack: () => Navigator.of(context).pop(),
              ),
              SizedBox(height: 18.h),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(
                      parent: ClampingScrollPhysics()),
                  itemCount: _langs.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, i) {
                    final l = _langs[i];
                    final selected = _selected == i;

                    return _LangPill(
                      title: l.title,
                      flagAsset: l.asset,
                      fallbackEmoji: l.emoji,
                      selected: selected,
                      onTap: () => setState(() => _selected = i),
                    );
                  },
                ),
              ),
              SizedBox(height: 14.h),

              // Next Butonu
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () =>
                      _toast("Selected: ${_langs[_selected].title}"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1677FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Lang {
  final String title;
  final String asset;
  final String emoji;
  const _Lang(this.title, this.asset, this.emoji);
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: 44.w,
              height: 44.w,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18.sp,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  height: 26 / 20,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          SizedBox(width: 44.w),
        ],
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  final String title;
  final String flagAsset;
  final String fallbackEmoji;
  final bool selected;
  final VoidCallback onTap;

  const _LangPill({
    required this.title,
    required this.flagAsset,
    required this.fallbackEmoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? const Color(0xFF1677FF) : const Color(0xFFE2E8F0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28.r),
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            // Bayrak alanı
            SizedBox(
              width: 28.w,
              height: 20.h,
              child: Image.asset(
                flagAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    fallbackEmoji,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Dil metni (Poppins Light 15px)
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15.sp,
                fontWeight: FontWeight.w300,
                height: 1.0,
                color: selected
                    ? const Color(0xFF1677FF)
                    : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
