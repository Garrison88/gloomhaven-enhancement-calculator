import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/models/calculation_step.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement.dart';
import 'package:gloomhaven_enhancement_calc/utils/themed_svg.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

/// A draggable bottom sheet that displays the enhancement cost.
/// Collapsed: Shows cost prominently with drag handle.
/// Expanded: Reveals full calculation breakdown.
class CostBottomSheet extends StatefulWidget {
  final int totalCost;
  final List<CalculationStep> steps;
  final Enhancement? enhancement;
  final bool temporaryMode;
  final bool hailsDiscount;
  final VoidCallback? onScrimTap;

  const CostBottomSheet({
    super.key,
    required this.totalCost,
    required this.steps,
    this.enhancement,
    this.temporaryMode = false,
    this.hailsDiscount = false,
    this.onScrimTap,
  });

  @override
  State<CostBottomSheet> createState() => CostBottomSheetState();
}

class CostBottomSheetState extends State<CostBottomSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  bool _isExpanded = false;

  // Sheet size configuration
  static const double _collapsedSize = 0.12;
  static const double _expandedSize = 0.55;
  static const double _fullSize = 1.0;
  static const double _expansionThreshold = 0.2;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSheetPositionChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSheetPositionChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSheetPositionChanged() {
    final isNowExpanded = _controller.size > _expansionThreshold;
    if (isNowExpanded != _isExpanded) {
      setState(() {
        _isExpanded = isNowExpanded;
      });
      // Update model to hide/show FAB
      context.read<EnhancementCalculatorModel>().isSheetExpanded =
          isNowExpanded;
    }
  }

  void _toggleExpanded() {
    final targetSize = _isExpanded ? _collapsedSize : _expandedSize;
    _controller.animateTo(
      targetSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Collapses the sheet. Can be called externally via GlobalKey.
  void collapse() {
    _controller.animateTo(
      _collapsedSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Semi-transparent scrim (animated based on sheet position)
        IgnorePointer(
          ignoring: !_isExpanded,
          child: GestureDetector(
            onTap: collapse,
            child: AnimatedOpacity(
              opacity: _isExpanded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(color: Colors.black54),
            ),
          ),
        ),
        // The draggable sheet
        DraggableScrollableSheet(
          controller: _controller,
          initialChildSize: _collapsedSize,
          minChildSize: _collapsedSize,
          maxChildSize: _fullSize,
          snap: true,
          snapSizes: const [_collapsedSize, _expandedSize, _fullSize],
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              // Match bottom navigation bar color
              color:
                  theme.bottomNavigationBarTheme.backgroundColor ??
                  theme.colorScheme.surface,
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
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(theme)),
                if (_isExpanded)
                  SliverToBoxAdapter(child: _buildBreakdown(theme)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return GestureDetector(
      onTap: _toggleExpanded,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 6),
          // Cost display with optional icon and symbols
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.enhancement?.assetKey != null) ...[
                ThemedSvg(
                  assetKey: widget.enhancement!.assetKey!,
                  width: 36,
                  height: 36,
                  showPlusOneOverlay: _isPlusOneEnhancement(
                    widget.enhancement!,
                  ),
                ),
                const SizedBox(width: smallPadding),
              ],
              Text('${widget.totalCost}g', style: theme.textTheme.displayLarge),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBreakdown(ThemeData theme) {
    if (widget.steps.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(smallPadding * 2),
        child: Text(
          'Select options to see cost breakdown',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    final nonTotalSteps = widget.steps.where((step) => !step.isTotal).toList();
    final totalSteps = widget.steps.where((step) => step.isTotal).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          // Non-total steps with separators
          for (int i = 0; i < nonTotalSteps.length; i++) ...[
            _buildStepRow(theme, nonTotalSteps[i]),
            if (i < nonTotalSteps.length - 1)
              Divider(
                height: 1,
                thickness: 0.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
              ),
          ],
          // Separator before total
          if (totalSteps.isNotEmpty)
            Divider(
              height: 16,
              thickness: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          // Total step
          ...totalSteps.map((step) => _buildStepRow(theme, step)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStepRow(ThemeData theme, CalculationStep step) {
    final colorScheme = theme.colorScheme;

    // Style for final total
    if (step.isTotal) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(
          step.description,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          '${step.value}g',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // Regular step row
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
}
