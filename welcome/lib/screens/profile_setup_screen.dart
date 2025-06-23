import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' as rive;
import '../blocs/theme_cubit.dart';
import '../core/constants.dart';
import '../widgets/interest_chip.dart';
import '../widgets/glowing_button.dart';
import 'personalized_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final void Function(bool isDark) toggleTheme;

  const ProfileSetupScreen({super.key, required this.toggleTheme});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController goalController = TextEditingController();

  List<String> selectedInterests = [];

  bool isLoading = false;

  void submitProfile() async {
    final name = nameController.text.trim();
    final goal = goalController.text.trim();

    if (name.isEmpty || goal.isEmpty || selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and select interests"),
        ),
      );
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Success! 🎉"),
            content: const Text("Your profile has been set up."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 1000),
                      pageBuilder:
                          (context, animation, secondaryAnimation) =>
                              PersonalizedScreen(
                                name: name,
                                goal: goal,
                                interests: selectedInterests,
                                toggleTheme: widget.toggleTheme,
                                isDarkMode:
                                    Theme.of(context).brightness ==
                                    Brightness.dark,
                              ),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        final slide = Tween<Offset>(
                          begin: const Offset(0.0, 1.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutQuart,
                          ),
                        );

                        final fade = Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeIn,
                          ),
                        );

                        return SlideTransition(
                          position: slide,
                          child: FadeTransition(opacity: fade, child: child),
                        );
                      },
                    ),
                  );
                },
                child: const Text("Continue"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Setup Your Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: "Toggle Day/Night Mode",
            onPressed: () => context.read<ThemeCubit>().toggleTheme(!isDark),
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: const rive.RiveAnimation.asset(
                    'assets/rive/venuto.riv',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Let’s personalize your experience by setting up your profile.",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 30),
                _buildTextField("Your Name", nameController),
                const SizedBox(height: 20),
                _buildTextField(
                  "Your Goal (e.g., Learn to code)",
                  goalController,
                ),
                const SizedBox(height: 25),
                const Text(
                  "Select your interests (max 3):",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      kAvailableInterests.map((interest) {
                        final isSelected = selectedInterests.contains(interest);
                        return InterestChip(
                          interest: interest,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedInterests.remove(interest);
                              } else if (selectedInterests.length < 3) {
                                selectedInterests.add(interest);
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 30),
                Center(
                  child: GlowingButton(
                    icon: isLoading ? Icons.hourglass_top : Icons.check,
                    label: isLoading ? "Submitting..." : "Submit",
                    onPressed: isLoading ? null : () => submitProfile(),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        filled: true,
        fillColor: Colors.white10,
      ),
    );
  }
}
