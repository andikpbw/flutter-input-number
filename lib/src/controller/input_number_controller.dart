import 'package:flutter/foundation.dart';

import '../utils/number_math.dart';

/// A controller for an `InputNumber` widget that manages its numeric value,
/// bounds, step increment, and decimal precision.
///
/// Extends [ValueNotifier] so it can be observed directly with
/// `ValueListenableBuilder<num?>` or `ListenableBuilder`.
///
/// Example:
/// ```dart
/// final controller = InputNumberController(
///   value: 10,
///   min: 0,
///   max: 100,
///   step: 5,
/// );
/// controller.increment(); // 15
/// controller.decrement(); // 10
/// ```
class InputNumberController extends ValueNotifier<num?> {
  /// Creates an [InputNumberController] with optional initial [value],
  /// [min] and [max] bounds, [step] increment, and decimal [precision].
  InputNumberController({
    num? value,
    num? min,
    num? max,
    num step = 1,
    int? precision,
  })  : assert(step > 0, 'step must be greater than 0.'),
        assert(
          min == null || max == null || min <= max,
          'min must be less than or equal to max.',
        ),
        assert(
          precision == null || (precision >= 0 && precision <= 15),
          'precision must be between 0 and 15.',
        ),
        _initialValue = value,
        _min = min,
        _max = max,
        _step = step,
        _precision = precision,
        super(
          value != null
              ? NumberMath.clampValue(
                  value,
                  min: min,
                  max: max,
                  precision: precision,
                )
              : null,
        );

  final num? _initialValue;
  num? _min;
  num? _max;
  num _step;
  int? _precision;

  /// The initial value provided when this controller was constructed.
  num? get initialValue => _initialValue;

  /// Minimum allowed numeric value, or `null` if unbounded below.
  num? get min => _min;

  /// Maximum allowed numeric value, or `null` if unbounded above.
  num? get max => _max;

  /// Default increment and decrement step size.
  num get step => _step;

  /// Number of decimal places to round values to, or `null` for automatic
  /// precision based on operands.
  int? get precision => _precision;

  /// Returns the current [value] rounded to an [int], or `null` if empty.
  int? get intValue => value?.round();

  /// Returns the current [value] converted to a [double], or `null` if empty.
  double? get doubleValue => value?.toDouble();

  /// Whether a non-null numeric value is currently held.
  bool get hasValue => value != null;

  /// Whether the current [value] is at or below [min].
  bool get isAtMin => _min != null && value != null && value! <= _min!;

  /// Whether the current [value] is at or above [max].
  bool get isAtMax => _max != null && value != null && value! >= _max!;

  /// Whether the value can be incremented further without exceeding [max].
  bool get canIncrement {
    if (_max == null) {
      return true;
    }
    final current = value;
    if (current == null) {
      return true;
    }
    return current < _max!;
  }

  /// Whether the value can be decremented further without falling below [min].
  bool get canDecrement {
    if (_min == null) {
      return true;
    }
    final current = value;
    if (current == null) {
      return true;
    }
    return current > _min!;
  }

  @override
  set value(num? newValue) {
    setValue(newValue);
  }

  /// Sets the current numeric [newValue].
  ///
  /// When [clamp] is `true` (the default), [newValue] is clamped between
  /// [min] and [max] and rounded to [precision].
  void setValue(num? newValue, {bool clamp = true}) {
    if (newValue == null) {
      super.value = null;
      return;
    }
    if (newValue.isNaN || newValue.isInfinite) {
      return;
    }
    final resolved = clamp
        ? NumberMath.clampValue(
            newValue,
            min: _min,
            max: _max,
            precision: _precision,
          )
        : (_precision != null
            ? NumberMath.roundToPrecision(newValue, _precision)
            : newValue);
    super.value = resolved;
  }

  /// Increments the current value by [customStep] (or [step] if omitted).
  ///
  /// If [value] is currently `null`, resolves to `0` (clamped to `[min, max]`)
  /// or [min] if `0` is outside the allowed range.
  ///
  /// Returns the updated numeric value.
  num increment([num? customStep]) {
    final delta = customStep ?? _step;
    assert(delta > 0, 'increment step must be greater than 0.');
    final current = value;
    final num next;
    if (current == null) {
      final baseline = _defaultBaseline();
      next = NumberMath.clampValue(
        baseline,
        min: _min,
        max: _max,
        precision: _precision,
      );
    } else {
      final sum = NumberMath.safeAdd(
        current,
        delta,
        precision: _precision,
      );
      next = NumberMath.clampValue(
        sum,
        min: _min,
        max: _max,
        precision: _precision,
      );
    }
    super.value = next;
    return next;
  }

  /// Decrements the current value by [customStep] (or [step] if omitted).
  ///
  /// If [value] is currently `null`, resolves to `0` (clamped to `[min, max]`)
  /// or [max] if `0` is outside the allowed range.
  ///
  /// Returns the updated numeric value.
  num decrement([num? customStep]) {
    final delta = customStep ?? _step;
    assert(delta > 0, 'decrement step must be greater than 0.');
    final current = value;
    final num next;
    if (current == null) {
      final baseline = _defaultBaseline();
      next = NumberMath.clampValue(
        baseline,
        min: _min,
        max: _max,
        precision: _precision,
      );
    } else {
      final diff = NumberMath.safeSubtract(
        current,
        delta,
        precision: _precision,
      );
      next = NumberMath.clampValue(
        diff,
        min: _min,
        max: _max,
        precision: _precision,
      );
    }
    super.value = next;
    return next;
  }

  /// Updates the constraints ([min], [max], [step], [precision]) on this
  /// controller and optionally clamps the current [value] to the new bounds.
  void updateBounds({
    num? min,
    bool clearMin = false,
    num? max,
    bool clearMax = false,
    num? step,
    int? precision,
    bool clearPrecision = false,
    bool clampCurrentValue = true,
  }) {
    final nextMin = clearMin ? null : (min ?? _min);
    final nextMax = clearMax ? null : (max ?? _max);
    final nextStep = step ?? _step;
    final nextPrecision = clearPrecision ? null : (precision ?? _precision);

    assert(nextStep > 0, 'step must be greater than 0.');
    assert(
      nextMin == null || nextMax == null || nextMin <= nextMax,
      'min must be less than or equal to max.',
    );
    assert(
      nextPrecision == null || (nextPrecision >= 0 && nextPrecision <= 15),
      'precision must be between 0 and 15.',
    );

    final changed = _min != nextMin ||
        _max != nextMax ||
        _step != nextStep ||
        _precision != nextPrecision;

    _min = nextMin;
    _max = nextMax;
    _step = nextStep;
    _precision = nextPrecision;

    if (clampCurrentValue && value != null) {
      final clamped = NumberMath.clampValue(
        value!,
        min: _min,
        max: _max,
        precision: _precision,
      );
      if (clamped != value) {
        super.value = clamped;
        return;
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  /// Resets [value] back to [initialValue].
  void reset() {
    setValue(_initialValue);
  }

  /// Clears [value] to `null`.
  void clear() {
    super.value = null;
  }

  num _defaultBaseline() {
    if (_min != null && 0 < _min!) {
      return _min!;
    }
    if (_max != null && 0 > _max!) {
      return _max!;
    }
    return 0;
  }
}
