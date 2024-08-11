/// Provides breakpoints for your adaptive designs
abstract interface class AdaptiveLayoutBreakpoints {
  /// Phone in portrait
  /// width < 600
  static const double compat = 600;

  /// Tablet in portrait, Foldable in portrait (unfolded)
  /// 600 ≤ width < 840
  static const double medium = 840;

  /// Phone in landscape, Tablet in landscape, Foldable in landscape (unfolded), Desktop
  /// 840 ≤ width < 1200*
  static const double expanded = 1200;

  /// Desktop
  /// 1200 ≤ width < 1600
  static const double large = 1600;

  /// Desktop, Ultra-wide
  /// 1600 ≤ width
  static const double extraLarge = 1600;
}
