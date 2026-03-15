import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingola_app/Core/widgets/common/app_card.dart';
import 'package:lingola_app/Core/widgets/text_translation/example_tile.dart';
import 'package:lingola_app/Core/widgets/text_translation/text_translation_models.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

class TextTranslationExamplesCard extends StatelessWidget {
  final List<TextExampleItem> examples;
  final ValueChanged<String> onExampleTap;
  final void Function(Offset globalPos) onMore;

  const TextTranslationExamplesCard({
    super.key,
    required this.examples,
    required this.onExampleTap,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.examplesLabel,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: const Color(0xFF94A3B8),
            ),
          ),
          SizedBox(height: 10.h),
          for (int i = 0; i < examples.length; i++) ...[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onExampleTap(examples[i].title),
              child: TextTranslationExampleTile(
                title: examples[i].title,
                subtitle: examples[i].subtitle,
                onMore: onMore,
              ),
            ),
            if (i != examples.length - 1)
              Divider(
                height: 18.h,
                thickness: 1,
                color: const Color(0xFFD9E1EF),
              ),
          ],
        ],
      ),
    );
  }
}
