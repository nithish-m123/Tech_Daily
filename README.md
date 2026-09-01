# Tech Daily — Mobile Application MVP

> **"A daily newspaper for technology."**

Tech Daily is a minimal, calm, and distraction-free mobile newspaper delivering a daily curated briefing of the most consequential stories in technology across Android and iOS using a single Flutter codebase.

---

## Product Philosophy

- **Zero Authentication**: Open the app and begin reading immediately. No login, sign-up, or paywall barriers.
- **Newspaper Flow**: Scroll vertically through today's edition: Masthead → Today's Biggest Story → What's Hot Today → Curated Categories → End of Edition.
- **Source Transparency**: Every story shows transparent sources (e.g. *Reuters · Ars Technica · The Verge*) and an explicit **READ ORIGINAL →** action opening external articles in the device browser.
- **Offline First**: Instant startup using locally cached editions, automatic cache updates upon network fetch, and graceful offline fallback banners.
- **API Ready Architecture**: Swappable between `MockEditionRepository` (for local development/testing) and `ApiEditionRepository` (consuming `/api/v1/edition/today`).

---

## Technology Stack

- **Framework**: Flutter 3.41+ (Dart 3.11+)
- **Platforms**: Android & iOS
- **State Management**: Riverpod (`flutter_riverpod: ^3.3.2`) with `Notifier` and `NotifierProvider`
- **Routing**: `go_router: ^17.5.0`
- **Networking**: `dio: ^5.11.0` with standardized exception handling
- **Storage**: `shared_preferences: ^2.5.5` for local edition caching
- **External URLs**: `url_launcher: ^6.3.2`
- **Push Notification Scaffolding**: FCM-ready payload parsing and routing
- **Ads Architecture**: Discreet `AdPlaceholder` isolated behind feature flag `FeatureFlags.adsEnabled`

---

## Directory Structure

```text
lib/
├── main.dart
│
├── app/
│   ├── app.dart                            # TechDailyApp root widget
│   ├── router.dart                         # GoRouter (/ for today, /archive, /edition/:date)
│   └── theme/
│       ├── app_colors.dart                 # Editorial palette (paper white, zinc, subtle accents)
│       ├── app_text_styles.dart            # Typography hierarchy & legibility
│       └── app_theme.dart                  # Light & dark ThemeData configurations
│
├── core/
│   ├── constants/                          # AppConstants, FeatureFlags
│   ├── errors/                             # AppException, NetworkException, ServerException
│   ├── network/                            # ApiClient (Dio with timeouts and interceptors)
│   ├── storage/                            # LocalCacheService
│   └── utils/                              # DateFormatter, UrlHelper
│
├── features/
│   ├── edition/
│   │   ├── data/
│   │   │   ├── edition_repository.dart     # Abstract interface
│   │   │   ├── mock_edition_repository.dart# Rich realistic stories across 8 categories
│   │   │   └── api_edition_repository.dart # Dio backend client
│   │   ├── domain/
│   │   │   └── edition.dart                # Edition domain model
│   │   ├── presentation/
│   │   │   ├── edition_screen.dart         # Scrollable newspaper view
│   │   │   └── widgets/
│   │   │       ├── newspaper_header.dart   # Masthead & date header
│   │   │       ├── biggest_story_card.dart # Hero story card
│   │   │       ├── hot_topic_card.dart     # "What's Hot Today" card
│   │   │       ├── category_section.dart   # Grouped category stories
│   │   │       ├── edition_skeleton.dart   # Newspaper loading skeleton
│   │   │       └── end_of_edition.dart     # Calm newspaper sign-off
│   │   └── providers/
│   │       └── edition_providers.dart      # Riverpod Notifier with offline fallback
│   │
│   ├── story/
│   │   ├── domain/
│   │   │   ├── story.dart                  # Story domain model
│   │   │   └── source.dart                 # Source domain model
│   │   └── presentation/widgets/
│   │       ├── story_card.dart             # Reusable story card widget
│   │       └── source_list.dart            # Transparent source attribution & button
│   │
│   ├── archive/
│   │   └── presentation/
│   │       └── archive_screen.dart         # Chronological list of past editions
│   │
│   ├── notifications/
│   │   ├── services/
│   │   │   └── notification_service.dart   # FCM scaffolding & payload routing
│   │   └── providers/
│   │       └── notification_providers.dart # Riverpod notification stream
│   │
│   └── ads/
│       ├── ad_config.dart                  # Feature flag & ad interval config
│       └── presentation/
│           └── ad_placeholder.dart         # Non-intrusive AdMob placeholder
```

---

## Categories Included

1. 🤖 **AI & Machine Learning**
2. 💻 **Developers**
3. 🏢 **Big Tech**
4. 🚀 **Startups**
5. 🔐 **Cybersecurity**
6. ☁️ **Cloud**
7. 🔬 **Technology Research**
8. 🌎 **Technology Around the World**

---

## Running the Application

### 1. Fetch dependencies
```bash
flutter pub get
```

### 2. Run on device or simulator
```bash
flutter run
```

The application runs immediately using built-in mock data without requiring an active backend or Firebase setup.

### 3. Run Static Analysis & Tests
```bash
flutter analyze
flutter test
```

---

## Switching to Live Backend

In `lib/core/constants/app_constants.dart`:

```dart
class FeatureFlags {
  // Set to false when your API server is running:
  static const bool useMockRepository = false;
  
  // Set to true when AdMob credentials are ready:
  static const bool adsEnabled = false;
}
```

The backend should provide:
- `GET /api/v1/edition/today`
- `GET /api/v1/edition/{date}`
- `GET /api/v1/editions/archive`
