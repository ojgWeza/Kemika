enum AppLanguage { english, arabic }

/// Same pattern as prayer-qibla-app's AppStrings: a plain Map, no code-gen, no ARB
/// files. Unlike the Unity prototype this replaced, Flutter renders Arabic (bidi,
/// glyph shaping, RTL) correctly out of the box -- see prayer-qibla-app for proof.
class AppStrings {
  static AppLanguage current = AppLanguage.english;

  static const Map<String, (String en, String ar)> _map = {
    'slice.instruction': (
      'Drag the AgNO3 dropper onto the beaker and release to add a drop.',
      'اسحب قطارة نترات الفضة فوق الكأس ثم أفلتها لإضافة قطرة.',
    ),
    'slice.beakerLabel': ('Unknown Solution X', 'محلول مجهول X'),
    'slice.recordButton': ('Record Observation', 'سجل الملاحظة'),
    'slice.recordPrompt': (
      'What do you see in the beaker right now?',
      'ماذا ترى في الكأس الآن؟',
    ),
    'slice.correct': ('Correct!', 'إجابة صحيحة!'),
    'slice.incorrect': ('Not quite — look again.', 'غير صحيح — انظر مرة أخرى.'),
  };

  static String get(String key) {
    final pair = _map[key];
    if (pair == null) return '<missing:$key>';
    return current == AppLanguage.arabic ? pair.$2 : pair.$1;
  }
}
