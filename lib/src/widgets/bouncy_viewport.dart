import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bouncy/src/rendering/bouncy_render_viewport.dart';

class BouncyViewport extends Viewport {
  BouncyViewport({
    required super.offset,
    super.anchor,
    super.axisDirection,
    super.cacheExtent,
    super.cacheExtentStyle,
    super.center,
    super.clipBehavior,
    super.crossAxisDirection,
    super.key,
    super.slivers,
  });
  @override
  RenderViewport createRenderObject(BuildContext context) {
    return BouncyRenderViewport(
      springDisplacement: ValueNotifier(0.0),
      pointerOffset: PointerOffset(),
      axisDirection: axisDirection,
      crossAxisDirection: crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      anchor: anchor,
      offset: offset,
      cacheExtent: cacheExtent,
      cacheExtentStyle: cacheExtentStyle,
      clipBehavior: clipBehavior,
    );
  }
}
