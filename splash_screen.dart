import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../home/presentation/home_screen.dart';

/// Animated splash screen: ripples, a bouncing/rotating logo, a letter-by-letter
/// title, a tagline and a loading bar. It moves to the Home screen when done
/// (or immediately when the user taps).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _title = 'Campus Hub';

  late final AnimationController _main = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3600),
  );
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat();

  late final Animation<double> _logoScale = CurvedAnimation(
    parent: _main,
    curve: const Interval(0.0, 0.38, curve: Curves.elasticOut),
  );
  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _main,
    curve: const Interval(0.0, 0.15, curve: Curves.easeOut),
  );
  late final Animation<double> _logoSpin = CurvedAnimation(
    parent: _main,
    curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
  );
  late final Animation<double> _tagline = CurvedAnimation(
    parent: _main,
    curve: const Interval(0.62, 0.82, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _progress = CurvedAnimation(
    parent: _main,
    curve: const Interval(0.1, 1.0, curve: Curves.easeInOut),
  );

  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _main.forward().whenComplete(_goHome);
  }

  void _goHome() {
    if (!mounted || _navigated) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.08, end: 1.0).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _main.dispose();
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _goHome,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: AppTheme.gradient),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildBubbles(),
              _buildRipples(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 28),
                  _buildTitle(),
                  const SizedBox(height: 10),
                  _buildTagline(),
                ],
              ),
              Positioned(
                left: 48,
                right: 48,
                bottom: 64,
                child: _buildProgress(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Soft translucent circles drifting in the background.
  Widget _buildBubbles() {
    const bubbles = [
      (0.12, 0.14, 70.0, 0.0),
      (0.82, 0.10, 46.0, 0.3),
      (0.88, 0.62, 90.0, 0.6),
      (0.08, 0.72, 56.0, 0.15),
      (0.55, 0.88, 38.0, 0.8),
    ];
    return AnimatedBuilder(
      animation: _loop,
      builder: (context, _) {
        final size = MediaQuery.sizeOf(context);
        return Stack(
          children: [
            for (final b in bubbles)
              Positioned(
                left: size.width * b.$1,
                top: size.height * b.$2 +
                    math.sin((_loop.value + b.$4) * 2 * math.pi) * 14,
                child: Container(
                  width: b.$3,
                  height: b.$3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Three expanding rings behind the logo.
  Widget _buildRipples() {
    return AnimatedBuilder(
      animation: _loop,
      builder: (context, _) {
        return Transform.translate(
          offset: const Offset(0, -62),
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (var i = 0; i < 3; i++) _ring((_loop.value + i / 3) % 1.0),
            ],
          ),
        );
      },
    );
  }

  Widget _ring(double phase) {
    final diameter = 110 + phase * 230;
    return Opacity(
      opacity: (1 - phase) * 0.35,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_main, _loop]),
      builder: (context, _) {
        final float = math.sin(_loop.value * 2 * math.pi) * 5;
        return Opacity(
          opacity: _logoFade.value.clamp(0.0, 1.0).toDouble(),
          child: Transform.translate(
            offset: Offset(0, float),
            child: Transform.rotate(
              angle: (1 - _logoSpin.value) * -math.pi,
              child: Transform.scale(
                scale: _logoScale.value,
                child: Container(
                  width: 124,
                  height: 124,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    size: 66,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Each letter fades and rises one after the other.
  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _main,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < _title.length; i++) _letter(i),
          ],
        );
      },
    );
  }

  Widget _letter(int index) {
    final start = 0.30 + index * 0.028;
    final t = ((_main.value - start) / 0.14).clamp(0.0, 1.0).toDouble();
    final eased = Curves.easeOutBack.transform(t);
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, (1 - eased) * 26),
        child: Text(
          _title[index],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return AnimatedBuilder(
      animation: _tagline,
      builder: (context, _) {
        return Opacity(
          opacity: _tagline.value.clamp(0.0, 1.0).toDouble(),
          child: Transform.translate(
            offset: Offset(0, (1 - _tagline.value) * 14),
            child: const Text(
              'Your campus, in your pocket',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                letterSpacing: 0.6,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgress() {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) {
        final percent = (_progress.value * 100).round();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _progress.value,
                minHeight: 6,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Loading your campus…  $percent%',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
