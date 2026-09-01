import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../domain/edition.dart';
import '../providers/edition_providers.dart';
import 'widgets/cover_page_item.dart';
import 'widgets/edition_skeleton.dart';
import 'widgets/end_of_edition_page_item.dart';
import 'widgets/hot_topic_page_item.dart';
import 'widgets/navigation_drawer_widget.dart';
import 'widgets/story_page_item.dart';

class EditionScreen extends ConsumerStatefulWidget {
  final DateTime? archiveDate;

  const EditionScreen({super.key, this.archiveDate});

  @override
  ConsumerState<EditionScreen> createState() => _EditionScreenState();
}

class _EditionScreenState extends ConsumerState<EditionScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isArchive = widget.archiveDate != null;

    if (isArchive) {
      final asyncArchive = ref.watch(archiveEditionProvider(widget.archiveDate!));
      return Scaffold(
        drawer: NavigationDrawerWidget(
          onSelectToday: () => context.go('/'),
        ),
        body: SafeArea(
          child: asyncArchive.when(
            loading: () => const EditionSkeleton(),
            error: (err, _) => _buildErrorView(
              context: context,
              message: 'Unable to load archived edition for this date.',
              onRetry: () => ref.refresh(archiveEditionProvider(widget.archiveDate!)),
            ),
            data: (edition) => _buildPaginatedReader(
              context: context,
              edition: edition,
              isArchive: true,
              isOffline: false,
              onArchiveTap: () => context.go('/'),
            ),
          ),
        ),
      );
    }

    // Today's Edition
    final state = ref.watch(todayEditionProvider);

    return Scaffold(
      drawer: NavigationDrawerWidget(
        onSelectToday: () => _goToPage(0),
      ),
      body: SafeArea(
        child: _buildTodayContent(context, state),
      ),
    );
  }

  Widget _buildTodayContent(BuildContext context, EditionViewState state) {
    if (state.isLoading && state.edition == null) {
      return const EditionSkeleton();
    }

    if (state.errorMessage != null && state.edition == null) {
      return _buildErrorView(
        context: context,
        message: state.errorMessage!,
        onRetry: () => ref.read(todayEditionProvider.notifier).loadTodayEdition(),
      );
    }

    if (state.edition == null ||
        (state.edition!.stories.isEmpty && state.edition!.biggestStory == null)) {
      return _buildEmptyView(
        context: context,
        onRetry: () => ref.read(todayEditionProvider.notifier).loadTodayEdition(),
      );
    }

    return _buildPaginatedReader(
      context: context,
      edition: state.edition!,
      isArchive: false,
      isOffline: state.isFromCache,
      onArchiveTap: () => context.push('/archive'),
    );
  }

  Widget _buildPaginatedReader({
    required BuildContext context,
    required Edition edition,
    required bool isArchive,
    required bool isOffline,
    required VoidCallback onArchiveTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedTextColor = isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final surfaceColor = isDark ? AppColors.darkHeaderBg : AppColors.lightHeaderBg;

    final hasHotTopic = edition.hotTopic != null && edition.hotTopicDescription != null;
    final stories = edition.stories;

    final int hotTopicPageIndex = hasHotTopic ? 1 : -1;
    final int storyStartIndex = hasHotTopic ? 2 : 1;
    final int totalPages = storyStartIndex + stories.length + 1;
    final int endPageIndex = totalPages - 1;

    String pageProgressLabel;
    if (_currentPage == 0) {
      pageProgressLabel = 'COVER';
    } else if (hasHotTopic && _currentPage == hotTopicPageIndex) {
      pageProgressLabel = 'HOT TOPIC';
    } else if (_currentPage == endPageIndex) {
      pageProgressLabel = 'COMPLETE';
    } else {
      final storyNumber = _currentPage - storyStartIndex + 1;
      pageProgressLabel = 'STORY $storyNumber OF ${stories.length}';
    }

    final List<String> hotTopicRelatedHeadlines = [];
    if (hasHotTopic && edition.hotTopicRelatedStoryIds != null) {
      for (final id in edition.hotTopicRelatedStoryIds!) {
        final story = edition.stories.where((s) => s.id == id).firstOrNull ??
            (edition.biggestStory?.id == id ? edition.biggestStory : null);
        if (story != null) {
          hotTopicRelatedHeadlines.add(story.headline);
        }
      }
    }

    return Stack(
      children: [
        Column(
          children: [
            // Offline banner
            if (isOffline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                color: AppColors.offlineBannerBg,
                child: const Row(
                  children: [
                    Icon(
                      Icons.cloud_off_outlined,
                      size: 14,
                      color: AppColors.offlineBannerText,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Viewing offline cached edition.",
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.offlineBannerText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Google Stitch Header (Left Drawer Menu Icon | Centered Logotype | Empty Spacer for perfect balance)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(bottom: BorderSide(color: borderColor, width: 1.0)),
              ),
              child: Row(
                children: [
                  Builder(
                    builder: (btnContext) {
                      return IconButton(
                        icon: const Icon(Icons.menu_rounded, size: 22),
                        color: primaryTextColor,
                        onPressed: () => Scaffold.of(btnContext).openDrawer(),
                      );
                    },
                  ),

                  Expanded(
                    child: InkWell(
                      onTap: () => _goToPage(0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'TECH DAILY',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.labelSection.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                              fontSize: 15,
                              color: primaryTextColor,
                            ),
                          ),
                          Text(
                            pageProgressLabel,
                            style: AppTextStyles.readTime.copyWith(
                              fontSize: 9.5,
                              color: mutedTextColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 48px width placeholder to balance the menu button and keep TECH DAILY perfectly centered
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Horizontal PageView with Stitch smooth card scale & opacity transition
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: totalPages,
                itemBuilder: (context, index) {
                  Widget pageChild;
                  if (index == 0) {
                    pageChild = CoverPageItem(
                      edition: edition,
                      onStartReading: _nextPage,
                    );
                  } else if (hasHotTopic && index == hotTopicPageIndex) {
                    pageChild = HotTopicPageItem(
                      topic: edition.hotTopic!,
                      description: edition.hotTopicDescription!,
                      relatedStoryHeadlines: hotTopicRelatedHeadlines,
                      onRelatedStoryTap: (storyIdx) {
                        if (storyIdx < stories.length) {
                          _goToPage(storyStartIndex + storyIdx);
                        }
                      },
                    );
                  } else if (index == endPageIndex) {
                    pageChild = EndOfEditionPageItem(
                      onBackToStart: () => _goToPage(0),
                      onBrowseArchives: onArchiveTap,
                    );
                  } else {
                    final storyIndex = index - storyStartIndex;
                    final story = stories[storyIndex];
                    pageChild = StoryPageItem(
                      story: story,
                      currentIndex: storyIndex + 1,
                      totalStories: stories.length,
                    );
                  }

                  // Apply Stitch smooth card scaling and opacity transition during horizontal swiping
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double diff = 0.0;
                      if (_pageController.position.haveDimensions) {
                        diff = ((_pageController.page ?? _currentPage.toDouble()) - index);
                      } else {
                        diff = (_currentPage - index).toDouble();
                      }

                      final factor = (1.0 - (diff.abs() * 0.35)).clamp(0.0, 1.0);
                      final scale = 0.93 + (0.07 * factor);
                      final opacity = (0.40 + (0.60 * factor)).clamp(0.0, 1.0);

                      return Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale,
                          child: child,
                        ),
                      );
                    },
                    child: pageChild,
                  );
                },
              ),
            ),
          ],
        ),

        // Sticky Bottom Bar with Stitch Dots Indicator
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: surfaceColor.withAlpha((0.95 * 255).round()),
              border: Border(top: BorderSide(color: borderColor, width: 1.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _currentPage > 0 ? _previousPage : null,
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: const Text('PREV'),
                  style: TextButton.styleFrom(
                    foregroundColor: primaryTextColor,
                    disabledForegroundColor: mutedTextColor.withAlpha((0.4 * 255).round()),
                    textStyle: AppTextStyles.labelSection.copyWith(fontSize: 11.5),
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    totalPages > 8 ? 8 : totalPages,
                    (i) {
                      final isActive = (i == _currentPage) ||
                          (i == 7 && _currentPage >= 7);
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        width: isActive ? 7 : 5,
                        height: isActive ? 7 : 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? primaryTextColor
                              : mutedTextColor.withAlpha((0.35 * 255).round()),
                        ),
                      );
                    },
                  ),
                ),

                TextButton(
                  onPressed: _currentPage < endPageIndex ? _nextPage : null,
                  style: TextButton.styleFrom(
                    foregroundColor: primaryTextColor,
                    disabledForegroundColor: mutedTextColor.withAlpha((0.4 * 255).round()),
                    textStyle: AppTextStyles.labelSection.copyWith(fontSize: 11.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_currentPage == 0 ? 'START' : 'NEXT'),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView({
    required BuildContext context,
    required String message,
    required VoidCallback onRetry,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper_outlined,
              size: 48,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: textColor, fontSize: 15),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView({
    required BuildContext context,
    required VoidCallback onRetry,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              size: 48,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            const SizedBox(height: 16),
            Text(
              "Today's edition isn't available yet.\nPlease check again later.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: textColor, fontSize: 15),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }
}
