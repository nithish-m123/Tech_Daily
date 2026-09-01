import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../ads/presentation/ad_placeholder.dart';
import '../../../story/domain/story.dart';
import '../../../story/presentation/widgets/story_card.dart';

class CategorySection extends StatelessWidget {
  final String category;
  final List<Story> stories;
  final bool showAdAfterFirstStory;

  const CategorySection({
    super.key,
    required this.category,
    required this.stories,
    this.showAdAfterFirstStory = false,
  });

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Section Header Divider
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 12.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: borderColor, thickness: 1.0),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    AppConstants.categoryEmoji(category),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      category.toUpperCase(),
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  Text(
                    '${stories.length}',
                    style: AppTextStyles.labelSection.copyWith(
                      color: mutedTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Stories in this category
        for (int i = 0; i < stories.length; i++) ...[
          StoryCard(story: stories[i]),
          if (showAdAfterFirstStory && i == 0)
            const AdPlaceholder(),
        ],
      ],
    );
  }
}
