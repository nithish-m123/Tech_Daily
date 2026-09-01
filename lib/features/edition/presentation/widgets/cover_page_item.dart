import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/edition.dart';
import 'biggest_story_card.dart';

class CoverPageItem extends StatelessWidget {
  final Edition edition;
  final VoidCallback onStartReading;

  const CoverPageItem({
    super.key,
    required this.edition,
    required this.onStartReading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 12.0, bottom: 80.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Masthead Brand
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text(
                  'TECH DAILY',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mastheadTitle.copyWith(
                    color: primaryTextColor,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  DateFormatter.formatEditionDate(edition.date).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mastheadDate.copyWith(
                    color: primaryTextColor.withAlpha((0.85 * 255).round()),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "TODAY'S TECHNOLOGY BRIEFING",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.mastheadSubtitle.copyWith(
                    color: mutedTextColor,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkTagBg : AppColors.lightTagBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${edition.totalStoryCount} STORIES CURATED TODAY',
                    style: AppTextStyles.labelSection.copyWith(
                      fontSize: 10.0,
                      color: mutedTextColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Divider(height: 1, thickness: 1.5, color: borderColor),
                const SizedBox(height: 2),
                Divider(height: 1, thickness: 0.8, color: borderColor),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Today's Biggest Story Hero
          if (edition.biggestStory != null)
            BiggestStoryCard(story: edition.biggestStory!),

          const SizedBox(height: 16),

          // Start Reading Call to Action Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: InkWell(
              onTap: onStartReading,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: 1.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "SWIPE OR TAP TO START READING",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.labelSection.copyWith(
                          color: primaryTextColor,
                          fontSize: 12,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: primaryTextColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
