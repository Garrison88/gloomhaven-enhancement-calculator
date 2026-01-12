import 'package:flutter/material.dart';

class ConditionalCheckbox extends StatelessWidget {
  final bool value;
  final bool isEditMode;
  final bool isRetired;
  final ValueChanged<bool>? onChanged;
  final VisualDensity visualDensity;

  const ConditionalCheckbox({
    super.key,
    required this.value,
    required this.isEditMode,
    required this.isRetired,
    required this.onChanged,
    this.visualDensity = VisualDensity.comfortable,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      visualDensity: visualDensity,
      value: value,
      onChanged: isEditMode && !isRetired
          ? (bool? val) => val != null ? onChanged?.call(val) : null
          : null,
    );
  }
}
