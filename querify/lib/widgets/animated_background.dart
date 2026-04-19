import 'package:flutter/material.dart';
import 'dart:math';

import 'package:querify/constants/appcolours.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final int particleCount = 20;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      particleCount,
      (index) => AnimationController(
        duration: Duration(seconds: 3 + Random().nextInt(4)),
        vsync: this,
      )..repeat(reverse: true),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF000000),
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 20, 20, 20),
                Color(0xFF000000),
              ],
            ),
          ),
        ),
        // Animated Particles
        ...List.generate(particleCount, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(
                  progress: _animations[index].value,
                  index: index,
                  total: particleCount,
                ),
                size: Size.infinite,
              );
            },
          );
        }),
        // Content
        widget.child,
      ],
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double progress;
  final int index;
  final int total;

  ParticlePainter({
    required this.progress,
    required this.index,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(index);
    final xStart = random.nextDouble() * size.width;
    final yStart = random.nextDouble() * size.height;
    final xOffset = (random.nextDouble() - 0.5) * 100;
    final yOffset = (random.nextDouble() - 0.5) * 100;

    final x = xStart + (xOffset * progress);
    final y = yStart + (yOffset * progress);

    final paint = Paint()
      ..color = Color.lerp(
        AppColours.primary.withOpacity(0.3),
        Color.fromARGB(255, 255, 255, 255).withOpacity(0.6),
        progress,
      )!
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(
      Offset(x, y),
      10 + (progress * 15),
      paint,
    );
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}