import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/url_helper.dart';
import '../../domain/source.dart';

class SourceList extends StatelessWidget {
  final List<Source> sources;

  const SourceList({
    super.key,
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    if (sources.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final primarySource = sources.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sources.length > 1
                  ? 'REPORTED BY ${sources.length} SOURCES'
                  : 'SOURCE',
              style: AppTextStyles.labelSection.copyWith(
                color: mutedColor,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Clean wrapped sources
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (int i = 0; i < sources.length; i++) ...[
              InkWell(
                onTap: () => UrlHelper.openArticleUrl(sources[i].url),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
                  child: Text(
                    sources[i].name,
                    style: AppTextStyles.sourceName.copyWith(
                      color: isDark ? AppColors.darkAccent : const Color(0xFF1D4ED8),
                      decoration: TextDecoration.underline,
                      decorationColor: (isDark ? AppColors.darkAccent : const Color(0xFF1D4ED8))
                          .withAlpha((0.4 * 255).round()),
                    ),
                  ),
                ),
              ),
              if (i < sources.length - 1)
                Text(
                  '·',
                  style: TextStyle(
                    color: mutedColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        // Clean READ ORIGINAL → button
        InkWell(
          onTap: () => UrlHelper.openArticleUrl(primarySource.url),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'READ ORIGINAL',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.readOriginal.copyWith(
                      color: primaryTextColor,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: primaryTextColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
