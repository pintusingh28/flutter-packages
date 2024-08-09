import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverPinnedHeader extends SingleChildRenderObjectWidget {
  const SliverPinnedHeader({
    super.key,
    required Widget super.child,
  });

  @override
  RenderSliver createRenderObject(BuildContext context) {
    return _RenderSliverPinnedHeader();
  }
}

class _RenderSliverPinnedHeader extends RenderSliverSingleBoxAdapter {
  @visibleForTesting
  @protected
  double get childExtent {
    if (child == null) return 0.0;
    assert(child!.hasSize);
    switch (constraints.axis) {
      case Axis.vertical:
        return child!.size.height;
      case Axis.horizontal:
        return child!.size.width;
    }
  }

  @override
  void performLayout() {
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final childExtent = this.childExtent;

    final paintedChildExtent = math.min(
      childExtent,
      constraints.remainingPaintExtent - constraints.overlap,
    );
    geometry = SliverGeometry(
      paintExtent: paintedChildExtent,
      maxPaintExtent: childExtent,
      maxScrollObstructionExtent: childExtent,
      paintOrigin:
          constraints.overlap < 0 ? constraints.overlap : -math.max(constraints.overlap, constraints.scrollOffset),
      scrollExtent: childExtent,
      layoutExtent: constraints.scrollOffset > paintedChildExtent
          ? 0
          : math.min(paintedChildExtent, childExtent - constraints.scrollOffset),
      hasVisualOverflow: paintedChildExtent < childExtent,
    );
  }

  @override
  double childMainAxisPosition(RenderBox child) {
    return 0;
  }
}
