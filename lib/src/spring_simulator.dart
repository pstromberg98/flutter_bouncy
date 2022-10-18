import 'package:flutter/scheduler.dart';

class SpringConfiguration {
  final double mass;
  final double k;
  double damping;

  SpringConfiguration({
    required this.mass,
    required this.k,
    double? damping,
  }) : damping = damping ?? 1;
}

class SpringState {
  double length;
  double force;
  double velocity;

  SpringState({
    required this.length,
    required this.force,
    required this.velocity,
  });
}

typedef SpringStateChangeCallback = void Function(SpringState state);
typedef RemovalFunction = void Function();

class SpringSimulator {
  final TickerProvider vsync;
  final SpringConfiguration configuration;

  final List<SpringStateChangeCallback> _listeners = [];

  late final SpringState _state;
  late final Ticker _ticker;

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

      if (updatedLength != _state.length) {
        _state.length = updatedLength;
        _state.velocity +=
            acceleration + -(configuration.damping * _state.velocity);

        _listeners.forEach((listener) => listener(_state));
      }
    });
    _ticker.start();
  }

  void setVelocity(double velocity) {
    // TODO: Not sure if this is the best way to do this
    if (velocity.abs() > _state.velocity.abs()) {
      _state.velocity = velocity;
    }
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
