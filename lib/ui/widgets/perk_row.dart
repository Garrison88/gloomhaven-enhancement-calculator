import 'package:flutter/material.dart';
import 'package:gloomhaven_enhancement_calc/models/character.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/check_row_divider.dart';
import 'package:gloomhaven_enhancement_calc/ui/widgets/conditional_checkbox.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';
import '../../models/perk/perk.dart';
import '../../utils/utils.dart';
import '../../viewmodels/characters_model.dart';

class PerkRow extends StatefulWidget {
  final Character character;
  final List<Perk> perks;

  const PerkRow({super.key, required this.character, required this.perks});

  @override
  PerkRowState createState() => PerkRowState();
}

class PerkRowState extends State<PerkRow> with SingleTickerProviderStateMixin {
  final List<String?> perkIds = [];
  double height = 0;

  // Animation state for grouped perk border
  AnimationController? _borderController;
  Animation<double>? _borderAnimation;
  bool _wasAllSelected = false;
  bool _isDrawing = true;

  @override
  void initState() {
    super.initState();
    // Only initialize animation if this is a grouped perk
    if (widget.perks[0].grouped) {
      _borderController = AnimationController(
        duration: const Duration(milliseconds: 250),
        vsync: this,
      );
      _borderAnimation = CurvedAnimation(
        parent: _borderController!,
        curve: Curves.easeOut,
      );
      // Initialize perkIds for allPerksSelected check
      for (final Perk perk in widget.perks) {
        perkIds.add(perk.perkId);
      }
      _wasAllSelected = allPerksSelected(widget.character);
      if (_wasAllSelected) {
        _borderController!.value = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _borderController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CharactersModel charactersModel = context.watch<CharactersModel>();

    // Build perkIds if not already done (for non-grouped perks)
    if (perkIds.isEmpty) {
      for (final Perk perk in widget.perks) {
        perkIds.add(perk.perkId);
      }
    }

    // Check for state change and trigger animation (grouped perks only)
    if (widget.perks[0].grouped && _borderController != null) {
      final isNowAllSelected = allPerksSelected(widget.character);
      if (isNowAllSelected != _wasAllSelected) {
        _wasAllSelected = isNowAllSelected;
        if (isNowAllSelected) {
          _isDrawing = true;
          _borderController!.forward(from: 0.0);
        } else {
          _isDrawing = false;
          _borderController!.forward(from: 0.0);
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: mediumPadding / 2),
      child: Row(
        children: <Widget>[
          widget.perks[0].grouped
              ? _buildGroupedCheckboxes(context, charactersModel)
              : Row(
                  children: List.generate(
                    widget.perks.length,
                    (index) => ConditionalCheckbox(
                      value: widget.character.characterPerks
                          .firstWhere(
                            (element) =>
                                element.associatedPerkId ==
                                widget.perks[index].perkId,
                          )
                          .characterPerkIsSelected,
                      isEditMode: charactersModel.isEditMode,
                      isRetired: widget.character.isRetired,
                      onChanged: (bool value) => charactersModel.togglePerk(
                        characterPerks: widget.character.characterPerks,
                        perk: widget.character.characterPerks.firstWhere(
                          (element) =>
                              element.associatedPerkId ==
                              widget.perks[index].perkId,
                        ),
                        value: value,
                      ),
                    ),
                  ),
                ),
          widget.perks[0].grouped
              ? const SizedBox(width: mediumPadding)
              : CheckRowDivider(
                  height: height,
                  color: Theme.of(context).dividerTheme.color,
                ),
          SizeProviderWidget(
            onChildSize: (Size? size) {
              if (size != null && context.mounted) {
                setState(() {
                  height = size.height * 0.9;
                });
              }
            },
            child: Expanded(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(letterSpacing: 0.7),
                  children: Utils.generateCheckRowDetails(
                    context,
                    widget.perks.first.perkDetails,
                    Theme.of(context).brightness == Brightness.dark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedCheckboxes(
    BuildContext context,
    CharactersModel charactersModel,
  ) {
    final borderColor = Theme.of(context).colorScheme.primary;
    final subtleBorderColor = Theme.of(context).dividerTheme.color!;

    final checkboxColumn = Column(
      children: List.generate(widget.perks.length, (index) {
        return Checkbox(
          visualDensity: VisualDensity.compact,
          value: widget.character.characterPerks
              .firstWhere(
                (element) =>
                    element.associatedPerkId == widget.perks[index].perkId,
              )
              .characterPerkIsSelected,
          onChanged: charactersModel.isEditMode && !widget.character.isRetired
              ? (bool? value) {
                  if (value != null) {
                    charactersModel.togglePerk(
                      characterPerks: widget.character.characterPerks,
                      perk: widget.character.characterPerks.firstWhere(
                        (element) =>
                            element.associatedPerkId ==
                            widget.perks[index].perkId,
                      ),
                      value: value,
                    );
                  }
                }
              : null,
        );
      }),
    );

    return Container(
      margin: const EdgeInsets.only(right: 6, left: 1),
      child: AnimatedBuilder(
        animation: _borderAnimation!,
        builder: (context, child) {
          return CustomPaint(
            painter: _AnimatedBorderPainter(
              progress: _borderAnimation!.value,
              color: borderColor,
              subtleBorderColor: subtleBorderColor,
              borderRadius: 4.0,
              isDrawing: _isDrawing,
            ),
            child: child,
          );
        },
        child: checkboxColumn,
      ),
    );
  }

  bool allPerksSelected(Character character) {
    return character.characterPerks
        .where((element) => perkIds.contains(element.associatedPerkId))
        .every((element) => element.characterPerkIsSelected);
  }
}

/// Custom painter that draws an animated border around a rounded rectangle.
/// Always draws a subtle border for grouping, then animates a colored border
/// on top when complete. The border draws progressively starting from the
/// middle of the left edge (aligned with the checkbox) and going clockwise.
/// When erasing, the border disappears in the same direction (tail chases head).
class _AnimatedBorderPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color subtleBorderColor;
  final double borderRadius;
  final bool isDrawing;

  _AnimatedBorderPainter({
    required this.progress,
    required this.color,
    required this.subtleBorderColor,
    required this.borderRadius,
    required this.isDrawing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final r = borderRadius;
    final w = size.width;
    final h = size.height;
    final midY = h / 2;

    // Build the rounded rectangle path
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(r),
    );

    // Always draw the subtle border first
    final subtlePaint = Paint()
      ..color = subtleBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(rrect, subtlePaint);

    // Draw animated colored border on top
    if ((progress <= 0 && isDrawing) || (progress >= 1 && !isDrawing)) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Build path starting from middle of left edge, going clockwise
    final path = Path()
      // Start at middle of left edge
      ..moveTo(0, midY)
      // Go up to top-left corner
      ..lineTo(0, r)
      // Top-left corner arc
      ..arcToPoint(Offset(r, 0), radius: Radius.circular(r))
      // Top edge
      ..lineTo(w - r, 0)
      // Top-right corner arc
      ..arcToPoint(Offset(w, r), radius: Radius.circular(r))
      // Right edge
      ..lineTo(w, h - r)
      // Bottom-right corner arc
      ..arcToPoint(Offset(w - r, h), radius: Radius.circular(r))
      // Bottom edge
      ..lineTo(r, h)
      // Bottom-left corner arc
      ..arcToPoint(Offset(0, h - r), radius: Radius.circular(r))
      // Back up to middle of left edge
      ..lineTo(0, midY);

    // Get path metrics to extract partial path
    final pathMetrics = path.computeMetrics().first;
    final totalLength = pathMetrics.length;

    // Extract the appropriate portion of the path
    final Path partialPath;
    if (isDrawing) {
      // Drawing: start at 0, end grows with progress
      final drawLength = totalLength * progress;
      partialPath = pathMetrics.extractPath(0, drawLength);
    } else {
      // Erasing: start grows with progress, end stays at totalLength
      final startLength = totalLength * progress;
      partialPath = pathMetrics.extractPath(startLength, totalLength);
    }

    canvas.drawPath(partialPath, paint);
  }

  @override
  bool shouldRepaint(_AnimatedBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.subtleBorderColor != subtleBorderColor ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.isDrawing != isDrawing;
  }
}
