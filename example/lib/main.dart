import 'package:flutter/material.dart';
import 'package:input_number/input_number.dart';

void main() {
  runApp(const InputNumberShowcaseApp());
}

/// Root application widget demonstrating the `input_number` library.
class InputNumberShowcaseApp extends StatefulWidget {
  /// Creates the showcase application.
  const InputNumberShowcaseApp({super.key});

  @override
  State<InputNumberShowcaseApp> createState() => _InputNumberShowcaseAppState();
}

class _InputNumberShowcaseAppState extends State<InputNumberShowcaseApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InputNumber Showcase',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF4F46E5),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF6366F1),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: ShowcaseHomePage(
        isDark: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

/// Interactive showcase screen for [InputNumber] and [InputNumberFormField].
class ShowcaseHomePage extends StatefulWidget {
  /// Creates the showcase home page.
  const ShowcaseHomePage({
    required this.isDark,
    required this.onToggleTheme,
    super.key,
  });

  /// Whether dark mode is active.
  final bool isDark;

  /// Callback to toggle light and dark theme modes.
  final VoidCallback onToggleTheme;

  @override
  State<ShowcaseHomePage> createState() => _ShowcaseHomePageState();
}

class _ShowcaseHomePageState extends State<ShowcaseHomePage> {
  final _formKey = GlobalKey<FormState>();
  late final InputNumberController _controlledStepper;

  @override
  void initState() {
    super.initState();
    _controlledStepper = InputNumberController(
      value: 25,
      min: 0,
      max: 100,
      step: 5,
    );
  }

  @override
  void dispose() {
    _controlledStepper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('input_number Showcase'),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle theme',
            icon: Icon(
              widget.isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionCard(
              title: '1. Button Layouts',
              subtitle: 'Choose between split, stackedEnd, inlineEnd, or none.',
              children: const [
                InputNumber(
                  labelText: 'Split Layout (Default)',
                  initialValue: 3,
                  min: 0,
                  max: 20,
                  buttonLayout: InputNumberButtonLayout.split,
                ),
                SizedBox(height: 16),
                InputNumber(
                  labelText: 'Stacked End (Desktop SpinBox)',
                  initialValue: 12,
                  min: 0,
                  max: 100,
                  buttonLayout: InputNumberButtonLayout.stackedEnd,
                ),
                SizedBox(height: 16),
                InputNumber(
                  labelText: 'Inline End',
                  initialValue: 50,
                  step: 10,
                  buttonLayout: InputNumberButtonLayout.inlineEnd,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: '2. Visual Variants & Sizes',
              subtitle: 'Outlined, filled, underlined, and pill styles.',
              children: const [
                InputNumber(
                  labelText: 'Outlined (Small)',
                  initialValue: 1,
                  size: InputNumberSize.small,
                  variant: InputNumberVariant.outlined,
                ),
                SizedBox(height: 16),
                InputNumber(
                  labelText: 'Filled (Medium)',
                  initialValue: 5,
                  size: InputNumberSize.medium,
                  variant: InputNumberVariant.filled,
                ),
                SizedBox(height: 16),
                InputNumber(
                  labelText: 'Pill Capsule (Large)',
                  initialValue: 10,
                  size: InputNumberSize.large,
                  variant: InputNumberVariant.pill,
                ),
                SizedBox(height: 16),
                InputNumber(
                  labelText: 'Underlined',
                  initialValue: 42,
                  variant: InputNumberVariant.underlined,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: '3. Precision Math & Formatting Presets',
              subtitle:
                  'IEEE 754 safe decimal stepping, currency, IDR, and percentages.',
              children: const [
                InputNumber(
                  labelText: 'Decimal Precision (step: 0.1)',
                  initialValue: 0.1,
                  min: 0,
                  max: 10,
                  step: 0.1,
                  precision: 2,
                  helperText: '0.1 + 0.2 equals exactly 0.3',
                ),
                SizedBox(height: 16),
                InputNumber(
                  labelText: 'USD Currency Format',
                  initialValue: 1250.5,
                  min: 0,
                  step: 25,
                  precision: 2,
                  format: InputNumberFormat.currency(),
                  buttonLayout: InputNumberButtonLayout.stackedEnd,
                ),
                SizedBox(height: 16),
                InputNumber(
                  labelText: 'Indonesian Rupiah (IDR)',
                  initialValue: 1500000,
                  min: 0,
                  step: 50000,
                  precision: 0,
                  format: InputNumberFormat.idr(),
                  buttonLayout: InputNumberButtonLayout.inlineEnd,
                ),
                SizedBox(height: 16),
                InputNumber(
                  labelText: 'Percentage Format',
                  initialValue: 75.5,
                  min: 0,
                  max: 100,
                  step: 0.5,
                  precision: 1,
                  format: InputNumberFormat.percentage(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: '4. Controller & Form Validation',
              subtitle:
                  'Observe changes with InputNumberController & validate with Form.',
              children: [
                InputNumber(
                  labelText: 'Controlled Input (0 - 100, step 5)',
                  controller: _controlledStepper,
                  showClearButton: true,
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<num?>(
                  valueListenable: _controlledStepper,
                  builder: (context, value, _) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Chip(label: Text('Current: ${value ?? "empty"}')),
                        OutlinedButton(
                          onPressed: () => _controlledStepper.setValue(50),
                          child: const Text('Set 50'),
                        ),
                        OutlinedButton(
                          onPressed: _controlledStepper.reset,
                          child: const Text('Reset'),
                        ),
                      ],
                    );
                  },
                ),
                const Divider(height: 32),
                InputNumberFormField(
                  labelText: 'Order Quantity (Min 5, Max 50)',
                  initialValue: 2,
                  min: 0,
                  max: 100,
                  step: 1,
                  precision: 0,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter a quantity.';
                    }
                    if (value < 5) {
                      return 'Minimum order quantity is 5 units.';
                    }
                    if (value > 50) {
                      return 'Maximum order quantity is 50 units.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () {
                      _formKey.currentState?.validate();
                    },
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Validate Form'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
