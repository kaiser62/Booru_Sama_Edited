// Flutter imports:
import 'package:flutter/material.dart';

class ShadowGradientOverlay extends StatelessWidget {
  const ShadowGradientOverlay({
    required this.alignment,
    required this.colors,
    super.key,
    this.height,
  }) : assert(
         alignment == Alignment.bottomCenter ||
             alignment == Alignment.topCenter,
         'Alignment must be either topCenter or bottomCenter',
       );

  final List<Color> colors;
  final Alignment alignment;
  final double? height;

  Gradient _buildGradient(Alignment alignment, List<Color> colors) {
    return alignment == Alignment.topCenter
        ? LinearGradient(
            end: const Alignment(0, 0.4),
            begin: Alignment.topCenter,
            colors: colors,
          )
        : LinearGradient(
            end: const Alignment(0, -0.4),
            begin: Alignment.bottomCenter,
            colors: colors,
          );
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Container(
          height: height ?? 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: _buildGradient(alignment, colors),
          ),
        ),
      ),
    );
  }
}
