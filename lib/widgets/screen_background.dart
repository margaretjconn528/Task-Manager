import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/utils/asset_path.dart';

/// A reusable background wrapper widget.
/// 
/// This widget applies a full-screen SVG background
/// and safely renders the provided child widget on top of it.
/// Commonly used for authentication or full-screen UI layouts.
class ScreenBackground extends StatelessWidget {
  /// The foreground widget displayed above the background
  final Widget child;

  const ScreenBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background SVG image stretched to full screen
        SvgPicture.asset(
          AssetPaths.backgroundSVG,
          width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.cover,
        ),

        /// Ensures content avoids system UI (notch, status bar, etc.)
        SafeArea(
          child: child,
        ),
      ],
    );
  }
}