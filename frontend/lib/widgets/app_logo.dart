import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
/// A stateless widget that displays the application's logo as an SVG.
/// This promotes reusability and a consistent brand identity across the application.
class AppLogo extends StatelessWidget {
  /// The optional width for the logo.
  final double? width;
  /// The optional height for the logo.
  final double? height;
  /// Creates an [AppLogo] widget.
  ///
  /// [key] is an optional key to use for the widget.
  /// [width] specifies the width of the SVG image.
  /// [height] specifies the height of the SVG image.
  const AppLogo({
    super.key,
    this.width,
    this.height,
  });
  // A constant string containing the SVG markup for the application logo.
  // It features a stylized checkmark within a gradient-filled rounded rectangle,
  // incorporating bright and vibrant colors from the global configuration.
  static const String _logoSvg = """
<svg width="100%" height="100%" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect width="100" height="100" fill="url(#mainGradient)" rx="20"/>
    <path d="M30 50 L45 65 L70 40" stroke="white" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
    <defs>
        <linearGradient id="mainGradient" x1="0" y1="0" x2="100" y2="100" gradientUnits="userSpaceOnUse">
            <stop stop-color="#4A90E2"/>
            <stop offset="1" stop-color="#50E3C2"/>
        </linearGradient>
    </defs>
</svg>
""";
  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _logoSvg,
      width: width,
      height: height,
      semanticsLabel: 'Task Manager Veeda Logo', // Added for accessibility
    );
  }
}