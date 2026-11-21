# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.3

- Added gold medal hero banner to `README.md`.
- Added animated Desktop and Mobile live preview showcases rendered from real `InputNumber` and `InputNumberFormField` widgets in `README.md`.

## 1.0.2

- Replaced unnecessary `package:flutter/material.dart` imports with `package:flutter/widgets.dart` in `InputNumberFormField` and `StepperButton`.
- Resolved Flutter 3.47+ static analysis deprecation lints (`deprecated_member_use`) on `package:flutter/material.dart` while maintaining backwards compatibility with Flutter `>=3.24.0`.

## 1.0.1

- Added `InputNumberFormat.european()` and `InputNumberFormat.unit()` presets for global number and measurement unit formatting.
- Improved active text editing focus synchronization so in-progress decimal points are preserved during parent widget rebuilds.
- Improved controlled `value` updates when transitioning to `null`.
- Added package funding metadata and updated documentation badges.

## 1.0.0

- Initial stable release of `input_number`.
- Added `InputNumber` widget with multiple button layouts (`split`, `stackedEnd`, `inlineEnd`, `none`).
- Added `InputNumberFormField` for seamless `Form` validation, saving, and error display.
- Added `InputNumberController` with floating-point precision-safe arithmetic (`increment`, `decrement`, `setValue`, `reset`, `clear`).
- Added `InputNumberFormat` with thousand grouping, custom decimal separator, prefix, suffix, and currency/percentage presets.
- Added `NumericTextInputFormatter` for real-time numeric input sanitization and cursor preservation.
- Added `InputNumberStyle`, `InputNumberVariant` (`outlined`, `filled`, `underlined`, `pill`), and `InputNumberSize` (`small`, `medium`, `large`) with full Material 3 dark and light theme adaptation.
- Added long-press auto-repeat with optional turbo acceleration, keyboard arrow/page navigation, mouse wheel stepping, and haptic feedback.
