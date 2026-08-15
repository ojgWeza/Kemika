using UnityEngine;

namespace Kemika.Data
{
    [CreateAssetMenu(fileName = "NewReaction", menuName = "Kemika/Reaction")]
    public class Reaction : ScriptableObject
    {
        public IonSpecies targetIon;
        public Reagent reagent;

        [Tooltip("Number of individual drip actions required before the reaction is fully revealed.")]
        public int requiredDripCount = 5;

        public Color resultColor = Color.white;
        public string resultDescriptionEn;
        public string resultDescriptionAr;
        public string equationText;

        [Tooltip("Plausible-but-wrong descriptions shown alongside the correct one at the record step, " +
                 "so the player has to pick based on what they actually observed, not what they're told.")]
        public string[] distractorDescriptionsEn;
        public string[] distractorDescriptionsAr;

        public static Reaction Create(IonSpecies ion, Reagent reagent, int dripCount, Color resultColor,
            string descEn, string descAr, string equation, string[] distractorsEn, string[] distractorsAr)
        {
            var r = CreateInstance<Reaction>();
            r.targetIon = ion;
            r.reagent = reagent;
            r.requiredDripCount = dripCount;
            r.resultColor = resultColor;
            r.resultDescriptionEn = descEn;
            r.resultDescriptionAr = descAr;
            r.equationText = equation;
            r.distractorDescriptionsEn = distractorsEn;
            r.distractorDescriptionsAr = distractorsAr;
            return r;
        }
    }
}
