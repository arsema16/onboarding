import 'package:flutter/material.dart';

class InterestChip extends StatefulWidget {
  final String interest;
  final bool isSelected;
  final VoidCallback onTap;

  const InterestChip({
    super.key,
    required this.interest,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<InterestChip> createState() => _InterestChipState();
}

class _InterestChipState extends State<InterestChip> with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    if (widget.isSelected) {
      _glowController.repeat(reverse: true);
      _bounceController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant InterestChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !_glowController.isAnimating) {
      _glowController.repeat(reverse: true);
      _bounceController.repeat(reverse: true);
    } else if (!widget.isSelected && _glowController.isAnimating) {
      _glowController.stop();
      _glowController.reset();
      _bounceController.stop();
      _bounceController.reset();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final iconData = {
      'Fitness': Icons.fitness_center,
      'Coding': Icons.code,
      'Art': Icons.brush,
      'Music': Icons.music_note,
      'Gaming': Icons.videogame_asset,
      'Travel': Icons.flight_takeoff,
    }[widget.interest];

    final gradientColors = [
  const Color.fromARGB(255, 150, 148, 151),
  const Color.fromARGB(255, 140, 137, 146),
];


    return AnimatedBuilder(
      animation: Listenable.merge([_glowController, _bounceController]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_bounceAnimation.value),
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: widget.isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(_glowAnimation.value * 0.7),
                        blurRadius: 20,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: widget.isSelected ? LinearGradient(colors: gradientColors) : null,
            color: widget.isSelected ? null : (isDark ? Colors.white12 : Colors.grey[200]),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected ? Colors.transparent : (isDark ? Colors.white30 : Colors.grey.shade400),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconData != null) ...[
                Icon(iconData,
                    size: 18,
                    color: widget.isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black54)),
                const SizedBox(width: 6),
              ],
              Text(
                widget.interest,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
