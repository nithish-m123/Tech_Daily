import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

class EndOfEditionPageItem extends StatelessWidget {
  final VoidCallback onBackToStart;
  final VoidCallback onBrowseArchives;

  const EndOfEditionPageItem({
    super.key,
    required this.onBackToStart,
    required this.onBrowseArchives,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: Icon(
                Icons.check_rounded,
                size: 28,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppConstants.endOfEditionTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.endOfEditionTitle.copyWith(
                color: primaryTextColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppConstants.endOfEditionMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.endOfEditionMessage.copyWith(
                color: mutedTextColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 36),
            OutlinedButton.icon(
              onPressed: onBackToStart,
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('BACK TO FRONT PAGE'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryTextColor,
                side: BorderSide(color: borderColor),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onBrowseArchives,
              icon: const Icon(Icons.calendar_month_outlined, size: 16),
              label: const Text('BROWSE ARCHIVES'),
              style: TextButton.styleFrom(
                foregroundColor: mutedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
