import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/models/element_state.dart';
import 'package:gloomhaven_enhancement_calc/utils/asset_config.dart';

/// A widget that renders an element icon in one of three visual states:
/// - [ElementState.gone]: Low opacity (30%), no ring
/// - [ElementState.strong]: Full opacity, filled glow/ring behind
/// - [ElementState.waning]: Full opacity, thin ring outline
class ElementIcon extends StatelessWidget {
  /// The asset key for the element (e.g., 'EARTH', 'FIRE', 'ICE', 'LIGHT', 'DARK', 'AIR')
  final String assetKey;

  /// The current state of the element
  final ElementState state;

  /// The size of the icon (width and height)
  final double size;

  const ElementIcon({
    super.key,
    required this.assetKey,
    required this.state,
    required this.size,
  });

  /// Opacity values for each state
  static const double _goneOpacity = 0.3;

  /// Ring/glow sizing relative to icon size
  static const double ringPadding = 2.0;
  static const double _ringStrokeWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    final darkTheme = Theme.of(context).brightness == Brightness.dark;
    final config = getAssetConfig(assetKey);
    final fullPath = 'images/${config.pathForTheme(darkTheme)}';
    final ringColor = darkTheme
        ? Colors.white.withValues(alpha: 0.6)
        : Colors.black.withValues(alpha: 0.4);
    final glowColor = darkTheme
        ? Colors.white.withValues(alpha: 0.25)
        : Colors.black.withValues(alpha: 0.15);

    // Total size includes padding for ring/glow
    final totalSize = size + (ringPadding * 2);

    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: switch (state) {
        ElementState.gone => _buildGoneIcon(fullPath, darkTheme, config),
        ElementState.strong => _buildStrongIcon(
            fullPath,
            darkTheme,
            config,
            glowColor,
          ),
        ElementState.waning => _buildWaningIcon(
            fullPath,
            darkTheme,
            config,
            ringColor,
          ),
      },
    );
  }

  /// Renders the icon with low opacity, no ring (inactive state)
  Widget _buildGoneIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    return Center(
      child: Opacity(
        opacity: _goneOpacity,
        child: _buildSvg(fullPath, darkTheme, config),
      ),
    );
  }

  /// Renders the icon with full opacity and a filled glow behind (fully active)
  Widget _buildStrongIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
    Color glowColor,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Filled glow/background circle
        Container(
          width: size + ringPadding,
          height: size + ringPadding,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: glowColor,
          ),
        ),
        // Icon at full opacity
        _buildSvg(fullPath, darkTheme, config),
      ],
    );
  }

  /// Renders the icon with full opacity and a thin ring outline (waning state)
  Widget _buildWaningIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
    Color ringColor,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Thin ring outline
        Container(
          width: size + ringPadding,
          height: size + ringPadding,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ringColor,
              width: _ringStrokeWidth,
            ),
          ),
        ),
        // Icon at full opacity
        _buildSvg(fullPath, darkTheme, config),
      ],
    );
  }

  /// Builds the SVG widget with proper theming
  Widget _buildSvg(String fullPath, bool darkTheme, AssetConfig config) {
    if (config.usesCurrentColor) {
      return SvgPicture(
        SvgAssetLoader(
          fullPath,
          theme: SvgTheme(
            currentColor: darkTheme ? Colors.white : Colors.black,
          ),
        ),
        width: size,
        height: size,
      );
    }
    return SvgPicture.asset(fullPath, width: size, height: size);
  }
}
