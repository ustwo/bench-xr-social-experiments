﻿// Distant Lands 2021.



using DistantLands.Cozy.Data;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace DistantLands.Cozy
{
    public class CozyForecast : CozyModule
    {

        [System.Serializable]
        public class Weather
        {
            public Data.WeatherProfile profile;
            public float weatherProfileDuration;

        }


        [Header("Profile Reference")]
        public ForecastProfile forecastProfile;


        public List<Weather> forecast;

        

        private float m_WeatherTimer;

        public float weatherTimer
        {

            get { return m_WeatherTimer; }
            set { m_WeatherTimer = weatherTimer; }

        }




        void Awake()
        {

            if (!enabled)
                return;

            base.SetupModule();

            for (int i = 0; i < forecastProfile.forecastLength; i++)
                ForecastNewWeather();



            SetNextWeather();

            foreach (WeatherProfile i in forecastProfile.profilesToForecast)
            {
                if (i.particleFX)
                {
                    ParticleSystem system = Instantiate(i.particleFX, transform.GetChild(2)).GetComponent<ParticleSystem>();
                    system.gameObject.name = i.name;


                    if (triggerManagerModule)
                    {
                        ParticleSystem.TriggerModule triggers = system.trigger;

                        triggers.enter = ParticleSystemOverlapAction.Kill;
                        triggers.inside = ParticleSystemOverlapAction.Kill;
                        for (int j = 0; j < triggerManagerModule.cozyTriggers.Count; j++)
                            triggers.SetCollider(j, triggerManagerModule.cozyTriggers[j]);
                    }
                }
            }
        }

        public void SkipTicks(float ticksToSkip)
        {

            m_WeatherTimer -= ticksToSkip;

        }

        // Update is called once per frame
        void Update()
        {

            m_WeatherTimer -= Time.deltaTime * weatherSphere.perennialProfile.ModifiedTickSpeed();

            if (m_WeatherTimer <= 0)
            {
                while(m_WeatherTimer <= 0)
                SetNextWeather();
            }

        }


        public void SetNextWeather()
        {

            WeatherProfile i = forecast[0].profile;

            if (audioModule)
                audioModule.ChangeSound(i);

            weatherSphere.ChangeProfile(i);
            m_WeatherTimer += forecast[0].weatherProfileDuration;

            forecast.RemoveAt(0);
            ForecastNewWeather();

        }

        public void ForecastNewWeather()
        {

            Weather i = new Weather();

            if (forecast.Count > 0)
                i.profile = WeightedRandom(IntersectionArray(forecastProfile.profilesToForecast.ToArray(), forecast.Last().profile.forecastNext));
            else
                i.profile = WeightedRandom(forecastProfile.profilesToForecast.ToArray());
            i.weatherProfileDuration = Random.Range(i.profile.weatherTime.x, i.profile.weatherTime.y);


            forecast.Add(i);

        }

        public WeatherProfile WeightedRandom(WeatherProfile[] profiles)
        {

            if (profiles.Count() == 0)
                profiles = forecastProfile.profilesToForecast.ToArray();

            WeatherProfile i = null;
            List<float> floats = new List<float>();
            float totalChance = 0;
            float inTicks = 0;

            foreach (Weather k in forecast)
                inTicks += k.weatherProfileDuration;


            foreach (WeatherProfile k in profiles)
            {
                float chance = calendarModule ? k.GetChance(climateModule.GlobalTemprature(false, inTicks),
                    climateModule.GlobalHumidity(inTicks),
                    weatherSphere.perennialProfile.YearPercentage(inTicks),
                    weatherSphere.perennialProfile.currentTicks + (inTicks - Mathf.Floor(inTicks / weatherSphere.perennialProfile.ticksPerDay)))
                    : 1;
                floats.Add(chance);         
                totalChance += chance;
            }

            float selection = Random.Range(0, totalChance);

            int m = 0;                                                                                                                                                                      
            float l = 0;

            while ( l <= selection)
            {

                if (selection >= l && selection < l + floats[m])
                {
                    i = profiles[m];
                    break;
                }
                l += floats[m];
                m++;

            }

            if (!i)
            {
                i = profiles[0];
            }

            return i;
        }

        WeatherProfile[] SubtractiveArray(WeatherProfile[] total, WeatherProfile[] subtraction)
        {

            return total.ToList().Except(subtraction.ToList()).ToArray();

        }
        WeatherProfile[] IntersectionArray(WeatherProfile[] total, WeatherProfile[] subtraction)
        {

            return subtraction.ToList().Except(subtraction.ToList().Except(total.ToList())).ToArray();

        }

    }
}