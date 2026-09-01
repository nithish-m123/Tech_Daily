class AppConstants {
  static const String appName = 'Tech Daily';
  static const String appSubtitle = "Today's Technology Briefing";
  static const String endOfEditionTitle = "END OF TODAY'S EDITION";
  static const String endOfEditionMessage = "You've reached the end.\nSee you tomorrow.";

  // Category Names & Icons
  static const String catAi = 'AI & MACHINE LEARNING';
  static const String catAiEmoji = '🤖';

  static const String catDev = 'DEVELOPERS';
  static const String catDevEmoji = '💻';

  static const String catBigTech = 'BIG TECH';
  static const String catBigTechEmoji = '🏢';

  static const String catStartups = 'STARTUPS';
  static const String catStartupsEmoji = '🚀';

  static const String catSecurity = 'CYBERSECURITY';
  static const String catSecurityEmoji = '🔐';

  static const String catCloud = 'CLOUD';
  static const String catCloudEmoji = '☁️';

  static const String catResearch = 'TECHNOLOGY RESEARCH';
  static const String catResearchEmoji = '🔬';

  static const String catWorld = 'TECHNOLOGY AROUND THE WORLD';
  static const String catWorldEmoji = '🌎';

  static const List<String> allCategories = [
    catAi,
    catDev,
    catBigTech,
    catStartups,
    catSecurity,
    catCloud,
    catResearch,
    catWorld,
  ];

  static String categoryEmoji(String category) {
    final upper = category.toUpperCase();
    if (upper.contains('AI') || upper.contains('MACHINE')) return catAiEmoji;
    if (upper.contains('DEVELOP')) return catDevEmoji;
    if (upper.contains('BIG TECH')) return catBigTechEmoji;
    if (upper.contains('STARTUP')) return catStartupsEmoji;
    if (upper.contains('CYBER') || upper.contains('SECURITY')) return catSecurityEmoji;
    if (upper.contains('CLOUD')) return catCloudEmoji;
    if (upper.contains('RESEARCH')) return catResearchEmoji;
    if (upper.contains('WORLD')) return catWorldEmoji;
    return '📰';
  }

  // API Config (Raw GitHub CDN endpoint for instant, free dynamic briefing feeds)
  static const String defaultBaseUrl = 'https://raw.githubusercontent.com/nithish-m123/Tech_Daily/main';
  static const int connectTimeoutSeconds = 10;
  static const int receiveTimeoutSeconds = 15;

  // Storage keys
  static const String latestEditionKey = 'cached_latest_edition_json';
  static const String editionPrefixKey = 'cached_edition_';
}

class FeatureFlags {
  // Ads are kept as a non-intrusive placeholder until monetization is enabled
  static const bool adsEnabled = false;

  // Frequency: show an ad placeholder after every N stories
  static const int adInterval = 7;

  // Toggle between mock and remote API repository
  static const bool useMockRepository = false;
}
