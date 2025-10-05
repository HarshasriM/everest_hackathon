# SHE (Safety Help Emergency) - Women's Safety App

A comprehensive Flutter application designed for women's safety, built with **Clean Architecture** principles and production-ready code structure.

## 🚀 Project Overview

SHE (Safety Help Emergency) is a mobile-based women's safety application that provides real-time help and rapid communication in emergency situations. The app ensures:

- ✅ Secure phone authentication (OTP-based)
- 🚨 SOS alerts sent instantly to trusted contacts
- 📍 Live location tracking
- 📞 Fake call simulation for threat escape
- 🆘 Helpline integration
- 🤖 AI-driven assistant (Niya) for emergency guidance
- 🌐 Multilingual support (English, Hindi, Telugu, Kannada)

## 🏗️ Architecture

This project follows **Clean Architecture** principles with strict separation of concerns:

```
lib/
├── app/                        # Application layer
│   └── app.dart               # Root widget configuration
│
├── core/                       # Core utilities and shared code
│   ├── config/                # Environment configuration
│   ├── dependency_injection/  # GetIt service locator setup
│   ├── network/              # API client and interceptors
│   ├── services/             # App-wide services
│   ├── theme/                # Theme and color schemes
│   └── utils/                # Constants, validators, logger
│
├── domain/                     # Business logic layer
│   ├── entities/             # Core business objects
│   ├── repositories/         # Repository interfaces
│   └── usecases/            # Business use cases
│
├── data/                      # Data layer
│   ├── datasources/         # Remote and local data sources
│   ├── models/              # Data models with freezed
│   └── repositories_impl/   # Repository implementations
│
├── features/                  # Feature modules
│   ├── auth/                # Authentication feature
│   │   ├── bloc/           # BLoC state management
│   │   ├── presentation/  # UI screens
│   │   └── widgets/       # Feature-specific widgets
│   ├── home/               # Home screen
│   ├── sos/                # SOS emergency feature
│   └── profile/            # User profile
│
├── routes/                   # Navigation setup
│   └── app_router.dart     # go_router configuration
│
└── shared/                   # Shared widgets
    └── widgets/
```

## 🛠️ Tech Stack

- **Flutter** - Cross-platform mobile framework
- **BLoC** - State management
- **GetIt** - Dependency injection
- **go_router** - Navigation
- **Dio** - Network requests
- **Freezed** - Immutable models and unions
- **Pinput** - OTP input
- **Google Maps** - Location services
- **Flutter ScreenUtil** - Responsive UI

## 📱 Features Implemented

### ✅ Complete Authentication Module
- Phone number input with validation
- OTP verification using Pinput
- Profile setup with emergency contacts
- Session management

### 🏠 Home Screen
- Quick action buttons
- SOS button with emergency countdown
- Feature cards for various safety tools

### 🆘 SOS Module
- Emergency button with countdown
- Cancel mechanism
- Quick actions (Call Police, Share Location, Record)

### 👤 Profile Management
- Personal information
- Emergency contacts management
- Settings and preferences

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio / Xcode for mobile development

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/everest_hackathon.git
cd everest_hackathon
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate freezed files**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

## 📝 Demo Credentials

For testing the authentication flow:
- **Phone Number**: Any 10-digit Indian number (e.g., 9999999999)
- **OTP**: 123456 (hardcoded for demo)

## 🔧 Configuration

### Environment Setup
Edit `lib/core/config/environment_config.dart` to configure:
- API base URLs
- Google Maps API key
- Emergency service numbers
- Feature flags

### Dependency Injection
All dependencies are registered in `lib/core/dependency_injection/di_setup.dart`

## 🧪 Testing

### Run Unit Tests
```bash
flutter test
```

### Sample Test for SendOtpUseCase
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('SendOtpUseCase should validate phone number', () async {
    // Test implementation
  });
}
```

## 📋 API Integration

The app uses mock APIs for demonstration. To connect real APIs:

1. Update endpoints in `lib/core/network/api_endpoints.dart`
2. Modify data sources in `lib/data/datasources/remote/`
3. Update environment configuration

## 🎨 UI/UX Features

- **Responsive Design**: Uses Flutter ScreenUtil for adaptive layouts
- **Theme Support**: Light and dark themes
- **Material 3**: Modern Material Design components
- **Custom Color Scheme**: safety-focused color palette

## 🔐 Security Features

- OTP-based authentication
- Biometric lock support (configurable)
- Secure token storage
- Emergency contact verification

## 🌍 Localization

The app supports multiple languages:
- English (en)
- Hindi (hi)
- Telugu (te)
- Kannada (kn)

Add translations in `lib/l10n/` directory.

## 📦 Build & Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🚧 Future Enhancements

- [ ] Firebase integration for real-time features
- [ ] Push notifications for emergency alerts
- [ ] Voice-activated SOS
- [ ] Shake detection for emergency trigger
- [ ] AI chatbot integration (Niya)
- [ ] Offline mode support
- [ ] Video/Audio recording during emergencies
- [ ] Integration with government emergency services

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team

Developed for the Everest Hackathon by Team SHE

## 📞 Support

For support, email support@she-safety.com or raise an issue in the GitHub repository.