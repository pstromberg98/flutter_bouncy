import 'package:flutter/widgets.dart';
import 'package:flutter_bouncy/src/rendering/bouncy_render_sliver_list.dart';

class BouncySliverList extends SliverMultiBoxAdaptorWidget {
  const BouncySliverList({
    Key? key,
    required SliverChildDelegate delegate,
  }) : super(key: key, delegate: delegate);

  @override
  SliverMultiBoxAdaptorElement createElement() =>
      _BouncySliverListElement(this, replaceMovedChildren: true);

  @override
  BouncyRenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return BouncyRenderSliverList(childManager: element);
  }
}

class _BouncySliverListElement extends SliverMultiBoxAdaptorElement {
  _BouncySliverListElement(
    super.widget, {
    super.replaceMovedChildren,
  });
}
