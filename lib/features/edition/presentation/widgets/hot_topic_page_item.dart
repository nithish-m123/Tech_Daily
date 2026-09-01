import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class HotTopicPageItem extends StatelessWidget {
  final String topic;
  final String description;
  final List<String> relatedStoryHeadlines;
  final void Function(int index)? onRelatedStoryTap;

  const HotTopicPageItem({
    super.key,
    required this.topic,
    required this.description,
    this.relatedStoryHeadlines = const [],
    this.onRelatedStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final hotTopicBg = isDark ? AppColors.darkHotTopicBg : AppColors.lightHotTopicBg;
    final hotTopicText = isDark ? AppColors.darkHotTopicText : AppColors.lightHotTopicText;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: hotTopicBg,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🔥', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 6),
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
          const SizedBox(height: 18),

          // Topic Headline
          Text(
            topic,
            style: AppTextStyles.heroHeadline.copyWith(
              fontSize: 26,
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 16),

          // Sub-label
          Text(
            'WHY EVERYONE IS TALKING ABOUT IT',
            style: AppTextStyles.labelSection.copyWith(
              color: mutedTextColor,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            description,
            style: AppTextStyles.body.copyWith(
              color: secondaryTextColor,
              fontSize: 16.0,
              height: 1.6,
            ),
          ),

          if (relatedStoryHeadlines.isNotEmpty) ...[
            const SizedBox(height: 24),
            Divider(color: borderColor),
            const SizedBox(height: 16),
            Text(
              'RELATED STORIES IN THIS EDITION',
              style: AppTextStyles.labelSection.copyWith(
                color: mutedTextColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < relatedStoryHeadlines.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: onRelatedStoryTap != null ? () => onRelatedStoryTap!(i) : null,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, right: 10.0),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? AppColors.darkAccent : const Color(0xFF1D4ED8),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            relatedStoryHeadlines[i],
                            style: AppTextStyles.storyHeadline.copyWith(
                              fontSize: 14.5,
                              color: primaryTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: mutedTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
