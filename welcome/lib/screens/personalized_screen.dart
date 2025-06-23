import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' as rive;
import '../models/avatar_model.dart';
import '../widgets/glowing_button.dart';
import '../blocs/theme_cubit.dart';
import 'welcome_screen.dart';

class PersonalizedScreen extends StatefulWidget {
  final String name;
  final String goal;
  final List<String> interests;
  final void Function(bool isDark) toggleTheme;
  final bool isDarkMode;

  const PersonalizedScreen({
    super.key,
    required this.name,
    required this.goal,
    required this.interests,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<PersonalizedScreen> createState() => _PersonalizedScreenState();
}

class _PersonalizedScreenState extends State<PersonalizedScreen> with TickerProviderStateMixin {
  late AnimationController _slideFadeController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  String _displayedText = "";
  int _currentIndex = 0;
  late final String _fullText;

  @override
  void initState() {
    super.initState();
    _fullText = "Hi ${widget.name}! 👋";

    _slideFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideFadeController, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_slideFadeController);
    _slideFadeController.forward();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bounceAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _startTyping();
  }

  void _startTyping() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_currentIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_currentIndex];
          _currentIndex++;
        });
        return true;
      } else {
        _bounceController.repeat(reverse: true);
        return false;
      }
    });
  }

  @override
  void dispose() {
    _slideFadeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Future<List<Avatar>> loadAvatars() async {
    final data = await rootBundle.loadString('assets/data/avatars.json');
    final List decoded = json.decode(data);
    return decoded.map((item) => Avatar.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Welcome"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () => themeCubit.toggleTheme(isDark),
          ),
        ],
      ),
      body: Stack(
        children: [
          const rive.RiveAnimation.asset(
            'assets/rive/welcome_background.riv',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          SafeArea(
            child: FutureBuilder<List<Avatar>>(
              future: loadAvatars(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No avatars found."));
                }

                final avatars = snapshot.data!
                    .where((a) => widget.interests.contains(a.interest) && a.rive != null)
                    .toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SlideTransition(
                        position: _offsetAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _bounceAnimation,
                            child: Text(
                              _displayedText,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Goal: ${widget.goal}",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Your Interests",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.interests
                            .map((interest) => Chip(
                                  label: Text(interest),
                                  backgroundColor: isDark ? Colors.white70 : Colors.black87,
                                  labelStyle: TextStyle(
                                      color: isDark ? Colors.black : Colors.white),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 30),
                      if (avatars.isNotEmpty) ...[
                        Text(
                          "Your Avatars",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 15),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                childAspectRatio: 1,
                              ),
                              itemCount: avatars.length,
                              itemBuilder: (context, index) {
                                final avatar = avatars[index];
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(avatar.interest),
                                        content: SizedBox(
                                          height: 200,
                                          child: rive.RiveAnimation.asset(
                                            avatar.rive!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text("Close"),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: Colors.white.withOpacity(0.3)),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: rive.RiveAnimation.asset(
                                      avatar.rive!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 30),

                      // Glowing Reusable Button
                      Center(
                        child: GlowingButton(
                          icon: Icons.home,
                          label: "Back to Home",
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 700),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        WelcomeScreen(toggleTheme: widget.toggleTheme),
                                transitionsBuilder:
                                    (context, animation, secondaryAnimation, child) {
                                  final slide = Tween<Offset>(
                                    begin: const Offset(-1.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(
                                      CurvedAnimation(parent: animation, curve: Curves.easeOut));

                                  final fade = Tween<double>(
                                    begin: 0.0,
                                    end: 1.0,
                                  ).animate(
                                      CurvedAnimation(parent: animation, curve: Curves.easeIn));

                                  return SlideTransition(
                                    position: slide,
                                    child: FadeTransition(
                                      opacity: fade,
                                      child: child,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
