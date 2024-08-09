import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'safe_area_directional.dart';

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
    final effectivePadding = calculateSafeAreaPadding(
          top: false,
          context: context,
          maintainBottomViewPadding: maintainBottomViewPadding,
          minimum: minimum ?? const EdgeInsets.fromLTRB(16, 16, 16, 8),
        ) +
        const EdgeInsets.only(bottom: 8);

    List<Widget> children = [];

    if (spacing > 0) {
      children = List.generate(
        (children.length * 2) - 1,
        (index) {
          final int itemIndex = index ~/ 2;
          if (index.isEven) {
            return children[itemIndex];
          }
          return Gap(spacing);
        },
      );
    } else {
      children = this.children;
    }

    Widget child = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Flex(
        direction: direction,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
      padding: effectivePadding,
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
