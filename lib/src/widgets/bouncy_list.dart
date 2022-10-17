import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bouncy/flutter_bouncy.dart';
import 'package:flutter_bouncy/src/rendering/bouncy_render_sliver_list.dart';
import 'package:flutter_bouncy/src/widgets/widgets.dart';

class BouncyList extends StatefulWidget {
  BouncyList({
    super.key,
    required this.delegate,
    this.onChange,
  });

  final SliverChildDelegate delegate;
  final Function? onChange;

  @override
  State<StatefulWidget> createState() => BouncyListState();
}

class BouncyListState extends State<BouncyList>
    with SingleTickerProviderStateMixin {
  late final SpringSimulator simulator;
  double length = 20;
  double lastPixels = 0;

  @override
  void initState() {
    simulator = SpringSimulator(
      vsync: this,
      initialLength: length,
      configuration: SpringConfiguration(
        mass: 20,
        k: 1,
      ),
    );

    Future.delayed(Duration(milliseconds: 2000)).then((value) {
      simulator.setVelocity(20);
      // print('Firing');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final maxSpeed = 20.0;
            final velocity = max(
              min(notification.metrics.pixels - lastPixels, maxSpeed),
              -maxSpeed,
            );
            simulator.setVelocity(velocity);
            lastPixels = notification.metrics.pixels;
            return true;
          },
          child: BouncyScrollView(
            sliversBuilder: (pointerNotifier) => [
              _BouncySliverList(
                pointerNotifier: pointerNotifier,
                delegate: widget.delegate,
                simulator: simulator,
              ),
            ],
          ),
        ),
        // Positioned(
        //   left: (_sliverState.pointerPosition?.dx ?? 0) - 10,
        //   top: (_sliverState.pointerPosition?.dy ?? 0) - 10,
        //   child: Container(
        //     width: 20,
        //     height: 20,
        //     decoration: BoxDecoration(
        //       color: Colors.red,
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //   ),
        // )
      ],
    );
  }
}

class _BouncySliverList extends SliverMultiBoxAdaptorWidget {
  /// Creates a sliver that places box children in a linear array.

  const _BouncySliverList({
    Key? key,
    required SliverChildDelegate delegate,
    required this.simulator,
    required this.pointerNotifier,
  }) : super(key: key, delegate: delegate);

  final SpringSimulator simulator;
  final PointerPositionNotifier pointerNotifier;

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    final widget = context.widget as _BouncySliverList;
    final sliver = renderObject as BouncyRenderSliverList;
    if (widget.simulator != sliver.currentSpringSimulator) {
      sliver.attachSpringSimulator(widget.simulator);
    }

    if (widget.pointerNotifier != sliver.currentPointerNotifier) {
      sliver.attachPointerNotifer(widget.pointerNotifier);
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
    sliver.attachPointerNotifer(pointerNotifier);
    return sliver;
  }
}
