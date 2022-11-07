import 'package:flutter/foundation.dart';

class ScrollDelta extends ValueNotifier<double> {
  ScrollDelta() : super(0.0);

  void notify(double updatedOffset) {
    value = updatedOffset;
    notifyListeners();
  }
}
