using UnityEngine;

namespace Kemika.Data
{
    public enum IonCategory
    {
        Cation,
        Anion
    }

    [CreateAssetMenu(fileName = "NewIon", menuName = "Kemika/Ion Species")]
    public class IonSpecies : ScriptableObject
    {
        public string id;
        public string displayNameEn;
        public string displayNameAr;
        public IonCategory category;

        public static IonSpecies Create(string id, string nameEn, string nameAr, IonCategory category)
        {
            var ion = CreateInstance<IonSpecies>();
            ion.id = id;
            ion.displayNameEn = nameEn;
            ion.displayNameAr = nameAr;
            ion.category = category;
            return ion;
        }
    }
}
