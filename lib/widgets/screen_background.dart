import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/utils/asset_path.dart';

class ScreenBackground extends StatelessWidget {
  final Widget child;
  const ScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(AssetPaths.backgroundSVG,
        width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.cover,
        ),
        SafeArea(child: child),

      ],
    );
  }
}
