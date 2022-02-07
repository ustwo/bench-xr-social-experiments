// Distant Lands 2021.



using System.Collections.Generic;
using UnityEngine;

namespace DistantLands.Cozy.Data
{

    [System.Serializable]
    [CreateAssetMenu(menuName = "Distant Lands/Cozy/Ambience Profile", order = 361)]
    public class AmbienceProfile : ScriptableObject
    {

        [Header("Forecast Settings")]
        [Tooltip("Specifies the minimum (x) and maximum (y) length for this ambience profile.")]
        public Vector2 playTime = new Vector2(120, 480);
        [Tooltip("Multiplier for the computational chance that this ambience profile will play; 0 being never, and 2 being twice as likely as the average.")]
        [Range(0, 2)]
        public float likelihood = 1;
        public WeatherProfile[] dontPlayDuring;
        public List<ChanceEffector> chances;


        [Header("VFX")]
        public GameObject particleFX;
        public AudioClip soundFX;
        [Range(0, 1)]
        public float FXVolume = 1;


        [System.Serializable]
        public class ChanceEffector
        {

            public enum LimitType { Temprature, Precipitation, YearPercentage, Time };
            public LimitType limitType;
            public AnimationCurve curve;


            public float GetChance(float temp, float precip, float yearPercent, float timePercent)
            {

                switch (limitType)
                {
                    case LimitType.Temprature:
                        return curve.Evaluate(temp / 100);
                    case (LimitType.Precipitation):
                        return curve.Evaluate(precip / 100);
                    case (LimitType.YearPercentage):
                        return curve.Evaluate(yearPercent);
                    case (LimitType.Time):
                        return curve.Evaluate(timePercent);
                    default:
                        return 1;
                }

            }
        }


        public float GetChance (float temp, float precip, float yearPercent, float time)
        {

            float i = likelihood;

            foreach (ChanceEffector j in chances)
            {
                i *= j.GetChance(temp, precip, yearPercent, time);
            }

            return Mathf.Clamp(i, 0, 1000000);

        }

    }
}