/// Provides a set of predefined width breakpoints for creating adaptive and
/// responsive UI layouts across different device form factors.
///
/// These breakpoints align with common guidelines for categorizing screen
/// sizes (e.g., Material Design's adaptive layouts) and can be used to
/// determine the appropriate [AdaptiveLayoutType] or to apply different
/// UI compositions based on the available screen width.
///
/// Example Usage:
/// ```dart
/// class MyResponsiveWidget extends StatelessWidget {
///   const MyResponsiveWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     final double screenWidth = MediaQuery.of(context).size.width;
///
///     if (screenWidth < AdaptiveLayoutBreakpoints.compat) {
///       // Compact layout: e.g., show a bottom navigation bar
///       return Scaffold(
///         appBar: AppBar(title: const Text('Compact Layout')),
///         body: const Center(child: Text('Phone Portrait UI')),
///         bottomNavigationBar: BottomNavigationBar(
///           items: const [
///             BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
///             BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
///           ],
///         ),
///       );
///     } else if (screenWidth < AdaptiveLayoutBreakpoints.medium) {
///       // Medium layout: e.g., tablet portrait
///       return Scaffold(
///         appBar: AppBar(title: const Text('Medium Layout')),
///         body: const Center(child: Text('Tablet Portrait UI')),
///         // Maybe a side panel or more content density
///       );
///     } else if (screenWidth < AdaptiveLayoutBreakpoints.expanded) {
///       // Expanded layout: e.g., phone landscape, tablet landscape, smaller desktop
///       return Scaffold(
///         appBar: AppBar(title: const Text('Expanded Layout')),
///         body: Row(
///           children: [
///             NavigationRail(
///               destinations: const [
///                 NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
///                 NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
///               ],
///               selectedIndex: 0,
///             ),
///             const VerticalDivider(thickness: 1, width: 1),
///             Expanded(child: Center(child: Text('Landscape/Desktop UI'))),
///           ],
///         ),
///       );
///     } else {
///       // Large or Extra Large layout: e.g., desktop, ultra-wide
///       return Scaffold(
///         appBar: AppBar(title: const Text('Large/Extra Large Layout')),
///         body: Row(
///           children: [
///             SizedBox(
///               width: 250, // Wider navigation for desktop
///               child: ListView(
///                 children: const [
///                   ListTile(leading: Icon(Icons.dashboard), title: Text('Dashboard')),
///                   ListTile(leading: Icon(Icons.analytics), title: Text('Analytics')),
///                 ],
///               ),
///             ),
///             const VerticalDivider(thickness: 1, width: 1),
///             Expanded(child: Center(child: Text('Desktop/Ultra-wide UI'))),
///           ],
///         ),
///       );
///     }
///   }
/// }
/// ```
abstract interface class AdaptiveLayoutBreakpoints {
  /// Breakpoint for "compact" layouts.
  ///
  /// Typically applies when the screen width is less than 600 logical pixels.
  /// This corresponds to:
  /// - Phone in portrait orientation.
  static const double compat = 600;

  /// Breakpoint for "medium" layouts.
  ///
  /// Typically applies when the screen width is between 600 (inclusive) and 900 (exclusive)
  /// logical pixels. This corresponds to:
  /// - Tablet in portrait orientation.
  /// - Foldable devices in portrait orientation when unfolded.
  static const double medium = 900;

  /// Breakpoint for "expanded" layouts.
  ///
  /// Typically applies when the screen width is between 900 (inclusive) and 1200 (exclusive)
  /// logical pixels. This corresponds to:
  /// - Phone in landscape orientation.
  /// - Tablet in landscape orientation.
  /// - Foldable devices in landscape orientation when unfolded.
  /// - Desktop (smaller window sizes).
  static const double expanded = 1200;

  /// Breakpoint for "large" layouts.
  ///
  /// Typically applies when the screen width is between 1200 (inclusive) and 1600 (exclusive)
  /// logical pixels. This corresponds to:
  /// - Desktop (standard window sizes).
  static const double large = 1600;

  /// Breakpoint for "extra large" layouts.
  ///
  /// Typically applies when the screen width is 1600 logical pixels or greater.
  /// This corresponds to:
  /// - Desktop (larger window sizes).
  /// - Ultra-wide displays.
  ///
  /// Note: This value is the same as [large] because any width greater than
  /// or equal to this value falls into the "extra large" category.
  static const double extraLarge = 1600;
}
