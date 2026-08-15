import 'package:flutter/material.dart';

class Reagent {
  const Reagent({
    required this.id,
    required this.displayNameEn,
    required this.displayNameAr,
    required this.dropperTint,
  });

  final String id;
  final String displayNameEn;
  final String displayNameAr;
  final Color dropperTint;
}
