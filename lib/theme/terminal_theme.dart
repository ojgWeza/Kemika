import 'package:flutter/material.dart';

/// Deliberately DOS/terminal-styled placeholder visuals -- CONSTITUTION.md
/// principle 4 ("DOS-like / deliberately primitive pixel art"). Sharp
/// corners, monospace type, black background, phosphor-green accent: this is
/// meant to read as an intentional retro aesthetic, not as "the graphic
/// wasn't made yet." Real pixel art replaces this incrementally later; this
/// is the placeholder done on purpose, not a missing one.
class TerminalColors {
  const TerminalColors._();

  static const background = Color(0xFF0A0F0A);
  static const green = Color(0xFF39FF14);
  static const greenDim = Color(0xFF1E7A0D);
  static const greenFaint = Color(0xFF123C09);
}

ThemeData buildTerminalTheme() {
  const green = TerminalColors.green;
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'monospace',
    scaffoldBackgroundColor: TerminalColors.background,
    colorScheme: const ColorScheme.dark(
      primary: green,
      onPrimary: Colors.black,
      surface: TerminalColors.background,
      onSurface: green,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: TerminalColors.background,
      foregroundColor: green,
      elevation: 0,
      centerTitle: false,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: TerminalColors.background,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: green, width: 2),
        borderRadius: BorderRadius.zero,
      ),
      titleTextStyle: TextStyle(color: green, fontWeight: FontWeight.bold, fontSize: 18),
      contentTextStyle: TextStyle(color: green),
    ),
  );
}

/// A sharp-cornered bracket-outline button, e.g. "[ RECORD OBSERVATION ]".
/// Full brightness when [onPressed] is set, dimmed when null -- the disabled
/// state must stay visually obvious (law 1: can't record before enough
/// drips land), not just technically inert.
class TerminalButton extends StatelessWidget {
  const TerminalButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = onPressed != null ? TerminalColors.green : TerminalColors.greenDim;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          side: BorderSide(color: color, width: 2),
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text('[ $label ]', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

/// Compact bracket toggle used for the EN/AR switch in the app bar, e.g. "[AR]".
/// [active] renders full-brightness green; inactive renders dim.
class TerminalToggleChip extends StatelessWidget {
  const TerminalToggleChip({super.key, required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? TerminalColors.green : TerminalColors.greenDim;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text('[$label]', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
