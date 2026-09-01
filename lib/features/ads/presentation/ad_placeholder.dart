import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../ad_config.dart';

class AdPlaceholder extends StatelessWidget {
  final bool forceShow;

  const AdPlaceholder({super.key, this.forceShow = false});

  @override
  Widget build(BuildContext context) {
    if (!forceShow && !AdConfig.isEnabled) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1.0),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ADVERTISEMENT',
              style: AppTextStyles.labelSection.copyWith(
                color: textColor,
                letterSpacing: 2.0,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Google AdMob Placement Placeholder',
              style: TextStyle(
                fontSize: 12,
                color: textColor.withAlpha((0.7 * 255).round()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
