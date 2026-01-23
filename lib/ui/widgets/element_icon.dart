import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gloomhaven_enhancement_calc/models/element_state.dart';
import 'package:gloomhaven_enhancement_calc/utils/asset_config.dart';

// ============================================================================
// ANIMATED ELEMENT ICON - IMPLEMENTATION DOCUMENTATION
// ============================================================================
//
// ## Overview
// This widget renders the 6 Gloomhaven elements (FIRE, ICE, AIR, EARTH, LIGHT,
// DARK) with animated glowing effects based on their state. Used in the element
// tracker bottom sheet on the Characters screen.
//
// ## Element States
// Each element cycles through 3 states when tapped: gone → strong → waning → gone
// - **gone**: Dimmed icon (30% opacity), no glow
// - **strong**: Full animated glow effect (element-specific colors/behavior)
// - **waning**: Bisected appearance - top half dim, bottom half glowing
//
// ## Animation Architecture
// - Each element has 2 AnimationControllers at different speeds for organic feel
// - Controllers are combined using `Listenable.merge` in AnimatedBuilder
// - Glow effects use layered boxShadow and RadialGradient for depth
// - Math combines sine waves at different frequencies for complex motion
//
// ## Crossfade Transitions
// All elements have smooth crossfade transitions between states:
// - `_fireIceFadeController` handles fade in/out (250ms)
// - Transitions trigger in `didUpdateWidget` when state changes
// - `_wrapWithFireIceFade` crossfades between static fallback and animated glow
// - `_buildFadeToGone` handles the special case of fading to gone state
// - All transitions use 250ms for consistency:
//   - gone → strong: 250ms fade in
//   - strong → waning: 250ms crossfade
//   - waning → gone: 250ms fade out (glow color fades out)
//   - Sheet expand/collapse: 250ms fade in/out
// - State tracking (`_isFadingToGone`, `_fadeFromState`) ensures glow fades out
//   properly when transitioning to gone state
//
// ## Current Status (as of implementation)
// ✅ FIRE - Complete with crossfade transitions
//    - Strong: Layered orange/amber glow, 3 controllers (base 2000ms, flare
//      1300ms, shimmer 800ms)
//    - Waning: Ember glow with single controller (1500ms)
//
// ✅ ICE - Complete with crossfade transitions
//    - Strong: Sharp, frenetic crystalline shimmer (cyan/lightBlue/white)
//    - Uses jagged math with multiple sine frequencies (4x, 7x, 11x) for sparkle
//    - Controllers: base 2200ms, shimmer 800ms
//    - Waning: Subtle frost flicker
//
// ✅ AIR - Complete with crossfade transitions
//    - Theme: Gentle breeze, soft and flowing (grey/blueGrey)
//    - Smooth undulation with theme-aware colors
//    - Controllers: flow 3000ms, wisp 1800ms
//
// ✅ EARTH - Complete with crossfade transitions
//    - Theme: Solid, grounded, deep rumble with tremors
//    - Crunchy tremor using multiple high-frequency sine waves (11x, 17x, 23x)
//    - Jagged shake effect with threshold-triggered cracks
//    - Controllers: base 2800ms, crack 1600ms
//
// ✅ LIGHT - Complete with crossfade transitions
//    - Theme: Bright, radiant, divine shimmer (yellow/amber/white)
//    - Sparkle effect using multiple sine frequencies (5x, 8x, 13x)
//    - Threshold-triggered bright flares for "divine spike" moments
//    - Controllers: base 2200ms, flare 1400ms
//
// ✅ DARK - Complete with crossfade transitions
//    - Theme: Spooky, eerie - like clouds passing across the moon
//    - Slow drifting undulation with periodic "cloud pass" dimming
//    - Controllers: pulse 2600ms, absorb 1700ms
//
// ## TODO / Next Steps
// All elements now have animations and crossfade transitions implemented!
// Future improvements:
// 1. Fine-tune animation timing/colors based on user feedback
// 2. Consider performance optimization if needed (e.g., pausing off-screen animations)
//
// ## Key Methods
// - `_buildElementStrongIcon` / `_buildElementWaningIcon`: Route to element-
//   specific builders
// - `_wrapWithFireIceFade`: Wraps animated widget with crossfade transition
// - `_build[Element]StrongIcon` / `_build[Element]WaningIcon`: Element-specific
//   animation builders
// - `didUpdateWidget`: Handles state change detection and triggers fades
//
// ## File Structure
// 1. Widget class definition and state
// 2. Animation controller initialization (initState)
// 3. State change handling (didUpdateWidget)
// 4. Build methods (static, animated, routing)
// 5. Fallback builders (_buildGoneIcon, _buildStrongIcon, _buildWaningIcon)
// 6. Element-specific builders grouped by element (FIRE, ICE, AIR, etc.)
// 7. SVG builder helper
//
// ============================================================================

/// A widget that renders an element icon with animated glow effects.
///
/// Supports three visual states:
/// - [ElementState.gone]: Low opacity (30%), no glow
/// - [ElementState.strong]: Full animated glow (element-specific)
/// - [ElementState.waning]: Subtle pulsing glow, 50% icon opacity
///
/// Set [animated] to true when the element tracker sheet is expanded to
/// enable glow animations. When false, shows static opacity-based states.
class AnimatedElementIcon extends StatefulWidget {
  /// The asset key for the element (e.g., 'EARTH', 'FIRE', 'ICE', 'LIGHT', 'DARK', 'AIR')
  final String assetKey;

  /// The current state of the element
  final ElementState state;

  /// The size of the icon (width and height)
  final double size;

  /// Whether to show animations (only when sheet is expanded)
  final bool animated;

  const AnimatedElementIcon({
    super.key,
    required this.assetKey,
    required this.state,
    required this.size,
    this.animated = false,
  });

  /// Ring/glow sizing relative to icon size
  static const double ringPadding = 2.0;

  @override
  State<AnimatedElementIcon> createState() => _AnimatedElementIconState();
}

class _AnimatedElementIconState extends State<AnimatedElementIcon>
    with TickerProviderStateMixin {
  // Fade controller for smooth animation transitions (all elements)
  late AnimationController _fireIceFadeController;

  // Track state for fade-out-to-gone transitions
  // When fading to gone, we need to remember what we're fading FROM
  ElementState? _fadeFromState;
  bool _isFadingToGone = false;

  // Multiple controllers for layered, organic fire animation
  late AnimationController _fireBaseController; // Slow base pulse
  late AnimationController _fireFlareController; // Occasional flares
  late AnimationController _fireShimmerController; // Subtle shimmer

  // Ice animation controllers - crystalline shimmer effect
  late AnimationController _iceBaseController; // Slow crystalline pulse
  late AnimationController _iceShimmerController; // Sparkle effect

  // Air animation controllers - flowing ethereal effect
  late AnimationController _airFlowController; // Slow flowing motion
  late AnimationController _airWispController; // Wispy secondary motion

  // Earth animation controllers - deep rumbling effect
  late AnimationController _earthBaseController; // Slow geological pulse
  late AnimationController _earthCrackController; // Occasional crack flare

  // Light animation controllers - radiant glow effect
  late AnimationController _lightBaseController; // Steady radiance
  late AnimationController _lightFlareController; // Occasional bright flares

  // Dark animation controllers - void/shadow effect
  late AnimationController _darkPulseController; // Slow void pulse
  late AnimationController _darkAbsorbController; // Absorbing effect

  /// Opacity values for each state
  static const double _goneOpacity = 0.3;
  static const double _ringStrokeWidth = 1.5;

  @override
  void initState() {
    super.initState();
    // Fade controller for fire & ice animation transitions
    _fireIceFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    // Listen for animation completion to reset fade-to-gone state
    _fireIceFadeController.addStatusListener(_onFadeStatusChanged);
    // Start faded in if already animated and in an active state
    if (widget.animated && widget.state != ElementState.gone) {
      _fireIceFadeController.value = 1.0;
    }

    // === FIRE Controllers ===
    // Slow base glow pulse (like breathing)
    _fireBaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Medium flare cycle
    _fireFlareController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);

    // Faster subtle shimmer
    _fireShimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // === ICE Controllers ===
    // Base pulse - slower
    _iceBaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // Sharp shimmer/sparkle effect - moderate speed
    _iceShimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // === AIR Controllers ===
    // Very slow flowing motion (wind-like)
    _airFlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    // Secondary wispy motion
    _airWispController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // === EARTH Controllers ===
    // Slow geological pulse (heavy, grounded)
    _earthBaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    // Occasional crack flare
    _earthCrackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    // === LIGHT Controllers ===
    // Steady radiant glow
    _lightBaseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // Occasional bright flares
    _lightFlareController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // === DARK Controllers ===
    // Slow void pulse
    _darkPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    // Absorbing effect
    _darkAbsorbController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);
  }

  /// Resets fade-to-gone state when animation completes
  void _onFadeStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && _isFadingToGone) {
      setState(() {
        _isFadingToGone = false;
        _fadeFromState = null;
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedElementIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle fade in/out for all elements
    if (_isFireElement || _isIceElement || _isAirElement || _isEarthElement || _isLightElement || _isDarkElement) {
      final wasAnimated = oldWidget.animated;
      final isAnimated = widget.animated;
      final oldState = oldWidget.state;
      final newState = widget.state;

      // Sheet expand/collapse transitions
      if (!wasAnimated && isAnimated && newState != ElementState.gone) {
        // Sheet expanded with active element - fade in
        _fireIceFadeController.forward();
      } else if (wasAnimated && !isAnimated) {
        // Sheet collapsed - fade out
        _fireIceFadeController.reverse();
      }
      // State change transitions (while animated)
      else if (isAnimated && oldState != newState) {
        if (oldState == ElementState.gone) {
          // gone → strong: fade in
          _fireIceFadeController.forward(from: 0.0);
        } else if (newState == ElementState.gone) {
          // waning/strong → gone: fade out the glow/color
          // Remember what we're fading from so we can show it during transition
          setState(() {
            _fadeFromState = oldState;
            _isFadingToGone = true;
          });
          _fireIceFadeController.reverse(from: 1.0);
        } else {
          // strong → waning: crossfade (reset and fade in new animation)
          _fireIceFadeController.forward(from: 0.0);
        }
      }
    }
  }

  @override
  void dispose() {
    // Fade controller
    _fireIceFadeController.removeStatusListener(_onFadeStatusChanged);
    _fireIceFadeController.dispose();
    // Fire controllers
    _fireBaseController.dispose();
    _fireFlareController.dispose();
    _fireShimmerController.dispose();
    // Ice controllers
    _iceBaseController.dispose();
    _iceShimmerController.dispose();
    // Air controllers
    _airFlowController.dispose();
    _airWispController.dispose();
    // Earth controllers
    _earthBaseController.dispose();
    _earthCrackController.dispose();
    // Light controllers
    _lightBaseController.dispose();
    _lightFlareController.dispose();
    // Dark controllers
    _darkPulseController.dispose();
    _darkAbsorbController.dispose();
    super.dispose();
  }

  // Element type checkers
  bool get _isFireElement => widget.assetKey == 'FIRE';
  bool get _isIceElement => widget.assetKey == 'ICE';
  bool get _isAirElement => widget.assetKey == 'AIR';
  bool get _isEarthElement => widget.assetKey == 'EARTH';
  bool get _isLightElement => widget.assetKey == 'LIGHT';
  bool get _isDarkElement => widget.assetKey == 'DARK';

  @override
  Widget build(BuildContext context) {
    final darkTheme = Theme.of(context).brightness == Brightness.dark;
    final config = getAssetConfig(widget.assetKey);
    final fullPath = 'images/${config.pathForTheme(darkTheme)}';

    // Total size includes padding for ring/glow
    final totalSize = widget.size + (AnimatedElementIcon.ringPadding * 2);

    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: widget.animated
          ? _buildAnimatedIcon(fullPath, darkTheme, config)
          : _buildStaticIcon(fullPath, darkTheme, config),
    );
  }

  /// Static icon display (when collapsed) - minimalist state representation
  /// - Gone: dim (30% opacity)
  /// - Strong: full bright (100% opacity)
  /// - Waning: bisected horizontally - top dim, bottom bright (sharp line)
  Widget _buildStaticIcon(String fullPath, bool darkTheme, AssetConfig config) {
    switch (widget.state) {
      case ElementState.gone:
        return Center(
          child: Opacity(
            opacity: _goneOpacity,
            child: _buildSvg(fullPath, darkTheme, config),
          ),
        );

      case ElementState.strong:
        return Center(
          child: _buildSvg(fullPath, darkTheme, config),
        );

      case ElementState.waning:
        // Bisected: top half dim, bottom half bright with sharp horizontal line
        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base layer: full icon at dim opacity
              Opacity(
                opacity: _goneOpacity,
                child: _buildSvg(fullPath, darkTheme, config),
              ),
              // Top layer: bright icon masked to bottom half only (sharp cut)
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                    ],
                    // Sharp cut at 50% - no gradient blur
                    stops: [0.0, 0.5, 0.5, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Opacity(
                  opacity: 0.85, // Slightly less bright than strong
                  child: _buildSvg(fullPath, darkTheme, config),
                ),
              ),
            ],
          ),
        );
    }
  }

  /// Animated icon display (when expanded)
  Widget _buildAnimatedIcon(String fullPath, bool darkTheme, AssetConfig config) {
    final ringColor = darkTheme
        ? Colors.white.withValues(alpha: 0.6)
        : Colors.black.withValues(alpha: 0.4);
    final glowColor = darkTheme
        ? Colors.white.withValues(alpha: 0.25)
        : Colors.black.withValues(alpha: 0.15);

    // Handle fade-to-gone transition for all elements
    if (_isFadingToGone && (_isFireElement || _isIceElement || _isAirElement || _isEarthElement || _isLightElement || _isDarkElement)) {
      return _buildFadeToGone(fullPath, darkTheme, config, glowColor, ringColor);
    }

    return switch (widget.state) {
      ElementState.gone => _buildGoneIcon(fullPath, darkTheme, config),
      ElementState.strong => _buildElementStrongIcon(fullPath, darkTheme, config, glowColor),
      ElementState.waning => _buildElementWaningIcon(fullPath, darkTheme, config, ringColor),
    };
  }

  /// Builds crossfade from animated state to gone state
  Widget _buildFadeToGone(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
    Color glowColor,
    Color ringColor,
  ) {
    // Build the animation we're fading FROM (without the wrapper, raw animation)
    final Widget fadingOutWidget;
    if (_fadeFromState == ElementState.strong) {
      if (_isFireElement) {
        fadingOutWidget = _buildFireStrongIcon(fullPath, darkTheme, config);
      } else if (_isIceElement) {
        fadingOutWidget = _buildIceStrongIcon(fullPath, darkTheme, config);
      } else if (_isAirElement) {
        fadingOutWidget = _buildAirStrongIcon(fullPath, darkTheme, config);
      } else if (_isEarthElement) {
        fadingOutWidget = _buildEarthStrongIcon(fullPath, darkTheme, config);
      } else if (_isLightElement) {
        fadingOutWidget = _buildLightStrongIcon(fullPath, darkTheme, config);
      } else {
        // Dark
        fadingOutWidget = _buildDarkStrongIcon(fullPath, darkTheme, config);
      }
    } else {
      // Waning
      if (_isFireElement) {
        fadingOutWidget = _buildFireWaningIcon(fullPath, darkTheme, config);
      } else if (_isIceElement) {
        fadingOutWidget = _buildIceWaningIcon(fullPath, darkTheme, config);
      } else if (_isAirElement) {
        fadingOutWidget = _buildAirWaningIcon(fullPath, darkTheme, config);
      } else if (_isEarthElement) {
        fadingOutWidget = _buildEarthWaningIcon(fullPath, darkTheme, config);
      } else if (_isLightElement) {
        fadingOutWidget = _buildLightWaningIcon(fullPath, darkTheme, config);
      } else {
        // Dark
        fadingOutWidget = _buildDarkWaningIcon(fullPath, darkTheme, config);
      }
    }

    // The gone state we're fading TO
    final goneWidget = _buildGoneIcon(fullPath, darkTheme, config);

    return AnimatedBuilder(
      animation: _fireIceFadeController,
      builder: (context, child) {
        final fadeValue = _fireIceFadeController.value;
        // fadeValue goes 1.0 → 0.0 during reverse
        // So animated fades out (opacity = fadeValue)
        // Gone fades in (opacity = 1 - fadeValue)
        return Stack(
          alignment: Alignment.center,
          children: [
            // Gone state fades in
            Opacity(opacity: 1.0 - fadeValue, child: goneWidget),
            // Animated glow fades out
            Opacity(opacity: fadeValue, child: fadingOutWidget),
          ],
        );
      },
    );
  }

  /// Routes to element-specific strong animation or fallback
  Widget _buildElementStrongIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
    Color glowColor,
  ) {
    if (_isFireElement) {
      return _wrapWithFireIceFade(
        _buildFireStrongIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, glowColor,
      );
    }
    if (_isIceElement) {
      return _wrapWithFireIceFade(
        _buildIceStrongIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, glowColor,
      );
    }
    if (_isAirElement) {
      return _wrapWithFireIceFade(
        _buildAirStrongIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, glowColor,
      );
    }
    if (_isEarthElement) {
      return _wrapWithFireIceFade(
        _buildEarthStrongIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, glowColor,
      );
    }
    if (_isLightElement) {
      return _wrapWithFireIceFade(
        _buildLightStrongIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, glowColor,
      );
    }
    if (_isDarkElement) {
      return _wrapWithFireIceFade(
        _buildDarkStrongIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, glowColor,
      );
    }
    return _buildStrongIcon(fullPath, darkTheme, config, glowColor);
  }

  /// Routes to element-specific waning animation or fallback
  Widget _buildElementWaningIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
    Color ringColor,
  ) {
    if (_isFireElement) {
      return _wrapWithFireIceFade(
        _buildFireWaningIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, null, ringColor,
      );
    }
    if (_isIceElement) {
      return _wrapWithFireIceFade(
        _buildIceWaningIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, null, ringColor,
      );
    }
    if (_isAirElement) {
      return _wrapWithFireIceFade(
        _buildAirWaningIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, null, ringColor,
      );
    }
    if (_isEarthElement) {
      return _wrapWithFireIceFade(
        _buildEarthWaningIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, null, ringColor,
      );
    }
    if (_isLightElement) {
      return _wrapWithFireIceFade(
        _buildLightWaningIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, null, ringColor,
      );
    }
    if (_isDarkElement) {
      return _wrapWithFireIceFade(
        _buildDarkWaningIcon(fullPath, darkTheme, config),
        fullPath, darkTheme, config, null, ringColor,
      );
    }
    return _buildWaningIcon(fullPath, darkTheme, config, ringColor);
  }

  /// Wraps fire/ice animated icons with fade transition, showing fallback during fade
  Widget _wrapWithFireIceFade(
    Widget animatedChild,
    String fullPath,
    bool darkTheme,
    AssetConfig config, [
    Color? glowColor,
    Color? ringColor,
  ]) {
    return AnimatedBuilder(
      animation: _fireIceFadeController,
      builder: (context, child) {
        final fadeValue = _fireIceFadeController.value;

        // During fade, show both the fallback (fading out) and animated (fading in)
        if (fadeValue < 1.0) {
          // Determine which fallback to show based on whether it's strong or waning
          final fallback = glowColor != null
              ? _buildStrongIcon(fullPath, darkTheme, config, glowColor)
              : _buildWaningIcon(fullPath, darkTheme, config, ringColor!);

          return Stack(
            alignment: Alignment.center,
            children: [
              // Fallback fades out
              Opacity(opacity: 1.0 - fadeValue, child: fallback),
              // Animated fades in
              Opacity(opacity: fadeValue, child: animatedChild),
            ],
          );
        }

        // Fully faded in - just show animated
        return animatedChild;
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
          width: widget.size + AnimatedElementIcon.ringPadding,
          height: widget.size + AnimatedElementIcon.ringPadding,
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
          width: widget.size + AnimatedElementIcon.ringPadding,
          height: widget.size + AnimatedElementIcon.ringPadding,
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

  /// Animated flickering fire glow for strong state - layered organic animation
  Widget _buildFireStrongIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    // Combine multiple animations using Listenable.merge
    return AnimatedBuilder(
      animation: Listenable.merge([
        _fireBaseController,
        _fireFlareController,
        _fireShimmerController,
      ]),
      builder: (context, child) {
        // Slow breathing base pulse (eased for smoothness)
        final baseCurve = Curves.easeInOut.transform(_fireBaseController.value);
        final basePulse = math.sin(baseCurve * math.pi);

        // Medium flare with slight offset
        final flareCurve = Curves.easeInOut.transform(_fireFlareController.value);
        final flare = math.sin(flareCurve * math.pi) * 0.6;

        // Subtle fast shimmer for life
        final shimmer = math.sin(_fireShimmerController.value * math.pi) * 0.15;

        // Combine layers with different weights
        final combined = (basePulse * 0.5) + (flare * 0.35) + shimmer;

        // Glow intensity varies smoothly
        final glowIntensity = 0.6 + (combined * 0.4);
        final outerGlowIntensity = 0.4 + (combined * 0.3);

        // Size pulses gently
        final sizeVariation = combined * 4;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer soft glow (orange/red)
            Container(
              width: baseSize + 16 + sizeVariation,
              height: baseSize + 16 + sizeVariation,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepOrange.withValues(alpha: outerGlowIntensity * 0.7),
                    blurRadius: 20 + (combined * 6),
                    spreadRadius: 2 + (combined * 2),
                  ),
                ],
              ),
            ),
            // Middle warm glow
            Container(
              width: baseSize + 8 + (sizeVariation * 0.6),
              height: baseSize + 8 + (sizeVariation * 0.6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: glowIntensity * 0.8),
                    blurRadius: 12 + (combined * 4),
                    spreadRadius: 4 + (combined * 2),
                  ),
                ],
              ),
            ),
            // Inner bright core gradient
            Container(
              width: baseSize + (sizeVariation * 0.3),
              height: baseSize + (sizeVariation * 0.3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.amber.withValues(alpha: glowIntensity),
                    Colors.orange.withValues(alpha: glowIntensity * 0.7),
                    Colors.deepOrange.withValues(alpha: glowIntensity * 0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
            // Icon
            child!,
          ],
        );
      },
      child: _buildSvg(fullPath, darkTheme, config),
    );
  }

  /// Animated ember glow for waning fire state - top half dim, bottom half glowing
  Widget _buildFireWaningIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    final totalSize = widget.size + (AnimatedElementIcon.ringPadding * 2);

    return AnimatedBuilder(
      animation: Listenable.merge([_fireBaseController, _fireFlareController]),
      builder: (context, child) {
        // Use fire's layered animation for the ember glow
        final baseCurve = Curves.easeInOut.transform(_fireBaseController.value);
        final basePulse = math.sin(baseCurve * math.pi);
        final flareCurve = Curves.easeInOut.transform(_fireFlareController.value);
        final flare = math.sin(flareCurve * math.pi) * 0.4;
        final combined = (basePulse * 0.6) + (flare * 0.4);

        final glowIntensity = 0.5 + (combined * 0.35);
        final sizeVariation = combined * 2;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        return SizedBox(
          width: totalSize,
          height: totalSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base layer: full icon at "gone" opacity (dim)
              Opacity(
                opacity: _goneOpacity,
                child: _buildSvg(fullPath, darkTheme, config),
              ),
              // Bottom half glow + icon with soft gradient mask
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                    ],
                    stops: [0.40, 0.55, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SizedBox(
                  width: totalSize,
                  height: totalSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ember glow using gradient
                      Container(
                        width: baseSize + 12 + sizeVariation,
                        height: baseSize + 12 + sizeVariation,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.amber.withValues(alpha: glowIntensity * 0.7),
                              Colors.orange.withValues(alpha: glowIntensity * 0.5),
                              Colors.deepOrange.withValues(alpha: glowIntensity * 0.3),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.35, 0.6, 1.0],
                          ),
                        ),
                      ),
                      // Icon at full opacity
                      _buildSvg(fullPath, darkTheme, config),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // ICE ELEMENT ANIMATIONS
  // Theme: Cold, crystalline, shimmering frost
  // ============================================================

  /// Animated crystalline ice glow for strong state - sharp and frenetic
  Widget _buildIceStrongIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _iceBaseController,
        _iceShimmerController,
      ]),
      builder: (context, child) {
        // Sharp base pulse using elasticOut for jagged feel
        final baseCurve = Curves.easeOut.transform(_iceBaseController.value);
        final basePulse = math.sin(baseCurve * math.pi * 1.5);

        // Fast, sharp shimmer - high frequency sparkle
        final shimmerRaw = _iceShimmerController.value;
        // Create jagged sawtooth-like pattern
        final shimmer = (math.sin(shimmerRaw * math.pi * 4) * 0.5 +
                math.sin(shimmerRaw * math.pi * 7) * 0.3)
            .abs();

        // Additional high-frequency flicker
        final flicker = math.sin(shimmerRaw * math.pi * 11) * 0.2;

        // Combine for sharp crystalline feel
        final combined = (basePulse * 0.4) + (shimmer * 0.4) + flicker;

        // Glow intensity with more abrupt changes
        final glowIntensity = 0.55 + (combined * 0.45);
        final outerGlowIntensity = 0.4 + (shimmer * 0.35);

        // Size varies more dramatically
        final sizeVariation = combined * 5;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer sharp cold glow
            Container(
              width: baseSize + 14 + sizeVariation,
              height: baseSize + 14 + sizeVariation,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: outerGlowIntensity * 0.7),
                    blurRadius: 16 + (shimmer * 8),
                    spreadRadius: 2 + (shimmer * 3),
                  ),
                ],
              ),
            ),
            // Middle icy glow - sharper edges
            Container(
              width: baseSize + 6 + (sizeVariation * 0.6),
              height: baseSize + 6 + (sizeVariation * 0.6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlue.shade200.withValues(alpha: glowIntensity * 0.8),
                    blurRadius: 8 + (combined * 5),
                    spreadRadius: 2 + (combined * 2),
                  ),
                ],
              ),
            ),
            // Inner bright crystalline core - tighter gradient
            Container(
              width: baseSize + (sizeVariation * 0.3),
              height: baseSize + (sizeVariation * 0.3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: glowIntensity),
                    Colors.lightBlue.shade100.withValues(alpha: glowIntensity * 0.7),
                    Colors.cyan.shade300.withValues(alpha: glowIntensity * 0.35),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.25, 0.5, 1.0],
                ),
              ),
            ),
            // Icon
            child!,
          ],
        );
      },
      child: _buildSvg(fullPath, darkTheme, config),
    );
  }

  /// Animated frost glow for waning ice state - top half dim, bottom half glowing
  Widget _buildIceWaningIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    final totalSize = widget.size + (AnimatedElementIcon.ringPadding * 2);

    return AnimatedBuilder(
      animation: Listenable.merge([_iceBaseController, _iceShimmerController]),
      builder: (context, child) {
        // Sharp crystalline animation
        final baseCurve = Curves.easeOut.transform(_iceBaseController.value);
        final basePulse = math.sin(baseCurve * math.pi * 1.5);
        final shimmerRaw = _iceShimmerController.value;
        final shimmer = (math.sin(shimmerRaw * math.pi * 4) * 0.5 +
                math.sin(shimmerRaw * math.pi * 7) * 0.3)
            .abs();
        final flicker = math.sin(shimmerRaw * math.pi * 11) * 0.2;
        final combined = (basePulse * 0.4) + (shimmer * 0.4) + flicker;

        final glowIntensity = 0.5 + (combined * 0.4);
        final sizeVariation = combined * 3;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        return SizedBox(
          width: totalSize,
          height: totalSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base layer: full icon at "gone" opacity (dim)
              Opacity(
                opacity: _goneOpacity,
                child: _buildSvg(fullPath, darkTheme, config),
              ),
              // Bottom half glow + icon with soft gradient mask
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                    ],
                    stops: [0.40, 0.55, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SizedBox(
                  width: totalSize,
                  height: totalSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ice glow using gradient
                      Container(
                        width: baseSize + 14 + sizeVariation,
                        height: baseSize + 14 + sizeVariation,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withValues(alpha: glowIntensity * 0.8),
                              Colors.lightBlue.shade100.withValues(alpha: glowIntensity * 0.5),
                              Colors.cyan.shade300.withValues(alpha: glowIntensity * 0.3),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.3, 0.55, 1.0],
                          ),
                        ),
                      ),
                      // Icon at full opacity
                      _buildSvg(fullPath, darkTheme, config),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // AIR ELEMENT ANIMATIONS
  // Theme: Gentle breeze, soft and flowing
  // ============================================================

  /// Animated gentle breeze glow for strong state
  Widget _buildAirStrongIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    // Theme-aware colors: light colors for dark mode, blue-grey for light mode
    final outerColor = darkTheme ? Colors.white : Colors.blueGrey.shade400;
    final middleColor = darkTheme ? Colors.blueGrey.shade100 : Colors.blueGrey.shade300;
    final innerColor = darkTheme ? Colors.white : Colors.blueGrey.shade200;
    final innerFadeColor = darkTheme ? Colors.grey.shade100 : Colors.blueGrey.shade100;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _airFlowController,
        _airWispController,
      ]),
      builder: (context, child) {
        // Primary breeze flow - smooth undulation like gentle wind
        final flow = math.cos(_airFlowController.value * math.pi * 2) * 0.5 + 0.5;

        // Secondary gentle gust - offset timing for natural feel
        final gust = math.sin(_airWispController.value * math.pi * 2) * 0.3;

        // Combine for soft breeze effect
        final breeze = (flow * 0.7) + (gust * 0.3);

        // Soft opacity - slightly higher in light mode for visibility
        final glowIntensity = darkTheme ? (0.25 + (breeze * 0.2)) : (0.35 + (breeze * 0.25));
        final outerGlowIntensity = darkTheme ? (0.15 + (breeze * 0.15)) : (0.25 + (breeze * 0.2));

        // Minimal size variation - breeze is about opacity, not size
        final sizeVariation = breeze * 1.5;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer very diffuse breeze glow - high blur for soft edges
            Container(
              width: baseSize + 18 + sizeVariation,
              height: baseSize + 18 + sizeVariation,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: outerColor.withValues(alpha: outerGlowIntensity * 0.4),
                    blurRadius: 28 + (breeze * 6),
                    spreadRadius: 2 + (breeze * 2),
                  ),
                ],
              ),
            ),
            // Middle soft breeze layer
            Container(
              width: baseSize + 10 + (sizeVariation * 0.5),
              height: baseSize + 10 + (sizeVariation * 0.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: middleColor.withValues(alpha: glowIntensity * 0.5),
                    blurRadius: 16 + (breeze * 4),
                    spreadRadius: 3 + (breeze * 1.5),
                  ),
                ],
              ),
            ),
            // Inner soft core - very light, airy
            Container(
              width: baseSize + (sizeVariation * 0.2),
              height: baseSize + (sizeVariation * 0.2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    innerColor.withValues(alpha: glowIntensity * 0.6),
                    innerFadeColor.withValues(alpha: glowIntensity * 0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Icon
            child!,
          ],
        );
      },
      child: _buildSvg(fullPath, darkTheme, config),
    );
  }

  /// Animated waning air state - top half dim (gone), bottom half glowing
  Widget _buildAirWaningIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    // Theme-aware colors for the glow
    final outerColor = darkTheme ? Colors.white : Colors.blueGrey.shade400;
    final middleColor = darkTheme ? Colors.blueGrey.shade100 : Colors.blueGrey.shade300;
    final innerColor = darkTheme ? Colors.white : Colors.blueGrey.shade200;
    final innerFadeColor = darkTheme ? Colors.grey.shade100 : Colors.blueGrey.shade100;

    final totalSize = widget.size + (AnimatedElementIcon.ringPadding * 2);

    return AnimatedBuilder(
      animation: Listenable.merge([_airFlowController, _airWispController]),
      builder: (context, child) {
        // Same breeze animation as strong state
        final flow = math.cos(_airFlowController.value * math.pi * 2) * 0.5 + 0.5;
        final gust = math.sin(_airWispController.value * math.pi * 2) * 0.3;
        final breeze = (flow * 0.7) + (gust * 0.3);

        final glowIntensity = darkTheme ? (0.25 + (breeze * 0.2)) : (0.35 + (breeze * 0.25));
        final outerGlowIntensity = darkTheme ? (0.15 + (breeze * 0.15)) : (0.25 + (breeze * 0.2));
        final sizeVariation = breeze * 1.5;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        return SizedBox(
          width: totalSize,
          height: totalSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base layer: full icon at "gone" opacity (dim)
              Opacity(
                opacity: _goneOpacity,
                child: _buildSvg(fullPath, darkTheme, config),
              ),
              // Bottom half glow + icon with soft gradient mask
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                    ],
                    // Soft transition from 40% to 55%
                    stops: [0.40, 0.55, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SizedBox(
                  width: totalSize,
                  height: totalSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow using gradient (not boxShadow to avoid clipping issues)
                      Container(
                        width: baseSize + 18 + sizeVariation,
                        height: baseSize + 18 + sizeVariation,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              innerColor.withValues(alpha: glowIntensity * 0.6),
                              innerFadeColor.withValues(alpha: glowIntensity * 0.4),
                              middleColor.withValues(alpha: glowIntensity * 0.3),
                              outerColor.withValues(alpha: outerGlowIntensity * 0.2),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.25, 0.45, 0.7, 1.0],
                          ),
                        ),
                      ),
                      // Icon at full opacity
                      _buildSvg(fullPath, darkTheme, config),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // EARTH ELEMENT ANIMATIONS
  // Theme: Solid, grounded, deep rumble with tremors
  // ============================================================

  /// Animated tremor glow for strong earth state - crunchy, jagged
  Widget _buildEarthStrongIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _earthBaseController,
        _earthCrackController,
      ]),
      builder: (context, child) {
        // Deep base pulse
        final baseCurve = Curves.easeInOut.transform(_earthBaseController.value);
        final basePulse = math.sin(baseCurve * math.pi);

        // Crunchy tremor - multiple high frequencies for gritty feel
        final tremorRaw = _earthCrackController.value;
        final crunch1 = (math.sin(tremorRaw * math.pi * 11) * 0.5).abs();
        final crunch2 = (math.sin(tremorRaw * math.pi * 17) * 0.3).abs();
        final crunch3 = (math.sin(tremorRaw * math.pi * 23) * 0.2).abs();

        // Sharp crack moments - sudden spikes
        final crackRaw = math.sin(tremorRaw * math.pi * 3);
        final crack = crackRaw > 0.7 ? (crackRaw - 0.7) * 3.3 : 0.0;

        // Combine for crunchy rumbling
        final crunch = crunch1 + crunch2 + crunch3;
        final combined = (basePulse * 0.4) + (crunch * 0.35) + (crack * 0.25);

        // Glow intensity with crunchy variation
        final glowIntensity = 0.5 + (combined * 0.45);
        final outerGlowIntensity = 0.35 + (combined * 0.35);

        // Jagged shake - irregular, not smooth
        final shakeX = (crunch1 - crunch2) * 2.0 + (crack * 1.5);
        final shakeY = (crunch2 - crunch3) * 1.8 - (crack * 0.8);

        final sizeVariation = combined * 4;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        return Transform.translate(
          offset: Offset(shakeX, shakeY),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer deep earth glow
              Container(
                width: baseSize + 14 + sizeVariation,
                height: baseSize + 14 + sizeVariation,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.shade800.withValues(alpha: outerGlowIntensity * 0.6),
                      blurRadius: 18 + (combined * 6),
                      spreadRadius: 2 + (combined * 2),
                    ),
                  ],
                ),
              ),
              // Middle magma glow
              Container(
                width: baseSize + 8 + (sizeVariation * 0.6),
                height: baseSize + 8 + (sizeVariation * 0.6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade900.withValues(alpha: glowIntensity * 0.7),
                      blurRadius: 12 + (combined * 5),
                      spreadRadius: 3 + (combined * 2),
                    ),
                  ],
                ),
              ),
              // Inner core gradient
              Container(
                width: baseSize + (sizeVariation * 0.3),
                height: baseSize + (sizeVariation * 0.3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.amber.shade700.withValues(alpha: glowIntensity * 0.85),
                      Colors.orange.shade800.withValues(alpha: glowIntensity * 0.55),
                      Colors.brown.shade700.withValues(alpha: glowIntensity * 0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.35, 0.65, 1.0],
                  ),
                ),
              ),
              // Icon
              child!,
            ],
          ),
        );
      },
      child: _buildSvg(fullPath, darkTheme, config),
    );
  }

  /// Animated earthen glow for waning state - top half dim, bottom half with fading tremor
  Widget _buildEarthWaningIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    final totalSize = widget.size + (AnimatedElementIcon.ringPadding * 2);

    return AnimatedBuilder(
      animation: Listenable.merge([_earthBaseController, _earthCrackController]),
      builder: (context, child) {
        // Slower base for waning - earth settling
        final baseCurve = Curves.easeInOut.transform(_earthBaseController.value);
        final basePulse = math.sin(baseCurve * math.pi);

        // Subtle crunch - still gritty but fading
        final tremorRaw = _earthCrackController.value;
        final crunch1 = (math.sin(tremorRaw * math.pi * 11) * 0.3).abs();
        final crunch2 = (math.sin(tremorRaw * math.pi * 17) * 0.2).abs();

        final crunch = crunch1 + crunch2;
        final combined = (basePulse * 0.5) + (crunch * 0.5);
        final glowIntensity = 0.5 + (combined * 0.35);

        // Subtle jagged shake - settling crumble
        final shakeX = (crunch1 - crunch2) * 0.8;
        final shakeY = (crunch2 - crunch1) * 0.6;

        final sizeVariation = combined * 2;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        return Transform.translate(
          offset: Offset(shakeX, shakeY),
          child: SizedBox(
            width: totalSize,
            height: totalSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Base layer: full icon at "gone" opacity (dim)
                Opacity(
                  opacity: _goneOpacity,
                  child: _buildSvg(fullPath, darkTheme, config),
                ),
                // Bottom half glow + icon with soft gradient mask
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white,
                        Colors.white,
                      ],
                      stops: [0.40, 0.55, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: SizedBox(
                    width: totalSize,
                    height: totalSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Earthy glow using gradient
                        Container(
                          width: baseSize + 12 + sizeVariation,
                          height: baseSize + 12 + sizeVariation,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.amber.shade700.withValues(alpha: glowIntensity * 0.7),
                                Colors.orange.shade800.withValues(alpha: glowIntensity * 0.45),
                                Colors.brown.shade700.withValues(alpha: glowIntensity * 0.25),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.35, 0.6, 1.0],
                            ),
                          ),
                        ),
                        // Icon at full opacity
                        _buildSvg(fullPath, darkTheme, config),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // LIGHT ELEMENT ANIMATIONS
  // Theme: Bright, shimmering, twinkling divine light
  // ============================================================

  /// Animated shimmering light glow for strong state - intense sparkle and twinkle
  Widget _buildLightStrongIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _lightBaseController,
        _lightFlareController,
      ]),
      builder: (context, child) {
        // Gentle base radiance (slow breathing)
        final baseCurve = Curves.easeInOut.transform(_lightBaseController.value);
        final basePulse = math.sin(baseCurve * math.pi) * 0.3;

        // Fast shimmer frequencies - sharp sparkle like light on water
        final shimmerRaw = _lightFlareController.value;
        // Use .abs() for sharp peaks (like ICE's crystalline effect)
        final sparkle1 = (math.sin(shimmerRaw * math.pi * 6) * 0.4).abs();
        final sparkle2 = (math.sin(shimmerRaw * math.pi * 10) * 0.3).abs();
        final sparkle3 = (math.sin(shimmerRaw * math.pi * 15) * 0.2).abs();

        // Extra high-frequency twinkle for that "glittering" feel
        final twinkle = (math.sin(shimmerRaw * math.pi * 23) * 0.15).abs();

        // Combine sparkles
        final shimmer = sparkle1 + sparkle2 + sparkle3 + twinkle;

        // Occasional bright divine flare
        final flareRaw = math.sin(_lightBaseController.value * math.pi * 2);
        final flare = flareRaw > 0.85 ? (flareRaw - 0.85) * 6.0 : 0.0;

        // Combined effect - shimmer dominates
        final combined = basePulse + (shimmer * 0.6) + (flare * 0.1);

        // High intensity - light is brightest
        final glowIntensity = 0.65 + (combined * 0.35);
        final outerGlowIntensity = 0.5 + (shimmer * 0.4);
        final coreIntensity = 0.75 + (shimmer * 0.25); // Core sparkles most

        // Size varies with shimmer
        final sizeVariation = combined * 6;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer warm golden radiance - pulses gently
            Container(
              width: baseSize + 18 + sizeVariation,
              height: baseSize + 18 + sizeVariation,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.shade300.withValues(alpha: outerGlowIntensity * 0.6),
                    blurRadius: 24 + (shimmer * 10),
                    spreadRadius: 3 + (shimmer * 3),
                  ),
                ],
              ),
            ),
            // Middle bright yellow - shimmers actively
            Container(
              width: baseSize + 10 + (sizeVariation * 0.6),
              height: baseSize + 10 + (sizeVariation * 0.6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.shade200.withValues(alpha: glowIntensity * 0.85),
                    blurRadius: 14 + (shimmer * 6),
                    spreadRadius: 4 + (shimmer * 3),
                  ),
                ],
              ),
            ),
            // Inner white-hot core - sparkles intensely
            Container(
              width: baseSize + (sizeVariation * 0.3),
              height: baseSize + (sizeVariation * 0.3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: coreIntensity),
                    Colors.yellow.shade50.withValues(alpha: coreIntensity * 0.8),
                    Colors.yellow.shade100.withValues(alpha: glowIntensity * 0.45),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.2, 0.5, 1.0],
                ),
              ),
            ),
            // Icon
            child!,
          ],
        );
      },
      child: _buildSvg(fullPath, darkTheme, config),
    );
  }

  /// Animated waning light state - top half dim, bottom half glowing with fading shimmer
  Widget _buildLightWaningIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    final totalSize = widget.size + (AnimatedElementIcon.ringPadding * 2);

    return AnimatedBuilder(
      animation: Listenable.merge([_lightBaseController, _lightFlareController]),
      builder: (context, child) {
        // Gentler but still shimmery for waning state
        final baseCurve = Curves.easeInOut.transform(_lightBaseController.value);
        final basePulse = math.sin(baseCurve * math.pi) * 0.3;

        // Fading sparkle - still shimmery but less intense
        final shimmerRaw = _lightFlareController.value;
        final sparkle1 = (math.sin(shimmerRaw * math.pi * 6) * 0.3).abs();
        final sparkle2 = (math.sin(shimmerRaw * math.pi * 10) * 0.2).abs();
        final sparkle3 = (math.sin(shimmerRaw * math.pi * 15) * 0.15).abs();
        final shimmer = sparkle1 + sparkle2 + sparkle3;

        final combined = basePulse + (shimmer * 0.7);
        final glowIntensity = 0.5 + (combined * 0.4);
        final sizeVariation = combined * 2.5;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        return SizedBox(
          width: totalSize,
          height: totalSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base layer: full icon at "gone" opacity (dim)
              Opacity(
                opacity: _goneOpacity,
                child: _buildSvg(fullPath, darkTheme, config),
              ),
              // Bottom half glow + icon with soft gradient mask
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                    ],
                    stops: [0.40, 0.55, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SizedBox(
                  width: totalSize,
                  height: totalSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Light glow using gradient
                      Container(
                        width: baseSize + 14 + sizeVariation,
                        height: baseSize + 14 + sizeVariation,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withValues(alpha: glowIntensity * 0.85),
                              Colors.yellow.shade50.withValues(alpha: glowIntensity * 0.6),
                              Colors.yellow.shade200.withValues(alpha: glowIntensity * 0.35),
                              Colors.amber.shade300.withValues(alpha: glowIntensity * 0.2),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.25, 0.45, 0.7, 1.0],
                          ),
                        ),
                      ),
                      // Icon at full opacity
                      _buildSvg(fullPath, darkTheme, config),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // DARK ELEMENT ANIMATIONS
  // Theme: Spooky, eerie - clouds drifting horizontally across the moon
  // ============================================================

  /// Animated eerie dark glow for strong state - horizontal shadow drift
  Widget _buildDarkStrongIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _darkPulseController,
        _darkAbsorbController,
      ]),
      builder: (context, child) {
        // Slow horizontal drift - clouds moving left to right
        // Use cosine for smooth back-and-forth sweep
        final driftX = math.cos(_darkPulseController.value * math.pi * 2) * 0.4;

        // Secondary cloud layer at different speed/phase
        final drift2X = math.cos(_darkAbsorbController.value * math.pi * 2 + 1.5) * 0.3;

        // Combined horizontal position (-0.7 to 0.7 range)
        final cloudPosition = driftX + drift2X;

        // Base pulse for overall intensity variation
        final basePulse = math.sin(_darkPulseController.value * math.pi) * 0.3;

        // Eerie flicker
        final flicker = math.sin(_darkAbsorbController.value * math.pi * 7) * 0.06;

        final combined = basePulse + flicker;
        final glowIntensity = 0.55 + (combined * 0.3);
        final outerGlowIntensity = 0.45 + (combined * 0.25);

        final sizeVariation = combined * 3;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        // Horizontal offset for cloud shadows (scaled to icon size)
        final cloudOffset = cloudPosition * (baseSize * 0.4);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer dark purple aura
            Container(
              width: baseSize + 16 + sizeVariation,
              height: baseSize + 16 + sizeVariation,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.shade900.withValues(alpha: outerGlowIntensity * 0.75),
                    blurRadius: 20 + (combined * 6),
                    spreadRadius: 2 + (combined * 2),
                  ),
                ],
              ),
            ),
            // Middle purple glow
            Container(
              width: baseSize + 8 + (sizeVariation * 0.6),
              height: baseSize + 8 + (sizeVariation * 0.6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.shade700.withValues(alpha: glowIntensity * 0.8),
                    blurRadius: 14 + (combined * 5),
                    spreadRadius: 3 + (combined * 2),
                  ),
                ],
              ),
            ),
            // Inner core with horizontally-drifting gradient (the "moon")
            Container(
              width: baseSize + (sizeVariation * 0.3),
              height: baseSize + (sizeVariation * 0.3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  // Offset center creates horizontal drift effect
                  center: Alignment(cloudPosition * 0.3, 0),
                  colors: [
                    Colors.purple.shade200.withValues(alpha: glowIntensity * 0.75),
                    Colors.purple.shade400.withValues(alpha: glowIntensity * 0.55),
                    Colors.deepPurple.shade700.withValues(alpha: glowIntensity * 0.35),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
            // Drifting shadow cloud - darker area that sweeps across
            Transform.translate(
              offset: Offset(cloudOffset, 0),
              child: Container(
                width: baseSize * 0.8,
                height: baseSize * 1.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.deepPurple.shade900.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),
            // Icon
            child!,
          ],
        );
      },
      child: _buildSvg(fullPath, darkTheme, config),
    );
  }

  /// Animated waning dark state - top half dim, bottom half with horizontal cloud drift
  Widget _buildDarkWaningIcon(
    String fullPath,
    bool darkTheme,
    AssetConfig config,
  ) {
    final totalSize = widget.size + (AnimatedElementIcon.ringPadding * 2);

    return AnimatedBuilder(
      animation: Listenable.merge([_darkPulseController, _darkAbsorbController]),
      builder: (context, child) {
        // Horizontal drift - gentler for waning
        final driftX = math.cos(_darkPulseController.value * math.pi * 2) * 0.3;
        final drift2X = math.cos(_darkAbsorbController.value * math.pi * 2 + 1.5) * 0.2;
        final cloudPosition = driftX + drift2X;

        // Base pulse
        final basePulse = math.sin(_darkPulseController.value * math.pi) * 0.25;
        final glowIntensity = 0.5 + (basePulse * 0.35);
        final sizeVariation = basePulse * 2;
        final baseSize = widget.size + AnimatedElementIcon.ringPadding;

        return SizedBox(
          width: totalSize,
          height: totalSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base layer: full icon at "gone" opacity (dim)
              Opacity(
                opacity: _goneOpacity,
                child: _buildSvg(fullPath, darkTheme, config),
              ),
              // Bottom half glow + icon with soft gradient mask
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                    ],
                    stops: [0.40, 0.55, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: SizedBox(
                  width: totalSize,
                  height: totalSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Dark glow with horizontally-drifting center
                      Container(
                        width: baseSize + 14 + sizeVariation,
                        height: baseSize + 14 + sizeVariation,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: Alignment(cloudPosition * 0.25, 0),
                            colors: [
                              Colors.purple.shade200.withValues(alpha: glowIntensity * 0.65),
                              Colors.purple.shade400.withValues(alpha: glowIntensity * 0.5),
                              Colors.deepPurple.shade600.withValues(alpha: glowIntensity * 0.35),
                              Colors.deepPurple.shade900.withValues(alpha: glowIntensity * 0.2),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.25, 0.45, 0.7, 1.0],
                          ),
                        ),
                      ),
                      // Icon at full opacity
                      _buildSvg(fullPath, darkTheme, config),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
        width: widget.size,
        height: widget.size,
      );
    }
    return SvgPicture.asset(fullPath, width: widget.size, height: widget.size);
  }
}
