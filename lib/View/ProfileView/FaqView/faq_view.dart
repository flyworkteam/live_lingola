import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingora_app/Core/Utils/assets.dart';

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  final List<_FaqItem> _items = const [
    _FaqItem("Live Lingola nasıl çalışır?", "Lorem ipsum..."),
    _FaqItem("Verilerim güvende mi?", "Lorem ipsum..."),
    _FaqItem("Çevrimdışı kullanabilir miyim?", "Lorem ipsum..."),
    _FaqItem("Aboneliğimi nasıl iptal ederim?", "Lorem ipsum..."),
    _FaqItem(
      "Aile paylaşımı var mı?",
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
          "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
          "when an unknown printer took a galley of type and scrambled it to",
    ),
  ];

  int _openIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 18.h),
          child: Column(
            children: [
              _TopBar(
                title: "F.A.Q.",
                onBack: () => Navigator.of(context).pop(),
              ),
              SizedBox(height: 18.h),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    final isOpen = _openIndex == i;

                    return _FaqCard(
                      title: item.q,
                      body: item.a,
                      isOpen: isOpen,
                      onTap: () => setState(() {
                        _openIndex = isOpen ? -1 : i;
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqItem {
  final String q;
  final String a;
  const _FaqItem(this.q, this.a);
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  const _TopBar({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(12.r),
          child: SizedBox(
            width: 44.w,
            height: 44.w,
            child: Center(
              child: SvgPicture.asset(
                AppAssets.icBack,
                width: 18.sp,
                height: 18.sp,
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
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                height: 26 / 20,
                letterSpacing: 0,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
        ),
        SizedBox(width: 44.w),
      ],
    );
  }
}

class _FaqCard extends StatelessWidget {
  final String title;
  final String body;
  final bool isOpen;
  final VoidCallback onTap;

  const _FaqCard({
    required this.title,
    required this.body,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDEE5F7).withOpacity(.55),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                        letterSpacing: -0.3,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    isOpen
                        ? 'assets/images/icons/features/ic_arrow_up.svg'
                        : 'assets/images/icons/features/ic_arrow_down.svg',
                    width: 24.sp,
                    height: 24.sp,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF94A3B8),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              if (isOpen) ...[
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    body,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12.2.sp,
                      height: 1.3,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF0F172A).withOpacity(.65),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
