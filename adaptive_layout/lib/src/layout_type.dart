/// Defines a set of adaptive layout types based on screen width breakpoints,
/// commonly used to design responsive UIs that adapt to various device form factors.
///
/// This enum categorizes screen widths into predefined types (compact, medium,
/// expanded, large, extraLarge) to guide UI layout decisions, such as showing
/// different navigation patterns (e.g., bottom navigation bar vs. navigation rail)
/// or adjusting content density.
///
/// The categorization generally follows Material Design's adaptive layout guidelines.
///
/// Example Usage:
/// ```dart
/// // In a widget that needs to adapt its layout
/// class ResponsiveLayout extends StatelessWidget {
///   final AdaptiveLayoutType layoutType;
///
///   const ResponsiveLayout({super.key, required this.layoutType});
///
///   @override
///   Widget build(BuildContext context) {
///     if (layoutType.isLarge) {
///       // Desktop or ultra-wide layout
///       return Row(
///         children: [
///           const NavigationRail(),
///           Expanded(child: _buildContent()),
///         ],
///       );
///     } else if (layoutType == AdaptiveLayoutType.expanded) {
///       // Tablet landscape, phone landscape
///       return Row(
///         children: [
///           const SizedBox(width: 72, child: VerticalDivider()),
///           Expanded(child: _buildContent()),
///         ],
///       );
///     } else {
///       // Compact or medium (phone portrait, tablet portrait)
///       return Column(
///         children: [
///           Expanded(child: _buildContent()),
///           const BottomNavigationBar(...),
///         ],
///       );
///     }
///   }
///
///   Widget _buildContent() {
///     return const Center(child: Text('Main Content Area'));
///   }
/// }
/// ```
enum AdaptiveLayoutType {
  /// Represents a compact layout, typically for:
  /// - Phone in portrait orientation.
  compact,

  /// Represents a medium layout, typically for:
  /// - Tablet in portrait orientation.
  /// - Foldable devices in portrait orientation when unfolded.
  medium,

  /// Represents an expanded layout, typically for:
  /// - Phone in landscape orientation.
  /// - Tablet in landscape orientation.
  /// - Foldable devices in landscape orientation when unfolded.
  /// - Desktop (smaller window sizes).
  expanded,

  /// Represents a large layout, typically for:
  /// - Desktop (standard window sizes).
  large,

  /// Represents an extra large layout, typically for:
  /// - Desktop (larger window sizes).
  /// - Ultra-wide displays.
  extraLarge;

  /// Returns `true` if the current layout type is [large] or [extraLarge].
  /// This is useful for quickly checking if the layout is suitable for
  /// larger screens like desktops.
  bool get isLarge => this >= AdaptiveLayoutType.large;

  /// Compares this [AdaptiveLayoutType] to `other` and returns `true`
  /// if this type is strictly greater (i.e., represents a larger screen size)
  /// than `other`.
  bool operator >(AdaptiveLayoutType other) => index > other.index;

  /// Compares this [AdaptiveLayoutType] to `other` and returns `true`
  /// if this type is strictly less (i.e., represents a smaller screen size)
  /// than `other`.
  bool operator <(AdaptiveLayoutType other) => index < other.index;

  /// Compares this [AdaptiveLayoutType] to `other` and returns `true`
  /// if this type is less than or equal to `other`.
  bool operator <=(AdaptiveLayoutType other) => index <= other.index;

  /// Compares this [AdaptiveLayoutType] to `other` and returns `true`
  /// if this type is greater than or equal to `other`.
  bool operator >=(AdaptiveLayoutType other) => index >= other.index;
}
