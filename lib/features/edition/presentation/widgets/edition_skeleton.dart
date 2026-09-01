import 'package:flutter/material.dart';

class EditionSkeleton extends StatefulWidget {
  const EditionSkeleton({super.key});

  @override
  State<EditionSkeleton> createState() => _EditionSkeletonState();
}

class _EditionSkeletonState extends State<EditionSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.35, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF27272A) : const Color(0xFFE4E4E7);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final shimmerColor = baseColor.withAlpha((_animation.value * 255).round());

        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Masthead Skeleton
              _skeletonBox(width: 180, height: 28, color: shimmerColor),
              const SizedBox(height: 8),
              _skeletonBox(width: 120, height: 14, color: shimmerColor),
              const SizedBox(height: 6),
              _skeletonBox(width: 160, height: 12, color: shimmerColor),
              const SizedBox(height: 16),
              Divider(color: baseColor),
              const SizedBox(height: 16),

              // Hero Card Skeleton
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: baseColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _skeletonBox(width: 140, height: 18, color: shimmerColor),
                    const SizedBox(height: 14),
                    _skeletonBox(width: double.infinity, height: 24, color: shimmerColor),
                    const SizedBox(height: 8),
                    _skeletonBox(width: 240, height: 24, color: shimmerColor),
                    const SizedBox(height: 16),
                    _skeletonBox(width: 90, height: 12, color: shimmerColor),
                    const SizedBox(height: 6),
                    _skeletonBox(width: double.infinity, height: 14, color: shimmerColor),
                    const SizedBox(height: 4),
                    _skeletonBox(width: double.infinity, height: 14, color: shimmerColor),
                    const SizedBox(height: 4),
                    _skeletonBox(width: 180, height: 14, color: shimmerColor),
                    const SizedBox(height: 16),
                    _skeletonBox(width: 100, height: 12, color: shimmerColor),
                    const SizedBox(height: 6),
                    _skeletonBox(width: double.infinity, height: 14, color: shimmerColor),
                    const SizedBox(height: 16),
                    Divider(color: baseColor),
                    const SizedBox(height: 10),
                    _skeletonBox(width: 120, height: 14, color: shimmerColor),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Normal Card Skeleton
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: baseColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _skeletonBox(width: 80, height: 16, color: shimmerColor),
                        _skeletonBox(width: 50, height: 12, color: shimmerColor),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _skeletonBox(width: double.infinity, height: 20, color: shimmerColor),
                    const SizedBox(height: 6),
                    _skeletonBox(width: 200, height: 20, color: shimmerColor),
                    const SizedBox(height: 12),
                    _skeletonBox(width: 80, height: 12, color: shimmerColor),
                    const SizedBox(height: 6),
                    _skeletonBox(width: double.infinity, height: 14, color: shimmerColor),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _skeletonBox({
    required double width,
    required double height,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
