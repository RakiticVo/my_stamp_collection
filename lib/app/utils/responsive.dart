import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600 &&
      MediaQuery.sizeOf(context).width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1200;

  /// Returns standard horizontal padding based on device type.
  /// Desktop: 120, Tablet: 48, Mobile: 24.
  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 120;
    if (isTablet(context)) return 48;
    return 24;
  }

  /// Returns standard vertical padding between major layout sections.
  static double verticalSpacing(BuildContext context) {
    return isMobile(context) ? 48 : 64;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) {
      return desktop;
    } else if (width >= 600 && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
