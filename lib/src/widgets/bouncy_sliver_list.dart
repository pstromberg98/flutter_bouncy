import 'package:flutter/widgets.dart';
import 'package:flutter_bouncy/flutter_bouncy.dart';
import 'package:flutter_bouncy/src/rendering/rendering.dart';

class BouncySliverList extends SliverMultiBoxAdaptorWidget {
  /// Creates a sliver that places box children in a linear array.

  const BouncySliverList({
    Key? key,
    required SliverChildDelegate delegate,
    required this.simulator,
    required this.pointerPosition,
  }) : super(key: key, delegate: delegate);

  final SpringSimulator simulator;
  final PointerPosition pointerPosition;

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    final widget = context.widget as BouncySliverList;
    final sliver = renderObject as BouncyRenderSliverList;
    if (widget.simulator != sliver.currentSpringSimulator) {
      sliver.attachSpringSimulator(widget.simulator);
    }

    if (widget.pointerPosition != sliver.currentPointerNotifier) {
      sliver.attachPointerNotifer(widget.pointerPosition);
    }

    super.updateRenderObject(context, renderObject);
  }

  @override
  SliverMultiBoxAdaptorElement createElement() => SliverMultiBoxAdaptorElement(
        this,
        replaceMovedChildren: true,
      );

  @override
  BouncyRenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;

    final sliver = BouncyRenderSliverList(childManager: element);
    sliver.attachSpringSimulator(simulator);
    sliver.attachPointerNotifer(pointerPosition);
    return sliver;
  }
}
