import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';

class NewspaperHeader extends StatelessWidget {
  final DateTime date;
  final int storyCount;
  final VoidCallback? onArchiveTap;
  final bool isArchiveView;

  const NewspaperHeader({
    super.key,
    required this.date,
    this.storyCount = 0,
    this.onArchiveTap,
    this.isArchiveView = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top utilities row (Archive button & Story count)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  storyCount > 0 ? '$storyCount STORIES TODAY' : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSection.copyWith(
                    color: mutedTextColor,
                    fontSize: 10.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (onArchiveTap != null)
                InkWell(
                  onTap: onArchiveTap,
                  borderRadius: BorderRadius.circular(4.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isArchiveView ? Icons.today_outlined : Icons.calendar_month_outlined,
                          size: 13,
                          color: primaryTextColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isArchiveView ? 'TODAY' : 'ARCHIVE',
                          style: AppTextStyles.labelSection.copyWith(
                            color: primaryTextColor,
                            fontSize: 10.5,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Masthead Brand
          Text(
            'TECH DAILY',
            textAlign: TextAlign.center,
            style: AppTextStyles.mastheadTitle.copyWith(
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 6),

          // Date
          Text(
            DateFormatter.formatEditionDate(date).toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextStyles.mastheadDate.copyWith(
              color: primaryTextColor.withAlpha((0.85 * 255).round()),
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            "TODAY'S TECHNOLOGY BRIEFING",
            textAlign: TextAlign.center,
            style: AppTextStyles.mastheadSubtitle.copyWith(
              color: mutedTextColor,
            ),
          ),
          const SizedBox(height: 14),

          // Classic Newspaper Rule (Double Line)
          Column(
            children: [
              Divider(height: 1, thickness: 1.5, color: borderColor),
              const SizedBox(height: 2),
              Divider(height: 1, thickness: 0.8, color: borderColor),
            ],
          ),
        ],
      ),
    );
  }
}
