import '../../core/constants/app_constants.dart';

class AdConfig {
  /// Whether ads are enabled in the application
  static bool get isEnabled => FeatureFlags.adsEnabled;

  /// Interval of stories after which an advertisement is placed
  static int get storyInterval => FeatureFlags.adInterval;
}
