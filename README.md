# input_number

[![pub package](https://img.shields.io/pub/v/input_number.svg)](https://pub.dev/packages/input_number)
[![License: MIT](https://img.shields.io/badge/License-MIT-indigo.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20macos%20%7C%20windows%20%7C%20linux-blue.svg)](https://pub.dev/packages/input_number)

A modern, customizable, and zero-dependency numeric input and stepper widget library for Flutter. Built for Material 3 with precision-safe decimal arithmetic, flexible stepper button layouts, currency & locale formatting, long-press turbo acceleration, keyboard/mouse wheel navigation, and full `FormField` support.

Sponsored and supported by **[Humanize AI](https://humanize.id)**.

---

## Features

- **Precision-Safe Decimal Math**: Eliminates IEEE 754 floating-point drift (`0.1 + 0.2 == 0.3` guaranteed) via `NumberMath`.
- **4 Stepper Button Layouts**:
  - `InputNumberButtonLayout.split` (`[-] 12 [+]`) — ideal for mobile & e-commerce quantity pickers.
  - `InputNumberButtonLayout.stackedEnd` (`12 [▲/▼]`) — classic desktop spinbox layout.
  - `InputNumberButtonLayout.inlineEnd` (`12 [-][+]`) — compact trailing actions.
  - `InputNumberButtonLayout.none` — clean numeric field with keyboard/wheel stepping.
- **4 Visual Variants & 3 Sizes**:
  - `outlined`, `filled`, `underlined`, and `pill` (stadium capsule).
  - `small`, `medium`, and `large` presets with full override support via `InputNumberStyle`.
- **Built-in Formatting & Presets (`InputNumberFormat`)**:
  - Thousand grouping separators (`,` or `.`), custom decimal separators, prefixes, suffixes, and fixed decimal padding.
  - Ready-to-use presets: `InputNumberFormat.standard()`, `InputNumberFormat.decimal()`, `InputNumberFormat.currency()`, `InputNumberFormat.idr()`, and `InputNumberFormat.percentage()`.
- **Long-Press Auto-Repeat with Turbo Acceleration**: Hold down `+` or `-` to step continuously with progressive speed-up.
- **Desktop & Web Ready**:
  - `ArrowUp` / `ArrowDown` for standard step, `PageUp` / `PageDown` for `largeStep`.
  - Mouse scroll wheel stepping when focused.
- **Seamless Form Integration**: `InputNumberFormField` integrates directly with Flutter's `Form`, `validator`, `onSaved`, `reset`, and `AutovalidateMode`.
- **Rich Controller API**: `InputNumberController` extends `ValueNotifier<num?>` with `increment()`, `decrement()`, `setValue()`, `reset()`, `clear()`, and dynamic bound updates.

---

## Installation

Add `input_number` to your `pubspec.yaml`:

```yaml
dependencies:
  input_number: ^1.0.0
```

Or install via the Flutter CLI:

```bash
flutter pub add input_number
```

---

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:input_number/input_number.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return InputNumber(
      labelText: 'Quantity',
      initialValue: 1,
      min: 1,
      max: 99,
      step: 1,
      onChanged: (value) {
        debugPrint('Current value: $value');
      },
    );
  }
}
```

---

## Usage Examples

### 1. Button Layouts & Visual Variants

```dart
// Desktop SpinBox style with stacked buttons on the right
InputNumber(
  initialValue: 10,
  min: 0,
  max: 100,
  buttonLayout: InputNumberButtonLayout.stackedEnd,
  variant: InputNumberVariant.outlined,
)

// Pill / Capsule style for shopping cart items
InputNumber(
  initialValue: 2,
  min: 1,
  max: 20,
  size: InputNumberSize.large,
  buttonLayout: InputNumberButtonLayout.split,
  variant: InputNumberVariant.pill,
)
```

### 2. Currency, Rupiah (IDR), and Percentage Formatting

```dart
// USD Currency ($1,250.50)
InputNumber(
  labelText: 'Price (USD)',
  initialValue: 1250.5,
  min: 0,
  step: 10,
  precision: 2,
  format: const InputNumberFormat.currency(symbol: r'$'),
)

// Indonesian Rupiah (Rp 1.500.000)
InputNumber(
  labelText: 'Harga (IDR)',
  initialValue: 1500000,
  min: 0,
  step: 50000,
  precision: 0,
  format: const InputNumberFormat.idr(),
)

// Percentage (75.5%)
InputNumber(
  labelText: 'Discount',
  initialValue: 15.5,
  min: 0,
  max: 100,
  step: 0.5,
  precision: 1,
  format: const InputNumberFormat.percentage(),
)
```

### 3. Programmatic Control with `InputNumberController`

```dart
final controller = InputNumberController(
  value: 10,
  min: 0,
  max: 100,
  step: 5,
);

// Listen to changes or bind to ValueListenableBuilder<num?>
InputNumber(
  controller: controller,
  showClearButton: true,
);

// Programmatic actions
controller.increment();     // 15
controller.decrement(2);    // 13
controller.setValue(80);    // 80
controller.reset();         // 10
controller.clear();         // null
```

### 4. Form Validation with `InputNumberFormField`

```dart
InputNumberFormField(
  labelText: 'Order Units',
  initialValue: 5,
  min: 1,
  max: 100,
  step: 1,
  precision: 0,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  validator: (value) {
    if (value == null) return 'Quantity is required';
    if (value < 5) return 'Minimum order is 5 units';
    return null;
  },
  onSaved: (value) {
    debugPrint('Saved order quantity: $value');
  },
)
```

### 5. Custom Styling with `InputNumberStyle`

```dart
InputNumber(
  initialValue: 42,
  style: InputNumberStyle(
    height: 48,
    borderRadius: BorderRadius.circular(14),
    focusedBorderColor: Colors.teal,
    buttonHoverColor: Colors.teal.withValues(alpha: 0.1),
    incrementIcon: Icons.add_circle_outline_rounded,
    decrementIcon: Icons.remove_circle_outline_rounded,
  ),
)
```

---

## Keyboard & Mouse Shortcuts

| Interaction | Action |
| :--- | :--- |
| **Tap `+` / `-`** | Increments or decrements by `step` |
| **Long-press `+` / `-`** | Continuous auto-repeat with optional turbo acceleration |
| **`ArrowUp` / `ArrowDown`** | Increments or decrements by `step` when focused |
| **`PageUp` / `PageDown`** | Increments or decrements by `largeStep` (`step * 10` by default) |
| **Mouse Wheel Up / Down** | Increments or decrements by `step` when focused |

---

## Support & Sponsor

This open-source library is proudly supported by **[Humanize AI](https://humanize.id)** — platform AI Humanizer modern untuk mengubah teks AI menjadi tulisan natural dan manusiawi.

- Website: [Humanize AI](https://humanize.id)
- Repository: [https://github.com/andikpbw/flutter-input-number.git](https://github.com/andikpbw/flutter-input-number.git)
- Issue Tracker: [GitHub Issues](https://github.com/andikpbw/flutter-input-number/issues)

---

## License

Released under the [MIT License](LICENSE).
