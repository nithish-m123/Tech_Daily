import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../story/domain/story.dart';
import '../../../story/presentation/widgets/source_list.dart';

class BiggestStoryCard extends StatelessWidget {
  final Story story;

  const BiggestStoryCard({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final heroBadgeBg = isDark ? AppColors.darkHeroBadgeBg : AppColors.lightHeroBadgeBg;
    final heroBadgeText = isDark ? AppColors.darkHeroBadgeText : AppColors.lightHeroBadgeText;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isDark ? const Color(0xFF3F3F46) : const Color(0xFFD4D4D8),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: heroBadgeBg,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      "TODAY'S BIGGEST STORY",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.heroBadge.copyWith(
                        color: heroBadgeText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Hero Headline
            Text(
              story.headline,
              style: AppTextStyles.heroHeadline,
            ),
            const SizedBox(height: 14),

            // Optional Image
            if (story.imageUrl != null && story.imageUrl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  story.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 14),
            ],

            // WHAT HAPPENED
            Text(
              'WHAT HAPPENED',
              style: AppTextStyles.labelSection.copyWith(color: mutedTextColor),
            ),
            const SizedBox(height: 5),
            Text(
              story.summary,
              style: AppTextStyles.body.copyWith(
                color: secondaryTextColor,
                fontSize: 14.5,
              ),
            ),
            const SizedBox(height: 14),

            // WHY IT MATTERS
            Text(
              'WHY IT MATTERS',
              style: AppTextStyles.labelSection.copyWith(color: mutedTextColor),
            ),
            const SizedBox(height: 5),
            Text(
              story.whyItMatters,
              style: AppTextStyles.body.copyWith(
                color: secondaryTextColor,
                fontSize: 14.5,
              ),
            ),

            // KEY POINTS
            if (story.keyPoints.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                'KEY POINTS',
                style: AppTextStyles.labelSection.copyWith(color: mutedTextColor),
              ),
              const SizedBox(height: 6),
              for (final point in story.keyPoints)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, right: 8.0),
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          point,
                          style: AppTextStyles.bulletPoint.copyWith(
                            color: secondaryTextColor,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],

            const SizedBox(height: 14),
            Divider(color: borderColor),
            const SizedBox(height: 10),

            // SOURCES
            SourceList(sources: story.sources),
          ],
        ),
      ),
    );
  }
}
