// Distant Lands 2021.



using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using DistantLands.Cozy.Data;
using System.Linq;

namespace DistantLands.Cozy.EditorScripts
{
    public class E_CozyCreateProfile : EditorWindow
    {

        public enum ProfileType { Weather, Ambience}

        public ProfileType profileType;

        public string profileName = "New Profile";
        public GameObject particleFX;
        public float minPlayTime = 30;
        public float maxPlayTime = 90;
        public float likelihood = 1;

        public AudioClip SFX;
        public float audioVolume = 1;
        public bool disableIndoors = true;

        public WeatherProfile.ChanceEffector[] chanceEffectors;
        public WeatherProfile[] forecastNext;
        public float minCloudCoverage = 0.3f;
        public float maxCloudCoverage = 0.6f;
        public float fogDensity = 1;
        public float snowAccumulation;
        public float waterAccumulation;
        public bool useThunder = false;
        public float saturation;
        public float value;
        public Color colorFilter = Color.white;
        public Color sunFilter = Color.white;
        public Color cloudFilter = Color.white;

        public Vector2 scrollPos;


        public WeatherProfile[] dontPlayDuring;




        [MenuItem("Distant Lands/Cozy/Create New Cozy Profile")]
        static void Init()
        {

            E_CozyCreateProfile window = (E_CozyCreateProfile)EditorWindow.GetWindow(typeof(E_CozyCreateProfile), false, "Create New Cozy Profile");
            window.Show();

        }


        private void OnGUI()
        {

            ScriptableObject target = this;
            SerializedObject so = new SerializedObject(target);
            SerializedProperty chances = so.FindProperty("chanceEffectors");
            SerializedProperty forecast = so.FindProperty("forecastNext");
            SerializedProperty disable = so.FindProperty("dontPlayDuring");
            SerializedProperty disableInTrigger = so.FindProperty("disableIndoors");

            EditorGUILayout.LabelField("Profile Type");
            profileType = (ProfileType)EditorGUILayout.EnumPopup(profileType);
            EditorGUILayout.Space(20);

            if (profileType == ProfileType.Ambience)
            {
                profileName = EditorGUILayout.TextField("Ambience Name", profileName);
                EditorGUILayout.Space(20);

                scrollPos = EditorGUILayout.BeginScrollView(scrollPos);
                EditorGUILayout.LabelField("Forecasting Behaviours", EditorStyles.whiteLabel);
                
                EditorGUILayout.MinMaxSlider("Ambience Length", ref minPlayTime, ref maxPlayTime, 0, 150); 

                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Min Ticks: " + Mathf.Round(minPlayTime).ToString(), EditorStyles.miniLabel);
                EditorGUILayout.LabelField("Max Ticks: " + Mathf.Round(maxPlayTime).ToString(), EditorStyles.miniLabel);
                EditorGUILayout.EndHorizontal();

                likelihood = EditorGUILayout.Slider("Ambience Likelihood", likelihood, 0, 2);


                EditorGUILayout.Space(10);

                EditorGUILayout.PropertyField(chances, true);
                EditorGUILayout.PropertyField(disable, true);
                                                            
                so.ApplyModifiedProperties();


                EditorGUILayout.Space(20);
                EditorGUILayout.LabelField("Ambience FX", EditorStyles.whiteLabel);

                particleFX = (GameObject)EditorGUILayout.ObjectField("Particle FX", particleFX, typeof(GameObject), true);
                EditorGUILayout.PropertyField(disableInTrigger, true);
                SFX = (AudioClip)EditorGUILayout.ObjectField("Sound FX", SFX, typeof(AudioClip), true);
                audioVolume = EditorGUILayout.Slider("SFX Volume", audioVolume, 0, 1.1f);



            }   
            else
            {
                profileName = EditorGUILayout.TextField("Weather Name", profileName);
                EditorGUILayout.Space(20);

                scrollPos = EditorGUILayout.BeginScrollView(scrollPos);
                EditorGUILayout.LabelField("Forecasting Behaviours", EditorStyles.whiteLabel);

                EditorGUILayout.MinMaxSlider("Weather Length", ref minPlayTime, ref maxPlayTime, 0, 150);

                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Min Ticks: " + Mathf.Round(minPlayTime).ToString(), EditorStyles.miniLabel);
                EditorGUILayout.LabelField("Max Ticks: " + Mathf.Round(maxPlayTime).ToString(), EditorStyles.miniLabel);
                EditorGUILayout.EndHorizontal();

                likelihood = EditorGUILayout.Slider("Weather Likelihood", likelihood, 0, 2);


                EditorGUILayout.Space(10);

                EditorGUILayout.PropertyField(chances, true);
                EditorGUILayout.PropertyField(forecast, true);

                so.ApplyModifiedProperties();


                EditorGUILayout.Space(20);
                EditorGUILayout.LabelField("Weather FX", EditorStyles.whiteLabel);

                particleFX = (GameObject)EditorGUILayout.ObjectField("Particle FX", particleFX, typeof(GameObject), true);
                EditorGUILayout.PropertyField(disableInTrigger, true);
                SFX = (AudioClip)EditorGUILayout.ObjectField("Sound FX", SFX, typeof(AudioClip), true);
                audioVolume = EditorGUILayout.Slider("SFX Volume", audioVolume, 0, 1.1f);

                EditorGUILayout.Space(20);
                EditorGUILayout.LabelField("Color Filters", EditorStyles.whiteLabel);


                saturation = EditorGUILayout.Slider("Saturation", saturation, -1, 1);
                value = EditorGUILayout.Slider("Value", value, -1, 1);
                colorFilter = EditorGUILayout.ColorField("Main Filter Color", colorFilter);
                cloudFilter = EditorGUILayout.ColorField("Cloud Filter Color", cloudFilter);
                sunFilter = EditorGUILayout.ColorField("Sun Filter Color", sunFilter);

                EditorGUILayout.Space(20);
                EditorGUILayout.LabelField("Precipitation", EditorStyles.whiteLabel);
                EditorGUILayout.MinMaxSlider("Cloud Coverage", ref minCloudCoverage, ref maxCloudCoverage, 0, 2);
                EditorGUILayout.BeginHorizontal();
                EditorGUILayout.LabelField("Min Coverage: " + (Mathf.Round(minCloudCoverage * 100) /100).ToString(), EditorStyles.miniLabel);
                EditorGUILayout.LabelField("Max Coverage: " + (Mathf.Round(maxCloudCoverage * 100) / 100).ToString(), EditorStyles.miniLabel);
                EditorGUILayout.EndHorizontal();
                fogDensity = EditorGUILayout.Slider("Fog Density", fogDensity, 0, 5);
                GUILayout.Space(10);
                snowAccumulation = EditorGUILayout.Slider("Snow Accumulation Speed", snowAccumulation, 0, 0.05f);
                waterAccumulation = EditorGUILayout.Slider("Puddle Accumulation Speed", waterAccumulation, 0, 0.05f);



            }


            GUILayout.Space(100);

            EditorGUILayout.EndScrollView();
            GUILayout.Space(20);
            GUILayout.FlexibleSpace();
            if (GUILayout.Button("Save"))
            Instantiate();



        }


        public void Instantiate()
        {

            string path = EditorUtility.OpenFolderPanel("Save Location", "Asset/", "");


            if (path.Length == 0)
                return;

            path = "Assets" + path.Substring(Application.dataPath.Length) + "/";

            if (profileType == ProfileType.Ambience)
            {
                AmbienceProfile i = CreateInstance<AmbienceProfile>();
                List<AmbienceProfile.ChanceEffector> k = new List<AmbienceProfile.ChanceEffector>();

                foreach (WeatherProfile.ChanceEffector j in chanceEffectors)
                {

                    AmbienceProfile.ChanceEffector l = new AmbienceProfile.ChanceEffector();

                    l.limitType = (AmbienceProfile.ChanceEffector.LimitType)j.limitType;
                    l.curve = j.curve;

                    k.Add(l);


                }

                i.chances = k;
                i.dontPlayDuring = dontPlayDuring;
                i.FXVolume = audioVolume;
                i.soundFX = SFX;

                ParticleSystem.TriggerModule trigger = particleFX.GetComponent<ParticleSystem>().trigger;
                trigger.enabled = disableIndoors;


                i.particleFX = particleFX;
                i.likelihood = likelihood;
                i.playTime = new Vector2(minPlayTime, maxPlayTime);
                i.name = profileName;

                AssetDatabase.CreateAsset(i, path + "/" + i.name + ".asset");
                Debug.Log("Saved asset to " + path + i.name + "!");


            }  else
            {
                WeatherProfile i = CreateInstance<WeatherProfile>(); 


                i.chances = chanceEffectors.ToList();
                i.forecastNext = forecastNext;
                i.FXVolume = audioVolume;
                i.soundFX = SFX;
                i.particleFX = particleFX;
                i.likelihood = likelihood;
                i.weatherTime = new Vector2(minPlayTime, maxPlayTime);
                i.name = profileName;

                i.useThunder = useThunder;
                i.weatherFilter = new WeatherProfile.WeatherFilter();
                i.weatherFilter.colorFilter = colorFilter;
                i.weatherFilter.saturation = saturation;
                i.weatherFilter.value = value;
                i.cloudFilter = cloudFilter;
                i.sunFilter = sunFilter;

                i.wetnessSpeed = waterAccumulation;
                i.snowAccumulationSpeed = snowAccumulation;
                i.fogDensity = fogDensity;
                i.cloudSettings.cloudCoverage = new Vector2(minCloudCoverage, maxCloudCoverage);

                ParticleSystem.TriggerModule trigger = particleFX.GetComponent<ParticleSystem>().trigger;
                trigger.enabled = disableIndoors;


                AssetDatabase.CreateAsset(i, path + "/" + i.name + ".asset");
                Debug.Log("Saved asset to " + path + i.name + "!");

            }



        }
    }
}