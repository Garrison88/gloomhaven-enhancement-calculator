/// Represents the three possible states of a game element.
///
/// Elements cycle through states when tapped:
/// - [gone] - Element is not active (greyscale icon)
/// - [strong] - Element is fully active (full color icon)
/// - [waning] - Element is waning (half-colored vertical split)
enum ElementState {
  gone,
  strong,
  waning;

  /// Returns the next state in the cycle: gone -> strong -> waning -> gone
  ElementState nextState() {
    return switch (this) {
      ElementState.gone => ElementState.strong,
      ElementState.strong => ElementState.waning,
      ElementState.waning => ElementState.gone,
    };
  }

  /// Creates an ElementState from its integer index value.
  /// Returns [gone] for invalid indices.
  static ElementState fromIndex(int index) {
    if (index >= 0 && index < ElementState.values.length) {
      return ElementState.values[index];
    }
    return ElementState.gone;
  }
}
