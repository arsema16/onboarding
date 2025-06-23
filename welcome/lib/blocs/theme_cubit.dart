import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(isDarkMode: false));

  void toggleTheme(bool isDark) => emit(ThemeState(isDarkMode: isDark));
}
