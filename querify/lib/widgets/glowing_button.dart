import 'package:flutter/material.dart';
import 'package:querify/constants/appcolours.dart';

class GlowingButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const GlowingButton({
    required this.text,
    required this.onTap,
  });

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              
              boxShadow: [
                BoxShadow(
                  color: AppColours.primary.withOpacity(_glowAnimation.value * 0.6),
                  blurRadius: _isHovered ? 30 : 20,
                  spreadRadius: _isHovered ? 5 : 2,
                ),
                BoxShadow(
                  color: Color.fromARGB(255, 40, 198, 45).withOpacity(_glowAnimation.value * 0.4),
                  blurRadius: _isHovered ? 40 : 30,
                  spreadRadius: _isHovered ? 8 : 4,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.onTap,
              style: ElevatedButton.styleFrom(
                // backgroundColor: Color.fromARGB(255, 67, 166, 35),
                // backgroundColor: AppColours.primary,
                backgroundColor: AppColours.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                widget.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}