import 'package:flutter/material.dart';

import 'ion_species.dart';
import 'reagent.dart';

class Reaction {
  const Reaction({
    required this.targetIon,
    required this.reagent,
    required this.requiredDripCount,
    required this.resultColor,
    required this.resultDescriptionEn,
    required this.resultDescriptionAr,
    required this.equationText,
    required this.distractorDescriptionsEn,
    required this.distractorDescriptionsAr,
  });

  final IonSpecies targetIon;
  final Reagent reagent;

  /// Number of individual drip actions required before the reaction is fully revealed.
  final int requiredDripCount;

  final Color resultColor;
  final String resultDescriptionEn;
  final String resultDescriptionAr;
  final String equationText;

  /// Plausible-but-wrong descriptions shown alongside the correct one at the record
  /// step (should include the correct one too), so the player has to pick based on
  /// what they actually observed, not what they're told.
  final List<String> distractorDescriptionsEn;
  final List<String> distractorDescriptionsAr;
}
