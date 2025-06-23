import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import '../blocs/theme_cubit.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WelcomeScreen(toggleTheme: themeCubit.toggleTheme),
        ),
      );
    });

    return Scaffold(
      body: Center(
        child: const RiveAnimation.asset('assets/rive/splash.riv'),
      ),
    );
  }
}
