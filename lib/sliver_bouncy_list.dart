import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverBouncyList extends SliverMultiBoxAdaptorWidget {
  final double scrollDelta;

  const SliverBouncyList({
    Key key,
    @required SliverChildDelegate delegate,
    @required this.scrollDelta,
  }) : super(key: key, delegate: delegate);

  @override
  SliverMultiBoxAdaptorElement createElement() =>
      SliverMultiBoxAdaptorElement(this, replaceMovedChildren: true);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderSliverBouncyList renderObject,
  ) {
    renderObject..scrollDelta = scrollDelta;
  }

  @override
  RenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return RenderSliverBouncyList(
      childManager: element,
      scrollDelta: scrollDelta,
    );
  }
}

class RenderSliverBouncyList extends RenderSliverList {
  double scrollDelta;

  RenderSliverBouncyList({
    @required RenderSliverBoxChildManager childManager,
    @required this.scrollDelta,
  }) : super(childManager: childManager);

  PointerEvent lastPointerEvent;

  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
    if (event is! PointerUpEvent && event is! PointerCancelEvent) {
      lastPointerEvent = event;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (firstChild == null) return;
    // offset is to the top-left corner, regardless of our axis direction.
    // originOffset gives us the delta from the real origin to the origin in the axis direction.
    Offset mainAxisUnit, crossAxisUnit, originOffset;
    bool addExtent;
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        mainAxisUnit = const Offset(0.0, -1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset + Offset(0.0, geometry.paintExtent);
        addExtent = true;
        break;
      case AxisDirection.right:
        mainAxisUnit = const Offset(1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset;
        addExtent = false;
        break;
      case AxisDirection.down:
        mainAxisUnit = const Offset(0.0, 1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset;
        addExtent = false;
        break;
      case AxisDirection.left:
        mainAxisUnit = const Offset(-1.0, 0.0);
        crossAxisUnit = const Offset(0.0, 1.0);
        originOffset = offset + Offset(geometry.paintExtent, 0.0);
        addExtent = true;
        break;
    }
    assert(mainAxisUnit != null);
    assert(addExtent != null);
    RenderBox child = firstChild;
    while (child != null) {
      final double mainAxisDelta = childMainAxisPosition(child);
      final double crossAxisDelta = childCrossAxisPosition(child);
      Offset childOffset = Offset(
        originOffset.dx +
            mainAxisUnit.dx * mainAxisDelta +
            crossAxisUnit.dx * crossAxisDelta,
        originOffset.dy +
            mainAxisUnit.dy * mainAxisDelta +
            crossAxisUnit.dy * crossAxisDelta,
      );
      if (addExtent) childOffset += mainAxisUnit * paintExtentOf(child);

      var resistance = 0.0;

      if (lastPointerEvent != null) {
        resistance = (lastPointerEvent.localPosition.dy - childOffset.dy) / 100;
      }

      final paint = Paint();
      // context.canvas.drawCircle(
      //   childOffset,
      //   10,
      //   paint,
      // );

      final yOffset = scrollDelta > 0
          ? max(scrollDelta, scrollDelta * resistance)
          : min(scrollDelta, scrollDelta * resistance);

      childOffset += Offset(0, yOffset);

      // If the child's visible interval (mainAxisDelta, mainAxisDelta + paintExtentOf(child))
      // does not intersect the paint extent interval (0, constraints.remainingPaintExtent), it's hidden.
      if (mainAxisDelta < constraints.remainingPaintExtent &&
          mainAxisDelta + paintExtentOf(child) > 0)
        context.paintChild(child, childOffset);

      paint.color = Colors.red;
      context.canvas.drawCircle(
        lastPointerEvent?.localPosition ?? Offset(0, 0),
        6,
        paint,
      );
      child = childAfter(child);
    }
  }
}
