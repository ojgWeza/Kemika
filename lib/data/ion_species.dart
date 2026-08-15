enum IonCategory { cation, anion }

class IonSpecies {
  const IonSpecies({
    required this.id,
    required this.displayNameEn,
    required this.displayNameAr,
    required this.category,
  });

  final String id;
  final String displayNameEn;
  final String displayNameAr;
  final IonCategory category;
}
