import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

class EndOfEdition extends StatelessWidget {
  const EndOfEdition({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
      child: Column(
        children: [
          Divider(color: borderColor, thickness: 1.0),
          const SizedBox(height: 24),
          Text(
            AppConstants.endOfEditionTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.endOfEditionTitle.copyWith(
              color: primaryTextColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppConstants.endOfEditionMessage,
            textAlign: TextAlign.center,
            style: AppTextStyles.endOfEditionMessage.copyWith(
              color: mutedTextColor,
            ),
          ),
          const SizedBox(height: 24),
          // Small emblem / end mark
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: borderColor,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
