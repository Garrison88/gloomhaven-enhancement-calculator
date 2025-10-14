import 'package:flutter/material.dart';

class CheckRowDivider extends StatelessWidget {
  final double height;
  final Color? color;

  const CheckRowDivider({
    super.key,
    required this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 1,
      color: color,
      margin: const EdgeInsets.only(right: 12),
    );
  }
}
