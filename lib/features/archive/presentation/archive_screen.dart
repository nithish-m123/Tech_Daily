import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/date_formatter.dart';
import '../../edition/providers/edition_providers.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final asyncDates = ref.watch(archiveDatesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ARCHIVES',
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
        child: asyncDates.when(
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Unable to load archives.',
                    style: AppTextStyles.body.copyWith(color: primaryTextColor),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => ref.refresh(archiveDatesProvider),
                    child: const Text('RETRY'),
                  ),
                ],
              ),
            ),
          ),
          data: (dates) {
            if (dates.isEmpty) {
              return Center(
                child: Text(
                  'No past editions available.',
                  style: AppTextStyles.body.copyWith(color: mutedTextColor),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              itemCount: dates.length,
              separatorBuilder: (context, index) => Divider(
                color: borderColor,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final date = dates[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                  title: Text(
                    DateFormatter.formatEditionDate(date),
                    style: AppTextStyles.storyHeadline.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      DateFormatter.formatArchiveDate(date),
                      style: AppTextStyles.readTime.copyWith(
                        color: mutedTextColor,
                      ),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: mutedTextColor,
                  ),
                  onTap: () {
                    final dateKey = DateFormatter.formatDateKey(date);
                    context.push('/edition/$dateKey');
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
