import 'package:flutter/material.dart';
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

class SpringSimulatorController implements Listenable {
  final listeners = <Function>[];

  void setVelocity(double velocity) {
    listeners.forEach((element) => element(velocity));
  }

  @override
  void addListener(Function listener) {
    listeners.add(listener);
  }

  @override
  void removeListener(Function listener) {
    listeners.remove(listener);
  }
}

typedef OnSpringStateChange = void Function(SpringState);

class SpringSimulator {
  final TickerProvider vsync;
  final SpringConfiguration configuration;
  final OnSpringStateChange onSpringStateChange;
  final SpringSimulatorController? springSimulatorController;

  late final SpringState _state;
  late final Ticker _ticker;

  SpringSimulator({
    required this.vsync,
    required this.configuration,
    required this.onSpringStateChange,
    this.springSimulatorController,
    double? initialLength,
  }) : _state = SpringState(
          length: initialLength ?? 0,
          force: 0,
          velocity: 0,
        ) {
    springSimulatorController?.addListener(
      (double velocity) {
        // TODO: Not sure if this is the best way to do this
        if (velocity.abs() > _state.velocity.abs()) {
          _state.velocity = velocity;
        }
      },
    );
    _ticker = vsync.createTicker((elapsed) {
      final displacement = _state.length;
      final force = (-configuration.k) * displacement;

      final acceleration = force / configuration.mass;

      // Not sure if this correct (adding acceleration and velocity)
      final deltaPosition = (_state.velocity + acceleration);

      _state.length += deltaPosition;
      _state.velocity +=
          acceleration + -(configuration.damping * _state.velocity);

      onSpringStateChange(_state);
    });
    _ticker.start();
  }

  void dispose() {
    _ticker.dispose();
  }
}
