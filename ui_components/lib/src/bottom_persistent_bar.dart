import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that displays a row or column of children at the bottom of the screen,
/// typically used for persistent action buttons or navigation elements.
///
/// The [BottomPersistenceBar] automatically handles safe area padding,
/// especially for the bottom inset (e.g., iPhone's home indicator),
/// ensuring that its content is always visible and not obscured by system UI.
///
/// It provides flexible layout options using a [Flex] widget internally,
/// allowing for horizontal or vertical arrangement of its [children].
///
/// Example:
/// ```dart
/// Scaffold(
///   appBar: AppBar(title: const Text('My App')),
///   body: const Center(child: Text('Main Content')),
///   bottomNavigationBar: BottomPersistenceBar(
///     children: [
///       ElevatedButton(
///         onPressed: () {
///           // Handle save action
///         },
///         child: const Text('Save'),
///       ),
///       OutlinedButton(
///         onPressed: () {
///           // Handle cancel action
///         },
///         child: const Text('Cancel'),
///       ),
///     ],
///     spacing: 16.0, // Space between buttons
///     direction: Axis.horizontal,
///     crossAxisAlignment: CrossAxisAlignment.end,
///     minimum: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
///   ),
/// );
/// ```
class BottomPersistenceBar extends StatelessWidget {
  /// Creates a [BottomPersistenceBar].
  ///
  /// The [children] list must not be empty.
  /// The [spacing] must be non-negative.
  const BottomPersistenceBar({
    super.key,
    required this.children,
    this.direction = Axis.vertical,
    this.constraints,
    this.spacing = 0,
    this.minimum,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.maintainBottomViewPadding = true,
  })  : assert(children.length > 0),
        assert(spacing >= 0);

  /// The list of widgets to display within the bar.
  ///
  /// These widgets will be arranged according to the [direction].
  final List<Widget> children;

  /// The direction in which the [children] are laid out.
  ///
  /// Defaults to [Axis.vertical].
  final Axis direction;

  /// Additional constraints to apply to the bar's content.
  ///
  /// If provided, the content will be wrapped in a [ConstrainedBox].
  final BoxConstraints? constraints;

  /// How the children should be placed along the cross axis.
  ///
  /// For [Axis.horizontal], this controls vertical alignment.
  /// For [Axis.vertical], this controls horizontal alignment.
  /// Defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment crossAxisAlignment;

  /// How the children should be placed along the cross axis.
  ///
  /// For [Axis.horizontal], this controls horizontal alignment.
  /// For [Axis.vertical], this controls vertical alignment.
  /// Defaults to [MainAxisAlignment.center].
  final MainAxisAlignment mainAxisAlignment;

  /// The amount of space between each child in the [direction].
  ///
  /// Defaults to 0.
  final double spacing;

  /// The minimum padding to apply around the bar's content.
  ///
  /// This padding is applied in addition to the safe area padding,
  /// ensuring a minimum visual margin. If not provided, a default
  /// padding of `EdgeInsets.all(16)` is used.
  final EdgeInsetsGeometry? minimum;

  /// Whether to maintain the bottom view padding, ensuring the bar
  /// is not obscured by system UI elements like the iPhone home indicator.
  ///
  /// When `true`, the bottom padding will be at least the `MediaQuery.viewPadding.bottom`
  /// plus an additional 8 logical pixels, or the `minimum.bottom` if it's larger.
  /// Defaults to `true`.
  final bool maintainBottomViewPadding;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasDirectionality(context));

    EdgeInsets safeAreaPadding = MediaQuery.paddingOf(context);
    if (maintainBottomViewPadding) {
      EdgeInsets viewPadding = MediaQuery.viewPaddingOf(context);
      safeAreaPadding = safeAreaPadding.copyWith(
        bottom: math.max(safeAreaPadding.bottom, viewPadding.bottom),
      );
    }

    final TextDirection textDirection = Directionality.of(context);
    // Resolve minimum padding, defaulting to 16.0 on all sides if not provided.
    final EdgeInsets effectiveMinimum = minimum?.resolve(textDirection) ?? const EdgeInsets.all(16);

    // Calculate the effective padding, taking into account safe area and minimums.
    // An additional 8 logical pixels are added to the bottom safe area padding
    // to provide extra clearance, especially for the home indicator.
    final effectiveSafeAreaPadding = EdgeInsets.only(
      left: math.max(safeAreaPadding.left, effectiveMinimum.left),
      top: effectiveMinimum.top,
      right: math.max(safeAreaPadding.right, effectiveMinimum.right),
      bottom: math.max(safeAreaPadding.bottom + 8, effectiveMinimum.bottom),
    );

    // Remove all existing padding from the context to ensure only
    // the calculated effectiveSafeAreaPadding is applied.
    Widget child = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Flex(
        spacing: spacing,
        direction: direction,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );

    // Apply constraints if provided, wrapping the Flex widget in a ConstrainedBox.
    if (constraints != null) {
      child = Align(
        heightFactor: 1.0,
        child: ConstrainedBox(
          constraints: constraints!,
          child: child,
        ),
      );
    }

    // Apply the final calculated padding to the entire bar.
    return Padding(
      padding: effectiveSafeAreaPadding,
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<Widget>('children', children));
    properties.add(EnumProperty<Axis>('direction', direction));
    properties.add(DiagnosticsProperty<BoxConstraints?>('constraints', constraints));
    properties.add(EnumProperty<CrossAxisAlignment>('crossAxisAlignment', crossAxisAlignment));
    properties.add(DoubleProperty('spacing', spacing));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('minimum', minimum));
    properties.add(DiagnosticsProperty<bool>('maintainBottomViewPadding', maintainBottomViewPadding));
  }
}
