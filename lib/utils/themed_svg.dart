import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/utils/asset_config.dart';

/// A widget that renders an SVG icon with proper theme-based coloring.
///
/// Takes an asset key (e.g., 'MOVE', 'ATTACK', 'LOSS') which is looked up in
/// [asset_config.dart] to get the file path and theming configuration.
///
/// For icons with [usesCurrentColor], uses [SvgTheme] so only SVG elements
/// with `fill="currentColor"` change based on theme. Other colors are preserved.
///
/// ## Usage
///
/// ```dart
/// ThemedSvg(assetKey: 'MOVE', width: 24)
/// ThemedSvg(assetKey: 'ATTACK', width: 24, color: Colors.red)
/// ```
class ThemedSvg extends StatelessWidget {
  /// The asset key to look up in [asset_config.dart].
  ///
  /// Examples: 'MOVE', 'ATTACK', 'LOSS', 'SHIELD', 'Wild_Element'
  final String assetKey;

  /// Optional width for the icon.
  final double? width;

  /// Optional height for the icon.
  final double? height;

  /// Optional custom color to tint the icon.
  /// When provided, overrides theme-based coloring.
  final Color? color;

  const ThemedSvg({
    super.key,
    required this.assetKey,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final darkTheme = Theme.of(context).brightness == Brightness.dark;
    final config = getAssetConfig(assetKey, darkTheme);
    final assetPath = config.path ?? assetKey;
    final fullPath = assetPath.startsWith('images/')
        ? assetPath
        : 'images/$assetPath';
    final effectiveWidth = width != null
        ? width! * config.widthMultiplier
        : null;

    // Handle custom color override (takes precedence over all other coloring)
    if (color != null) {
      return SvgPicture.asset(
        fullPath,
        width: effectiveWidth,
        height: height,
        colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
      );
    }

    // Handle usesCurrentColor - use SvgTheme so only parts with
    // fill="currentColor" or stroke="currentColor" change color
    if (config.usesCurrentColor) {
      return SvgPicture(
        SvgAssetLoader(
          fullPath,
          theme: SvgTheme(
            currentColor: darkTheme ? Colors.white : Colors.black,
          ),
        ),
        width: effectiveWidth,
        height: height,
      );
    }

    // Handle usesForegroundColor (deprecated) - tint entire SVG white in dark mode
    if (config.usesForegroundColor && darkTheme) {
      return SvgPicture.asset(
        fullPath,
        width: effectiveWidth,
        height: height,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      );
    }

    // No color modification needed
    return SvgPicture.asset(fullPath, width: effectiveWidth, height: height);
  }
}

/// A variant of [ThemedSvg] that includes a +1 overlay badge.
///
/// Used for enhancement icons like ATTACK+1, MOVE+1, etc.
class ThemedSvgWithPlusOne extends StatelessWidget {
  final String assetKey;
  final double? width;
  final double? height;

  const ThemedSvgWithPlusOne({
    super.key,
    required this.assetKey,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final size = width ?? height ?? 24.0;

    return Stack(
      alignment: const Alignment(1.75, -1.75),
      children: [
        ThemedSvg(assetKey: assetKey, width: size, height: height),
        SvgPicture.asset(
          'images/plus_one.svg',
          width: size * 0.5,
          height: size * 0.5,
        ),
      ],
    );
  }
}
