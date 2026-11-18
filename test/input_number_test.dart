import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:input_number/input_number.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('NumberMath', () {
    test('countDecimals handles integers, decimals, and scientific notation',
        () {
      expect(NumberMath.countDecimals(10), 0);
      expect(NumberMath.countDecimals(10.0), 0);
      expect(NumberMath.countDecimals(0.125), 3);
      expect(NumberMath.countDecimals(1e-5), 5);
    });

    test('safeAdd and safeSubtract eliminate IEEE 754 drift', () {
      expect(NumberMath.safeAdd(0.1, 0.2), 0.3);
      expect(NumberMath.safeSubtract(0.3, 0.1), 0.2);
      expect(NumberMath.safeAdd(1, 2), isA<int>());
      expect(NumberMath.safeAdd(1, 2), 3);
      expect(NumberMath.safeSubtract(5, 2), 3);
    });

    test('roundToPrecision rounds accurately', () {
      expect(NumberMath.roundToPrecision(1.005, 2), 1.01);
      expect(NumberMath.roundToPrecision(3.6, 0), 4);
      expect(NumberMath.roundToPrecision(2.345, null), 2.345);
    });

    test('clampValue and snapToStep work as expected', () {
      expect(NumberMath.clampValue(150, min: 0, max: 100), 100);
      expect(NumberMath.clampValue(-5, min: 0, max: 100), 0);
      expect(NumberMath.snapToStep(13, step: 5, base: 0), 15);
      expect(NumberMath.snapToStep(12, step: 5, base: 0), 10);
    });
  });

  group('InputNumberFormat', () {
    test(
        'standard, decimal, currency, idr, and percentage presets format and parse',
        () {
      const currency = InputNumberFormat.currency();
      expect(currency.format(1234.5, precision: 2), r'$1,234.50');
      expect(currency.format(-1234.5, precision: 2), r'-$1,234.50');
      expect(currency.parse(r'$1,234.50'), 1234.5);
      expect(currency.parse(r'-$1,234.50'), -1234.5);

      const idr = InputNumberFormat.idr();
      expect(idr.format(1500000, precision: 0), 'Rp 1.500.000');
      expect(idr.parse('Rp 1.500.000'), 1500000);

      const pct = InputNumberFormat.percentage();
      expect(pct.format(75.5, precision: 1), '75.5%');
      expect(pct.parse('75.5%'), 75.5);

      const dec = InputNumberFormat.decimal();
      expect(dec.format(9876543.21), '9,876,543.21');
      expect(dec.parse('9,876,543.21'), 9876543.21);
    });

    test('copyWith and equality work properly', () {
      const formatA = InputNumberFormat.currency();
      final formatB = formatA.copyWith(prefix: '€');
      expect(formatA == formatA.copyWith(), isTrue);
      expect(formatA == formatB, isFalse);
      expect(formatB.format(100, precision: 2), '€100.00');
    });
  });

  group('NumericTextInputFormatter', () {
    test('sanitizes invalid characters and respects negative and decimal rules',
        () {
      const formatter = NumericTextInputFormatter(
        allowNegative: true,
        allowDecimal: true,
        maxDecimalDigits: 2,
      );

      final result1 = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '-12a3.4567'),
      );
      expect(result1.text, '-123.45');

      const positiveIntFormatter = NumericTextInputFormatter(
        allowNegative: false,
        allowDecimal: false,
      );
      final result2 = positiveIntFormatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '-0042.99'),
      );
      expect(result2.text, '4299');
    });
  });

  group('InputNumberController', () {
    test('manages value, bounds, increment, decrement, reset, and clear', () {
      final controller = InputNumberController(
        value: 10,
        min: 0,
        max: 20,
        step: 5,
      );

      expect(controller.value, 10);
      expect(controller.intValue, 10);
      expect(controller.doubleValue, 10.0);
      expect(controller.canIncrement, isTrue);
      expect(controller.canDecrement, isTrue);

      expect(controller.increment(), 15);
      expect(controller.increment(), 20);
      expect(controller.isAtMax, isTrue);
      expect(controller.canIncrement, isFalse);

      expect(controller.decrement(15), 5);
      expect(controller.decrement(10), 0);
      expect(controller.isAtMin, isTrue);
      expect(controller.canDecrement, isFalse);

      controller.reset();
      expect(controller.value, 10);

      controller.clear();
      expect(controller.value, isNull);
      expect(controller.hasValue, isFalse);

      // Stepping from null initializes to baseline within bounds.
      expect(controller.increment(), 0);

      controller.updateBounds(min: 12, max: 50);
      expect(controller.value, 12);

      controller.dispose();
    });
  });

  group('InputNumber widget', () {
    testWidgets('increments and decrements on stepper button taps',
        (tester) async {
      num? latestValue;
      final controller = InputNumberController(
        value: 2,
        min: 0,
        max: 4,
        step: 1,
      );

      await tester.pumpWidget(
        _wrap(
          InputNumber(
            controller: controller,
            onChanged: (val) => latestValue = val,
          ),
        ),
      );

      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      expect(controller.value, 3);
      expect(latestValue, 3);
      expect(find.text('3'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pump();
      expect(controller.value, 2);
      expect(latestValue, 2);

      controller.dispose();
    });

    testWidgets('handles decimal precision stepping without drift',
        (tester) async {
      final controller = InputNumberController(
        value: 0.1,
        min: 0,
        max: 1,
        step: 0.2,
        precision: 2,
      );

      await tester.pumpWidget(
        _wrap(
          InputNumber(controller: controller),
        ),
      );

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      expect(controller.value, 0.3);
      expect(find.text('0.3'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('supports manual text input and clamps on blur',
        (tester) async {
      final controller = InputNumberController(
        value: 10,
        min: 5,
        max: 50,
      );
      final focusNode = FocusNode();

      await tester.pumpWidget(
        _wrap(
          InputNumber(
            controller: controller,
            focusNode: focusNode,
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '25');
      await tester.pump();
      expect(controller.value, 25);

      // Enter out-of-range value and unfocus to trigger clampOnBlur.
      await tester.enterText(find.byType(TextField), '999');
      await tester.pump();
      focusNode.unfocus();
      await tester.pump();

      expect(controller.value, 50);
      expect(find.text('50'), findsOneWidget);

      focusNode.dispose();
      controller.dispose();
    });

    testWidgets('supports keyboard ArrowUp, ArrowDown, PageUp, and PageDown',
        (tester) async {
      final controller = InputNumberController(
        value: 10,
        min: 0,
        max: 100,
        step: 2,
      );

      await tester.pumpWidget(
        _wrap(
          InputNumber(
            controller: controller,
            autofocus: true,
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      expect(controller.value, 12);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(controller.value, 10);

      await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
      await tester.pump();
      expect(controller.value, 30);

      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.pump();
      expect(controller.value, 10);

      controller.dispose();
    });

    testWidgets('supports mouse wheel scroll when focused', (tester) async {
      final controller = InputNumberController(
        value: 10,
        min: 0,
        max: 100,
        step: 5,
      );

      await tester.pumpWidget(
        _wrap(
          InputNumber(
            controller: controller,
            autofocus: true,
          ),
        ),
      );
      await tester.pump();

      final center = tester.getCenter(find.byType(InputNumber));
      final testPointer = TestPointer(1, PointerDeviceKind.mouse);
      testPointer.hover(center);

      // Scroll up -> increment
      await tester.sendEventToBinding(
        testPointer.scroll(const Offset(0, -20)),
      );
      await tester.pump();
      expect(controller.value, 15);

      // Scroll down -> decrement
      await tester.sendEventToBinding(
        testPointer.scroll(const Offset(0, 20)),
      );
      await tester.pump();
      expect(controller.value, 10);

      controller.dispose();
    });

    testWidgets('supports long-press continuous auto-repeat', (tester) async {
      final controller = InputNumberController(
        value: 0,
        min: 0,
        max: 100,
        step: 1,
      );

      await tester.pumpWidget(
        _wrap(
          InputNumber(
            controller: controller,
            longPressInitialDelay: const Duration(milliseconds: 200),
            longPressInterval: const Duration(milliseconds: 80),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byIcon(Icons.add_rounded)),
      );
      await tester.pump();
      expect(controller.value, 1);

      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.value! > 2, isTrue);

      await gesture.up();
      await tester.pump();

      controller.dispose();
    });

    testWidgets('renders all button layouts, variants, sizes, and clear button',
        (tester) async {
      final controller = InputNumberController(value: 42);

      await tester.pumpWidget(
        _wrap(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputNumber(
                controller: controller,
                buttonLayout: InputNumberButtonLayout.stackedEnd,
                variant: InputNumberVariant.filled,
                size: InputNumberSize.small,
                showClearButton: true,
              ),
              const InputNumber(
                initialValue: 10,
                buttonLayout: InputNumberButtonLayout.inlineEnd,
                variant: InputNumberVariant.pill,
                size: InputNumberSize.large,
              ),
              const InputNumber(
                initialValue: 5,
                buttonLayout: InputNumberButtonLayout.none,
                variant: InputNumberVariant.underlined,
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.keyboard_arrow_up_rounded), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
      expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.cancel_rounded));
      await tester.pump();
      expect(controller.value, isNull);

      controller.dispose();
    });
  });

  group('InputNumberFormField', () {
    testWidgets('validates, saves, and resets inside a Form', (tester) async {
      final formKey = GlobalKey<FormState>();
      num? savedValue;

      await tester.pumpWidget(
        _wrap(
          Form(
            key: formKey,
            child: InputNumberFormField(
              initialValue: 2,
              min: 0,
              max: 20,
              labelText: 'Quantity',
              validator: (val) {
                if (val == null || val < 5) {
                  return 'Minimum 5 required';
                }
                return null;
              },
              onSaved: (val) => savedValue = val,
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Minimum 5 required'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '10');
      await tester.pump();

      expect(formKey.currentState!.validate(), isTrue);
      await tester.pump();
      expect(find.text('Minimum 5 required'), findsNothing);

      formKey.currentState!.save();
      expect(savedValue, 10);

      formKey.currentState!.reset();
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
    });
  });
}
