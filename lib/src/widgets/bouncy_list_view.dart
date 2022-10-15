import 'package:flutter/material.dart';
import 'package:flutter_bouncy/src/widgets/bouncy_sliver_list.dart';

class BouncyListView extends ListView {
  @override
  Widget buildChildLayout(BuildContext context) {
    // if (itemExtent != null) {
    //   return SliverFixedExtentList(
    //     delegate: childrenDelegate,
    //     itemExtent: itemExtent!,
    //   );
    // } else if (prototypeItem != null) {
    //   return SliverPrototypeExtentList(
    //     delegate: childrenDelegate,
    //     prototypeItem: prototypeItem!,
    //   );
    // }
    return BouncySliverList(delegate: childrenDelegate);
  }
}
