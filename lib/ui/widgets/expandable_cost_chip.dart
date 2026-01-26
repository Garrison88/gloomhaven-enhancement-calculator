import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/models/calculation_step.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement.dart';
import 'package:gloomhaven_enhancement_calc/utils/themed_svg.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

/// A floating chip that displays the total enhancement cost and can expand
/// into a full breakdown card.
///
/// Collapsed: Pill-shaped chip with icon, cost, and expand indicator
/// Expanded: Card with header, divider, and scrollable breakdown list
class ExpandableCostChip extends StatefulWidget {
  final int totalCost;
  final List<CalculationStep> steps;
  final Enhancement? enhancement;

  const ExpandableCostChip({
    super.key,
    required this.totalCost,
    required this.steps,
    this.enhancement,
  });

  @override
  State<ExpandableCostChip> createState() => _ExpandableCostChipState();
}

class _ExpandableCostChipState extends State<ExpandableCostChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  // Chip dimensions
  static const double _chipHeight = 48.0;
  static const double _chipWidth = 160.0;
  static const double _chipBorderRadius = 24.0;

  // Card dimensions
  static const double _cardTopRadius = 28.0;
  static const double _cardBottomRadius = 24.0;
  static const double _cardMaxWidth = 468.0;
  static const double _cardExpandedFraction = 0.85;

  // Positioning - 20dp aligns chip center with FAB center (FAB is 56dp at 16dp offset)
  static const double _bottomOffset = 20.0;
  static const double _horizontalPadding = 16.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    // Update model for FAB visibility
    context.read<EnhancementCalculatorModel>().isSheetExpanded = _isExpanded;
  }

  void _collapse() {
    if (_isExpanded) {
      _toggleExpanded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.of(context).size;

    // Calculate card dimensions
    final cardWidth = (screenSize.width - _horizontalPadding * 2).clamp(
      0.0,
      _cardMaxWidth,
    );
    final availableHeight =
        screenSize.height -
        kToolbarHeight -
        kBottomNavigationBarHeight -
        _bottomOffset;
    final cardHeight = availableHeight * _cardExpandedFraction;

    return SizedBox.expand(
      child: Stack(
        children: [
          // Scrim overlay
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              if (_expandAnimation.value == 0) {
                return const SizedBox.shrink();
              }
              return GestureDetector(
                onTap: _collapse,
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.5 * _expandAnimation.value,
                  ),
                ),
              );
            },
          ),

          // Expandable chip/card
          Positioned(
            left: 0,
            right: 0,
            bottom: _bottomOffset,
            child: Center(
              child: AnimatedBuilder(
                animation: _expandAnimation,
                builder: (context, child) {
                  // Interpolate dimensions
                  final width = _lerpDouble(
                    _chipWidth,
                    cardWidth,
                    _expandAnimation.value,
                  );
                  final height = _lerpDouble(
                    _chipHeight,
                    cardHeight,
                    _expandAnimation.value,
                  );

                  // Interpolate border radius
                  final borderRadius = BorderRadius.vertical(
                    top: Radius.circular(
                      _lerpDouble(
                        _chipBorderRadius,
                        _cardTopRadius,
                        _expandAnimation.value,
                      ),
                    ),
                    bottom: Radius.circular(
                      _lerpDouble(
                        _chipBorderRadius,
                        _cardBottomRadius,
                        _expandAnimation.value,
                      ),
                    ),
                  );

                  // Interpolate elevation
                  final elevation = _lerpDouble(
                    3.0,
                    6.0,
                    _expandAnimation.value,
                  );

                  final chipColor =
                      theme.bottomNavigationBarTheme.backgroundColor ??
                      colorScheme.surface;

                  return Material(
                    elevation: elevation,
                    borderRadius: borderRadius,
                    color: chipColor,
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: _isExpanded || _expandAnimation.value > 0.5
                          ? GestureDetector(
                              onTap: _collapse,
                              behavior: HitTestBehavior.opaque,
                              child: _buildExpandedContent(theme),
                            )
                          : _buildCollapsedContent(theme),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedContent(ThemeData theme) {
    return InkWell(
      onTap: _toggleExpanded,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Centered icon + cost
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.enhancement?.assetKey != null) ...[
                  ThemedSvg(
                    assetKey: widget.enhancement!.assetKey!,
                    width: 22,
                    height: 22,
                    showPlusOneOverlay: _isPlusOneEnhancement(widget.enhancement!),
                  ),
                  const SizedBox(width: smallPadding),
                ],
                Text(
                  '${widget.totalCost}g',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            // Arrow on the right
            Positioned(
              right: 8,
              child: Icon(
                Icons.keyboard_arrow_up,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Header with close button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Centered icon + cost
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.enhancement?.assetKey != null) ...[
                      ThemedSvg(
                        assetKey: widget.enhancement!.assetKey!,
                        width: 40,
                        height: 40,
                        showPlusOneOverlay: _isPlusOneEnhancement(
                          widget.enhancement!,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      '${widget.totalCost}g',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Close button on the right
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _collapse,
                    tooltip: 'Close',
                  ),
                ),
              ],
            ),
          ),
        ),

        Divider(height: 1, color: colorScheme.outlineVariant),

        // Breakdown content
        Expanded(
          child: widget.steps.isEmpty
              ? _buildEmptyState(theme)
              : _buildBreakdownList(theme),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(smallPadding * 2),
        child: Text(
          'Select options to see cost breakdown',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBreakdownList(ThemeData theme) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: widget.steps.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) =>
          _buildStepRow(theme, widget.steps[index]),
    );
  }

  Widget _buildStepRow(ThemeData theme, CalculationStep step) {
    final colorScheme = theme.colorScheme;
    final hasSubtitle = step.modifier != null || step.formula != null;

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(step.description, style: theme.textTheme.bodyMedium),
      subtitle: hasSubtitle
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (step.modifier != null)
                  Text(
                    step.modifier!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                if (step.formula != null)
                  Text(
                    step.formula!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            )
          : null,
      trailing: Text(
        '${step.value}g',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Returns true if the enhancement is a +1 type (character, summon, or target).
  bool _isPlusOneEnhancement(Enhancement enhancement) {
    return enhancement.category == EnhancementCategory.charPlusOne ||
        enhancement.category == EnhancementCategory.summonPlusOne ||
        enhancement.category == EnhancementCategory.target;
  }

  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
