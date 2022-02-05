// Distant Lands 2021.



using System.Collections.Generic;
using UnityEngine;



namespace DistantLands.Cozy.Data
{

    [System.Serializable]
    [CreateAssetMenu(menuName = "Distant Lands/Cozy/Perennial Profile", order = 361)]
    public class PerennialProfile : ScriptableObject
    {

        [Header("Current Settings")]
        [Tooltip("Specifies the current ticks.")]
        public float currentTicks;
        [Tooltip("Specifies the current day.")]
        public int currentDay;
        [Tooltip("Specifies the current year.")]
        public int currentYear;
        [HideInInspector]
        public float dayAndTime;
        public bool pauseTime;

        [Header("Day Settings")]
        [Tooltip("Specifies the maximum amount of ticks per day.")]
        public float ticksPerDay = 360;
        [Tooltip("Specifies the amount of ticks that passs in a second.")]
        public float tickSpeed = 1;
        [Tooltip("Changes tick speed based on the percentage of the day.")]
        public AnimationCurve tickSpeedMultiplier;

        [Header("Year Settings")]
        public int daysPerYear = 48;


        public float ModifiedTickSpeed()
        {

            return tickSpeed * tickSpeedMultiplier.Evaluate(currentTicks / ticksPerDay);

        }

        public float YearPercentage()
        {

            return dayAndTime / daysPerYear;


        }

        public float DayPercentage()
        {

            return currentTicks / ticksPerDay;


        }

        public float YearPercentage(float inTicks) { return (dayAndTime + (inTicks / ticksPerDay)) / daysPerYear; }

    }
}