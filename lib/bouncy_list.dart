import 'package:flutter/material.dart';
import 'package:flutter_bouncy/sliver_bouncy_list.dart';

class BouncyList extends StatefulWidget {
  final SliverChildDelegate delegate;

  BouncyList({this.delegate});

  @override
  State<StatefulWidget> createState() => BouncyListState();
}

class BouncyListState extends State<BouncyList>
    with SingleTickerProviderStateMixin {
  final tween = Tween<double>(begin: 0.0, end: 0.0);
  Animation<double> tweenAnimation;
  AnimationController controller;
  ScrollController scrollController;
  double scrollDelta = 0.0;
  double lastPixels;

  @override
  void initState() {
    scrollController = ScrollController();
    controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    tweenAnimation = controller.drive(tween);
    CurvedAnimation(parent: tweenAnimation, curve: Curves.ease).addListener(() {
      setState(() {
        scrollDelta = tweenAnimation.value;
        // print(tweenAnimation.value);
        // print(scrollDelta);
      });
    });
    tweenAnimation.addListener(() {
      // setState(() {
      //   scrollDelta = tweenAnimation.value;
      //   // print(tweenAnimation.value);
      //   // print(scrollDelta);
      // });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (scrollController.position != null) {
            // setState(() {
            //   scrollDelta = notification.scrollDelta;
            // });
            tween.begin = scrollDelta;
            tween.end = notification.scrollDelta;

            if (controller.isCompleted) {
              controller.reset();
            }

            if (!controller.isAnimating) {
              controller.forward();
            }
          }
        }

        if (notification is ScrollEndNotification) {
          // controller.reset();
          // setState(() {
          //   scrollDelta = 0;
          // });
        }
        return false;
      },
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverBouncyList(
            scrollDelta: scrollDelta,
            delegate: widget.delegate,
          ),
        ],
      ),
    );
  }
}
