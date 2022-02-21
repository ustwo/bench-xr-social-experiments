// Distant Lands 2021.



using System.Collections.Generic;
using UnityEngine;



namespace DistantLands.Cozy.Data
{

    [System.Serializable]
    [CreateAssetMenu(menuName = "Distant Lands/Cozy/Weather Profile", order = 361)]
    public class WeatherProfile : ScriptableObject
    {

        [Header("Forecast Settings")]
        [Tooltip("Specifies the minimum (x) and maximum (y) length for this weather profile.")]
        public Vector2 weatherTime = new Vector2(120, 480);
        [Tooltip("Multiplier for the computational chance that this weather profile will play; 0 being never, and 2 being twice as likely as the average.")]
        [Range(0, 2)]
        public float likelihood = 1;              
        [Tooltip("Allow only these weather profiles to immediately follow this weather profile in a forecast.")]
        public WeatherProfile[] forecastNext;
        [Tooltip("Animation curves that increase or decrease weather chance based on time, temprature, etc.")]
        public List<ChanceEffector> chances;


        [Header("Cloud Settings")]
        public CloudSettings cloudSettings;


        [Tooltip("The density of fog for this weather profile.")]
        public float fogDensity = 1;


        [Header("Wind Settings")]
        [Tooltip("The average wind speed for this weather profile.")]
        public float windSpeed = 0.1f;
        [Tooltip("The average wind amount for this weather profile.")]
        public float windAmount = 1;

        [Header("Precipitation")]
        [Tooltip("How much snow should accumulate per second.")]
        public float snowAccumulationSpeed = 0;
        [Tooltip("How much should puddles accumulate per second.")]
        public float wetnessSpeed = 0;
        public GameObject particleFX;
        public bool useThunder;
        [Tooltip("Specifies the minimum (x) and maximum (y) time between lightning strikes.")]
        public Vector2 thunderTime = new Vector2(7, 13);

        [Header("SFX")]
        public AudioClip soundFX;
        public float FXVolume = 1;


        [Header("Color Correction")]
        public WeatherFilter weatherFilter;

        [System.Serializable]
        public class WeatherFilter
        {
            [Range(-1, 1)]
            public float saturation;
            [Range(-1, 1)]
            public float value;
            public Color colorFilter = Color.white;

        }


        [System.Serializable]
        public class CloudSettings
        {
            [Tooltip("Specifies the minimum (x) and maximum (y) cloud coverage for this weather profile.")]
            public Vector2 cloudCoverage = new Vector2(0.2f, 0.3f);
            [Tooltip("Multiplier for cumulus clouds.")]
            [Range(0, 2)]
            public float cumulusCoverage = 1;
            [Tooltip("Multiplier for altocumulus clouds.")]
            [Range(0, 2)]
            public float altocumulusCoverage = 0;
            [Tooltip("Multiplier for chemtrails.")]
            [Range(0, 2)]
            public float chemtrailCoverage = 0;
            [Tooltip("Multiplier for cirrostratus clouds.")]
            [Range(0, 2)]
            public float cirrostratusCoverage = 0;
            [Tooltip("Multiplier for cirrus clouds.")]
            [Range(0, 2)]
            public float cirrusCoverage = 0;
            [Tooltip("Multiplier for nimbus clouds.")]
            [Range(0, 2)]
            public float nimbusCoverage = 0;
            [Tooltip("Variation for nimbus clouds.")]
            [Range(0, 1)]
            public float nimbusVariation = 0.9f;
            [Tooltip("Height mask effect for nimbus clouds.")]
            [Range(0, 1)]
            public float nimbusHeightEffect = 1;

            [Tooltip("Starting height for cloud border.")]
            [Range(0, 1)]
            public float borderHeight = 0.5f;
            [Tooltip("Variation for cloud border.")]
            [Range(0, 1)]
            public float borderVariation = 0.9f;
            [Tooltip("Multiplier for the border. Values below zero clip the clouds whereas values above zero add clouds.")]
            [Range(-1, 1)]
            public float borderEffect = 1;

        }

        public Color sunFilter = Color.white;
        public Color cloudFilter = Color.white;





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