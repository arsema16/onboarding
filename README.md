# 🚀 Flutter Onboarding App

A beautifully animated onboarding experience using Flutter + Rive. This app introduces users to a personalized journey through:

- ✨ SplashScreen with animated background
- 👋 WelcomeScreen with typewriter effect & glowing button
- 🧑‍💼 ProfileSetupScreen with animation, dynamic interest chips & Rive background
- 🤖 PersonalizedScreen with animated welcome text, responsive avatar grid, and dark/light theme toggle

---

## 🔧 Features

- 🌓 Light & Dark mode support
- 🎞️ Rive animations for engaging visuals
- 💾 Local JSON for avatar data
- 💡 Custom transition animations
- ⚙️ Modular architecture with BLoC, `core/`, and `widgets/` separation

---

## 🗂️ Folder Structure

```bash
lib/
├── bloc/              # BLoC state management
├── core/              # Constants & theme utils
├── models/            # Avatar data model
├── screens/           # All screen widgets
├── widgets/           # Reusable components
└── main.dart
