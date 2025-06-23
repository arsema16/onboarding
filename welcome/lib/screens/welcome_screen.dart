import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../widgets/glowing_button.dart';
import 'profile_setup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  final void Function(bool) toggleTheme;

  const WelcomeScreen({super.key, required this.toggleTheme});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late final AnimationController _glowController;
  late final AnimationController _bounceController;
  late final Animation<double> _glowAnimation;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Welcome"),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(value: isDark, onChanged: widget.toggleTheme),
              const Icon(Icons.dark_mode),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        children: [
          // Background Rive animation
          const RiveAnimation.asset(
            'assets/rive/welcome_background.riv',
            fit: BoxFit.cover,
          ),
          // Semi-transparent overlay
          Container(color: Colors.black.withOpacity(0.3)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated typing text
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Ready to begin your journey?',
                          textStyle: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          speed: const Duration(milliseconds: 80),
                        ),
                      ],
                      totalRepeatCount: 1,
                      pause: const Duration(milliseconds: 1000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    ),
                    const SizedBox(height: 30),
                    // Animated glowing & bouncing button
                    AnimatedBuilder(
                      animation:
                          Listenable.merge([_glowController, _bounceController]),
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, -_bounceAnimation.value),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(_glowAnimation.value * 0.6),
                                  blurRadius: 20,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: GlowingButton(
                        icon: Icons.arrow_forward,
                        label: "Get Started",
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 700),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      ProfileSetupScreen(
                                          toggleTheme: widget.toggleTheme),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                final slide = Tween<Offset>(
                                  begin: const Offset(0.0, 1.0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                    parent: animation, curve: Curves.easeOutQuart));

                                final fade = Tween<double>(
                                  begin: 0.0,
                                  end: 1.0,
                                ).animate(CurvedAnimation(
                                    parent: animation, curve: Curves.easeIn));

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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
