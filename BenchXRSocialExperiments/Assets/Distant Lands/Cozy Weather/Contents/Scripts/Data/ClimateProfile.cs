// Distant Lands 2022.



using UnityEngine;



namespace DistantLands.Cozy.Data
{

    [System.Serializable]
    [CreateAssetMenu(menuName = "Distant Lands/Cozy/Climate Profile", order = 361)]
    public class ClimateProfile : ScriptableObject
    {


        [Header("Curves and Filters")]
        [Tooltip("The global temprature during the year. the x-axis is the current day over the days in the year and the y axis is the temprature in farenheit.")]
        public AnimationCurve tempratureOverYear;
        [Tooltip("The global precipitation during the year. the x-axis is the current day over the days in the year and the y axis is the precipitation.")]
        public AnimationCurve precipitationOverYear;
        [Tooltip("The local temprature during the day. the x-axis is the current ticks over 360 and the y axis is the temprature change in farenheit from the global temprature.")]
        public AnimationCurve tempratureOverDay;
        [Tooltip("The local precipitation during the day. the x-axis is the current ticks over 360 and the y axis is the precipitation change from the global precipitation.")]
        public AnimationCurve precipitationOverDay;


        [Space(10)]
        [Tooltip("Adds an offset to the global temprature. Useful for adding biomes or climate change by location or elevation")]
        public float tempratureFilter;
        [Tooltip("Adds an offset to the global precipitation. Useful for adding biomes or climate change by location or elevation")]
        public float precipitationFilter;

    }
}