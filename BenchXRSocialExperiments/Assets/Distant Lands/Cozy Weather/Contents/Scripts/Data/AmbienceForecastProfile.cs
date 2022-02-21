// Distant Lands 2021.



using System.Collections.Generic;
using UnityEngine;

namespace DistantLands.Cozy.Data
{

    [System.Serializable]
    [CreateAssetMenu(menuName = "Distant Lands/Cozy/Ambience Forecast Profile", order = 361)]
    public class AmbienceForecastProfile : ScriptableObject
    {

        public List<AmbienceProfile> ambienceProfiles;

    }
}