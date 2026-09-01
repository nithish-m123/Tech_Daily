import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/theme/theme_provider.dart';
import '../../providers/liked_stories_provider.dart';

class NavigationDrawerWidget extends ConsumerWidget {
  final VoidCallback? onSelectToday;

  const NavigationDrawerWidget({
    super.key,
    this.onSelectToday,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final drawerBg = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final likedCount = ref.watch(likedStoriesProvider).length;

    return Drawer(
      backgroundColor: drawerBg,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MENU',
                    style: AppTextStyles.labelSection.copyWith(
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      color: primaryTextColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),
            const SizedBox(height: 12),

            // Navigation Items
            ListTile(
              leading: Icon(Icons.newspaper_outlined, color: primaryTextColor, size: 20),
              title: Text(
                'Today\'s Briefing',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: primaryTextColor,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                if (onSelectToday != null) {
                  onSelectToday!();
                } else {
                  context.go('/');
                }
              },
            ),

            ListTile(
              leading: Icon(Icons.favorite_border_rounded, color: AppColors.likedHeartColor, size: 20),
              title: Text(
                'Liked News',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: primaryTextColor,
                ),
              ),
              trailing: likedCount > 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.likedHeartColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$likedCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
              onTap: () {
                Navigator.of(context).pop();
                context.push('/liked');
              },
            ),

            const Spacer(),
            Divider(height: 1, color: borderColor),

            // Footer Night Mode Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_outlined,
                    color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Night Mode',
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: primaryTextColor,
                          ),
                        ),
                        Text(
                          isDark ? 'Dark paper theme' : 'Light paper theme',
                          style: AppTextStyles.readTime.copyWith(
                            fontSize: 10.5,
                            color: mutedTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isDark,
                    activeThumbColor: AppColors.darkAccent,
                    onChanged: (val) {
                      ref.read(themeModeProvider.notifier).toggleTheme(val);
                    },
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),

            // Footer branding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TECH DAILY',
                    style: AppTextStyles.labelSection.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      fontSize: 12,
                      color: primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'The Professional Technology Record',
                    style: AppTextStyles.readTime.copyWith(
                      color: mutedTextColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
