import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BottomPersistenceBar extends StatelessWidget {
  const BottomPersistenceBar({
    super.key,
    required this.children,
    this.direction = Axis.vertical,
    this.constraints,
    this.spacing = 0,
    this.minimum,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.maintainBottomViewPadding = true,
  })  : assert(children.length > 0),
        assert(spacing >= 0);

  final List<Widget> children;
  final Axis direction;
  final BoxConstraints? constraints;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final EdgeInsetsGeometry? minimum;
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
    final EdgeInsets effectiveMinimum = minimum?.resolve(textDirection) ?? const EdgeInsets.all(16);

    final effectiveSafeAreaPadding = EdgeInsets.only(
      left: math.max(safeAreaPadding.left, effectiveMinimum.left),
      top: effectiveMinimum.top,
      right: math.max(safeAreaPadding.right, effectiveMinimum.right),
      bottom: math.max(safeAreaPadding.bottom + 8, effectiveMinimum.bottom),
    );

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

    if (constraints != null) {
      child = Align(
        heightFactor: 1.0,
        child: ConstrainedBox(
          constraints: constraints ?? const BoxConstraints(),
          child: child,
        ),
      );
    }

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
