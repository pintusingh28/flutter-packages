import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  final bool left = switch (textDirection) { TextDirection.ltr => start, TextDirection.rtl => end };
  final bool right = switch (textDirection) { TextDirection.rtl => start, TextDirection.ltr => end };

  return EdgeInsets.only(
    left: math.max(left ? padding.left : 0.0, effectiveMinimum.left),
    top: math.max(top ? padding.top : 0.0, effectiveMinimum.top),
    right: math.max(right ? padding.right : 0.0, effectiveMinimum.right),
    bottom: math.max(bottom ? padding.bottom : 0.0, effectiveMinimum.bottom),
  );
}

class SafeAreaDirectional extends StatelessWidget {
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

  final bool start;
  final bool top;
  final bool end;
  final bool bottom;
  final bool maintainBottomViewPadding;
  final EdgeInsetsGeometry minimum;
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

class SliverSafeAreaDirectional extends StatelessWidget {
  const SliverSafeAreaDirectional({
    super.key,
    this.start = true,
    this.top = true,
    this.end = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    required this.sliver,
  });

  final bool start;
  final bool top;
  final bool end;
  final bool bottom;
  final EdgeInsetsGeometry minimum;
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
