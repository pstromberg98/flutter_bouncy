class SpringConfiguration {
  final double mass;
  final double k;
  final double damping;

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

class Spring {
  final SpringConfiguration configuration;

  final SpringState _state;

  SpringState get state => _state;

  Spring({
    required this.configuration,
    double? initialLength,
  }) : _state = SpringState(
          length: initialLength ?? 0,
          force: 0,
          velocity: 0,
        );

  void tick() {
    final displacement = _state.length;
    final force = (-configuration.k) * displacement;

    final acceleration = force / configuration.mass;

    // Not sure if this correct (adding acceleration and velocity)
    var deltaPosition = (_state.velocity + acceleration);

    // if (deltaPosition.abs() < 0.001) {
    //   deltaPosition = 0.0;
    // }

    final updatedLength = _state.length + deltaPosition;
    _state.velocity +=
        acceleration + -(configuration.damping * _state.velocity);

    if (updatedLength != _state.length) {
      _state.length = updatedLength;
    }
  }

  void addLength(double length) {
    final previousLength = _state.length;
    _state.length += length;
    _state.velocity = _state.length - previousLength;
  }

  void setVelocity(double velocity) {
    _state.velocity = velocity;
  }
}
