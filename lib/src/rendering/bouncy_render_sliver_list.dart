import 'package:flutter/rendering.dart';

class BouncyRenderSliverState {
  final double springLength;
  final Offset? pointerPosition;

  BouncyRenderSliverState({
    required this.springLength,
    required this.pointerPosition,
  });
}

typedef StateGetter = BouncyRenderSliverState Function();

class SliverBouncyParentData extends SliverMultiBoxAdaptorParentData {
  double springOffset = 0.0;
  double? baseOffset;

  @override
  set layoutOffset(double? offset) {
    baseOffset = offset;
    super.layoutOffset = offset;
  }
}

class BouncyRenderSliverList extends RenderSliverMultiBoxAdaptor {
  /// Creates a sliver that places multiple box children in a linear array along
  /// the main axis.
  ///
  /// The [childManager] argument must not be null.
  BouncyRenderSliverList({
    required RenderSliverBoxChildManager childManager,
  }) : super(childManager: childManager);

  BouncyRenderSliverState _state = BouncyRenderSliverState(
    springLength: 0,
    pointerPosition: null,
  );

  void setState(BouncyRenderSliverState state) {
    _state = BouncyRenderSliverState(
      springLength: state.springLength,
      pointerPosition: state.pointerPosition,
    );
    markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (firstChild == null) return;
    // offset is to the top-left corner, regardless of our axis direction.
    // originOffset gives us the delta from the real origin to the origin in the axis direction.
    final Offset mainAxisUnit, crossAxisUnit, originOffset;
    final bool addExtent;
    switch (applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection)) {
      case AxisDirection.up:
        mainAxisUnit = const Offset(0.0, -1.0);
        crossAxisUnit = const Offset(1.0, 0.0);
        originOffset = offset + Offset(0.0, geometry!.paintExtent);
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
        originOffset = offset + Offset(geometry!.paintExtent, 0.0);
        addExtent = true;
        break;
    }
    assert(mainAxisUnit != null);
    assert(addExtent != null);
    RenderBox? child = firstChild;
    while (child != null) {
      final double mainAxisDelta = childMainAxisPosition(child);
      final double crossAxisDelta = childCrossAxisPosition(child);

      Offset childOffset = Offset(
        originOffset.dx +
            mainAxisUnit.dx * mainAxisDelta +
            crossAxisUnit.dx * crossAxisDelta,
        (originOffset.dy +
            mainAxisUnit.dy * mainAxisDelta +
            crossAxisUnit.dy * crossAxisDelta),
      );

      if (addExtent) childOffset += mainAxisUnit * paintExtentOf(child);

      // If the child's visible interval (mainAxisDelta, mainAxisDelta + paintExtentOf(child))
      // does not intersect the paint extent interval (0, constraints.remainingPaintExtent), it's hidden.
      if (mainAxisDelta < constraints.remainingPaintExtent)
        context.paintChild(child, childOffset);

      child = childAfter(child);
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child is! SliverBouncyParentData) {
      child.parentData = SliverBouncyParentData();
    }
  }

  @override
  double? childScrollOffset(RenderBox child) {
    assert(child.parent == this);
    final childParentData = child.parentData! as SliverBouncyParentData;
    final baseOffset = childParentData.baseOffset;

    return baseOffset != null
        ? baseOffset + childParentData.springOffset
        : null;
  }

  double? childBaseOffset(RenderBox child) {
    assert(child.parent == this);
    final childParentData = child.parentData! as SliverBouncyParentData;
    final baseOffset = childParentData.baseOffset;
    return baseOffset;
  }

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    final double scrollOffset =
        constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0);
    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0);
    final double targetEndScrollOffset = scrollOffset + remainingExtent;
    final BoxConstraints childConstraints = constraints.asBoxConstraints();
    int leadingGarbage = 0;
    int trailingGarbage = 0;
    bool reachedEnd = false;

    if (firstChild == null) {
      if (!addInitialChild()) {
        geometry = SliverGeometry.zero;
        return;
      }
    } else {
      // collectGarbage(0, childCount - 1);
      // Adjust layout
      RenderBox? child = firstChild!;
      while (child != null) {
        final parentData = (child.parentData as SliverBouncyParentData);
        if (parentData.baseOffset != null) {
          parentData.springOffset = 0.0;
        }
        child = childAfter(child);
      }
    }

    firstChild!.layout(
      childConstraints,
      parentUsesSize: true,
    );

    layoutAtOffset(
      child: firstChild!,
      offset: childBaseOffset(firstChild!)!,
    );

    RenderBox? leadingChild = firstChild!;
    RenderBox? trailingChild = firstChild!;

    double startOffset = childScrollOffset(leadingChild)!;
    double startBaseOffset = childBaseOffset(leadingChild)!;
    while (startOffset > scrollOffset) {
      leadingChild = insertAndLayoutLeadingChild(
        childConstraints,
        parentUsesSize: true,
      );

      if (leadingChild == null) {
        // Out of children
        break;
      }

      leadingChild.layout(childConstraints, parentUsesSize: true);

      layoutBeforeOffset(
        child: leadingChild,
        offset: startBaseOffset,
      );

      startOffset = childScrollOffset(leadingChild)!;
      startBaseOffset = childBaseOffset(leadingChild)!;

      if (startOffset > targetEndScrollOffset) {
        trailingGarbage++;
      }
    }

    double endOffset =
        childScrollOffset(trailingChild)! + paintExtentOf(trailingChild);
    double endBaseOffset =
        childBaseOffset(trailingChild)! + paintExtentOf(trailingChild);

    while (endOffset < targetEndScrollOffset) {
      trailingChild = childAfter(trailingChild!) ??
          insertAndLayoutChild(
            childConstraints,
            after: trailingChild,
            parentUsesSize: true,
          );

      if (trailingChild == null) {
        // Out of children
        reachedEnd = true;
        break;
      }

      trailingChild.layout(
        childConstraints,
        parentUsesSize: true,
      );

      layoutAtOffset(
        child: trailingChild,
        offset: endBaseOffset,
      );

      endOffset =
          childScrollOffset(trailingChild)! + paintExtentOf(trailingChild);
      endBaseOffset =
          childBaseOffset(trailingChild)! + paintExtentOf(trailingChild);

      if (endOffset < scrollOffset) {
        leadingGarbage++;
      }
    }

    // Clean up remaining trailing children
    if (trailingChild != null) {
      trailingChild = childAfter(trailingChild);
      while (trailingChild != null) {
        trailingGarbage++;
        trailingChild = childAfter(trailingChild);
      }
    }

    collectGarbage(leadingGarbage, trailingGarbage);
    assert(debugAssertChildListIsNonEmptyAndContiguous());
    if (leadingGarbage > 0) {
      print('Leading Garbage: ' + leadingGarbage.toString());
    }

    if (trailingGarbage > 0) {
      print('Trailing Garbage: ' + trailingGarbage.toString());
    }
    final double estimatedMaxScrollOffset;
    if (reachedEnd) {
      estimatedMaxScrollOffset = endOffset;
    } else {
      estimatedMaxScrollOffset = childManager.estimateMaxScrollOffset(
        constraints,
        firstIndex: indexOf(firstChild!),
        lastIndex: indexOf(lastChild!),
        leadingScrollOffset: childScrollOffset(firstChild!),
        trailingScrollOffset: endOffset,
      );
    }

    final double paintExtent = calculatePaintOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: endOffset,
    );
    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: childScrollOffset(firstChild!)!,
      to: endOffset,
    );
    final targetEndScrollOffsetForPaint =
        constraints.scrollOffset + constraints.remainingPaintExtent;
    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      hasVisualOverflow: endOffset > targetEndScrollOffsetForPaint ||
          constraints.scrollOffset > 0.0,
    );

    childManager.didFinishLayout();
  }

  SliverBouncyParentData layoutBeforeOffset({
    required RenderBox child,
    required double offset,
  }) {
    final parentData = child.parentData as SliverBouncyParentData;
    parentData.baseOffset = offset - paintExtentOf(child);
    parentData.springOffset = _springOffset(parentData.baseOffset!);
    return parentData;
  }

  SliverBouncyParentData layoutAtOffset({
    required RenderBox child,
    required double offset,
  }) {
    final parentData = child.parentData as SliverBouncyParentData;
    parentData.baseOffset = offset;
    parentData.springOffset = _springOffset(parentData.baseOffset!);
    return parentData;
  }

  double _springOffset(double layoutOffset) {
    if (_state.pointerPosition == null) {
      return 0;
    }

    final difference =
        (constraints.scrollOffset + _state.pointerPosition!.dy) - layoutOffset;
    var yTranslate = (difference / 700) * _state.springLength;

    if (difference < 0) {
      yTranslate = -yTranslate;
    }
    return yTranslate;
  }
}
