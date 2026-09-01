import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../edition/presentation/widgets/story_page_item.dart';
import '../../edition/providers/liked_stories_provider.dart';

class LikedNewsScreen extends ConsumerWidget {
  const LikedNewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final likedStories = ref.watch(likedStoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LIKED NEWS',
          style: AppTextStyles.labelSection.copyWith(
            letterSpacing: 2.0,
            fontSize: 13,
            color: primaryTextColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(height: 1, color: borderColor),
        ),
      ),
      body: SafeArea(
        child: likedStories.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 48,
                        color: mutedTextColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Liked News Yet',
                        style: AppTextStyles.heroHeadline.copyWith(
                          fontSize: 20,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the heart icon on any story to save it to your Liked News collection.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          color: mutedTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : PageView.builder(
                itemCount: likedStories.length,
                itemBuilder: (context, index) {
                  final story = likedStories[index];
                  return StoryPageItem(
                    story: story,
                    currentIndex: index + 1,
                    totalStories: likedStories.length,
                  );
                },
              ),
      ),
    );
  }
}
