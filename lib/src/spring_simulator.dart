import 'package:flutter/scheduler.dart';
import 'package:flutter_bouncy/src/spring.dart';

typedef SpringStateChangeCallback = void Function(SpringState state);
typedef RemovalFunction = void Function();

class SpringSimulator {
  final TickerProvider vsync;
  final SpringConfiguration configuration;

  final List<SpringStateChangeCallback> _listeners = [];

  late final SpringState _state;
  late final Ticker _ticker;

  SpringState get state => _state;

  SpringSimulator({
    required this.vsync,
    required this.configuration,
    double? initialLength,
  }) : _state = SpringState(
          length: initialLength ?? 0,
          force: 0,
          velocity: 0,
        ) {
    _ticker = vsync.createTicker((elapsed) {
      final displacement = _state.length;
      final force = (-configuration.k) * displacement;

      final acceleration = force / configuration.mass;

      // Not sure if this correct (adding acceleration and velocity)
      var deltaPosition = (_state.velocity + acceleration);

      if (deltaPosition.abs() < 0.001) {
        deltaPosition = 0.0;
      }

      final updatedLength = _state.length + deltaPosition;
      _state.velocity +=
          acceleration + -(configuration.damping * _state.velocity);

      if (updatedLength != _state.length) {
        _state.length = updatedLength;
        _listeners.forEach((listener) => listener(_state));
      }
    });
    _ticker.start();
  }

  void setVelocity(double velocity) {
    _state.velocity = velocity;
  }

  void dispose() {
    _ticker.dispose();
    _listeners.clear();
  }

  RemovalFunction addListener(SpringStateChangeCallback callback) {
    _listeners.add(callback);
    return () => _listeners.remove(callback);
  }
}
