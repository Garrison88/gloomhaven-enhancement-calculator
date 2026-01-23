import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/element_state.dart';
import 'package:gloomhaven_enhancement_calc/shared_prefs.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/element_icon.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/characters_model.dart';
import 'package:provider/provider.dart';

/// A draggable bottom sheet for tracking element states.
///
/// Displays 6 game elements (FIRE, ICE, AIR, EARTH, LIGHT, DARK) that can be
/// tapped to cycle through states: gone -> strong -> waning -> gone.
///
/// Icons smoothly animate size and spacing as the sheet is dragged.
class ElementTrackerSheet extends StatefulWidget {
  const ElementTrackerSheet({super.key});

  @override
  State<ElementTrackerSheet> createState() => _ElementTrackerSheetState();
}

class _ElementTrackerSheetState extends State<ElementTrackerSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  // Sheet size configuration
  static const double _collapsedSize = 0.065;
  static const double _expandedSize = 0.18;
  static const double _expansionThreshold = 0.10;

  // Icon sizes (note: ElementIcon adds 4px for ring padding)
  static const double _collapsedIconSize = 16.0;
  static const double _expandedIconSize = 36.0;

  // Padding values
  static const double _collapsedIconPadding = 3.0;
  static const double _expandedIconPadding = 8.0;
  static const double _collapsedVerticalPadding = 2.0;
  static const double _expandedVerticalPadding = 8.0;

  // Element asset keys in display order
  static const List<String> _elementKeys = [
    'FIRE',
    'ICE',
    'AIR',
    'EARTH',
    'LIGHT',
    'DARK',
  ];

  // Map element keys to SharedPrefs getters/setters
  late final Map<String, int Function()> _stateGetters;
  late final Map<String, void Function(int)> _stateSetters;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSheetPositionChanged);
    _initStateAccessors();
  }

  void _initStateAccessors() {
    final prefs = SharedPrefs();
    _stateGetters = {
      'FIRE': () => prefs.fireState,
      'ICE': () => prefs.iceState,
      'AIR': () => prefs.airState,
      'EARTH': () => prefs.earthState,
      'LIGHT': () => prefs.lightState,
      'DARK': () => prefs.darkState,
    };
    _stateSetters = {
      'FIRE': (v) => prefs.fireState = v,
      'ICE': (v) => prefs.iceState = v,
      'AIR': (v) => prefs.airState = v,
      'EARTH': (v) => prefs.earthState = v,
      'LIGHT': (v) => prefs.lightState = v,
      'DARK': (v) => prefs.darkState = v,
    };
  }

  @override
  void dispose() {
    _controller.removeListener(_onSheetPositionChanged);
    _controller.dispose();
    super.dispose();
  }

  /// Calculates expansion progress from 0.0 (collapsed) to 1.0 (expanded)
  double get _expansionProgress {
    if (!_controller.isAttached) return 0.0;
    final size = _controller.size;
    final progress =
        (size - _collapsedSize) / (_expandedSize - _collapsedSize);
    return progress.clamp(0.0, 1.0);
  }

  bool get _isExpanded => _controller.isAttached && _controller.size > _expansionThreshold;

  void _onSheetPositionChanged() {
    // Trigger rebuild to update interpolated values
    setState(() {});
    // Update model for FAB visibility
    context.read<CharactersModel>().isElementSheetExpanded = _isExpanded;
  }

  void _toggleExpanded() {
    final targetSize = _isExpanded ? _collapsedSize : _expandedSize;
    _controller.animateTo(
      targetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  ElementState _getElementState(String key) {
    final getter = _stateGetters[key];
    if (getter == null) return ElementState.gone;
    return ElementState.fromIndex(getter());
  }

  void _cycleElementState(String key) {
    final currentState = _getElementState(key);
    final nextState = currentState.nextState();
    final setter = _stateSetters[key];
    if (setter != null) {
      setter(nextState.index);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sheetColor =
        theme.bottomNavigationBarTheme.backgroundColor ??
        theme.colorScheme.surface;

    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: _collapsedSize,
      minChildSize: _collapsedSize,
      maxChildSize: _expandedSize,
      snap: true,
      snapSizes: const [_collapsedSize, _expandedSize],
      builder: (context, scrollController) {
        final progress = _expansionProgress;

        // Interpolate padding values
        final topPadding = lerpDouble(6, 8, progress)!;
        final handleBottomPadding = lerpDouble(4, 8, progress)!;
        final verticalPadding = lerpDouble(
          _collapsedVerticalPadding,
          _expandedVerticalPadding,
          progress,
        )!;
        final bottomPadding = lerpDouble(4, 8, progress)!;

        return Container(
          decoration: BoxDecoration(
            color: sheetColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle (tappable to toggle)
                GestureDetector(
                  onTap: _toggleExpanded,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      SizedBox(height: topPadding),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: handleBottomPadding),
                    ],
                  ),
                ),
                // Element icons row
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: verticalPadding,
                  ),
                  child: _buildElementRow(progress),
                ),
                SizedBox(height: bottomPadding),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildElementRow(double progress) {
    // Interpolate icon size and padding
    final iconSize = lerpDouble(
      _collapsedIconSize,
      _expandedIconSize,
      progress,
    )!;
    final iconPadding = lerpDouble(
      _collapsedIconPadding,
      _expandedIconPadding,
      progress,
    )!;

    // ElementIcon adds ring padding (2px each side = 4px total)
    const double ringPaddingTotal = 4.0;

    final icons = _elementKeys.map((key) {
      final state = _getElementState(key);
      final icon = ElementIcon(
        assetKey: key,
        state: state,
        size: iconSize,
      );

      // Only interactive when past threshold
      if (_isExpanded) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: iconPadding),
          child: GestureDetector(
            onTap: () => _cycleElementState(key),
            child: icon,
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: iconPadding),
        child: icon,
      );
    }).toList();

    // Use a custom layout that interpolates between centered and spread
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate total width of icons with their padding
        // Account for ElementIcon's ring padding in the actual widget size
        final actualIconWidth = iconSize + ringPaddingTotal;
        final totalIconsWidth =
            _elementKeys.length * (actualIconWidth + iconPadding * 2);

        // Calculate the extra space to distribute when expanded
        final availableWidth = constraints.maxWidth;
        final extraSpace = (availableWidth - totalIconsWidth).clamp(0.0, double.infinity);

        // Distribute extra space based on progress (0 = centered, 1 = spread)
        final distributedSpace = extraSpace * progress;
        final spaceBetween = _elementKeys.length > 1
            ? distributedSpace / (_elementKeys.length - 1)
            : 0.0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < icons.length; i++) ...[
              icons[i],
              if (i < icons.length - 1) SizedBox(width: spaceBetween),
            ],
          ],
        );
      },
    );
  }
}
