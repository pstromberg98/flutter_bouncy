import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bouncy/flutter_bouncy.dart';
import 'package:flutter_bouncy/src/scroll_delta.dart';

class BouncyRenderSliverState {
  final double springLength;
  final double? pointerOffset;

  BouncyRenderSliverState({
    required this.springLength,
    required this.pointerOffset,
  });
}

typedef StateGetter = BouncyRenderSliverState Function();

class SliverBouncyParentData extends SliverMultiBoxAdaptorParentData {
  double get springOffset => _springOffset;

  double _springOffset = 0.0;
  double? baseOffset;

  Spring spring;

  SliverBouncyParentData({
    required this.spring,
  });

  void tick() {
    spring.tick();
    _springOffset = spring.state.length;
  }

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
    required super.childManager,
  });

  ScrollDelta? _scrollDelta;
  PointerPosition? _pointerNotifer;

  BouncyRenderSliverState _state = BouncyRenderSliverState(
    springLength: 0,
    pointerOffset: null,
  );

  PointerPosition? get currentPointerNotifier => _pointerNotifer;
  ScrollDelta? get currentScrollDelta => _scrollDelta;

  Ticker? _ticker;

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    // Stream.periodic(Duration(seconds: 4)).listen((event) {
    //   RenderBox? child = firstChild;
    //   while (child != null) {
    //     final parentData = child.parentData as SliverBouncyParentData;
    //     parentData.spring.state.length = 100;
    //     parentData.tick();
    //     child = childAfter(child);
    //   }
    // });
    _ticker = Ticker((elapsed) {
      // tick springs
      RenderBox? child = firstChild;
      while (child != null) {
        final parentData = child.parentData as SliverBouncyParentData;
        parentData.tick();
        child = childAfter(child);
      }

      markNeedsLayout();
    });
    _ticker!.start();
  }

  @override
  void detach() {
    super.detach();
    if (_ticker != null) {
      _ticker!.dispose();
    }
  }

  void attachScrollDelta(ScrollDelta scrollDelta) {
    if (_scrollDelta != null) {
      _scrollDelta!.dispose();
    }
    _scrollDelta = scrollDelta;
    _scrollDelta!.addListener(() => _updateWithScrollDelta(scrollDelta.value));
  }

  void _updateWithScrollDelta(double delta) {
    // tick springs
    RenderBox? child = firstChild;
    while (child != null) {
      final parentData = child.parentData as SliverBouncyParentData;
      if (parentData.baseOffset != null) {
        var difference = _state.pointerOffset! - parentData.baseOffset!;
        if (difference < 0) {
          difference = -difference;
        }
        parentData.spring.setVelocity(delta * (difference / 1000));
      }
      child = childAfter(child);
    }
  }

  void attachPointerNotifer(PointerPosition pointerNotifier) {
    if (_pointerNotifer != null) {
      _pointerNotifer!.dispose();
    }
    _pointerNotifer = pointerNotifier;
    _pointerNotifer!.addListener(() {
      final pointerOffset = constraints.axis == Axis.vertical
          ? _pointerNotifer!.value.dy
          : _pointerNotifer!.value.dx;

      final scrollOffset = _pointerOffsetToScrollOffset(pointerOffset);
      _state = BouncyRenderSliverState(
        springLength: _state.springLength,
        pointerOffset: scrollOffset,
      );
      markNeedsLayout();
    });
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (firstChild == null) return;
    // offset is to the top-left corner, regardless of our axis direction.
    // originOffset gives us the delta from the real origin to the origin in the axis direction.
    final Offset mainAxisUnit, crossAxisUnit, originOffset;
    final bool addExtent;
    switch (applyGrowthDirectionToAxisDirection(
      constraints.axisDirection,
      constraints.growthDirection,
    )) {
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
    if (child.parentData is! SliverBouncyParentData) {
      final parentData = SliverBouncyParentData(
        spring: Spring(
          configuration: SpringConfiguration(
            mass: 10,
            k: 0.6,
            damping: 0.8,
          ),
        ),
      );

      // if (lastChild != null) {
      //   final firstChildParentData =
      //       lastChild!.parentData as SliverBouncyParentData;
      //   parentData.spring.state.length =
      //       firstChildParentData.spring.state.length;
      //   parentData.spring.state.velocity =
      //       firstChildParentData.spring.state.velocity;
      // }
      child.parentData = parentData;
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

    // Trash leading children that haven't been previously laid out (most likely resulting from reordering).
    int leadingGarbageWithoutLayout = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      if (childScrollOffset(child) == null) {
        leadingGarbageWithoutLayout++;
      } else {
        break;
      }

      child = childAfter(child);
    }

    collectGarbage(leadingGarbageWithoutLayout, 0);

    if (firstChild == null) {
      if (!addInitialChild()) {
        geometry = SliverGeometry.zero;
        return;
      }
    } else {
      // Reset existing children's spring offset
      RenderBox? child = firstChild!;
      while (child != null) {
        final parentData = child.parentData as SliverBouncyParentData;
        if (parentData.baseOffset != null) {
          // TODO(pstromberg): Put this back in
          // parentData.springOffset = 0.0;
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
      final previousParentData =
          leadingChild!.parentData as SliverBouncyParentData;
      leadingChild = insertAndLayoutLeadingChild(
        childConstraints,
        parentUsesSize: true,
      );

      if (leadingChild == null) {
        // Out of children
        break;
      }

      leadingChild.layout(childConstraints, parentUsesSize: true);

      final parentData = leadingChild.parentData as SliverBouncyParentData;
      parentData.spring.state.length = previousParentData.spring.state.length;
      parentData.spring.state.velocity =
          -previousParentData.spring.state.velocity;
      parentData.tick();

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

    return parentData;
  }

  SliverBouncyParentData layoutAtOffset({
    required RenderBox child,
    required double offset,
  }) {
    final parentData = child.parentData as SliverBouncyParentData;
    parentData.baseOffset = offset;

    return parentData;
  }

  double _pointerOffsetToScrollOffset(double pointerOffset) {
    final axisDirection = applyGrowthDirectionToAxisDirection(
      constraints.axisDirection,
      constraints.growthDirection,
    );

    final growsForward = [
      AxisDirection.down,
      AxisDirection.right,
    ].contains(axisDirection);

    if (growsForward) {
      return pointerOffset + constraints.scrollOffset;
    } else {
      return (geometry!.paintExtent - pointerOffset) + constraints.scrollOffset;
    }
  }

  double _springOffset(double layoutOffset) {
    if (_state.pointerOffset == null) {
      return 0;
    }

    final difference = _state.pointerOffset! - layoutOffset;
    // The spring offset exactly matches the spring simulations length
    // when the difference between the pointer and layout offset is 2x
    // the viewport extent
    var yTranslate = (difference / (constraints.viewportMainAxisExtent * 1.5)) *
        _state.springLength;

    if (difference < 0) {
      yTranslate = -yTranslate;
    }
    return yTranslate;
  }
}
