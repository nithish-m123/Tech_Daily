import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class HotTopicCard extends StatelessWidget {
  final String topic;
  final String description;
  final List<String> relatedStoryHeadlines;
  final void Function(int index)? onRelatedStoryTap;

  const HotTopicCard({
    super.key,
    required this.topic,
    required this.description,
    this.relatedStoryHeadlines = const [],
    this.onRelatedStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hotTopicBg = isDark ? AppColors.darkHotTopicBg : AppColors.lightHotTopicBg;
    final hotTopicText = isDark ? AppColors.darkHotTopicText : AppColors.lightHotTopicText;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final borderColor = isDark ? const Color(0xFF3F3F46) : const Color(0xFFE4E4E7);

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
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              decoration: BoxDecoration(
                color: hotTopicBg,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 5),
                  Text(
                    "WHAT'S HOT TODAY?",
                    style: AppTextStyles.labelSection.copyWith(
                      color: hotTopicText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Topic Name
            Text(
              topic,
              style: AppTextStyles.storyHeadline.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            Text(
              'Why everyone is talking about it:',
              style: AppTextStyles.labelSection.copyWith(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 4),

            // Description
            Text(
              description,
              style: AppTextStyles.body.copyWith(color: secondaryTextColor),
            ),

            // Related Stories
            if (relatedStoryHeadlines.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                'Related stories in this edition:',
                style: AppTextStyles.labelSection.copyWith(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 6),
              for (int i = 0; i < relatedStoryHeadlines.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: InkWell(
                    onTap: onRelatedStoryTap != null ? () => onRelatedStoryTap!(i) : null,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                                color: isDark ? AppColors.darkAccent : const Color(0xFF1D4ED8),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              relatedStoryHeadlines[i],
                              style: AppTextStyles.bulletPoint.copyWith(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
