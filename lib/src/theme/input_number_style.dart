import 'package:flutter/material.dart';

import '../models/input_number_config.dart';

/// Visual styling configuration for an `InputNumber` widget.
///
/// Any property left as `null` automatically falls back to defaults derived
/// from the ambient [ThemeData], [InputNumberSize], and [InputNumberVariant].
@immutable
class InputNumberStyle {
  /// Creates a visual style configuration for `InputNumber`.
  const InputNumberStyle({
    this.height,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.disabledBorderColor,
    this.borderWidth,
    this.focusedBorderWidth,
    this.buttonBackgroundColor,
    this.buttonForegroundColor,
    this.buttonDisabledForegroundColor,
    this.buttonHoverColor,
    this.buttonSplashColor,
    this.buttonWidth,
    this.iconSize,
    this.textStyle,
    this.hintStyle,
    this.affixStyle,
    this.contentPadding,
    this.textAlign,
    this.showDividers,
    this.incrementIcon,
    this.decrementIcon,
    this.stackedIncrementIcon,
    this.stackedDecrementIcon,
    this.animationDuration,
  });

  /// Overall height of the control in logical pixels.
  final double? height;

  /// Optional fixed width of the control in logical pixels.
  final double? width;

  /// Corner radius of the outer container.
  final BorderRadiusGeometry? borderRadius;

  /// Background fill color when enabled.
  final Color? backgroundColor;

  /// Background fill color when disabled.
  final Color? disabledBackgroundColor;

  /// Default border and divider color when unfocused.
  final Color? borderColor;

  /// Border color when the input has keyboard focus.
  final Color? focusedBorderColor;

  /// Border color when the input is in an error state.
  final Color? errorBorderColor;

  /// Border color when the input is disabled.
  final Color? disabledBorderColor;

  /// Stroke width of the container border when unfocused.
  final double? borderWidth;

  /// Stroke width of the container border when focused.
  final double? focusedBorderWidth;

  /// Background color of the increment and decrement stepper buttons.
  final Color? buttonBackgroundColor;

  /// Icon color of the increment and decrement stepper buttons when active.
  final Color? buttonForegroundColor;

  /// Icon color of the increment and decrement stepper buttons when disabled.
  final Color? buttonDisabledForegroundColor;

  /// Hover highlight color for stepper buttons.
  final Color? buttonHoverColor;

  /// Press/splash highlight color for stepper buttons.
  final Color? buttonSplashColor;

  /// Width of each stepper button in logical pixels.
  final double? buttonWidth;

  /// Size of the stepper button icons in logical pixels.
  final double? iconSize;

  /// Text style for the numeric value inside the input field.
  final TextStyle? textStyle;

  /// Text style for the placeholder/hint text.
  final TextStyle? hintStyle;

  /// Text style for prefix and suffix labels.
  final TextStyle? affixStyle;

  /// Inner padding around the editable numeric text field.
  final EdgeInsetsGeometry? contentPadding;

  /// Horizontal alignment of the numeric text inside the field.
  final TextAlign? textAlign;

  /// Whether to render divider lines between the text field and stepper buttons.
  final bool? showDividers;

  /// Icon used for the increment button in `split` and `inlineEnd` layouts.
  final IconData? incrementIcon;

  /// Icon used for the decrement button in `split` and `inlineEnd` layouts.
  final IconData? decrementIcon;

  /// Icon used for the top increment button in the `stackedEnd` layout.
  final IconData? stackedIncrementIcon;

  /// Icon used for the bottom decrement button in the `stackedEnd` layout.
  final IconData? stackedDecrementIcon;

  /// Duration of border and focus transitions.
  final Duration? animationDuration;

  /// Creates a copy of this [InputNumberStyle] with selected fields replaced.
  InputNumberStyle copyWith({
    double? height,
    double? width,
    BorderRadiusGeometry? borderRadius,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? errorBorderColor,
    Color? disabledBorderColor,
    double? borderWidth,
    double? focusedBorderWidth,
    Color? buttonBackgroundColor,
    Color? buttonForegroundColor,
    Color? buttonDisabledForegroundColor,
    Color? buttonHoverColor,
    Color? buttonSplashColor,
    double? buttonWidth,
    double? iconSize,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? affixStyle,
    EdgeInsetsGeometry? contentPadding,
    TextAlign? textAlign,
    bool? showDividers,
    IconData? incrementIcon,
    IconData? decrementIcon,
    IconData? stackedIncrementIcon,
    IconData? stackedDecrementIcon,
    Duration? animationDuration,
  }) {
    return InputNumberStyle(
      height: height ?? this.height,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      borderColor: borderColor ?? this.borderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      focusedBorderWidth: focusedBorderWidth ?? this.focusedBorderWidth,
      buttonBackgroundColor:
          buttonBackgroundColor ?? this.buttonBackgroundColor,
      buttonForegroundColor:
          buttonForegroundColor ?? this.buttonForegroundColor,
      buttonDisabledForegroundColor:
          buttonDisabledForegroundColor ?? this.buttonDisabledForegroundColor,
      buttonHoverColor: buttonHoverColor ?? this.buttonHoverColor,
      buttonSplashColor: buttonSplashColor ?? this.buttonSplashColor,
      buttonWidth: buttonWidth ?? this.buttonWidth,
      iconSize: iconSize ?? this.iconSize,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      affixStyle: affixStyle ?? this.affixStyle,
      contentPadding: contentPadding ?? this.contentPadding,
      textAlign: textAlign ?? this.textAlign,
      showDividers: showDividers ?? this.showDividers,
      incrementIcon: incrementIcon ?? this.incrementIcon,
      decrementIcon: decrementIcon ?? this.decrementIcon,
      stackedIncrementIcon: stackedIncrementIcon ?? this.stackedIncrementIcon,
      stackedDecrementIcon: stackedDecrementIcon ?? this.stackedDecrementIcon,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }

  /// Resolves concrete values for all style properties based on [theme],
  /// [size], [variant], and [buttonLayout].
  ResolvedInputNumberStyle resolve({
    required ThemeData theme,
    required InputNumberSize size,
    required InputNumberVariant variant,
    required InputNumberButtonLayout buttonLayout,
  }) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final defaultHeight = switch (size) {
      InputNumberSize.small => 34.0,
      InputNumberSize.medium => 42.0,
      InputNumberSize.large => 50.0,
    };

    final resolvedHeight = height ?? defaultHeight;

    final defaultButtonWidth = switch (size) {
      InputNumberSize.small =>
        buttonLayout == InputNumberButtonLayout.stackedEnd ? 26.0 : 32.0,
      InputNumberSize.medium =>
        buttonLayout == InputNumberButtonLayout.stackedEnd ? 30.0 : 38.0,
      InputNumberSize.large =>
        buttonLayout == InputNumberButtonLayout.stackedEnd ? 34.0 : 46.0,
    };

    final defaultIconSize = switch (size) {
      InputNumberSize.small =>
        buttonLayout == InputNumberButtonLayout.stackedEnd ? 13.0 : 16.0,
      InputNumberSize.medium =>
        buttonLayout == InputNumberButtonLayout.stackedEnd ? 15.0 : 18.0,
      InputNumberSize.large =>
        buttonLayout == InputNumberButtonLayout.stackedEnd ? 17.0 : 21.0,
    };

    final defaultFontSize = switch (size) {
      InputNumberSize.small => 13.0,
      InputNumberSize.medium => 15.0,
      InputNumberSize.large => 17.0,
    };

    final defaultRadius = switch (variant) {
      InputNumberVariant.pill => BorderRadius.circular(resolvedHeight / 2),
      InputNumberVariant.underlined => BorderRadius.zero,
      InputNumberVariant.outlined ||
      InputNumberVariant.filled =>
        BorderRadius.circular(
          switch (size) {
            InputNumberSize.small => 8.0,
            InputNumberSize.medium => 10.0,
            InputNumberSize.large => 12.0,
          },
        ),
    };

    final defaultBg = switch (variant) {
      InputNumberVariant.filled => isDark
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.55)
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
      InputNumberVariant.underlined => Colors.transparent,
      InputNumberVariant.outlined ||
      InputNumberVariant.pill =>
        colorScheme.surface,
    };

    final defaultDisabledBg =
        colorScheme.onSurface.withValues(alpha: isDark ? 0.06 : 0.04);

    final defaultBorderColor = switch (variant) {
      InputNumberVariant.filled =>
        colorScheme.outlineVariant.withValues(alpha: 0.5),
      InputNumberVariant.outlined ||
      InputNumberVariant.pill ||
      InputNumberVariant.underlined =>
        colorScheme.outline.withValues(alpha: isDark ? 0.55 : 0.45),
    };

    final baseTextStyle =
        (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: defaultFontSize,
      fontWeight: FontWeight.w500,
      color: colorScheme.onSurface,
      fontFeatures: const [FontFeature.tabularFigures()],
    ).merge(textStyle);

    final baseHintStyle = baseTextStyle
        .copyWith(
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        )
        .merge(hintStyle);

    final baseAffixStyle = baseTextStyle
        .copyWith(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        )
        .merge(affixStyle);

    final defaultTextAlign = textAlign ??
        (buttonLayout == InputNumberButtonLayout.split
            ? TextAlign.center
            : TextAlign.start);

    return ResolvedInputNumberStyle(
      height: resolvedHeight,
      width: width,
      borderRadius: borderRadius ?? defaultRadius,
      backgroundColor: backgroundColor ?? defaultBg,
      disabledBackgroundColor: disabledBackgroundColor ?? defaultDisabledBg,
      borderColor: borderColor ?? defaultBorderColor,
      focusedBorderColor: focusedBorderColor ?? colorScheme.primary,
      errorBorderColor: errorBorderColor ?? colorScheme.error,
      disabledBorderColor:
          disabledBorderColor ?? colorScheme.onSurface.withValues(alpha: 0.14),
      borderWidth: borderWidth ?? 1.0,
      focusedBorderWidth: focusedBorderWidth ?? 1.6,
      buttonBackgroundColor: buttonBackgroundColor ?? Colors.transparent,
      buttonForegroundColor: buttonForegroundColor ?? colorScheme.onSurface,
      buttonDisabledForegroundColor: buttonDisabledForegroundColor ??
          colorScheme.onSurface.withValues(alpha: 0.28),
      buttonHoverColor: buttonHoverColor ??
          colorScheme.primary.withValues(alpha: isDark ? 0.12 : 0.07),
      buttonSplashColor: buttonSplashColor ??
          colorScheme.primary.withValues(alpha: isDark ? 0.20 : 0.14),
      buttonWidth: buttonWidth ?? defaultButtonWidth,
      iconSize: iconSize ?? defaultIconSize,
      textStyle: baseTextStyle,
      hintStyle: baseHintStyle,
      affixStyle: baseAffixStyle,
      contentPadding: contentPadding ??
          EdgeInsets.symmetric(
            horizontal: size == InputNumberSize.small ? 8.0 : 12.0,
          ),
      textAlign: defaultTextAlign,
      showDividers: showDividers ?? (variant != InputNumberVariant.underlined),
      incrementIcon: incrementIcon ?? Icons.add_rounded,
      decrementIcon: decrementIcon ?? Icons.remove_rounded,
      stackedIncrementIcon:
          stackedIncrementIcon ?? Icons.keyboard_arrow_up_rounded,
      stackedDecrementIcon:
          stackedDecrementIcon ?? Icons.keyboard_arrow_down_rounded,
      animationDuration: animationDuration ?? const Duration(milliseconds: 160),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is InputNumberStyle &&
        other.height == height &&
        other.width == width &&
        other.borderRadius == borderRadius &&
        other.backgroundColor == backgroundColor &&
        other.disabledBackgroundColor == disabledBackgroundColor &&
        other.borderColor == borderColor &&
        other.focusedBorderColor == focusedBorderColor &&
        other.errorBorderColor == errorBorderColor &&
        other.disabledBorderColor == disabledBorderColor &&
        other.borderWidth == borderWidth &&
        other.focusedBorderWidth == focusedBorderWidth &&
        other.buttonBackgroundColor == buttonBackgroundColor &&
        other.buttonForegroundColor == buttonForegroundColor &&
        other.buttonDisabledForegroundColor == buttonDisabledForegroundColor &&
        other.buttonHoverColor == buttonHoverColor &&
        other.buttonSplashColor == buttonSplashColor &&
        other.buttonWidth == buttonWidth &&
        other.iconSize == iconSize &&
        other.textStyle == textStyle &&
        other.hintStyle == hintStyle &&
        other.affixStyle == affixStyle &&
        other.contentPadding == contentPadding &&
        other.textAlign == textAlign &&
        other.showDividers == showDividers &&
        other.incrementIcon == incrementIcon &&
        other.decrementIcon == decrementIcon &&
        other.stackedIncrementIcon == stackedIncrementIcon &&
        other.stackedDecrementIcon == stackedDecrementIcon &&
        other.animationDuration == animationDuration;
  }

  @override
  int get hashCode => Object.hashAll([
        height,
        width,
        borderRadius,
        backgroundColor,
        disabledBackgroundColor,
        borderColor,
        focusedBorderColor,
        errorBorderColor,
        disabledBorderColor,
        borderWidth,
        focusedBorderWidth,
        buttonBackgroundColor,
        buttonForegroundColor,
        buttonDisabledForegroundColor,
        buttonHoverColor,
        buttonSplashColor,
        buttonWidth,
        iconSize,
        textStyle,
        hintStyle,
        affixStyle,
        contentPadding,
        textAlign,
        showDividers,
        incrementIcon,
        decrementIcon,
        stackedIncrementIcon,
        stackedDecrementIcon,
        animationDuration,
      ]);
}

/// Concrete resolved style values produced by [InputNumberStyle.resolve].
@immutable
class ResolvedInputNumberStyle {
  /// Creates a [ResolvedInputNumberStyle] with non-nullable resolved fields.
  const ResolvedInputNumberStyle({
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.backgroundColor,
    required this.disabledBackgroundColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.errorBorderColor,
    required this.disabledBorderColor,
    required this.borderWidth,
    required this.focusedBorderWidth,
    required this.buttonBackgroundColor,
    required this.buttonForegroundColor,
    required this.buttonDisabledForegroundColor,
    required this.buttonHoverColor,
    required this.buttonSplashColor,
    required this.buttonWidth,
    required this.iconSize,
    required this.textStyle,
    required this.hintStyle,
    required this.affixStyle,
    required this.contentPadding,
    required this.textAlign,
    required this.showDividers,
    required this.incrementIcon,
    required this.decrementIcon,
    required this.stackedIncrementIcon,
    required this.stackedDecrementIcon,
    required this.animationDuration,
  });

  /// Resolved control height.
  final double height;

  /// Optional fixed control width.
  final double? width;

  /// Resolved corner radius.
  final BorderRadiusGeometry borderRadius;

  /// Resolved background color when enabled.
  final Color backgroundColor;

  /// Resolved background color when disabled.
  final Color disabledBackgroundColor;

  /// Resolved border color when unfocused.
  final Color borderColor;

  /// Resolved border color when focused.
  final Color focusedBorderColor;

  /// Resolved border color when in error state.
  final Color errorBorderColor;

  /// Resolved border color when disabled.
  final Color disabledBorderColor;

  /// Resolved unfocused border width.
  final double borderWidth;

  /// Resolved focused border width.
  final double focusedBorderWidth;

  /// Resolved stepper button background color.
  final Color buttonBackgroundColor;

  /// Resolved active stepper button icon color.
  final Color buttonForegroundColor;

  /// Resolved disabled stepper button icon color.
  final Color buttonDisabledForegroundColor;

  /// Resolved stepper button hover color.
  final Color buttonHoverColor;

  /// Resolved stepper button press/splash color.
  final Color buttonSplashColor;

  /// Resolved width of each stepper button.
  final double buttonWidth;

  /// Resolved icon size for stepper buttons.
  final double iconSize;

  /// Resolved text style for the numeric input.
  final TextStyle textStyle;

  /// Resolved text style for the placeholder hint.
  final TextStyle hintStyle;

  /// Resolved text style for prefix/suffix labels.
  final TextStyle affixStyle;

  /// Resolved inner content padding.
  final EdgeInsetsGeometry contentPadding;

  /// Resolved text alignment.
  final TextAlign textAlign;

  /// Resolved flag indicating whether dividers are shown.
  final bool showDividers;

  /// Resolved increment icon for split/inline layouts.
  final IconData incrementIcon;

  /// Resolved decrement icon for split/inline layouts.
  final IconData decrementIcon;

  /// Resolved top increment icon for stacked layout.
  final IconData stackedIncrementIcon;

  /// Resolved bottom decrement icon for stacked layout.
  final IconData stackedDecrementIcon;

  /// Resolved transition duration.
  final Duration animationDuration;
}
