// Distant Lands 2021.



using UnityEngine;



namespace DistantLands.Cozy.Data
{

    [System.Serializable]
    [CreateAssetMenu(menuName = "Distant Lands/Cozy/Material Manager Profile", order = 361)]
    public class MaterialManagerProfile : ScriptableObject
    {


        [Tooltip("Changes the terrain tint color for these layers")]
        public TerrainLayerProfile[] terrainLayers;
        [Tooltip("Changes a certain color value for a material based on the current time of year")]
        public SeasonalColorMaterialProfile[] seasonalMaterials;
        [Tooltip("Changes a certain float value for a material based on the current time of year")]
        public SeasonalValueMaterialProfile[] seasonalValueMaterials;



        [System.Serializable]
        public class TerrainLayerProfile
        {
            public TerrainLayer layer;
            public Gradient color;


        }


        [System.Serializable]
        public class SeasonalColorMaterialProfile
        {
            public Material material;
            public string propertyToChange;
            public Gradient color;

        }
        [System.Serializable]
        public class SeasonalValueMaterialProfile
        {
            public Material material;
            public string propertyToChange;
            public AnimationCurve value;

        }

    }
}