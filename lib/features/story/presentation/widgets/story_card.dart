import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/story.dart';
import 'source_list.dart';

class StoryCard extends StatelessWidget {
  final Story story;

  const StoryCard({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final tagBg = isDark ? AppColors.darkTagBg : AppColors.lightTagBg;
    final tagText = isDark ? AppColors.darkTagText : AppColors.lightTagText;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category & Read Time header
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                      decoration: BoxDecoration(
                        color: tagBg,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppConstants.categoryEmoji(story.category),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              story.category.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.labelSection.copyWith(
                                fontSize: 10.5,
                                color: tagText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${story.estimatedReadMinutes} min read',
                  style: AppTextStyles.readTime.copyWith(color: mutedTextColor),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Headline
            Text(
              story.headline,
              style: AppTextStyles.storyHeadline,
            ),
            const SizedBox(height: 14),

            // Optional Image (handled gracefully)
            if (story.imageUrl != null && story.imageUrl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.network(
                  story.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
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
            const SizedBox(height: 4),
            Text(
              story.summary,
              style: AppTextStyles.body.copyWith(color: secondaryTextColor),
            ),
            const SizedBox(height: 14),

            // WHY IT MATTERS
            Text(
              'WHY IT MATTERS',
              style: AppTextStyles.labelSection.copyWith(color: mutedTextColor),
            ),
            const SizedBox(height: 4),
            Text(
              story.whyItMatters,
              style: AppTextStyles.body.copyWith(color: secondaryTextColor),
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
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          point,
                          style: AppTextStyles.bulletPoint.copyWith(color: secondaryTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
            ],

            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 10),

            // SOURCES
            SourceList(sources: story.sources),
          ],
        ),
      ),
    );
  }
}
