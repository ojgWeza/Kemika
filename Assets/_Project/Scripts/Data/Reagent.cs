using UnityEngine;

namespace Kemika.Data
{
    [CreateAssetMenu(fileName = "NewReagent", menuName = "Kemika/Reagent")]
    public class Reagent : ScriptableObject
    {
        public string id;
        public string displayNameEn;
        public string displayNameAr;
        public Color dropperTint = Color.white;

        public static Reagent Create(string id, string nameEn, string nameAr, Color tint)
        {
            var reagent = CreateInstance<Reagent>();
            reagent.id = id;
            reagent.displayNameEn = nameEn;
            reagent.displayNameAr = nameAr;
            reagent.dropperTint = tint;
            return reagent;
        }
    }
}
