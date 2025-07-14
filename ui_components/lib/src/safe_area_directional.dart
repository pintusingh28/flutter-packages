import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Calculates the safe area padding for a given [BuildContext], allowing for
/// directional control and minimum padding overrides.
///
/// This function is useful when you need to programmatically determine the
/// effective safe area insets, potentially excluding certain sides or ensuring
/// a minimum padding value. It also handles the `maintainBottomViewPadding`
/// logic similar to [SafeArea].
///
/// Parameters:
/// - [context]: The [BuildContext] from which to retrieve [MediaQueryData]
///   and [Directionality].
/// - [minimum]: An [EdgeInsetsGeometry] that specifies the minimum padding
///   to apply. The calculated safe area padding for each side will be
///   the maximum of the actual safe area inset and the corresponding minimum
///   value. Defaults to [EdgeInsets.zero].
/// - [start]: If `true`, the safe area padding for the start edge (left in LTR,
///   right in RTL) is included. Defaults to `true`.
/// - [top]: If `true`, the safe area padding for the top edge is included.
///   Defaults to `true`.
/// - [end]: If `true`, the safe area padding for the end edge (right in LTR,
///   left in RTL) is included. Defaults to `true`.
/// - [bottom]: If `true`, the safe area padding for the bottom edge is included.
///   Defaults to `true`.
/// - [maintainBottomViewPadding]: If `true`, the bottom padding will be at least
///   the `MediaQuery.viewPadding.bottom`, which accounts for system overlays
///   like the iPhone home indicator. Defaults to `false`.
///
/// Returns an [EdgeInsets] representing the calculated safe area padding.
///
/// Throws an assertion error if [debugCheckHasMediaQuery] or
/// [debugCheckHasDirectionality] fail.
EdgeInsets calculateSafeAreaPadding({
  required BuildContext context,
  EdgeInsetsGeometry minimum = EdgeInsets.zero,
  bool start = true,
  bool top = true,
  bool end = true,
  bool bottom = true,
  bool maintainBottomViewPadding = false,
}) {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasDirectionality(context));

  EdgeInsets padding = MediaQuery.paddingOf(context);
  if (maintainBottomViewPadding) {
    EdgeInsets viewPadding = MediaQuery.viewPaddingOf(context);
    padding = padding.copyWith(
      bottom: math.max(padding.bottom, viewPadding.bottom),
    );
  }

  final TextDirection textDirection = Directionality.of(context);
  final EdgeInsets effectiveMinimum = minimum.resolve(textDirection);

  // Determine left/right based on text direction and start/end flags.
  final bool left = switch (textDirection) { TextDirection.ltr => start, TextDirection.rtl => end };
  final bool right = switch (textDirection) { TextDirection.rtl => start, TextDirection.ltr => end };

  return EdgeInsets.only(
    left: math.max(left ? padding.left : 0.0, effectiveMinimum.left),
    top: math.max(top ? padding.top : 0.0, effectiveMinimum.top),
    right: math.max(right ? padding.right : 0.0, effectiveMinimum.right),
    bottom: math.max(bottom ? padding.bottom : 0.0, effectiveMinimum.bottom),
  );
}

/// A widget that insets its child by a given padding, but only where the
/// operating system's keyboard or other system UI would otherwise obscure the
/// content. This version provides directional control (`start`, `end`)
/// instead of explicit `left`, `right`.
///
/// This widget is a wrapper around [SafeArea] that interprets `start` and `end`
/// properties based on the current [TextDirection].
///
/// Example:
/// ```dart
/// Scaffold(
///   appBar: AppBar(title: const Text('My App')),
///   body: SafeAreaDirectional(
///     // Only apply padding to the top and start (left in LTR, right in RTL)
///     bottom: false,
///     end: false,
///     child: ListView(
///       children: const <Widget>[
///         ListTile(title: Text('Item 1')),
///         ListTile(title: Text('Item 2')),
///         // ... more items
///       ],
///     ),
///   ),
/// );
/// ```
class SafeAreaDirectional extends StatelessWidget {
  /// Creates a [SafeAreaDirectional] widget.
  ///
  /// The [child] must not be null.
  const SafeAreaDirectional({
    super.key,
    this.start = true,
    this.top = true,
    this.end = true,
    this.bottom = true,
    this.maintainBottomViewPadding = false,
    this.minimum = EdgeInsets.zero,
    required this.child,
  });

  /// Whether to avoid system intrusions on the start side of the screen.
  ///
  /// This corresponds to `left` in [TextDirection.ltr] and `right` in
  /// [TextDirection.rtl]. Defaults to `true`.
  final bool start;

  /// Whether to avoid system intrusions on the top side of the screen.
  /// Defaults to `true`.
  final bool top;

  /// Whether to avoid system intrusions on the end side of the screen.
  ///
  /// This corresponds to `right` in [TextDirection.ltr] and `left` in
  /// [TextDirection.rtl]. Defaults to `true`.
  final bool end;

  /// Whether to avoid system intrusions on the bottom side of the screen.
  /// Defaults to `true`.
  final bool bottom;

  /// Whether to maintain the bottom view padding, which includes the
  /// keyboard and system overlays like the iPhone home indicator.
  /// Defaults to `false`.
  final bool maintainBottomViewPadding;

  /// The minimum padding to apply. The safe area padding for each side
  /// will be the maximum of the actual safe area inset and the corresponding
  /// minimum value. Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry minimum;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets effectiveMinimum = minimum.resolve(textDirection);

    return SafeArea(
      top: top,
      bottom: bottom,
      left: textDirection == TextDirection.ltr ? start : end,
      right: textDirection == TextDirection.rtl ? start : end,
      maintainBottomViewPadding: maintainBottomViewPadding,
      minimum: effectiveMinimum,
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('start', value: start, ifTrue: 'avoid start padding'));
    properties.add(FlagProperty('top', value: top, ifTrue: 'avoid top padding'));
    properties.add(FlagProperty('end', value: end, ifTrue: 'avoid end padding'));
    properties.add(FlagProperty('bottom', value: bottom, ifTrue: 'avoid bottom padding'));
  }
}

/// A sliver widget that insets its [sliver] by a given padding, but only where
/// the operating system's keyboard or other system UI would otherwise obscure
/// the content. This version provides directional control (`start`, `end`)
/// instead of explicit `left`, `right`.
///
/// This widget is a wrapper around [SliverSafeArea] that interprets `start` and `end`
/// properties based on the current [TextDirection].
///
/// Example:
/// ```dart
/// CustomScrollView(
///   slivers: <Widget>[
///     const SliverAppBar(
///       title: Text('Sliver Safe Area Demo'),
///       floating: true,
///     ),
///     SliverSafeAreaDirectional(
///       // Only apply padding to the start (left in LTR, right in RTL)
///       top: false,
///       bottom: false,
///       end: false,
///       sliver: SliverList(
///         delegate: SliverChildBuilderDelegate(
///           (BuildContext context, int index) {
///             return ListTile(title: Text('Item $index'));
///           },
///           childCount: 50,
///         ),
///       ),
///     ),
///   ],
/// );
/// ```
class SliverSafeAreaDirectional extends StatelessWidget {
  /// Creates a [SliverSafeAreaDirectional] widget.
  ///
  /// The [sliver] must not be null.
  const SliverSafeAreaDirectional({
    super.key,
    this.start = true,
    this.top = true,
    this.end = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    required this.sliver,
  });

  /// Whether to avoid system intrusions on the start side of the screen.
  ///
  /// This corresponds to `left` in [TextDirection.ltr] and `right` in
  /// [TextDirection.rtl]. Defaults to `true`.
  final bool start;

  /// Whether to avoid system intrusions on the top side of the screen.
  /// Defaults to `true`.
  final bool top;

  /// Whether to avoid system intrusions on the end side of the screen.
  ///
  /// This corresponds to `right` in [TextDirection.ltr] and `left` in
  /// [TextDirection.rtl]. Defaults to `true`.
  final bool end;

  /// Whether to avoid system intrusions on the bottom side of the screen.
  /// Defaults to `true`.
  final bool bottom;

  /// The minimum padding to apply. The safe area padding for each side
  /// will be the maximum of the actual safe area inset and the corresponding
  /// minimum value. Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry minimum;

  /// The sliver widget below this widget in the tree.
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets effectiveMinimum = minimum.resolve(textDirection);

    return SliverSafeArea(
      top: top,
      bottom: bottom,
      left: textDirection == TextDirection.ltr ? start : end,
      right: textDirection == TextDirection.rtl ? start : end,
      minimum: effectiveMinimum,
      sliver: sliver,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('start', value: start, ifTrue: 'avoid start padding'));
    properties.add(FlagProperty('top', value: top, ifTrue: 'avoid top padding'));
    properties.add(FlagProperty('end', value: end, ifTrue: 'avoid end padding'));
    properties.add(FlagProperty('bottom', value: bottom, ifTrue: 'avoid bottom padding'));
  }
}
