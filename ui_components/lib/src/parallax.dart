import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A widget that applies a parallax effect to its child within a [Scrollable]
/// widget.
///
/// The child (typically an image or a background) will move at a different
/// speed than the scrollable content, creating a depth illusion. This effect
/// is achieved by adjusting the child's paint offset based on its position
/// within the scrollable viewport.
///
/// This widget is designed to be used as a child of a [Scrollable] (e.g.,
/// inside a [ListView], [GridView], or [CustomScrollView]).
///
/// The parallax effect can be applied along either the vertical or horizontal
/// axis, depending on the [Axis] of the parent [Scrollable].
///
/// Example:
/// ```dart
/// ListView.builder(
///   itemCount: 20,
///   itemBuilder: (context, index) {
///     return SizedBox(
///       height: 200,
///       child: Parallax(
///         child: Image.network(
///           '[https://placehold.co/600x400/FF0000/FFFFFF?text=Parallax+Image+$index](https://placehold.co/600x400/FF0000/FFFFFF?text=Parallax+Image+$index)',
///           fit: BoxFit.cover,
///         ),
///       ),
///     );
///   },
/// );
/// ```
class Parallax extends SingleChildRenderObjectWidget {
  /// Creates a [Parallax] widget.
  ///
  /// The [child] is the widget to which the parallax effect will be applied.
  const Parallax({
    super.key,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    // Create the custom render object for parallax effect.
    // It needs access to the ScrollableState to monitor scroll position.
    return RenderParallax(scrollable: Scrollable.of(context));
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderParallax renderObject) {
    // Update the scrollable state if it changes (e.g., if the widget is
    // moved to a different scrollable context).
    renderObject.scrollable = Scrollable.of(context);
  }
}

/// Custom parent data for the child of [RenderParallax].
///
/// This is a simple container for [RenderBox] parent data,
/// primarily used to ensure the child has the correct parent data type.
class ParallaxParentData extends ContainerBoxParentData<RenderBox> {}

/// The [RenderBox] that implements the parallax scrolling effect.
///
/// This render object is responsible for:
/// 1. Listening to the scroll position of the parent [Scrollable].
/// 2. Laying out its child (the background) with adjusted constraints.
/// 3. Calculating the paint offset for the child based on the scroll position
///    to create the parallax effect.
class RenderParallax extends RenderBox with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin {
  /// Creates a [RenderParallax] with the given [scrollable] state.
  RenderParallax({
    required ScrollableState scrollable,
  }) : _scrollable = scrollable;

  ScrollableState _scrollable;

  /// The [ScrollableState] that this parallax effect is associated with.
  ///
  /// The parallax effect depends on the scroll position provided by this state.
  ScrollableState get scrollable => _scrollable;

  /// Sets the [ScrollableState].
  ///
  /// If the new [value] is different from the current one, it removes the
  /// listener from the old scrollable position and adds it to the new one.
  set scrollable(ScrollableState value) {
    if (value != _scrollable) {
      // If already attached to a pipeline, remove listener from old position.
      if (attached) {
        _scrollable.position.removeListener(markNeedsLayout);
      }
      _scrollable = value;
      // If attached, add listener to new position.
      if (attached) {
        _scrollable.position.addListener(markNeedsLayout);
      }
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    // When attached to the render tree, start listening to scroll position changes.
    // markNeedsLayout will cause this render object to relayout and repaint
    // whenever the scroll position changes.
    _scrollable.position.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    // When detached from the render tree, stop listening to scroll position changes.
    _scrollable.position.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    // Ensure the child has the correct ParentData type.
    if (child.parentData is! ParallaxParentData) {
      child.parentData = ParallaxParentData();
    }
  }

  @override
  void performLayout() {
    // This render object takes up all available space given by its parent constraints.
    size = constraints.biggest;

    // Layout the child (background image/widget).
    // The child is forced to take up more space than the parent (1.25x)
    // to allow for the parallax movement.
    final background = child!;
    final backgroundImageConstraints = switch (scrollable.widget.axis) {
      Axis.horizontal => BoxConstraints.tightFor(
          width: constraints.maxWidth * 1.25, // Make background wider for horizontal parallax
          height: constraints.maxHeight,
        ),
      Axis.vertical => BoxConstraints.tightFor(
          width: constraints.maxWidth,
          height: constraints.maxHeight * 1.25, // Make background taller for vertical parallax
        ),
    };
    // Layout the background with these expanded constraints.
    background.layout(backgroundImageConstraints, parentUsesSize: true);

    // The child's local offset within this render object is initially zero.
    // Its actual painted position will be adjusted in the paint phase.
    (background.parentData as ParallaxParentData).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Get the axis of the scrollable (vertical or horizontal).
    final axis = scrollable.widget.axis;
    // Get the dimension of the viewport along the main axis.
    final viewportDimension = scrollable.position.viewportDimension;

    // Calculate the global position of this Parallax widget within the scrollable.
    // This helps determine how far into the viewport this widget is.
    final RenderBox scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final Offset backgroundOffset = localToGlobal(size.center(Offset.zero), ancestor: scrollableBox);

    // Determine the "percent position" of this widget within the scrollable area.
    // This value ranges from -1.0 to 1.0, where 0.0 is the center of the viewport.
    // It's used to calculate how much the background should shift.
    final Alignment alignment = switch (axis) {
      Axis.horizontal => Alignment(
          (backgroundOffset.dx / viewportDimension).clamp(0.0, 1.0) * 2 - 1,
          0.0,
        ),
      Axis.vertical => Alignment(
          0.0,
          (backgroundOffset.dy / viewportDimension).clamp(0.0, 1.0) * 2 - 1,
        ),
    };

    // Get the child (background) and its size.
    final background = child!;
    final backgroundSize = background.size;
    final childSize = size;

    // Calculate the rectangle within the Parallax widget's bounds where the
    // background should be painted, based on the calculated alignment.
    final Rect childRect = alignment.inscribe(backgroundSize, Offset.zero & childSize);

    // Determine the final offset for painting the background.
    // This offset shifts the background within the Parallax widget's bounds
    // to create the parallax effect.
    final Offset childOffset = switch (axis) {
      Axis.horizontal => Offset(childRect.left, 0.0),
      Axis.vertical => Offset(0.0, childRect.top),
    };

    // Paint the background child at its calculated offset.
    // The `offset` argument is the global offset of this RenderParallax.
    // `(background.parentData as ParallaxParentData).offset` is the local offset (which is zero).
    // `childOffset` is the parallax-induced offset.
    context.paintChild(
      background,
      (background.parentData as ParallaxParentData).offset + offset + childOffset,
    );
  }
}
