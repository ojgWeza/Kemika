import 'package:flutter/material.dart';

import 'screens/practice_slice_screen.dart';
import 'theme/terminal_theme.dart';

void main() {
  runApp(const KemikaApp());
}

class KemikaApp extends StatelessWidget {
  const KemikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kemika',
      debugShowCheckedModeBanner: false,
      theme: buildTerminalTheme(),
      home: const PracticeSliceScreen(),
    );
  }
}
