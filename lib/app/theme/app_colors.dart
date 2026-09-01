import 'package:flutter/material.dart';

/// Exact color palette from Google Stitch design specifications (DESIGN.md)
class AppColors {
  // Light Palette (Paper & Ink - Google Stitch)
  static const Color lightBackground = Color(0xFFF7F3F2); // surface-container-low (Scaffold outer container)
  static const Color lightSurface = Color(0xFFFDF8F8); // surface-bright (Paper Card)
  static const Color lightHeaderBg = Color(0xFFF7F3F2); // Fixed header
  static const Color lightTextPrimary = Color(0xFF1C1B1B); // on-surface Ink
  static const Color lightTextSecondary = Color(0xFF444748); // on-surface-variant Muted Ink
  static const Color lightTextMuted = Color(0xFF747878); // outline
  static const Color lightBorder = Color(0xFFC4C7C7); // outline-variant (1px crisp hairline)
  static const Color lightDivider = Color(0x1F1C1B1B); // 12% opacity ink hairline
  static const Color lightAccent = Color(0xFF0041C9); // secondary Tech Blue
  static const Color lightHeroBadgeBg = Color(0xFF000000);
  static const Color lightHeroBadgeText = Color(0xFFFFFFFF);
  static const Color lightHotTopicBg = Color(0xFFF1EDEC);
  static const Color lightHotTopicText = Color(0xFF1C1B1B);
  static const Color lightTagBg = Color(0xFFFDF8F8);
  static const Color lightTagText = Color(0xFF1C1B1B);

  // Dark Palette (Night Editorial - Stitch Dark Mode)
  static const Color darkBackground = Color(0xFF121214); // Dark slate outer scaffold
  static const Color darkSurface = Color(0xFF1C1C20); // Dark paper card
  static const Color darkHeaderBg = Color(0xFF121214);
  static const Color darkTextPrimary = Color(0xFFF4F0EF); // inverse-on-surface
  static const Color darkTextSecondary = Color(0xFFA0A0A5);
  static const Color darkTextMuted = Color(0xFF747878);
  static const Color darkBorder = Color(0xFF2E2E34); // Dark 1px hairline rule
  static const Color darkDivider = Color(0x26FFFFFF);
  static const Color darkAccent = Color(0xFF38BDF8); // Electric Tech Blue
  static const Color darkHeroBadgeBg = Color(0xFFF4F0EF);
  static const Color darkHeroBadgeText = Color(0xFF121214);
  static const Color darkHotTopicBg = Color(0xFF24242A);
  static const Color darkHotTopicText = Color(0xFFF4F0EF);
  static const Color darkTagBg = Color(0xFF1C1C20);
  static const Color darkTagText = Color(0xFFF4F0EF);

  // Status & Action colors
  static const Color offlineBannerBg = Color(0xFFFFFBEB);
  static const Color offlineBannerText = Color(0xFFB45309);
  static const Color likedHeartColor = Color(0xFFDC2626); // Red heart when liked
}
