/// Specifies a type of layout to depend on.
enum AdaptiveLayoutType {
  /// Phone in portrait
  compact,

  /// Tablet in portrait, Foldable in portrait (unfolded)
  medium,

  /// Phone in landscape, Tablet in landscape, Foldable in landscape (unfolded), Desktop
  expanded,

  /// Desktop
  large,

  /// Desktop, Ultra-wide
  extraLarge;

  bool get isLarge => this >= AdaptiveLayoutType.large;

  bool operator >(AdaptiveLayoutType other) => index > other.index;

  bool operator <(AdaptiveLayoutType other) => index < other.index;

  bool operator <=(AdaptiveLayoutType other) => index <= other.index;

  bool operator >=(AdaptiveLayoutType other) => index >= other.index;
}
