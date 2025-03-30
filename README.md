# Resident Live

A Flutter mobile application for [brief description of what your app does - appears to be related to residential/location services based on the dependencies].

Directory structure:
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



# Руководство по развертыванию Resident Live с помощью Fastlane

Это руководство поможет разработчикам настроить окружение для сборки и деплоя приложения Resident Live с использованием Fastlane.

## Требования к окружению

### Общие требования
- Flutter SDK >=3.3.2
- Dart SDK
- [FVM](https://fvm.app/) (Flutter Version Management) - опционально, но рекомендуется
- Git

### Для iOS деплоя
- macOS
- Xcode (последняя стабильная версия)
- Ruby 2.6+ (системный или через [rbenv](https://github.com/rbenv/rbenv))
- [Fastlane](https://fastlane.tools/) (`gem install fastlane` или `brew install fastlane`)
- [Bundler](https://bundler.io/) (`gem install bundler`)
- Apple Developer аккаунт с доступом к проекту
- Apple Developer Team ID
- App Store Connect Team ID

## Настройка окружения

### 1. Клонирование репозитория

```bash
git clone [url-репозитория]
cd niktishakov-resident_live/mobile
```

### 2. Установка зависимостей Flutter

```bash
flutter pub get
dart run easy_localization:generate -S assets/translations -f keys
dart run build_runner watch
```

### 3. Настройка Fastlane для iOS

#### Установка необходимых инструментов

```bash
cd ios
bundle install
```

#### Настройка ключей App Store Connect API

1. Создайте ключ API в [App Store Connect](https://appstoreconnect.apple.com/access/api)
   - Скачайте файл `.p8`
   - Сохраните Key ID и Issuer ID

2. Настройте переменные окружения:

```bash
export APP_STORE_CONNECT_KEY_ID="ВАШ_KEY_ID"
export APP_STORE_CONNECT_ISSUER_ID="ВАШ_ISSUER_ID"
export APP_STORE_CONNECT_KEY_PATH="/полный/путь/к/вашему/файлу/AuthKey_XXX.p8"
```

Для постоянного использования добавьте эти строки в ваш `~/.bash_profile`, `~/.zshrc` или другой файл конфигурации оболочки.

### 4. Настройка профилей подготовки (Provisioning Profiles)

1. Убедитесь, что у вас есть следующие профили:
   - `rl-testflight-profile` для TestFlight (App Store Distribution)
   - Профиль для Ad-hoc дистрибуции

2. Профили должны быть настроены в Apple Developer Portal и загружены на ваш Mac.

## Доступные команды Fastlane

### Деплой в TestFlight

```bash
cd ios
fastlane beta
```

Эта команда:
- Подключается к API App Store Connect
- Получает последний номер сборки из TestFlight и увеличивает его
- Собирает Flutter приложение
- Создает IPA файл
- Загружает IPA в TestFlight

### Создание Ad-hoc IPA

```bash
cd ios
fastlane adhoc
```

Эта команда:
- Подключается к API App Store Connect
- Увеличивает номер сборки
- Собирает Flutter приложение
- Создает Ad-hoc IPA в директории `./build`
- Файл результата: `ResidentLive_AdHoc.ipa`

## Проверка настройки окружения

Перед запуском сборок убедитесь, что:

1. Все переменные окружения установлены:
```bash
echo $APP_STORE_CONNECT_KEY_ID
echo $APP_STORE_CONNECT_ISSUER_ID
echo $APP_STORE_CONNECT_KEY_PATH
```

2. Профили подготовки настроены корректно. Проверьте через Xcode:
   - Откройте `ios/Runner.xcworkspace`
   - Перейдите в настройки проекта
   - Проверьте вкладку Signing & Capabilities

3. Настройки Bundle ID соответствуют `com.nikapps.residentlive` в Appfile и проекте

## Решение проблем

### Ошибка с ключом App Store Connect
- Убедитесь, что путь к файлу `.p8` корректный и файл существует
- Убедитесь, что Key ID и Issuer ID введены правильно
- Проверьте права доступа к файлу ключа: `chmod 600 /путь/к/AuthKey_XXX.p8`

### Ошибки профилей подготовки
- Обновите профили через Xcode: Xcode -> Preferences -> Accounts -> [ваш аккаунт] -> Manage Certificates
- Убедитесь, что в Fastfile указано правильное имя профиля, соответствующее имени в Apple Developer Portal

### Ошибки сборки Flutter
- Попробуйте выполнить `flutter clean` и затем `flutter pub get`
- Проверьте, что версия Flutter соответствует требованиям (>=3.3.2)


## Контакты для поддержки

При возникновении проблем обратитесь к: [starscreamnik@gmail.com](mailto:starscreamnik@gmail.com)