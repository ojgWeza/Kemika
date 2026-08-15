using System.Collections.Generic;

namespace Kemika.Localization
{
    public enum Language
    {
        English,
        Arabic
    }

    // Mirrors prayer-qibla-app's AppStrings pattern: a plain Map, no code-gen, no ARB
    // files. Arabic strings live here but are not yet safe to render with Unity's
    // built-in UI Text component -- see CLAUDE.md "Known gaps" for why (no bidi/glyph
    // shaping without extra setup).
    public static class LocalizedStrings
    {
        public static Language Current = Language.English;

        private static readonly Dictionary<string, (string en, string ar)> Map = new()
        {
            ["slice.instruction"] = (
                "Drag the AgNO3 dropper onto the beaker and release to add a drop.",
                "اسحب قطارة نترات الفضة فوق الكأس ثم أفلتها لإضافة قطرة."),
            ["slice.beakerLabel"] = ("Unknown Solution X", "محلول مجهول X"),
            ["slice.recordButton"] = ("Record Observation", "سجل الملاحظة"),
            ["slice.recordPrompt"] = (
                "What do you see in the beaker right now?",
                "ماذا ترى في الكأس الآن؟"),
            ["slice.correct"] = ("Correct!", "إجابة صحيحة!"),
            ["slice.incorrect"] = ("Not quite -- look again.", "غير صحيح -- انظر مرة أخرى."),
        };

        public static string Get(string key)
        {
            if (!Map.TryGetValue(key, out var pair)) return $"<missing:{key}>";
            return Current == Language.Arabic ? pair.ar : pair.en;
        }
    }
}
