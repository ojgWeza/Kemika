import 'package:flutter/material.dart';

import 'screens/practice_slice_screen.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D6B)),
        useMaterial3: true,
      ),
      home: const PracticeSliceScreen(),
    );
  }
}
