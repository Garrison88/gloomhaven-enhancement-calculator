import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/data/constants.dart';

class CustomTextStyle {
  static TextStyle dialogText() {
    return TextStyle(fontSize: dialogFontSize, fontFamily: secondaryFontFamily, color: Colors.black87);
  }

  static TextStyle dialogTextBold() {
    return TextStyle(
        fontSize: dialogFontSize,
        fontFamily: secondaryFontFamily,
        fontWeight: FontWeight.bold, color: Colors.black87);
  }
}
