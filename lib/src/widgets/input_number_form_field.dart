import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../controller/input_number_controller.dart';
import '../models/input_number_config.dart';
import '../theme/input_number_style.dart';
import 'input_number.dart';

/// A [FormField] that contains an [InputNumber] widget.
///
/// Integrates [InputNumber] with Flutter's [Form] validation, saving,
/// resetting, and error message display lifecycle.
///
/// Example:
/// ```dart
/// InputNumberFormField(
///   initialValue: 1,
///   min: 1,
///   max: 10,
///   labelText: 'Quantity',
///   validator: (value) {
///     if (value == null) return 'Quantity is required';
///     if (value < 1) return 'Must be at least 1';
///     return null;
///   },
///   onSaved: (value) => debugPrint('Saved: $value'),
/// )
/// ```
class InputNumberFormField extends FormField<num> {
  /// Creates an [InputNumberFormField] wrapping an [InputNumber] widget.
  InputNumberFormField({
    this.controller,
    num? initialValue,
    num? min,
    num? max,
    num? step,
    num? largeStep,
    int? precision,
    ValueChanged<num?>? onChanged,
    ValueChanged<num?>? onSubmitted,
    ValueChanged<num>? onStep,
    InputNumberFormat format = const InputNumberFormat.standard(),
    InputNumberButtonLayout buttonLayout = InputNumberButtonLayout.split,
    InputNumberSize size = InputNumberSize.medium,
    InputNumberVariant variant = InputNumberVariant.outlined,
    InputNumberStyle style = const InputNumberStyle(),
    FocusNode? focusNode,
    super.enabled = true,
    bool readOnly = false,
    bool autofocus = false,
    bool allowEmpty = true,
    bool clampOnBlur = true,
    bool snapToStepOnBlur = false,
    bool selectAllOnFocus = false,
    bool enableLongPress = true,
    bool enableAcceleration = true,
    Duration longPressInitialDelay = const Duration(milliseconds: 400),
    Duration longPressInterval = const Duration(milliseconds: 110),
    bool enableKeyboardStep = true,
    bool enableMouseWheel = true,
    bool mouseWheelRequiresFocus = true,
    bool enableHaptics = false,
    bool showClearButton = false,
    String? hintText,
    String? labelText,
    String? helperText,
    String? semanticLabel,
    String incrementSemanticLabel = 'Increment',
    String decrementSemanticLabel = 'Decrement',
    Widget? prefixWidget,
    Widget? suffixWidget,
    Widget? leading,
    Widget? trailing,
    TextInputAction? textInputAction,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.restorationId,
    super.forceErrorText,
    super.key,
  }) : super(
          initialValue: controller != null ? controller.value : initialValue,
          builder: (field) {
            final state = field as _InputNumberFormFieldState;
            return InputNumber(
              controller: state._effectiveController,
              min: min,
              max: max,
              step: step,
              largeStep: largeStep,
              precision: precision,
              format: format,
              buttonLayout: buttonLayout,
              size: size,
              variant: variant,
              style: style,
              focusNode: focusNode,
              enabled: enabled,
              readOnly: readOnly,
              autofocus: autofocus,
              allowEmpty: allowEmpty,
              clampOnBlur: clampOnBlur,
              snapToStepOnBlur: snapToStepOnBlur,
              selectAllOnFocus: selectAllOnFocus,
              enableLongPress: enableLongPress,
              enableAcceleration: enableAcceleration,
              longPressInitialDelay: longPressInitialDelay,
              longPressInterval: longPressInterval,
              enableKeyboardStep: enableKeyboardStep,
              enableMouseWheel: enableMouseWheel,
              mouseWheelRequiresFocus: mouseWheelRequiresFocus,
              enableHaptics: enableHaptics,
              showClearButton: showClearButton,
              hintText: hintText,
              labelText: labelText,
              helperText: helperText,
              errorText: field.errorText,
              semanticLabel: semanticLabel,
              incrementSemanticLabel: incrementSemanticLabel,
              decrementSemanticLabel: decrementSemanticLabel,
              prefixWidget: prefixWidget,
              suffixWidget: suffixWidget,
              leading: leading,
              trailing: trailing,
              textInputAction: textInputAction,
              onChanged: (val) {
                field.didChange(val);
                onChanged?.call(val);
              },
              onSubmitted: onSubmitted,
              onStep: onStep,
            );
          },
        );

  /// Optional external [InputNumberController] synchronized with this form field.
  final InputNumberController? controller;

  @override
  FormFieldState<num> createState() => _InputNumberFormFieldState();
}

class _InputNumberFormFieldState extends FormFieldState<num> {
  InputNumberController? _internalController;

  InputNumberFormField get _formField => widget as InputNumberFormField;

  InputNumberController get _effectiveController =>
      _formField.controller ?? _internalController!;

  @override
  void initState() {
    super.initState();
    if (_formField.controller == null) {
      _internalController = InputNumberController(
        value: widget.initialValue,
      );
    } else {
      _formField.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(covariant InputNumberFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_formField.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      if (_formField.controller != null) {
        _internalController?.dispose();
        _internalController = null;
        _formField.controller!.addListener(_handleControllerChanged);
        setValue(_formField.controller!.value);
      } else {
        _internalController = InputNumberController(
          value: oldWidget.controller?.value ?? widget.initialValue,
        );
      }
    }
  }

  @override
  void dispose() {
    _formField.controller?.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    super.dispose();
  }

  @override
  void didChange(num? value) {
    super.didChange(value);
    if (_effectiveController.value != value) {
      _effectiveController.setValue(value);
    }
  }

  @override
  void reset() {
    super.reset();
    _effectiveController.setValue(widget.initialValue);
  }

  void _handleControllerChanged() {
    if (_effectiveController.value != value) {
      didChange(_effectiveController.value);
    }
  }
}
