/// Represents a single step in the enhancement cost calculation breakdown.
///
/// Each step shows how the cost is built up from base cost through
/// multipliers, discounts, and penalties.
class CalculationStep {
  /// Description of what this step represents (e.g., "Card level 4")
  final String description;

  /// The value at this step (running total or the modifier value)
  final int value;

  /// Optional formula showing how this value was calculated (e.g., "x2", "+75g")
  final String? formula;

  /// Optional modifier description (e.g., "Party Boon: −5g/level")
  final String? modifier;

  const CalculationStep({
    required this.description,
    required this.value,
    this.formula,
    this.modifier,
  });
}
