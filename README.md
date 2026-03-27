# Iron Forge - Fitness Training App

A complete Flutter fitness app based on the Iron Forge UI design with dark orange theme.

## Features

### 5 Main Screens:
1. **Home Dashboard** - Welcome screen with today's workout, quick actions, and daily activity stats
2. **Training Library** - Browse workout programs by category with search functionality
3. **Fitness Tracker** - Interactive calendar, calorie tracker, water intake, and workout log
4. **BMI Calculator** - Real-time BMI calculator with sliders for height/weight and visual scale
5. **Profile** - User profile with stats, body metrics, and subscription status

### Key Functionality:
- ✅ Full dark theme with orange (#FF6B00) accent color
- ✅ Bottom navigation between all 5 screens
- ✅ Working BMI calculator with real-time updates
- ✅ Workout timer that starts when you begin a workout
- ✅ Water intake tracker with tap-to-add/remove glasses
- ✅ Calorie tracking with add meal dialog
- ✅ Interactive calendar in fitness tracker
- ✅ Subscription upgrade flow (monthly/yearly plans)
- ✅ Provider-based state management
- ✅ Workout log that persists during session
- ✅ Animated UI elements and smooth transitions

## Setup & Run

### Prerequisites:
- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+

### Install & Run:
```bash
cd iron_forge
flutter pub get
flutter run
```

### Build APK:
```bash
flutter build apk --release
```

### Build iOS:
```bash
flutter build ios --release
```

## Project Structure

```
iron_forge/
├── lib/
│   ├── main.dart                    # App entry point & bottom nav shell
│   ├── theme/
│   │   └── app_theme.dart           # Colors, typography, theme config
│   ├── models/
│   │   ├── user_model.dart          # User data model with BMI calculation
│   │   └── workout_model.dart       # Workout & Program models
│   ├── providers/
│   │   └── app_provider.dart        # Global state management
│   ├── widgets/
│   │   └── common_widgets.dart      # Reusable UI components
│   └── screens/
│       ├── home_screen.dart         # Home Dashboard
│       ├── training_library_screen.dart  # Training Library
│       ├── fitness_tracker_screen.dart   # Fitness Tracker
│       ├── bmi_calculator_screen.dart    # BMI Calculator
│       ├── subscription_screen.dart      # Subscription Plans
│       ├── profile_screen.dart           # User Profile
│       └── workout_detail_screen.dart    # Workout Detail & Timer
└── pubspec.yaml                     # Dependencies
```

## Dependencies
- `provider` - State management
- `fl_chart` - Charts and graphs
- `intl` - Date formatting
- `percent_indicator` - Progress indicators
- `animate_do` - Animations
- `flutter_staggered_animations` - Staggered list animations
