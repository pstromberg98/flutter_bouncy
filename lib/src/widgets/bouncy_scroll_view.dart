import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PointerPositionNotifier extends ValueNotifier<Offset> {
  PointerPositionNotifier() : super(Offset.zero);

  void updatePosition(Offset updatedOffset) {
    value = updatedOffset;
    notifyListeners();
  }
}

typedef PointerSliversBuilder = List<Widget> Function(PointerPositionNotifier);

class BouncyScrollView extends ScrollView {
  BouncyScrollView({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.scrollBehavior,
    super.shrinkWrap,
    super.center,
    super.anchor,
    super.cacheExtent,
    required this.sliversBuilder,
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
  });

  final PointerSliversBuilder sliversBuilder;

  final pointerPosition = PointerPositionNotifier();

  @override
  Widget build(BuildContext context) {
    final List<Widget> slivers = buildSlivers(context);
    final AxisDirection axisDirection = getDirection(context);

    final bool effectivePrimary = primary ??
        controller == null &&
            PrimaryScrollController.shouldInherit(context, scrollDirection);

    final ScrollController? scrollController =
        effectivePrimary ? PrimaryScrollController.of(context) : controller;

    final Scrollable scrollable = Scrollable(
      dragStartBehavior: dragStartBehavior,
      axisDirection: axisDirection,
      controller: scrollController,
      physics: physics,
      scrollBehavior: scrollBehavior,
      semanticChildCount: semanticChildCount,
      restorationId: restorationId,
      viewportBuilder: (BuildContext context, ViewportOffset offset) {
        return buildViewport(context, offset, axisDirection, slivers);
      },
      clipBehavior: clipBehavior,
    );

    Widget scrollableResult = effectivePrimary && scrollController != null
        // Further descendant ScrollViews will not inherit the same PrimaryScrollController
        ? PrimaryScrollController.none(child: scrollable)
        : scrollable;

    scrollableResult = Listener(
      onPointerMove: (event) {
        if (event.down) {
          pointerPosition.updatePosition(event.localPosition);
        }
      },
      child: scrollableResult,
    );

    if (keyboardDismissBehavior == ScrollViewKeyboardDismissBehavior.onDrag) {
      return NotificationListener<ScrollUpdateNotification>(
        child: scrollableResult,
        onNotification: (ScrollUpdateNotification notification) {
          final FocusScopeNode focusScope = FocusScope.of(context);
          if (notification.dragDetails != null && focusScope.hasFocus) {
            focusScope.unfocus();
          }
          return false;
        },
      );
    } else {
      return scrollableResult;
    }
  }

  List<Widget> buildSlivers(BuildContext context) {
    return sliversBuilder(pointerPosition);
  }
}
