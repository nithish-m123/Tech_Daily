import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/share_helper.dart';
import '../../../story/domain/story.dart';
import '../../../story/presentation/widgets/source_list.dart';
import '../../providers/liked_stories_provider.dart';

class StoryPageItem extends ConsumerWidget {
  final Story story;
  final int currentIndex;
  final int totalStories;

  const StoryPageItem({
    super.key,
    required this.story,
    required this.currentIndex,
    required this.totalStories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final tagBg = isDark ? AppColors.darkTagBg : AppColors.lightTagBg;
    final tagText = isDark ? AppColors.darkTagText : AppColors.lightTagText;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    final likedNotifier = ref.read(likedStoriesProvider.notifier);
    final isLiked = ref.watch(likedStoriesProvider).any((s) => s.id == story.id);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 80.0),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.zero, // Sharp Stitch 0px radius
          border: Border.all(color: borderColor, width: 1.0),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Edition Sub-header Record line (Stitch Design)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'The Professional Technology Record — Story $currentIndex of $totalStories',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.readTime.copyWith(
                    color: mutedTextColor,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 16),

            // Header Row: Sharp Category Badge (Left) & Share + Like Icons (Right)
            Row(
              children: [
                // Sharp Category Badge
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: tagBg,
                        borderRadius: BorderRadius.zero, // Sharp 0px corners
                        border: Border.all(color: primaryTextColor, width: 1.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppConstants.categoryEmoji(story.category),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              story.category.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.labelSection.copyWith(
                                fontSize: 10.5,
                                color: tagText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Interactive Share Icon Button
                IconButton(
                  icon: const Icon(Icons.share_outlined, size: 20),
                  color: primaryTextColor,
                  tooltip: 'Share News',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: () => ShareHelper.shareStory(story),
                ),

                // Interactive Like / Love Icon Button
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 22,
                  ),
                  color: isLiked ? AppColors.likedHeartColor : primaryTextColor,
                  tooltip: isLiked ? 'Unlike Story' : 'Like Story',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: () async {
                    final nowLiked = await likedNotifier.toggleLike(story);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text(
                            nowLiked
                                ? '❤️ Saved to Liked News'
                                : 'Removed from Liked News',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Headline
            Text(
              story.headline,
              style: AppTextStyles.heroHeadline.copyWith(
                color: primaryTextColor,
                fontSize: 22,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),

            // Optional Image
            if (story.imageUrl != null && story.imageUrl!.isNotEmpty) ...[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.zero,
                ),
                child: Image.network(
                  story.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 190,
                  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // WHAT HAPPENED
            Text(
              'WHAT HAPPENED',
              style: AppTextStyles.labelSection.copyWith(
                color: mutedTextColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              story.summary,
              style: AppTextStyles.body.copyWith(
                color: secondaryTextColor,
                fontSize: 15.0,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 18),

            // WHY IT MATTERS
            Text(
              'WHY IT MATTERS',
              style: AppTextStyles.labelSection.copyWith(
                color: mutedTextColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              story.whyItMatters,
              style: AppTextStyles.body.copyWith(
                color: secondaryTextColor,
                fontSize: 15.0,
                height: 1.55,
              ),
            ),

            // KEY POINTS
            if (story.keyPoints.isNotEmpty) ...[
              const SizedBox(height: 18),
              Text(
                'KEY POINTS',
                style: AppTextStyles.labelSection.copyWith(
                  color: mutedTextColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              for (final point in story.keyPoints)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 7.0, right: 10.0),
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          point,
                          style: AppTextStyles.bulletPoint.copyWith(
                            color: secondaryTextColor,
                            fontSize: 14.5,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],

            const SizedBox(height: 18),
            Divider(color: borderColor),
            const SizedBox(height: 14),

            // SOURCES
            SourceList(sources: story.sources),
          ],
        ),
      ),
    );
  }
}
