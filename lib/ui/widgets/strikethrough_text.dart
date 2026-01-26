import 'package:flutter/material.dart';

/// A text widget with a custom strikethrough line that sits at the true
/// vertical center of the text, unlike the built-in [TextDecoration.lineThrough]
/// which can sit too high depending on the font.
class StrikethroughText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double lineThickness;

  const StrikethroughText(
    this.text, {
    super.key,
    this.style,
    this.lineThickness = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;
    final lineColor = effectiveStyle.color ?? Colors.black;

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(text, style: effectiveStyle),
        Positioned.fill(
          child: Center(
            child: Container(
              height: lineThickness,
              color: lineColor,
            ),
          ),
        ),
      ],
    );
  }
}
