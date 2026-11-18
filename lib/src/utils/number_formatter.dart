import 'dart:math' as math;
import 'package:flutter/services.dart';

/// A [TextInputFormatter] that restricts input to valid numeric representations.
///
/// Supports optional negative signs, configurable decimal separators,
/// thousand separator stripping on paste, and maximum fractional digit limits.
class NumericTextInputFormatter extends TextInputFormatter {
  /// Creates a [NumericTextInputFormatter].
  const NumericTextInputFormatter({
    this.allowNegative = true,
    this.allowDecimal = true,
    this.maxDecimalDigits,
    this.decimalSeparator = '.',
    this.thousandSeparator,
  });

  /// Whether negative numbers (a leading `-`) are permitted.
  final bool allowNegative;

  /// Whether fractional decimal values are permitted.
  final bool allowDecimal;

  /// Maximum number of digits allowed after the [decimalSeparator].
  ///
  /// When `null`, any number of decimal digits is allowed (provided
  /// [allowDecimal] is `true`).
  final int? maxDecimalDigits;

  /// Character used as the decimal separator (defaults to `'.'`).
  final String decimalSeparator;

  /// Optional character used as the thousand separator to strip when pasting.
  final String? thousandSeparator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text;
    if (raw.isEmpty) {
      return newValue;
    }

    final buffer = StringBuffer();
    var hasNegative = false;
    var hasDecimal = false;
    var decimalCount = 0;

    for (var i = 0; i < raw.length; i++) {
      final char = raw[i];

      // Allow leading negative sign.
      if (char == '-') {
        if (allowNegative && buffer.isEmpty && !hasNegative) {
          hasNegative = true;
          buffer.write('-');
        }
        continue;
      }

      // Skip thousand separator characters if present (e.g. from clipboard paste).
      if (thousandSeparator != null &&
          thousandSeparator!.isNotEmpty &&
          char == thousandSeparator) {
        continue;
      }

      // Handle decimal separator.
      final isConfiguredDecimal = char == decimalSeparator;
      final isFallbackDot =
          char == '.' && thousandSeparator != '.' && decimalSeparator != '.';
      if (isConfiguredDecimal || isFallbackDot) {
        if (allowDecimal &&
            !hasDecimal &&
            (maxDecimalDigits == null || maxDecimalDigits! > 0)) {
          if (buffer.isEmpty || (buffer.length == 1 && hasNegative)) {
            buffer.write('0');
          }
          hasDecimal = true;
          buffer.write(decimalSeparator);
        }
        continue;
      }

      // Allow digits 0-9.
      final code = char.codeUnitAt(0);
      if (code >= 48 && code <= 57) {
        if (hasDecimal) {
          if (maxDecimalDigits != null && decimalCount >= maxDecimalDigits!) {
            continue;
          }
          decimalCount++;
        }
        buffer.write(char);
      }
    }

    final sanitized = buffer.toString();

    // Prevent superfluous leading zeros like "00" or "-00" before a decimal.
    final normalized = _normalizeLeadingZeros(sanitized);

    final selectionIndex = math.min(
      normalized.length,
      math.max(
        0,
        newValue.selection.end - (raw.length - normalized.length),
      ),
    );

    return TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }

  String _normalizeLeadingZeros(String input) {
    if (input.isEmpty) {
      return input;
    }
    final isNeg = input.startsWith('-');
    final body = isNeg ? input.substring(1) : input;
    if (body.length <= 1) {
      return input;
    }
    final decIndex = body.indexOf(decimalSeparator);
    final intPart = decIndex == -1 ? body : body.substring(0, decIndex);
    final rest = decIndex == -1 ? '' : body.substring(decIndex);

    if (intPart.length > 1 && intPart.startsWith('0')) {
      final stripped = intPart.replaceFirst(RegExp(r'^0+'), '');
      final effectiveInt = stripped.isEmpty ? '0' : stripped;
      return '${isNeg ? '-' : ''}$effectiveInt$rest';
    }
    return input;
  }
}
