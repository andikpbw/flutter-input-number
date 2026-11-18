import 'package:flutter/foundation.dart';

import '../utils/number_math.dart';

/// Signature for a custom number formatter function.
typedef InputNumberFormatterCallback = String Function(num? value);

/// Signature for a custom number parser function.
typedef InputNumberParserCallback = num? Function(String text);

/// Defines the arrangement of increment and decrement stepper buttons
/// in an `InputNumber` widget.
enum InputNumberButtonLayout {
  /// Decrement button on the leading edge, text input in the center,
  /// and increment button on the trailing edge (`[-] 123 [+]`).
  split,

  /// Text input on the leading side and vertically stacked increment (top)
  /// and decrement (bottom) buttons on the trailing edge (`123 [▲/▼]`).
  stackedEnd,

  /// Text input on the leading side and side-by-side decrement and increment
  /// buttons on the trailing edge (`123 [-][+]`).
  inlineEnd,

  /// Hides both stepper buttons, rendering only the numeric text input.
  none,
}

/// Defines the preset size dimensions for an `InputNumber` widget.
enum InputNumberSize {
  /// Compact height (`34.0` logical pixels by default).
  small,

  /// Standard height (`42.0` logical pixels by default).
  medium,

  /// Prominent height (`50.0` logical pixels by default).
  large,
}

/// Defines the visual container variant for an `InputNumber` widget.
enum InputNumberVariant {
  /// Rounded rectangle container with an outline border and focus ring.
  outlined,

  /// Soft surface-tinted background container.
  filled,

  /// Minimalist bottom-border container.
  underlined,

  /// Stadium/capsule shaped container with fully rounded ends.
  pill,
}

/// Configuration for formatting and parsing numeric values in `InputNumber`.
///
/// Supports thousand grouping separators, custom decimal separators,
/// text prefixes and suffixes (such as currency symbols or measurement units),
/// fixed decimal padding, and custom formatter/parser callbacks.
@immutable
class InputNumberFormat {
  /// Creates a numeric formatting configuration.
  const InputNumberFormat({
    this.thousandSeparator,
    this.decimalSeparator = '.',
    this.prefix = '',
    this.suffix = '',
    this.padDecimals = false,
    this.customFormatter,
    this.customParser,
  }) : assert(
          decimalSeparator != thousandSeparator,
          'decimalSeparator and thousandSeparator must not be identical.',
        );

  /// Creates a standard ungrouped format using `.` as the decimal separator.
  const InputNumberFormat.standard()
      : thousandSeparator = null,
        decimalSeparator = '.',
        prefix = '',
        suffix = '',
        padDecimals = false,
        customFormatter = null,
        customParser = null;

  /// Creates a grouped decimal format (e.g., `1,234,567.89`).
  const InputNumberFormat.decimal({
    this.thousandSeparator = ',',
    this.decimalSeparator = '.',
    this.padDecimals = false,
  })  : prefix = '',
        suffix = '',
        customFormatter = null,
        customParser = null,
        assert(
          decimalSeparator != thousandSeparator,
          'decimalSeparator and thousandSeparator must not be identical.',
        );

  /// Creates a currency format (e.g., `$1,234.50`, `€1,234.50`, or `£1,234.50`).
  const InputNumberFormat.currency({
    String symbol = r'$',
    this.thousandSeparator = ',',
    this.decimalSeparator = '.',
    this.padDecimals = true,
    bool symbolAtEnd = false,
  })  : prefix = symbolAtEnd ? '' : symbol,
        suffix = symbolAtEnd ? symbol : '',
        customFormatter = null,
        customParser = null,
        assert(
          decimalSeparator != thousandSeparator,
          'decimalSeparator and thousandSeparator must not be identical.',
        );

  /// Creates a European-style format using `.` for thousands and `,` for
  /// decimals (e.g., `1.250,50` or `€1.250,50`).
  const InputNumberFormat.european({
    String symbol = '',
    this.thousandSeparator = '.',
    this.decimalSeparator = ',',
    this.padDecimals = false,
    bool symbolAtEnd = false,
  })  : prefix = symbolAtEnd ? '' : symbol,
        suffix = symbolAtEnd ? symbol : '',
        customFormatter = null,
        customParser = null,
        assert(
          decimalSeparator != thousandSeparator,
          'decimalSeparator and thousandSeparator must not be identical.',
        );

  /// Creates a percentage format (e.g., `75.5%`).
  const InputNumberFormat.percentage({
    this.suffix = '%',
    this.thousandSeparator,
    this.decimalSeparator = '.',
    this.padDecimals = false,
  })  : prefix = '',
        customFormatter = null,
        customParser = null,
        assert(
          decimalSeparator != thousandSeparator,
          'decimalSeparator and thousandSeparator must not be identical.',
        );

  /// Creates a measurement unit format (e.g., `1,250 kg`, `100 px`, `24.5 °C`).
  const InputNumberFormat.unit({
    required String unit,
    this.thousandSeparator = ',',
    this.decimalSeparator = '.',
    this.padDecimals = false,
    bool spaceBeforeUnit = true,
  })  : prefix = '',
        suffix = spaceBeforeUnit ? ' $unit' : unit,
        customFormatter = null,
        customParser = null,
        assert(
          decimalSeparator != thousandSeparator,
          'decimalSeparator and thousandSeparator must not be identical.',
        );

  /// Optional character used to group thousands (e.g., `','` or `'.'`).
  ///
  /// When `null` or empty, no thousand grouping is applied.
  final String? thousandSeparator;

  /// Character used to separate the integer part from the fractional part.
  ///
  /// Defaults to `'.'`.
  final String decimalSeparator;

  /// Text prepended to the formatted number (e.g., `'$'` or `'€'`).
  final String prefix;

  /// Text appended to the formatted number (e.g., `'%'` or `' kg'`).
  final String suffix;

  /// Whether to pad trailing decimal zeros when `precision` is greater than 0.
  final bool padDecimals;

  /// Optional callback that overrides the built-in display formatting logic.
  final InputNumberFormatterCallback? customFormatter;

  /// Optional callback that overrides the built-in text parsing logic.
  final InputNumberParserCallback? customParser;

  /// Formats [value] into a display string according to this configuration.
  ///
  /// When [includeAffixes] is `false`, [prefix] and [suffix] are omitted
  /// (useful while the user is actively editing the raw text field).
  String format(
    num? value, {
    int? precision,
    bool includeAffixes = true,
  }) {
    if (customFormatter != null && includeAffixes) {
      return customFormatter!(value);
    }
    if (value == null || value.isNaN || value.isInfinite) {
      return '';
    }

    final rounded = precision != null
        ? NumberMath.roundToPrecision(value, precision)
        : value;
    final isNegative = rounded < 0;
    final absValue = rounded.abs();

    String rawNumber;
    if (precision != null && precision == 0) {
      rawNumber = absValue.round().toString();
    } else if (precision != null && padDecimals) {
      rawNumber = absValue.toStringAsFixed(precision.clamp(0, 15));
    } else if (precision != null) {
      rawNumber = absValue.toStringAsFixed(precision.clamp(0, 15));
      if (rawNumber.contains('.')) {
        rawNumber = rawNumber.replaceFirst(RegExp(r'0+$'), '');
        rawNumber = rawNumber.replaceFirst(RegExp(r'\.$'), '');
      }
    } else if (absValue is int || absValue == absValue.roundToDouble()) {
      rawNumber = absValue.toInt().toString();
    } else {
      rawNumber = absValue.toString();
    }

    final parts = rawNumber.split('.');
    var integerPart = parts[0];
    final fractionalPart = parts.length > 1 ? parts[1] : null;

    final groupSep = thousandSeparator;
    if (groupSep != null && groupSep.isNotEmpty && integerPart.length > 3) {
      final buffer = StringBuffer();
      final length = integerPart.length;
      for (var i = 0; i < length; i++) {
        if (i > 0 && (length - i) % 3 == 0) {
          buffer.write(groupSep);
        }
        buffer.write(integerPart[i]);
      }
      integerPart = buffer.toString();
    }

    final formattedCore = fractionalPart != null && fractionalPart.isNotEmpty
        ? '$integerPart$decimalSeparator$fractionalPart'
        : integerPart;

    final sign = isNegative ? '-' : '';
    if (!includeAffixes) {
      return '$sign$formattedCore';
    }
    return '$sign$prefix$formattedCore$suffix';
  }

  /// Parses a user-entered or formatted [text] into a [num] value.
  ///
  /// Returns `null` if [text] is empty or cannot be parsed as a valid number.
  num? parse(String text) {
    if (customParser != null) {
      return customParser!(text);
    }
    var cleaned = text.trim();
    if (cleaned.isEmpty) {
      return null;
    }

    if (prefix.isNotEmpty) {
      cleaned = cleaned.replaceAll(prefix, '');
      final trimmedPrefix = prefix.trim();
      if (trimmedPrefix.isNotEmpty) {
        cleaned = cleaned.replaceAll(trimmedPrefix, '');
      }
    }
    if (suffix.isNotEmpty) {
      cleaned = cleaned.replaceAll(suffix, '');
      final trimmedSuffix = suffix.trim();
      if (trimmedSuffix.isNotEmpty) {
        cleaned = cleaned.replaceAll(trimmedSuffix, '');
      }
    }

    final groupSep = thousandSeparator;
    if (groupSep != null && groupSep.isNotEmpty) {
      cleaned = cleaned.replaceAll(groupSep, '');
    }

    if (decimalSeparator != '.') {
      cleaned = cleaned.replaceAll(decimalSeparator, '.');
    }

    cleaned = cleaned.replaceAll(' ', '');
    if (cleaned.isEmpty ||
        cleaned == '-' ||
        cleaned == '+' ||
        cleaned == '.' ||
        cleaned == '-.') {
      return null;
    }

    final intVal = int.tryParse(cleaned);
    if (intVal != null) {
      return intVal;
    }
    return double.tryParse(cleaned);
  }

  /// Creates a copy of this [InputNumberFormat] with the given fields replaced.
  InputNumberFormat copyWith({
    String? thousandSeparator,
    bool clearThousandSeparator = false,
    String? decimalSeparator,
    String? prefix,
    String? suffix,
    bool? padDecimals,
    InputNumberFormatterCallback? customFormatter,
    InputNumberParserCallback? customParser,
  }) {
    return InputNumberFormat(
      thousandSeparator: clearThousandSeparator
          ? null
          : (thousandSeparator ?? this.thousandSeparator),
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      padDecimals: padDecimals ?? this.padDecimals,
      customFormatter: customFormatter ?? this.customFormatter,
      customParser: customParser ?? this.customParser,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is InputNumberFormat &&
        other.thousandSeparator == thousandSeparator &&
        other.decimalSeparator == decimalSeparator &&
        other.prefix == prefix &&
        other.suffix == suffix &&
        other.padDecimals == padDecimals &&
        other.customFormatter == customFormatter &&
        other.customParser == customParser;
  }

  @override
  int get hashCode => Object.hash(
        thousandSeparator,
        decimalSeparator,
        prefix,
        suffix,
        padDecimals,
        customFormatter,
        customParser,
      );
}
