// Distant Lands 2021.





using DistantLands.Cozy.Data;
using UnityEngine;


namespace DistantLands.Cozy
{

    [ExecuteAlways]
    public class CozyClimate : CozyModule
    {



        [Header("Profile Reference")]
        public ClimateProfile climateProfile;


        [Space(10)]
        [Tooltip("Adds an offset to the global temprature. Useful for adding biomes or climate change by location or elevation")]
        public float tempratureFilter;
        [Tooltip("Adds an offset to the global precipitation. Useful for adding biomes or climate change by location or elevation")]
        public float precipitationFilter;


        [Header("Current Information")]
        public float currentTemprature;
        public float currentTempratureCelsius;
        public float currentPrecipitation;





        void Awake()
        {

            if (!enabled)
                return;

            base.SetupModule();

            currentTemprature = GlobalTemprature(false);
            currentPrecipitation = GlobalHumidity();


        }

        // Update is called once per frame
        public void Update()
        {

            if (weatherSphere == null)
                if (CozyWeather.instance)
                    base.SetupModule();
                else
                {
                    Debug.LogError("Could not find an instance of COZY");
                    return;
                }


            currentTemprature = GlobalTemprature(false) + tempratureFilter;
            currentTempratureCelsius = GlobalTemprature(true) + tempratureFilter;
            currentPrecipitation = GlobalHumidity() + precipitationFilter;



        }


      

        public float GlobalTemprature(bool celsius)
        {


            float i = (climateProfile.tempratureOverYear.Evaluate(weatherSphere.perennialProfile.YearPercentage()) * climateProfile.tempratureOverDay.Evaluate(weatherSphere.perennialProfile.DayPercentage())) + tempratureFilter;

            if (celsius)
                i = (i - 32) * 5 / 9;

            return i;
        }

        public float GlobalTemprature(bool celsius, float inTicks)
        {

            float nextDays = inTicks / weatherSphere.perennialProfile.ticksPerDay;

            float i = (climateProfile.tempratureOverYear.Evaluate((weatherSphere.perennialProfile.dayAndTime + nextDays) / weatherSphere.perennialProfile.daysPerYear) * climateProfile.tempratureOverDay.Evaluate(weatherSphere.perennialProfile.DayPercentage())) + tempratureFilter;

            if (celsius)
                i = (i - 32) * 5 / 9;

            return i;
        }

        public float GlobalHumidity()
        {


            float i = (climateProfile.precipitationOverYear.Evaluate(weatherSphere.perennialProfile.YearPercentage()) * climateProfile.precipitationOverDay.Evaluate(weatherSphere.perennialProfile.DayPercentage())) + precipitationFilter;

            return i;
        }

        public float GlobalHumidity(float inTicks)
        {
            float nextDays = inTicks / weatherSphere.perennialProfile.ticksPerDay;

            float i = (climateProfile.precipitationOverYear.Evaluate((weatherSphere.perennialProfile.dayAndTime + nextDays) / weatherSphere.perennialProfile.daysPerYear) * climateProfile.precipitationOverDay.Evaluate(weatherSphere.perennialProfile.DayPercentage())) + precipitationFilter;

            return i;
        }

    }
}