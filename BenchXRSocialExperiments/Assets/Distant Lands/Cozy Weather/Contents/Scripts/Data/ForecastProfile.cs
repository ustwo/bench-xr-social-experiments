// Distant Lands 2022.



using System.Collections.Generic;
using UnityEngine;



namespace DistantLands.Cozy.Data
{

    [System.Serializable]
    [CreateAssetMenu(menuName = "Distant Lands/Cozy/Forecast Profile", order = 361)]
    public class ForecastProfile : ScriptableObject
    {


        [Tooltip("The weather profiles that this profile will forecast.")]
        public List<WeatherProfile> profilesToForecast;

        public int forecastLength;

    }
}