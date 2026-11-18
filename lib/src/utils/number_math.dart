import 'dart:math' as math;

/// Precision-safe numeric arithmetic utilities for [num] values.
///
/// Prevents common IEEE 754 floating-point precision artifacts such as
/// `0.1 + 0.2 = 0.30000000000000004` during stepping and formatting.
abstract final class NumberMath {
  /// Counts the number of decimal places in [value].
  ///
  /// Returns `0` for integers or whole numbers.
  static int countDecimals(num value) {
    if (value is int || value.isNaN || value.isInfinite) {
      return 0;
    }
    final text = value.toString().toLowerCase();
    if (text.contains('e-')) {
      final parts = text.split('e-');
      final exponent = int.tryParse(parts[1]) ?? 0;
      final mantissaParts = parts[0].split('.');
      final mantissaDecimals =
          mantissaParts.length > 1 ? mantissaParts[1].length : 0;
      return exponent + mantissaDecimals;
    }
    final dotIndex = text.indexOf('.');
    if (dotIndex == -1) {
      return 0;
    }
    final fraction = text.substring(dotIndex + 1);
    if (fraction == '0') {
      return 0;
    }
    return fraction.length;
  }

  /// Determines the effective decimal precision for an operation involving
  /// [a] and [b], respecting an optional [explicitPrecision].
  static int effectivePrecision({
    num? a,
    num? b,
    int? explicitPrecision,
  }) {
    if (explicitPrecision != null) {
      return explicitPrecision.clamp(0, 15);
    }
    final decA = a != null ? countDecimals(a) : 0;
    final decB = b != null ? countDecimals(b) : 0;
    return math.max(decA, decB).clamp(0, 15);
  }

  /// Rounds [value] to [precision] decimal places.
  ///
  /// If [precision] is `null`, [value] is returned unchanged.
  /// If [precision] is `0`, an [int] is returned.
  static num roundToPrecision(num value, int? precision) {
    if (value.isNaN || value.isInfinite || precision == null) {
      return value;
    }
    final clampedPrecision = precision.clamp(0, 15);
    if (clampedPrecision == 0) {
      return value.round();
    }
    final factor = math.pow(10, clampedPrecision);
    // Add a tiny epsilon scaled to the value magnitude to prevent half-way
    // binary representation issues like 1.005 * 100 = 100.49999999999999.
    final scaled = (value * factor) +
        (value >= 0 ? 1e-12 : -1e-12) * math.max(1, value.abs());
    final rounded = scaled.round() / factor;
    return double.parse(rounded.toStringAsFixed(clampedPrecision));
  }

  /// Adds [a] and [b] using decimal-safe precision rounding.
  ///
  /// Example:
  /// ```dart
  /// NumberMath.safeAdd(0.1, 0.2); // 0.3
  /// ```
  static num safeAdd(num a, num b, {int? precision}) {
    if (a is int && b is int && (precision == null || precision == 0)) {
      return a + b;
    }
    final targetPrecision = effectivePrecision(
      a: a,
      b: b,
      explicitPrecision: precision,
    );
    return roundToPrecision(a + b, targetPrecision);
  }

  /// Subtracts [b] from [a] using decimal-safe precision rounding.
  ///
  /// Example:
  /// ```dart
  /// NumberMath.safeSubtract(0.3, 0.1); // 0.2
  /// ```
  static num safeSubtract(num a, num b, {int? precision}) {
    if (a is int && b is int && (precision == null || precision == 0)) {
      return a - b;
    }
    final targetPrecision = effectivePrecision(
      a: a,
      b: b,
      explicitPrecision: precision,
    );
    return roundToPrecision(a - b, targetPrecision);
  }

  /// Clamps [value] between [min] and [max] (when provided) and applies
  /// [precision] rounding.
  static num clampValue(
    num value, {
    num? min,
    num? max,
    int? precision,
  }) {
    var result = value;
    if (min != null && result < min) {
      result = min;
    }
    if (max != null && result > max) {
      result = max;
    }
    if (precision != null) {
      result = roundToPrecision(result, precision);
    } else if (result is double &&
        result == result.roundToDouble() &&
        (min is int || min == null) &&
        (max is int || max == null) &&
        value is int) {
      result = result.toInt();
    }
    return result;
  }

  /// Snaps [value] to the nearest valid multiple of [step] relative to [base].
  static num snapToStep(
    num value, {
    required num step,
    num? base,
    int? precision,
  }) {
    if (step <= 0) {
      return roundToPrecision(value, precision);
    }
    final origin = base ?? 0;
    final steps = ((value - origin) / step).round();
    final targetPrecision = precision ??
        effectivePrecision(
          a: step,
          b: origin,
        );
    return roundToPrecision(origin + (steps * step), targetPrecision);
  }
}
