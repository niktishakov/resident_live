# Resident Live

A Flutter mobile application for [brief description of what your app does - appears to be related to residential/location services based on the dependencies].

Directory structure:
```
└── niktishakov-resident_live/
    ├── README.md
    ├── LICENSE
    └── mobile/
        ├── analysis_options.yaml
        ├── devtools_options.yaml
        ├── pubspec.lock
        ├── pubspec.yaml
        ├── .fvmrc
        ├── .gitignore
        ├── .metadata
        ├── android/
        ├── assets/
        │   ├── fonts/
        │   │   ├── Poppins/
        │   │   └── SFProDisplay/
        │   │       ├── COPYRIGHT.txt
        │   │       └── SFPro_Font_License.rtf
        │   ├── imgs/
        │   ├── svgs/
        │   └── translations/
        │       ├── en-US.json
        │       └── ru-RU.json
        ├── ios/
        ├── lib/
        │   ├── app/
        │   ├── domain/
        │   │   ├── entities/
        │   │   │   ├── country/
        │   │   │   └── user/
        │   │   └── value_objects/
        │   │       └── stay_period/
        │   ├── features/
        │   │   ├── auth/
        │   │   │   └── model/
        │   │   ├── countries/
        │   │   │   └── model/
        │   │   ├── language/
        │   │   │   ├── api/
        │   │   │   ├── model/
        │   │   │   └── ui/
        │   │   ├── location/
        │   │   │   └── model/
        │   │   └── user/
        │   │       └── model/
        │   ├── generated/
        │   ├── screens/
        │   │   ├── all_countries/
        │   │   │   └── ui/
        │   │   ├── bottom_bar/
        │   │   │   └── cubit/
        │   │   ├── get_started/
        │   │   │   ├── model/
        │   │   │   └── ui/
        │   │   ├── home/
        │   │   │   └── ui/
        │   │   │       └── widgets/
        │   │   ├── language/
        │   │   ├── manage_countries/
        │   │   ├── onboarding/
        │   │   │   ├── model/
        │   │   │   └── ui/
        │   │   │       └── pages/
        │   │   ├── residence_details/
        │   │   │   └── widgets/
        │   │   ├── settings/
        │   │   ├── splash/
        │   │   ├── tracking_residences/
        │   │   └── web_view/
        │   │       └── widgets/
        │   ├── shared/
        │   │   ├── lib/
        │   │   │   ├── assets/
        │   │   │   ├── extensions/
        │   │   │   ├── observers/
        │   │   │   ├── services/
        │   │   │   │   └── workmanager/
        │   │   │   ├── theme/
        │   │   │   └── utils/
        │   │   ├── router/
        │   │   └── ui/
        │   └── widgets/
        │       ├── add_periods/
        │       │   └── ui/
        │       ├── find_countries/
        │       │   └── ui/
        │       ├── get_started/
        │       │   └── ui/
        │       └── journey_view/
        │           └── ui/
        │               └── widgets/
        └── .vscode/
```

## Features

- Location-based services (using geolocator and geocoding)
- Authentication with biometrics (local_auth)
- Multi-language support (easy_localization)
- Data visualization with heatmaps and charts
- Background task management
- Secure data storage
- Modern, animated UI components

## Getting Started

### Prerequisites

- Flutter SDK >=3.3.2
- Dart SDK
- [FVM](https://fvm.app/) (Flutter Version Management) - optional but recommended

### Installation

1. Clone the repository: ```git clone [your-repository-url]```
2. Navigate to the project directory: ```cd mobile```
3. Install dependencies: ```flutter pub get```
4. Generate localizations: ```dart run easy_localization:generate -S assets/translations -f keys```
5. Generate other build files: ```dart run build_runner watch```
6. Run the app: ```fvm flutter run```

## Design System

The app uses two main font families:
- SF Pro Display
- Poppins

Both fonts include weights from 100 (Thin) to 900 (Black).

