import 'dart:async';
import 'package:flutter/widgets.dart';

/// Internal stepper button widget supporting single tap and continuous
/// long-press auto-repeat with optional turbo acceleration.
class StepperButton extends StatefulWidget {
  /// Creates a [StepperButton].
  const StepperButton({
    required this.icon,
    required this.enabled,
    required this.onStep,
    required this.width,
    required this.iconSize,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.disabledForegroundColor,
    required this.hoverColor,
    required this.splashColor,
    required this.semanticLabel,
    this.height,
    this.enableLongPress = true,
    this.enableAcceleration = true,
    this.longPressInitialDelay = const Duration(milliseconds: 400),
    this.longPressInterval = const Duration(milliseconds: 110),
    super.key,
  });

  /// Icon displayed inside the stepper button.
  final IconData icon;

  /// Whether the button is interactive.
  final bool enabled;

  /// Callback invoked on tap and on each auto-repeat tick.
  final VoidCallback onStep;

  /// Width of the button in logical pixels.
  final double width;

  /// Optional height of the button in logical pixels.
  final double? height;

  /// Icon size in logical pixels.
  final double iconSize;

  /// Background color of the button.
  final Color backgroundColor;

  /// Icon color when [enabled] is `true`.
  final Color foregroundColor;

  /// Icon color when [enabled] is `false`.
  final Color disabledForegroundColor;

  /// Highlight color on pointer hover.
  final Color hoverColor;

  /// Highlight color when pressed.
  final Color splashColor;

  /// Accessibility label for screen readers.
  final String semanticLabel;

  /// Whether holding the button continuously repeats [onStep].
  final bool enableLongPress;

  /// Whether long-press auto-repeat accelerates the longer it is held.
  final bool enableAcceleration;

  /// Delay before continuous auto-repeat starts after initial press.
  final Duration longPressInitialDelay;

  /// Base interval between auto-repeat steps.
  final Duration longPressInterval;

  @override
  State<StepperButton> createState() => _StepperButtonState();
}

class _StepperButtonState extends State<StepperButton> {
  Timer? _initialTimer;
  Timer? _repeatTimer;
  bool _isHovered = false;
  bool _isPressed = false;
  int _tickCount = 0;

  @override
  void didUpdateWidget(covariant StepperButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && oldWidget.enabled) {
      _stopRepeating(updateState: true);
    }
  }

  @override
  void dispose() {
    _stopRepeating(updateState: false);
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) {
      return;
    }
    setState(() => _isPressed = true);
    widget.onStep();

    if (!widget.enableLongPress) {
      return;
    }

    _stopTimers();
    _tickCount = 0;
    _initialTimer = Timer(widget.longPressInitialDelay, () {
      if (!mounted || !widget.enabled || !_isPressed) {
        return;
      }
      _scheduleNextTick();
    });
  }

  void _scheduleNextTick() {
    if (!mounted || !widget.enabled || !_isPressed) {
      return;
    }
    var intervalMs = widget.longPressInterval.inMilliseconds;
    if (widget.enableAcceleration) {
      if (_tickCount > 15) {
        intervalMs = (intervalMs * 0.35).round().clamp(25, intervalMs);
      } else if (_tickCount > 6) {
        intervalMs = (intervalMs * 0.6).round().clamp(35, intervalMs);
      }
    }
    _repeatTimer = Timer(Duration(milliseconds: intervalMs), () {
      if (!mounted || !widget.enabled || !_isPressed) {
        _stopRepeating(updateState: mounted);
        return;
      }
      _tickCount++;
      widget.onStep();
      if (widget.enabled && _isPressed) {
        _scheduleNextTick();
      } else {
        _stopRepeating(updateState: mounted);
      }
    });
  }

  void _handleTapEnd() {
    _stopRepeating(updateState: true);
  }

  void _stopTimers() {
    _initialTimer?.cancel();
    _initialTimer = null;
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  void _stopRepeating({required bool updateState}) {
    _stopTimers();
    _tickCount = 0;
    if (updateState && mounted && _isPressed) {
      setState(() => _isPressed = false);
    } else {
      _isPressed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBg = _isPressed && widget.enabled
        ? widget.splashColor
        : (_isHovered && widget.enabled
            ? widget.hoverColor
            : widget.backgroundColor);

    final iconColor = widget.enabled
        ? widget.foregroundColor
        : widget.disabledForegroundColor;

    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) {
          if (mounted) {
            setState(() => _isHovered = true);
          }
        },
        onExit: (_) {
          if (mounted) {
            setState(() => _isHovered = false);
          }
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: widget.enabled ? _handleTapDown : null,
          onTapUp: widget.enabled ? (_) => _handleTapEnd() : null,
          onTapCancel: widget.enabled ? _handleTapEnd : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: widget.width,
            height: widget.height,
            color: effectiveBg,
            alignment: Alignment.center,
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
