// Distant Lands 2021.





using UnityEngine;


namespace DistantLands.Cozy
{

    [ExecuteAlways]
    public class CozyCalendar : CozyModule
    {



        [Header("Options")]
        [Tooltip("Should this system reset the ticks when it loads or should it pull the current ticks from the scriptable object?")]
        public bool resetTicksOnStart = false;
        [Tooltip("The ticks that this system should start at when the scene is loaded.")]
        public float startTicks = 120;


        [Header("Current Information")]
        public string monthName;
        public string formattedTime;




        #region Context Menu Items
        [ContextMenu("Dawn", false, 1000)]
        public void Dawn()
        {

            weatherSphere.perennialProfile.currentTicks = (weatherSphere.perennialProfile.ticksPerDay / 360) * 75;

        }

        [ContextMenu("Morning", false, 1000)]
        public void Morning()
        {

            weatherSphere.perennialProfile.currentTicks = (weatherSphere.perennialProfile.ticksPerDay / 360) * 90;

        }
        [ContextMenu("Noon", false, 1000)]
        public void Noon()
        {

            weatherSphere.perennialProfile.currentTicks = (weatherSphere.perennialProfile.ticksPerDay / 360) * 180;

        }
        [ContextMenu("Afternoon", false, 1000)]
        public void Afternoon()
        {

            weatherSphere.perennialProfile.currentTicks = (weatherSphere.perennialProfile.ticksPerDay / 360) * 240;

        }
        [ContextMenu("Evening", false, 1000)]
        public void Evening()
        {

            weatherSphere.perennialProfile.currentTicks = (weatherSphere.perennialProfile.ticksPerDay / 360) * 260;

        }
        [ContextMenu("Twilight", false, 1000)]
        public void Twilight()
        {

            weatherSphere.perennialProfile.currentTicks = (weatherSphere.perennialProfile.ticksPerDay / 360) * 285;

        }

        [ContextMenu("Night", false, 1000)]
        public void Night()
        {

            weatherSphere.perennialProfile.currentTicks = (weatherSphere.perennialProfile.ticksPerDay / 360) * 300;

        }

        [ContextMenu("Midnight", false, 1000)]
        public void Midnight()
        {

            weatherSphere.perennialProfile.currentTicks = 0;

        }

        [ContextMenu("Spring")]
        public void SetSeasonSpring()
        {

            weatherSphere.perennialProfile.currentDay = (weatherSphere.perennialProfile.daysPerYear / 4);

        }
        [ContextMenu("Summer")]
        public void SetSeasonSummer()
        {

            weatherSphere.perennialProfile.currentDay = (weatherSphere.perennialProfile.daysPerYear / 4) * 2;

        }
        [ContextMenu("Autumn")]
        public void SetSeasonAutumn()
        {

            weatherSphere.perennialProfile.currentDay = (weatherSphere.perennialProfile.daysPerYear / 4) * 3;

        }
        [ContextMenu("Winter")]
        public void SetSeasonWinter()
        {

            weatherSphere.perennialProfile.currentDay = (weatherSphere.perennialProfile.daysPerYear / 4) * 4;

        }

        #endregion



        void Awake()
        {

            if (!enabled)
                return;

            base.SetupModule(); 

            if (resetTicksOnStart)
                weatherSphere.perennialProfile.currentTicks = startTicks;

        }

        // Update is called once per frame
        public void Update()
        {

            if (weatherSphere == null)
                if (CozyWeather.instance)
                    SetupModule();
                else
                {
                    Debug.LogError("Could not find an instance of COZY");
                    return;
                }

            ManageTime();

            monthName = MonthTitle(weatherSphere.perennialProfile.dayAndTime / weatherSphere.perennialProfile.daysPerYear);

            

        }


        public void ManageTime()
        {

            if (Application.isPlaying && !weatherSphere.perennialProfile.pauseTime)
                weatherSphere.perennialProfile.currentTicks += weatherSphere.perennialProfile.ModifiedTickSpeed() * Time.deltaTime;

            if (weatherSphere.perennialProfile.currentTicks > weatherSphere.perennialProfile.ticksPerDay)
            {
                weatherSphere.perennialProfile.currentTicks -= weatherSphere.perennialProfile.ticksPerDay;
                weatherSphere.perennialProfile.currentDay++;
            }

            if (weatherSphere.perennialProfile.currentTicks < 0)
            {
                weatherSphere.perennialProfile.currentTicks += weatherSphere.perennialProfile.ticksPerDay;
                weatherSphere.perennialProfile.currentDay--;
            }

            if (weatherSphere.perennialProfile.currentDay >= weatherSphere.perennialProfile.daysPerYear)
            {
                weatherSphere.perennialProfile.currentDay -= weatherSphere.perennialProfile.daysPerYear;
                weatherSphere.perennialProfile.currentYear++;
            }

            if (weatherSphere.perennialProfile.currentDay < 0)
            {
                weatherSphere.perennialProfile.currentDay += weatherSphere.perennialProfile.daysPerYear;
                weatherSphere.perennialProfile.currentYear--;
            }

            weatherSphere.perennialProfile.dayAndTime = weatherSphere.perennialProfile.currentDay + (weatherSphere.perennialProfile.currentTicks / weatherSphere.perennialProfile.ticksPerDay);

        }


        public string MonthTitle (float month)
        {

            string monthName = "";
            string monthTimeName = "";

            float j = Mathf.Floor(month * 12);
            float monthLength = weatherSphere.perennialProfile.ticksPerDay / 12;
            float monthTime = weatherSphere.perennialProfile.dayAndTime - (j * monthLength);

            switch (j)
            {
                case 0:
                    monthName = "January";
                    break;
                case 1:
                    monthName = "February";
                    break;
                case 2:
                    monthName = "March";
                    break;
                case 3:
                    monthName = "April";
                    break;
                case 4:
                    monthName = "May";
                    break;
                case 5:
                    monthName = "June";
                    break;
                case 6:
                    monthName = "July";
                    break;
                case 7:
                    monthName = "August";
                    break;
                case 8:
                    monthName = "September";
                    break;
                case 9:
                    monthName = "October";
                    break;
                case 10:
                    monthName = "November";
                    break;
                case 11:
                    monthName = "December";
                    break;


            }


            if ((monthTime / monthLength) < 0.33f)
                monthTimeName = "Early";
            else if ((monthTime / monthLength) > 0.66f)
                monthTimeName = "Late";
            else
                monthTimeName = "Mid";
            

            return monthTimeName + " " + monthName;
        }

        public float YearPercentage() { return weatherSphere.perennialProfile.dayAndTime / weatherSphere.perennialProfile.daysPerYear; }
        public float YearPercentage(float inTicks) { return (weatherSphere.perennialProfile.dayAndTime + (inTicks / weatherSphere.perennialProfile.ticksPerDay)) / weatherSphere.perennialProfile.daysPerYear; }

    }
}