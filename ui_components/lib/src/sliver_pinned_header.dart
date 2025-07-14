import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A sliver that displays its single child as a "pinned" header.
///
/// A pinned header remains visible at the top (or start) of the viewport
/// even when the user scrolls past its original position. Once the scroll
/// position moves back, the header will scroll with the content again.
///
/// This widget is useful for creating sticky headers in custom scroll views,
/// similar to `SliverAppBar`'s pinning behavior but for arbitrary widgets.
///
/// Example:
/// ```dart
/// CustomScrollView(
///   slivers: <Widget>[
///     SliverPinnedHeader(
///       child: Container(
///         height: 60.0,
///         color: Colors.blue,
///         alignment: Alignment.center,
///         child: const Text(
///           'Pinned Header',
///           style: TextStyle(color: Colors.white, fontSize: 20),
///         ),
///       ),
///     ),
///     SliverList(
///       delegate: SliverChildBuilderDelegate(
///         (BuildContext context, int index) {
///           return Container(
///             height: 50.0,
///             color: index.isEven ? Colors.grey[200] : Colors.white,
///             child: Center(child: Text('Item $index')),
///           );
///         },
///         childCount: 50,
///       ),
///     ),
///   ],
/// );
/// ```
class SliverPinnedHeader extends SingleChildRenderObjectWidget {
  /// Creates a [SliverPinnedHeader].
  ///
  /// The [child] is the widget that will be displayed as the pinned header.
  const SliverPinnedHeader({
    super.key,
    required Widget super.child,
  });

  @override
  RenderSliver createRenderObject(BuildContext context) {
    return _RenderSliverPinnedHeader();
  }
}

/// The [RenderSliver] for [SliverPinnedHeader].
///
/// This render object handles the layout and painting of the pinned header
/// within a [CustomScrollView]. It calculates the [SliverGeometry] such that
/// the child remains visible at the top of the scrollable area once it
/// reaches that position.
class _RenderSliverPinnedHeader extends RenderSliverSingleBoxAdapter {
  /// Returns the main axis extent (height for vertical, width for horizontal)
  /// of the child widget.
  ///
  /// Assumes the child has already been laid out and has a size.
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
    // Layout the child with the current sliver constraints converted to box constraints.
    // parentUsesSize: true is important because we need the child's size to calculate geometry.
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);

    // Get the extent of the child along the main axis.
    final childExtent = this.childExtent;

    // Calculate the `paintedChildExtent`: how much of the child is currently
    // visible and needs to be painted. This is the minimum of the child's
    // full extent and the remaining paint extent available in the viewport,
    // adjusted for overlap.
    final paintedChildExtent = math.min(
      childExtent,
      constraints.remainingPaintExtent - constraints.overlap,
    );

    // Calculate `paintOrigin`: where the child should be painted relative to
    // the current scroll offset.
    // If there's negative overlap (meaning the header is being pushed off-screen
    // from the top), we use that. Otherwise, we take the maximum of the
    // current overlap (how much of the header is already scrolled off)
    // and the scrollOffset (how far the scroll view has scrolled).
    // The negative sign is because paintOrigin is relative to the leading edge.
    final double paintOrigin =
        constraints.overlap < 0 ? constraints.overlap : -math.max(constraints.overlap, constraints.scrollOffset);

    // Calculate `layoutExtent`: how much space the sliver occupies in the layout
    // along the main axis.
    // If the scrollOffset is greater than the paintedChildExtent, it means the
    // header has fully scrolled past its original position and is now pinned,
    // so it occupies 0 layout extent. Otherwise, it occupies the minimum of
    // the painted extent and the remaining portion of the child's extent
    // that hasn't been scrolled off.
    final double layoutExtent = constraints.scrollOffset > paintedChildExtent
        ? 0
        : math.min(paintedChildExtent, childExtent - constraints.scrollOffset);

    // Set the SliverGeometry, which defines how this sliver behaves in the scroll view.
    geometry = SliverGeometry(
      paintExtent: paintedChildExtent,
      maxPaintExtent: childExtent,
      maxScrollObstructionExtent: childExtent,
      paintOrigin: paintOrigin,
      scrollExtent: childExtent,
      layoutExtent: layoutExtent,
      hasVisualOverflow: paintedChildExtent < childExtent,
    );
  }

  @override
  double childMainAxisPosition(RenderBox child) {
    // The child is always positioned at the leading edge of the sliver,
    // which is effectively 0 relative to the sliver's paint origin.
    return 0;
  }
}
