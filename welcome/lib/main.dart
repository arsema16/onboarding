import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'blocs/theme_cubit.dart'; // import your cubit

void main() {
  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: const OnboardingApp(),
    ),
  );
}
