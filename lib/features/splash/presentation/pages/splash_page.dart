import 'package:flutter/material.dart';
import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/utils/responsive.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // Navigate to Home Shell after the animation completes and a short delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => AppRouter.homeShell(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double logoSize = isMobile ? 120 : 180;
    final double titleSize = isMobile ? 36 : 48;
    final double subtitleSize = isMobile ? 14 : 18;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The Stampzy S Logo
                    Container(
                      height: logoSize,
                      width: logoSize,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback if logo not found
                          return Icon(
                            Icons.auto_awesome_mosaic_rounded,
                            size: logoSize * 0.8,
                            color: AppColors.primary,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Stampzy Brand Text
                    Text(
                      'Stampzy',
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Subtitle
                    Text(
                      'Capture your world, one story at a time.',
                      style: TextStyle(
                        fontSize: subtitleSize,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
