import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Parallax extends SingleChildRenderObjectWidget {
  const Parallax({
    super.key,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderParallax(scrollable: Scrollable.of(context));
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderParallax renderObject) {
    renderObject.scrollable = Scrollable.of(context);
  }
}

class ParallaxParentData extends ContainerBoxParentData<RenderBox> {}

class RenderParallax extends RenderBox with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin {
  RenderParallax({
    required ScrollableState scrollable,
  }) : _scrollable = scrollable;

  ScrollableState _scrollable;

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    if (value != _scrollable) {
      if (attached) {
        _scrollable.position.removeListener(markNeedsLayout);
      }
      _scrollable = value;
      if (attached) {
        _scrollable.position.addListener(markNeedsLayout);
      }
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _scrollable.position.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollable.position.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ParallaxParentData) {
      child.parentData = ParallaxParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // Force the background to take up all available width
    // and then scale its height based on the image's aspect ratio.
    final background = child!;
    final backgroundImageConstraints = switch (scrollable.widget.axis) {
      Axis.horizontal => BoxConstraints.tightFor(
          width: constraints.maxWidth * 1.25,
          height: constraints.maxHeight,
        ),
      Axis.vertical => BoxConstraints.tightFor(
          width: constraints.maxWidth,
          height: constraints.maxHeight * 1.25,
        ),
    };
    background.layout(backgroundImageConstraints, parentUsesSize: true);

    // Set the background's local offset, which is zero.
    (background.parentData as ParallaxParentData).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Get the size of the scrollable area.
    final axis = scrollable.widget.axis;
    final viewportDimension = scrollable.position.viewportDimension;

    // Calculate the global position of this list item.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final backgroundOffset = localToGlobal(size.center(Offset.zero), ancestor: scrollableBox);

    // Determine the percent position of this widget within the scrollable area.
    final Alignment alignment = switch (axis) {
      Axis.horizontal => Alignment((backgroundOffset.dx / viewportDimension).clamp(0.0, 1.0) * 2 - 1, 0.0),
      Axis.vertical => Alignment(0.0, (backgroundOffset.dy / viewportDimension).clamp(0.0, 1.0) * 2 - 1),
    };

    // Convert the background alignment into a pixel offset for painting purposes.
    final background = child!;
    final backgroundSize = background.size;
    final childSize = size;
    final childRect = alignment.inscribe(backgroundSize, Offset.zero & childSize);

    // Paint the background.
    final childOffset = switch (axis) {
      Axis.horizontal => Offset(childRect.left, 0.0),
      Axis.vertical => Offset(0.0, childRect.top),
    };
    context.paintChild(
      background,
      (background.parentData as ParallaxParentData).offset + offset + childOffset,
    );
  }
}
