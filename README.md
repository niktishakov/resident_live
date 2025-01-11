# Resident Live

A Flutter mobile application for [brief description of what your app does - appears to be related to residential/location services based on the dependencies].

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

