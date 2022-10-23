import 'dart:ui';
import 'package:flutter/foundation.dart';

class PointerPosition extends ValueNotifier<Offset> {
  PointerPosition() : super(Offset.zero);

  void updatePosition(Offset updatedOffset) {
    value = updatedOffset;
    notifyListeners();
  }
}
