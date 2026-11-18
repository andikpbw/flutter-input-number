import 'package:flutter/gestures.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/input_number_controller.dart';
import '../models/input_number_config.dart';
import '../theme/input_number_style.dart';
import '../utils/number_formatter.dart';
import '../utils/number_math.dart';
import 'stepper_button.dart';

/// A modern, customizable numeric input and stepper widget for Flutter.
///
/// Supports precision-safe decimal arithmetic, multiple stepper button
/// layouts ([InputNumberButtonLayout]), visual variants ([InputNumberVariant]),
/// sizes ([InputNumberSize]), custom number/currency formatting
/// ([InputNumberFormat]), long-press rapid stepping with turbo acceleration,
/// keyboard arrow/page shortcuts, and mouse wheel stepping.
///
/// Example:
/// ```dart
/// InputNumber(
///   initialValue: 1,
///   min: 0,
///   max: 99,
///   step: 1,
///   onChanged: (value) => debugPrint('Value: $value'),
/// )
/// ```
class InputNumber extends StatefulWidget {
  /// Creates an [InputNumber] widget.
  const InputNumber({
    this.controller,
    this.value,
    this.initialValue,
    this.min,
    this.max,
    this.step,
    this.largeStep,
    this.precision,
    this.onChanged,
    this.onSubmitted,
    this.onStep,
    this.format = const InputNumberFormat.standard(),
    this.buttonLayout = InputNumberButtonLayout.split,
    this.size = InputNumberSize.medium,
    this.variant = InputNumberVariant.outlined,
    this.style = const InputNumberStyle(),
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.allowEmpty = true,
    this.clampOnBlur = true,
    this.snapToStepOnBlur = false,
    this.selectAllOnFocus = false,
    this.enableLongPress = true,
    this.enableAcceleration = true,
    this.longPressInitialDelay = const Duration(milliseconds: 400),
    this.longPressInterval = const Duration(milliseconds: 110),
    this.enableKeyboardStep = true,
    this.enableMouseWheel = true,
    this.mouseWheelRequiresFocus = true,
    this.enableHaptics = false,
    this.showClearButton = false,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.semanticLabel,
    this.incrementSemanticLabel = 'Increment',
    this.decrementSemanticLabel = 'Decrement',
    this.prefixWidget,
    this.suffixWidget,
    this.leading,
    this.trailing,
    this.textInputAction,
    super.key,
  })  : assert(
          step == null || step > 0,
          'step must be greater than 0.',
        ),
        assert(
          largeStep == null || largeStep > 0,
          'largeStep must be greater than 0.',
        ),
        assert(
          min == null || max == null || min <= max,
          'min must be less than or equal to max.',
        ),
        assert(
          precision == null || (precision >= 0 && precision <= 15),
          'precision must be between 0 and 15.',
        );

  /// Optional external controller managing the numeric value and bounds.
  final InputNumberController? controller;

  /// Controlled numeric value when [controller] is not provided.
  ///
  /// When updated in a parent rebuild, the displayed value synchronizes
  /// automatically.
  final num? value;

  /// Initial numeric value for uncontrolled usage when both [controller]
  /// and [value] are `null`.
  final num? initialValue;

  /// Minimum allowed numeric value, or `null` if unbounded below.
  final num? min;

  /// Maximum allowed numeric value, or `null` if unbounded above.
  final num? max;

  /// Step delta applied when incrementing or decrementing (defaults to `1`).
  final num? step;

  /// Large step delta applied on `PageUp` / `PageDown` keys.
  ///
  /// Defaults to `step * 10`.
  final num? largeStep;

  /// Number of decimal places to round values to (`0` for integers).
  final int? precision;

  /// Called whenever the numeric value changes.
  final ValueChanged<num?>? onChanged;

  /// Called when the user commits the value (e.g., pressing Enter/Done or blur).
  final ValueChanged<num?>? onSubmitted;

  /// Called specifically when a value change is triggered by a stepper action
  /// (button press, keyboard arrow, or mouse wheel).
  final ValueChanged<num>? onStep;

  /// Formatting and parsing configuration for the displayed number.
  final InputNumberFormat format;

  /// Placement layout for the increment and decrement stepper buttons.
  final InputNumberButtonLayout buttonLayout;

  /// Preset size dimensions of the control.
  final InputNumberSize size;

  /// Visual container variant of the control.
  final InputNumberVariant variant;

  /// Custom visual style overrides.
  final InputNumberStyle style;

  /// Optional external [FocusNode] for managing keyboard focus.
  final FocusNode? focusNode;

  /// Whether the control is interactive.
  final bool enabled;

  /// Whether direct text typing is disabled while stepper buttons remain active.
  final bool readOnly;

  /// Whether the text input requests focus automatically on mount.
  final bool autofocus;

  /// Whether the input is allowed to hold a `null` (empty) value.
  ///
  /// If `false`, clearing the field and unfocusing restores `min ?? 0`.
  final bool allowEmpty;

  /// Whether out-of-range values typed manually are clamped to `[min, max]`
  /// when the input loses focus or is submitted.
  final bool clampOnBlur;

  /// Whether manually typed values are snapped to the nearest multiple of
  /// [step] when the input loses focus or is submitted.
  final bool snapToStepOnBlur;

  /// Whether all text in the input field is selected automatically when focused.
  final bool selectAllOnFocus;

  /// Whether holding a stepper button triggers continuous auto-repeat.
  final bool enableLongPress;

  /// Whether continuous long-press stepping accelerates over time.
  final bool enableAcceleration;

  /// Initial delay before long-press auto-repeat begins.
  final Duration longPressInitialDelay;

  /// Base interval between long-press auto-repeat ticks.
  final Duration longPressInterval;

  /// Whether `ArrowUp`, `ArrowDown`, `PageUp`, and `PageDown` keys adjust
  /// the value while focused.
  final bool enableKeyboardStep;

  /// Whether scrolling the mouse wheel over the widget adjusts the value.
  final bool enableMouseWheel;

  /// Whether mouse wheel stepping requires the widget to have keyboard focus.
  final bool mouseWheelRequiresFocus;

  /// Whether stepping triggers platform haptic feedback.
  final bool enableHaptics;

  /// Whether to show a quick clear button when the field has a non-null value.
  final bool showClearButton;

  /// Placeholder text displayed when the input value is `null`.
  final String? hintText;

  /// Optional label text displayed above the input control.
  final String? labelText;

  /// Optional helper caption displayed below the input control.
  final String? helperText;

  /// Optional error message displayed below the input control; also activates
  /// the error border state when non-empty.
  final String? errorText;

  /// Optional accessibility label for the input field.
  final String? semanticLabel;

  /// Accessibility label for the increment button.
  final String incrementSemanticLabel;

  /// Accessibility label for the decrement button.
  final String decrementSemanticLabel;

  /// Optional widget rendered inside the input area before the text field.
  final Widget? prefixWidget;

  /// Optional widget rendered inside the input area after the text field.
  final Widget? suffixWidget;

  /// Optional widget rendered at the leading edge of the outer container.
  final Widget? leading;

  /// Optional widget rendered at the trailing edge of the outer container.
  final Widget? trailing;

  /// Action button label for the soft keyboard (e.g., [TextInputAction.done]).
  final TextInputAction? textInputAction;

  @override
  State<InputNumber> createState() => _InputNumberState();
}

class _InputNumberState extends State<InputNumber> {
  InputNumberController? _internalController;
  late final TextEditingController _textController;
  FocusNode? _internalFocusNode;
  bool _isUpdatingFromText = false;
  bool _isFocused = false;

  InputNumberController get _effectiveController =>
      widget.controller ?? _internalController!;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode!;

  num? get _effectiveMin => widget.min ?? widget.controller?.min;
  num? get _effectiveMax => widget.max ?? widget.controller?.max;
  num get _effectiveStep => widget.step ?? widget.controller?.step ?? 1;
  num get _effectiveLargeStep => widget.largeStep ?? (_effectiveStep * 10);
  int? get _effectivePrecision =>
      widget.precision ?? widget.controller?.precision;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = InputNumberController(
        value: widget.value ?? widget.initialValue,
        min: widget.min,
        max: widget.max,
        step: widget.step ?? 1,
        precision: widget.precision,
      );
    } else {
      _syncExternalControllerBounds();
    }

    _textController = TextEditingController(
      text: _formatForDisplay(
        _effectiveController.value,
        forEditing: false,
      ),
    );

    if (widget.focusNode == null) {
      _internalFocusNode = FocusNode();
    }
    _effectiveFocusNode.addListener(_handleFocusChange);
    _effectiveController.addListener(_handleControllerChange);
  }

  @override
  void didUpdateWidget(covariant InputNumber oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(
        _handleFocusChange,
      );
      if (widget.focusNode == null && _internalFocusNode == null) {
        _internalFocusNode = FocusNode();
      }
      _effectiveFocusNode.addListener(_handleFocusChange);
      _isFocused = _effectiveFocusNode.hasFocus;
    }

    if (widget.controller != oldWidget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(
        _handleControllerChange,
      );
      if (widget.controller == null) {
        _internalController ??= InputNumberController(
          value: widget.value ??
              oldWidget.controller?.value ??
              widget.initialValue,
          min: widget.min,
          max: widget.max,
          step: widget.step ?? 1,
          precision: widget.precision,
        );
      } else {
        _internalController?.dispose();
        _internalController = null;
        _syncExternalControllerBounds();
      }
      _effectiveController.addListener(_handleControllerChange);
      _syncTextWithController(force: true);
    } else {
      if (widget.controller == null) {
        _internalController!.updateBounds(
          min: widget.min,
          clearMin: widget.min == null,
          max: widget.max,
          clearMax: widget.max == null,
          step: widget.step ?? 1,
          precision: widget.precision,
          clearPrecision: widget.precision == null,
          clampCurrentValue: widget.clampOnBlur,
        );
        if (widget.value != oldWidget.value) {
          _internalController!.setValue(
            widget.value,
            clamp: widget.clampOnBlur,
          );
        }
      } else {
        _syncExternalControllerBounds();
      }
    }

    if (widget.format != oldWidget.format ||
        widget.precision != oldWidget.precision) {
      _syncTextWithController(force: !_isFocused);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    _effectiveController.removeListener(_handleControllerChange);
    _internalController?.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _syncExternalControllerBounds() {
    final ext = widget.controller;
    if (ext == null) {
      return;
    }
    if (widget.min != null ||
        widget.max != null ||
        widget.step != null ||
        widget.precision != null) {
      ext.updateBounds(
        min: widget.min ?? ext.min,
        max: widget.max ?? ext.max,
        step: widget.step ?? ext.step,
        precision: widget.precision ?? ext.precision,
        clampCurrentValue: widget.clampOnBlur,
      );
    }
  }

  String _formatForDisplay(num? val, {required bool forEditing}) {
    if (val == null) {
      return '';
    }
    if (forEditing && !widget.readOnly) {
      // While editing, present a clean raw representation without affixes or
      // thousand separators so the user can edit digits directly.
      final rawFormat = InputNumberFormat(
        decimalSeparator: widget.format.decimalSeparator,
        padDecimals: false,
      );
      return rawFormat.format(
        val,
        precision: _effectivePrecision,
        includeAffixes: false,
      );
    }
    return widget.format.format(
      val,
      precision: _effectivePrecision,
      includeAffixes: true,
    );
  }

  void _handleControllerChange() {
    if (_isUpdatingFromText) {
      return;
    }
    _syncTextWithController();
  }

  void _syncTextWithController({bool force = false}) {
    final currentValue = _effectiveController.value;
    if (_isFocused && !widget.readOnly && !force) {
      // Avoid overwriting in-progress user typing (e.g. "12." or "12.0")
      // when the parsed text already matches the controller value.
      final currentParsed = widget.format.parse(_textController.text);
      if (currentParsed == currentValue &&
          (currentValue != null || _textController.text.trim().isEmpty)) {
        return;
      }
    }
    final formatted = _formatForDisplay(
      currentValue,
      forEditing: _isFocused && !widget.readOnly,
    );
    if (_textController.text != formatted) {
      _textController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _handleFocusChange() {
    final hasFocus = _effectiveFocusNode.hasFocus;
    if (_isFocused == hasFocus) {
      return;
    }
    setState(() => _isFocused = hasFocus);

    if (hasFocus) {
      if (!widget.readOnly) {
        final editableText = _formatForDisplay(
          _effectiveController.value,
          forEditing: true,
        );
        final selection = widget.selectAllOnFocus
            ? TextSelection(baseOffset: 0, extentOffset: editableText.length)
            : TextSelection.collapsed(offset: editableText.length);
        _textController.value = TextEditingValue(
          text: editableText,
          selection: selection,
        );
      }
    } else {
      _commitEditingText(notifySubmit: true);
    }
  }

  void _onTextChanged(String rawText) {
    if (!widget.enabled || widget.readOnly) {
      return;
    }
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) {
      if (widget.allowEmpty) {
        _isUpdatingFromText = true;
        final previous = _effectiveController.value;
        _effectiveController.clear();
        _isUpdatingFromText = false;
        if (previous != null) {
          widget.onChanged?.call(null);
        }
      }
      return;
    }

    final parsed = widget.format.parse(trimmed);
    if (parsed == null) {
      return;
    }

    final min = _effectiveMin;
    final max = _effectiveMax;
    final inBounds =
        (min == null || parsed >= min) && (max == null || parsed <= max);

    if (inBounds || !widget.clampOnBlur) {
      _isUpdatingFromText = true;
      final previous = _effectiveController.value;
      _effectiveController.setValue(parsed, clamp: widget.clampOnBlur);
      _isUpdatingFromText = false;
      if (_effectiveController.value != previous) {
        widget.onChanged?.call(_effectiveController.value);
      }
    }
  }

  void _commitEditingText({required bool notifySubmit}) {
    final rawText = _textController.text.trim();
    final previous = _effectiveController.value;

    if (rawText.isEmpty) {
      if (widget.allowEmpty) {
        _effectiveController.clear();
      } else {
        final fallback = _effectiveMin ?? 0;
        _effectiveController.setValue(fallback, clamp: widget.clampOnBlur);
      }
    } else {
      final parsed = widget.format.parse(rawText);
      if (parsed != null) {
        var resolved = parsed;
        if (widget.snapToStepOnBlur) {
          resolved = NumberMath.snapToStep(
            resolved,
            step: _effectiveStep,
            base: _effectiveMin ?? 0,
            precision: _effectivePrecision,
          );
        }
        _effectiveController.setValue(resolved, clamp: widget.clampOnBlur);
      } else if (widget.allowEmpty) {
        _effectiveController.clear();
      } else {
        _effectiveController.setValue(
          previous ?? _effectiveMin ?? 0,
          clamp: widget.clampOnBlur,
        );
      }
    }

    _syncTextWithController(force: true);

    final current = _effectiveController.value;
    if (current != previous) {
      widget.onChanged?.call(current);
    }
    if (notifySubmit) {
      widget.onSubmitted?.call(current);
    }
  }

  void _performStep({required bool isIncrement, num? customStep}) {
    if (!widget.enabled) {
      return;
    }
    // Commit any uncommitted manual text edits before stepping.
    if (_isFocused && !widget.readOnly) {
      final rawText = _textController.text.trim();
      final parsed = widget.format.parse(rawText);
      if (parsed != null && parsed != _effectiveController.value) {
        _effectiveController.setValue(parsed, clamp: widget.clampOnBlur);
      }
    }

    final previous = _effectiveController.value;
    final delta = customStep ?? _effectiveStep;
    final next = isIncrement
        ? _effectiveController.increment(delta)
        : _effectiveController.decrement(delta);

    _syncTextWithController(force: true);

    if (next != previous) {
      if (widget.enableHaptics) {
        HapticFeedback.selectionClick();
      }
      widget.onStep?.call(next);
      widget.onChanged?.call(next);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _handleClear() {
    if (!widget.enabled || !widget.allowEmpty) {
      return;
    }
    final previous = _effectiveController.value;
    _effectiveController.clear();
    _syncTextWithController(force: true);
    if (previous != null) {
      widget.onChanged?.call(null);
    }
    setState(() {});
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!widget.enabled || !widget.enableKeyboardStep) {
      return KeyEventResult.ignored;
    }
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp) {
      if (_effectiveController.canIncrement) {
        _performStep(isIncrement: true);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      if (_effectiveController.canDecrement) {
        _performStep(isIncrement: false);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.pageUp) {
      if (_effectiveController.canIncrement) {
        _performStep(isIncrement: true, customStep: _effectiveLargeStep);
      }
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.pageDown) {
      if (_effectiveController.canDecrement) {
        _performStep(isIncrement: false, customStep: _effectiveLargeStep);
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!widget.enabled || !widget.enableMouseWheel) {
      return;
    }
    if (widget.mouseWheelRequiresFocus && !_isFocused) {
      return;
    }
    if (event is PointerScrollEvent) {
      if (event.scrollDelta.dy < 0 && _effectiveController.canIncrement) {
        _performStep(isIncrement: true);
      } else if (event.scrollDelta.dy > 0 &&
          _effectiveController.canDecrement) {
        _performStep(isIncrement: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolved = widget.style.resolve(
      theme: theme,
      size: widget.size,
      variant: widget.variant,
      buttonLayout: widget.buttonLayout,
    );

    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return ListenableBuilder(
      listenable: _effectiveController,
      builder: (context, _) {
        final canInc = widget.enabled && _effectiveController.canIncrement;
        final canDec = widget.enabled && _effectiveController.canDecrement;

        final activeBorderColor = !widget.enabled
            ? resolved.disabledBorderColor
            : (hasError
                ? resolved.errorBorderColor
                : (_isFocused
                    ? resolved.focusedBorderColor
                    : resolved.borderColor));

        final activeBorderWidth = (_isFocused || hasError) && widget.enabled
            ? resolved.focusedBorderWidth
            : resolved.borderWidth;

        final boxBorder = widget.variant == InputNumberVariant.underlined
            ? Border(
                bottom: BorderSide(
                  color: activeBorderColor,
                  width: activeBorderWidth,
                ),
              )
            : Border.all(
                color: activeBorderColor,
                width: activeBorderWidth,
              );

        final bgColor = widget.enabled
            ? resolved.backgroundColor
            : resolved.disabledBackgroundColor;

        Widget control = Listener(
          onPointerSignal: _handlePointerSignal,
          child: Focus(
            onKeyEvent: _handleKeyEvent,
            child: AnimatedContainer(
              duration: resolved.animationDuration,
              height: resolved.height,
              width: resolved.width,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: widget.variant == InputNumberVariant.underlined
                    ? null
                    : resolved.borderRadius,
                border: boxBorder,
              ),
              clipBehavior: widget.variant == InputNumberVariant.underlined
                  ? Clip.none
                  : Clip.antiAlias,
              child: Row(
                children: [
                  if (widget.leading != null) widget.leading!,
                  if (widget.buttonLayout == InputNumberButtonLayout.split) ...[
                    _buildDecrementButton(resolved, canDec),
                    if (resolved.showDividers) _buildVerticalDivider(resolved),
                  ],
                  Expanded(
                    child: _buildTextFieldArea(resolved),
                  ),
                  if (widget.buttonLayout == InputNumberButtonLayout.split) ...[
                    if (resolved.showDividers) _buildVerticalDivider(resolved),
                    _buildIncrementButton(resolved, canInc),
                  ],
                  if (widget.buttonLayout ==
                      InputNumberButtonLayout.inlineEnd) ...[
                    if (resolved.showDividers) _buildVerticalDivider(resolved),
                    _buildDecrementButton(resolved, canDec),
                    if (resolved.showDividers) _buildVerticalDivider(resolved),
                    _buildIncrementButton(resolved, canInc),
                  ],
                  if (widget.buttonLayout ==
                      InputNumberButtonLayout.stackedEnd) ...[
                    if (resolved.showDividers) _buildVerticalDivider(resolved),
                    _buildStackedButtons(resolved, canInc, canDec),
                  ],
                  if (widget.trailing != null) widget.trailing!,
                ],
              ),
            ),
          ),
        );

        if (widget.labelText != null || widget.helperText != null || hasError) {
          control = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.labelText != null) ...[
                Text(
                  widget.labelText!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: hasError
                        ? resolved.errorBorderColor
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              control,
              if (hasError) ...[
                const SizedBox(height: 4),
                Text(
                  widget.errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: resolved.errorBorderColor,
                  ),
                ),
              ] else if (widget.helperText != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.helperText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          );
        }

        return Semantics(
          label: widget.semanticLabel ?? widget.labelText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          textField: true,
          child: control,
        );
      },
    );
  }

  Widget _buildTextFieldArea(ResolvedInputNumberStyle resolved) {
    final allowNegative = _effectiveMin == null || _effectiveMin! < 0;
    final allowDecimal =
        _effectivePrecision == null || _effectivePrecision! > 0;

    final showClear = widget.showClearButton &&
        widget.enabled &&
        !widget.readOnly &&
        widget.allowEmpty &&
        _effectiveController.hasValue;

    return Padding(
      padding: resolved.contentPadding,
      child: Row(
        children: [
          if (widget.prefixWidget != null) ...[
            widget.prefixWidget!,
            const SizedBox(width: 4),
          ],
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _effectiveFocusNode,
              enabled: widget.enabled,
              readOnly: widget.readOnly,
              autofocus: widget.autofocus,
              textAlign: resolved.textAlign,
              style: widget.enabled
                  ? resolved.textStyle
                  : resolved.textStyle.copyWith(
                      color: resolved.buttonDisabledForegroundColor,
                    ),
              keyboardType: TextInputType.numberWithOptions(
                signed: allowNegative,
                decimal: allowDecimal,
              ),
              textInputAction: widget.textInputAction ?? TextInputAction.done,
              inputFormatters: [
                NumericTextInputFormatter(
                  allowNegative: allowNegative,
                  allowDecimal: allowDecimal,
                  maxDecimalDigits: _effectivePrecision,
                  decimalSeparator: widget.format.decimalSeparator,
                  thousandSeparator: widget.format.thousandSeparator,
                ),
              ],
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: widget.hintText,
                hintStyle: resolved.hintStyle,
              ),
              onChanged: _onTextChanged,
              onSubmitted: (_) => _commitEditingText(notifySubmit: true),
            ),
          ),
          if (showClear) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: _handleClear,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.cancel_rounded,
                size: resolved.iconSize * 0.9,
                color: resolved.affixStyle.color?.withValues(alpha: 0.6),
              ),
            ),
          ],
          if (widget.suffixWidget != null) ...[
            const SizedBox(width: 4),
            widget.suffixWidget!,
          ],
        ],
      ),
    );
  }

  Widget _buildIncrementButton(
    ResolvedInputNumberStyle resolved,
    bool canInc,
  ) {
    return StepperButton(
      icon: resolved.incrementIcon,
      enabled: canInc,
      width: resolved.buttonWidth,
      height: resolved.height,
      iconSize: resolved.iconSize,
      backgroundColor: resolved.buttonBackgroundColor,
      foregroundColor: resolved.buttonForegroundColor,
      disabledForegroundColor: resolved.buttonDisabledForegroundColor,
      hoverColor: resolved.buttonHoverColor,
      splashColor: resolved.buttonSplashColor,
      semanticLabel: widget.incrementSemanticLabel,
      enableLongPress: widget.enableLongPress,
      enableAcceleration: widget.enableAcceleration,
      longPressInitialDelay: widget.longPressInitialDelay,
      longPressInterval: widget.longPressInterval,
      onStep: () => _performStep(isIncrement: true),
    );
  }

  Widget _buildDecrementButton(
    ResolvedInputNumberStyle resolved,
    bool canDec,
  ) {
    return StepperButton(
      icon: resolved.decrementIcon,
      enabled: canDec,
      width: resolved.buttonWidth,
      height: resolved.height,
      iconSize: resolved.iconSize,
      backgroundColor: resolved.buttonBackgroundColor,
      foregroundColor: resolved.buttonForegroundColor,
      disabledForegroundColor: resolved.buttonDisabledForegroundColor,
      hoverColor: resolved.buttonHoverColor,
      splashColor: resolved.buttonSplashColor,
      semanticLabel: widget.decrementSemanticLabel,
      enableLongPress: widget.enableLongPress,
      enableAcceleration: widget.enableAcceleration,
      longPressInitialDelay: widget.longPressInitialDelay,
      longPressInterval: widget.longPressInterval,
      onStep: () => _performStep(isIncrement: false),
    );
  }

  Widget _buildStackedButtons(
    ResolvedInputNumberStyle resolved,
    bool canInc,
    bool canDec,
  ) {
    return SizedBox(
      width: resolved.buttonWidth,
      height: resolved.height,
      child: Column(
        children: [
          Expanded(
            child: StepperButton(
              icon: resolved.stackedIncrementIcon,
              enabled: canInc,
              width: resolved.buttonWidth,
              iconSize: resolved.iconSize,
              backgroundColor: resolved.buttonBackgroundColor,
              foregroundColor: resolved.buttonForegroundColor,
              disabledForegroundColor: resolved.buttonDisabledForegroundColor,
              hoverColor: resolved.buttonHoverColor,
              splashColor: resolved.buttonSplashColor,
              semanticLabel: widget.incrementSemanticLabel,
              enableLongPress: widget.enableLongPress,
              enableAcceleration: widget.enableAcceleration,
              longPressInitialDelay: widget.longPressInitialDelay,
              longPressInterval: widget.longPressInterval,
              onStep: () => _performStep(isIncrement: true),
            ),
          ),
          if (resolved.showDividers)
            Container(
              height: resolved.borderWidth,
              width: resolved.buttonWidth,
              color: resolved.borderColor,
            ),
          Expanded(
            child: StepperButton(
              icon: resolved.stackedDecrementIcon,
              enabled: canDec,
              width: resolved.buttonWidth,
              iconSize: resolved.iconSize,
              backgroundColor: resolved.buttonBackgroundColor,
              foregroundColor: resolved.buttonForegroundColor,
              disabledForegroundColor: resolved.buttonDisabledForegroundColor,
              hoverColor: resolved.buttonHoverColor,
              splashColor: resolved.buttonSplashColor,
              semanticLabel: widget.decrementSemanticLabel,
              enableLongPress: widget.enableLongPress,
              enableAcceleration: widget.enableAcceleration,
              longPressInitialDelay: widget.longPressInitialDelay,
              longPressInterval: widget.longPressInterval,
              onStep: () => _performStep(isIncrement: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(ResolvedInputNumberStyle resolved) {
    return Container(
      width: resolved.borderWidth,
      height: resolved.height,
      color:
          widget.enabled ? resolved.borderColor : resolved.disabledBorderColor,
    );
  }
}
