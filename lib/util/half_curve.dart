import 'package:flutter/animation.dart';

/// Makes a curve only animate in the second half of the animation.
class HalfCurve extends Curve {
  static const _interval = Interval(0.5, 1.0);
  final Curve animationCurve;

  const HalfCurve(this.animationCurve);

  @override
  double transformInternal(double t) {
    final mappedValue = _interval.transformInternal(t);
    return animationCurve.transformInternal(mappedValue);
  }
}
