import 'package:flutter/material.dart';

class GlowingButton extends StatefulWidget {
  final VoidCallback? onPressed; 
  final String label;
  final IconData icon;

  const GlowingButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    if (widget.onPressed != null) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant GlowingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onPressed != null && !_glowController.isAnimating) {
      _glowController.repeat(reverse: true);
    } else if (widget.onPressed == null && _glowController.isAnimating) {
      _glowController.stop();
      _glowController.reset();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: widget.onPressed != null
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(_glowAnimation.value * 0.7),
                      blurRadius: 20,
                      spreadRadius: 3,
                    )
                  ]
                : [],
          ),
          child: child,
        );
      },
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        icon: Icon(widget.icon),
        label: Text(widget.label),
        onPressed: widget.onPressed,
      ),
    );
  }
}
