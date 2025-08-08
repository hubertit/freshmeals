## FreshMeals – Flutter App

FreshMeals is a cross‑platform Flutter app for discovering meals, managing a cart and checkout, tracking nutrition and progress, booking appointments with nutritionists, and managing delivery addresses and orders.

- Repository: [`hubertit/freshmeals`](https://github.com/hubertit/freshmeals.git)


### Highlights
- Built with Flutter 3 and Dart 3
- State management with Riverpod (StateNotifier)
- Declarative navigation with `go_router`
- REST API client with `dio`
- Persistent session via `shared_preferences`
- Local notifications
- Facebook and Google Sign‑In integrations (Google backend exchange stubbed)


## Features

- Authentication
  - Email/phone + password login, register, logout
  - Forgot/reset password flow
  - Token verification and session persistence (stored in `SharedPreferences`)
  - Splash screen auto‑redirects to Home or Login based on stored user
  - Facebook Login (via `flutter_facebook_auth`)
  - Google Sign‑In (client sign‑in complete; backend token exchange placeholder)

- Onboarding & Profile
  - Welcome screens and profile capture: age, gender, height, weight
  - Health goals and dietary preferences
  - Subscription selection

- Meals & Discovery
  - Meal categories and types
  - Recommended and random meals
  - Search and detailed meal pages

- Cart & Checkout
  - Add, update, remove items
  - Cart summary (subtotal, VAT, totals)
  - Checkout and payment status screens: success, failed, processing

- Orders & Delivery
  - My Orders and Order Details
  - Manage delivery addresses and default address
  - Address picker and location tracking

- Favorites
  - Mark/unmark favorite meals and view favorites

- Nutritionists & Appointments
  - List of nutritionists and details page
  - Appointment booking and "My Appointments"

- Tracking & Insights
  - Calorie tracker and progress tracker screens

- Notifications
  - Local notifications for cart and system events


## Architecture Overview

- Entry point: `lib/main.dart`
  - Initializes notifications and sets up `MaterialApp.router` with `go_router`
  - Provides global `ProviderScope` for Riverpod

- Routing: `lib/routers/app_router.dart`
  - Central route table using `GoRouter` with paths for splash, auth, onboarding, home, meals, cart/checkout, orders, payments, tracking, nutritionists, and appointments

- State Management: Riverpod (StateNotifier)
  - Notifiers in `lib/riverpod/notifiers/**`
  - Providers in `lib/riverpod/providers/**`
  - Examples:
    - `UserNotifier` (login/register/logout/token verify, session storage)
    - `CartNotifier` (items, add/update/remove, summary)
    - `SettingsNotifier` (address & working hours)
    - Multiple domain notifiers for meals, favorites, addresses, orders, payments, appointments, search, trackers

- Networking
  - `dio` for HTTP
  - Base URL configured in `lib/constants/_api_utls.dart`

- Persistence
  - `shared_preferences` for user session JSON

- Theming
  - Central styles in `lib/theme/**`

- Utilities
  - Notifications: `lib/utls/notification_service.dart`
  - Authentication helpers: `lib/utls/auth.dart`
  - Validators and shared styles in `lib/utls/**`


## Key Files

- App entry: `lib/main.dart`
- Router: `lib/routers/app_router.dart`
- API config: `lib/constants/_api_utls.dart`
- Auth state: `lib/riverpod/notifiers/user_notifier.dart`
- Cart state: `lib/riverpod/notifiers/cart_notifier.dart`
- Settings state: `lib/riverpod/notifiers/settings.dart`
- Splash redirect logic: `lib/views/splash/splash.dart`


## Project Structure (simplified)

```
lib/
  constants/
    _api_utls.dart
    _assets.dart
  models/
    general/, home/, settings/, user_model.dart, ...
  riverpod/
    notifiers/ (auth, cart, meals, orders, payments, settings, ...)
    providers/ (auth_providers.dart, general.dart, home.dart)
  routers/
    app_router.dart
  theme/
    colors.dart, styles.dart
  utls/
    auth.dart, notification_service.dart, validatots.dart, ...
  views/
    splash/, auth/, welcome/, homepage/, appointment/
```


## Configuration

Update API and keys:

- Base API URL: `lib/constants/_api_utls.dart`
  - `baseUrl = "https://freshmeals.rw/api/"`
- Google Maps API key: ensure the key is configured for both Android and iOS
- Facebook App configuration: provide App ID/Name and platform configs
- Google Sign‑In configuration: provide client IDs and platform configs

Environment/secrets best‑practice: do not hard‑code secrets in VCS. Prefer injecting via CI or using a local, git‑ignored Dart file that is conditionally imported per flavor.


### Android Setup

- Google Maps API key in `android/app/src/main/AndroidManifest.xml` inside `<application>`:

```xml
<meta-data
  android:name="com.google.android.geo.API_KEY"
  android:value="YOUR_ANDROID_GOOGLE_MAPS_API_KEY" />
```

- Geolocation permissions in manifest if needed:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

- Facebook Login: configure `applicationId`, `meta-data`, and activity per `flutter_facebook_auth` docs.

- Notifications: default channel as per `flutter_local_notifications` plugin (no extra setup for basics).


### iOS Setup

- Google Maps API key in `ios/Runner/Info.plist`:

```xml
<key>GMSApiKey</key>
<string>YOUR_IOS_GOOGLE_MAPS_API_KEY</string>
```

- Location permissions in `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app uses your location to show delivery options nearby.</string>
```

- Facebook Login: add `CFBundleURLTypes`, `LSApplicationQueriesSchemes`, and `FacebookAppID`/`FacebookDisplayName`.

- Notifications: request permissions on first use; ensure provisional/alert/badge settings as needed.


## API Endpoints (used by app)

- `POST user/login`
- `POST token/verify`
- `GET  general/health_goals`
- `POST addresses/retrieve`
- `POST cart/items`, `POST cart/add`, `PUT cart/update`, `PUT cart/remove`
- `GET  settings/address`, `GET settings/working_hours`
- Additional endpoints exist across meals, orders, favorites, payments, appointments

These are built on top of the `baseUrl` in `lib/constants/_api_utls.dart`.


## Development

Prerequisites
- Flutter SDK 3.x, Dart 3.4+
- Xcode (iOS), Android Studio/SDK (Android)

Install dependencies
```bash
flutter pub get
```

Run (choose your device: iOS Simulator, Android Emulator, or web)
```bash
flutter run
```

Run tests
```bash
flutter test
```

Build
```bash
# Android
flutter build apk
flutter build appbundle

# iOS (requires code signing set up in Xcode)
flutter build ios --release
```


## Code Style & Linting

- Lints configured via `analysis_options.yaml` with `flutter_lints`
- Follow Clean Code naming and Riverpod patterns used in the repository


## Notes for the Next Developer

- Routing table is centralized in `lib/routers/app_router.dart`. Review route extras and path parameters when adding screens.
- `UserNotifier` handles session storage in `SharedPreferences` and navigation side‑effects on auth actions.
- `CartNotifier` maintains the cart list and summary and triggers notifications/snackbars on updates.
- `SettingsNotifier` eagerly loads address and working hours on startup.
- Google Sign‑In flow signs in on device; the backend token exchange (`AuthRepository.authenticateUser`) is placeholder and should be wired to a real backend endpoint.
- Verify third‑party platform setup (Facebook/Google/Maps) in both Android and iOS before release builds.


