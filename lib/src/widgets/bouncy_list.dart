import 'package:flutter/material.dart';
import 'package:flutter_bouncy/flutter_bouncy.dart';
import 'package:flutter_bouncy/src/widgets/bouncy_sliver_list.dart';
import 'package:flutter_bouncy/src/widgets/widgets.dart';

class BouncyList extends StatefulWidget {
  BouncyList({
    super.key,
    required List<Widget> children,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    SpringConfiguration? configuration,
  })  : delegate = SliverChildListDelegate(children),
        this.configuration = configuration ??
            SpringConfiguration(
              mass: 20,
              k: 1,
            );

  BouncyList.builder({
    super.key,
    required IndexedWidgetBuilder itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    int? itemCount,
    SpringConfiguration? configuration,
  })  : delegate = SliverChildBuilderDelegate(
          itemBuilder,
          childCount: itemCount,
        ),
        this.configuration = configuration ??
            SpringConfiguration(
              mass: 20,
              k: 1,
            );

  final Axis scrollDirection;
  final SliverChildDelegate delegate;
  final SpringConfiguration configuration;
  final bool reverse;

  @override
  State<StatefulWidget> createState() => BouncyListState();
}

class BouncyListState extends State<BouncyList> with TickerProviderStateMixin {
  late SpringSimulator simulator;
  double lastPixels = 0;

  @override
  void initState() {
    super.initState();
    simulator = SpringSimulator(
      vsync: this,
      initialLength: 0,
      configuration: widget.configuration,
    );
  }

  @override
  void didUpdateWidget(BouncyList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.configuration != widget.configuration) {
      simulator = SpringSimulator(
        vsync: this,
        initialLength: 0,
        configuration: widget.configuration,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final velocity = notification.metrics.pixels - lastPixels;
        simulator.setVelocity(velocity);
        lastPixels = notification.metrics.pixels;
        return true;
      },
      child: BouncyScrollView(
        reverse: widget.reverse,
        scrollDirection: widget.scrollDirection,
        sliversBuilder: (pointerPosition) => [
          BouncySliverList(
            pointerPosition: pointerPosition,
            delegate: widget.delegate,
            simulator: simulator,
          ),
        ],
      ),
    );
  }
}
