import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bouncy/flutter_bouncy.dart';
import 'package:flutter_bouncy/src/bouncy_render_sliver_list.dart';

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
  BouncyRenderSliverState _sliverState = BouncyRenderSliverState(
    springLength: 0,
    pointerPosition: null,
  );

  late final SpringSimulator simulation;
  late final SpringSimulatorController controller;
  double length = 20;
  double lastPixels = 0;

  @override
  void initState() {
    controller = SpringSimulatorController();
    simulation = SpringSimulator(
      vsync: this,
      initialLength: length,
      springSimulatorController: controller,
      configuration: SpringConfiguration(
        mass: 10,
        k: 3,
      ),
      onSpringStateChange: (state) {
        if (widget.onChange != null) {
          widget.onChange!(state);
        }
        setState(() {
          _sliverState = BouncyRenderSliverState(
            springLength: state.length,
            pointerPosition: _sliverState.pointerPosition,
          );
        });
      },
    );

    Future.delayed(Duration(milliseconds: 2000)).then((value) {
      controller.setVelocity(20);
      // print('Firing');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        setState(() {
          _sliverState = BouncyRenderSliverState(
            springLength: _sliverState.springLength,
            pointerPosition: event.localPosition,
          );
        });
      },
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final maxSpeed = 4.0;
              final velocity = max(
                min(notification.metrics.pixels - lastPixels, maxSpeed),
                -maxSpeed,
              );
              controller.setVelocity(velocity);
              lastPixels = notification.metrics.pixels;
              return true;
            },
            child: CustomScrollView(
              slivers: [
                _BouncySliverList(
                  delegate: widget.delegate,
                  state: _sliverState,
                ),
              ],
            ),
          ),
          Positioned(
            left: (_sliverState.pointerPosition?.dx ?? 0) - 10,
            top: (_sliverState.pointerPosition?.dy ?? 0) - 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _BouncySliverList extends SliverMultiBoxAdaptorWidget {
  /// Creates a sliver that places box children in a linear array.

  final BouncyRenderSliverState state;

  const _BouncySliverList({
    Key? key,
    required SliverChildDelegate delegate,
    required this.state,
  }) : super(key: key, delegate: delegate);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    final widget = context.widget as _BouncySliverList;
    final bouncyRender = renderObject as BouncyRenderSliverList;
    bouncyRender.setState(widget.state);

    super.updateRenderObject(context, renderObject);
  }

  @override
  SliverMultiBoxAdaptorElement createElement() =>
      SliverMultiBoxAdaptorElement(this, replaceMovedChildren: true);

  @override
  BouncyRenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return BouncyRenderSliverList(childManager: element);
  }
}
