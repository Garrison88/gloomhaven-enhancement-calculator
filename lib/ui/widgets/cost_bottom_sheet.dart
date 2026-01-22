import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gloomhaven_enhancement_calc/data/constants.dart';
import 'package:gloomhaven_enhancement_calc/data/enhancement_data.dart';
import 'package:gloomhaven_enhancement_calc/models/calculation_step.dart';
import 'package:gloomhaven_enhancement_calc/models/enhancement.dart';
import 'package:gloomhaven_enhancement_calc/utils/themed_svg.dart';
import 'package:gloomhaven_enhancement_calc/viewmodels/enhancement_calculator_model.dart';

/// A draggable bottom sheet with a fixed cost overlay.
///
/// The sheet slides up normally with a drag handle, but the total cost display
/// stays fixed at the bottom so the breakdown appears to slide up behind it.
/// This creates a "reveal from behind" effect.
///
/// Key features:
/// - Drag handle moves with sheet (natural affordance)
/// - Total cost overlay stays fixed at bottom
/// - Shadow on overlay indicates content behind (hides when scrolled to end)
/// - Bottom padding ensures last item can scroll above the overlay
class CostBottomSheet extends StatefulWidget {
  final int totalCost;
  final List<CalculationStep> steps;
  final Enhancement? enhancement;

  const CostBottomSheet({
    super.key,
    required this.totalCost,
    required this.steps,
    this.enhancement,
  });

  @override
  State<CostBottomSheet> createState() => CostBottomSheetState();
}

class CostBottomSheetState extends State<CostBottomSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();
  ScrollController? _scrollController;
  bool _isExpanded = false;
  bool _isScrolledToEnd = false;

  // Height of the fixed cost overlay
  static const double _costOverlayHeight = 56.0;

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
    _scrollController?.removeListener(_onScrollChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onScrollChanged() {
    if (_scrollController == null || !_scrollController!.hasClients) return;

    final maxExtent = _scrollController!.position.maxScrollExtent;

    // Only mark as scrolled to end if we have valid metrics and are at the end
    final isAtEnd = maxExtent > 1 &&
        _scrollController!.offset >= maxExtent - 1;

    if (isAtEnd != _isScrolledToEnd) {
      setState(() {
        _isScrolledToEnd = isAtEnd;
      });
    }
  }

  void _onSheetPositionChanged() {
    final isNowExpanded = _controller.size > _expansionThreshold;
    if (isNowExpanded != _isExpanded) {
      setState(() {
        _isExpanded = isNowExpanded;
        // Reset scroll state when collapsing so shadow shows on next expand
        if (!isNowExpanded) {
          _isScrolledToEnd = false;
        }
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
    final sheetColor =
        theme.bottomNavigationBarTheme.backgroundColor ??
        theme.colorScheme.surface;

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
        // The draggable sheet (moves normally)
        DraggableScrollableSheet(
          controller: _controller,
          initialChildSize: _collapsedSize,
          minChildSize: _collapsedSize,
          maxChildSize: _fullSize,
          snap: true,
          snapSizes: const [_collapsedSize, _expandedSize, _fullSize],
          builder: (context, scrollController) {
            // Track the scroll controller to detect when content is scrolled
            if (_scrollController != scrollController) {
              _scrollController?.removeListener(_onScrollChanged);
              _scrollController = scrollController;
              _scrollController!.addListener(_onScrollChanged);
              // Check initial state after frame
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _onScrollChanged();
              });
            }
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
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                // Drag handle area (tappable to toggle)
                SliverToBoxAdapter(
                  child: GestureDetector(
                    onTap: _toggleExpanded,
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        // Drag handle
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                // Breakdown content (slides up behind the cost overlay)
                if (_isExpanded)
                  SliverToBoxAdapter(child: _buildBreakdown(theme)),
              ],
            ),
          );
          },
        ),
        // Fixed cost overlay - stays at bottom, in front of the sheet
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              height: _costOverlayHeight + 16, // extra for visual padding
              decoration: BoxDecoration(
                color: sheetColor,
                boxShadow: _isExpanded && !_isScrolledToEnd
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, -4),
                        ),
                      ]
                    : null,
              ),
              padding: const EdgeInsets.only(top: 8),
              child: Row(
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
                  Text(
                    '${widget.totalCost}g',
                    style: theme.textTheme.displayLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Steps with separators
          for (int i = 0; i < widget.steps.length; i++) ...[
            _buildStepRow(theme, widget.steps[i]),
            if (i < widget.steps.length - 1)
              Divider(
                height: 1,
                thickness: 0.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
              ),
          ],
          // Extra padding so last item can scroll above the fixed cost overlay
          SizedBox(height: _costOverlayHeight + 24),
        ],
      ),
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
}
