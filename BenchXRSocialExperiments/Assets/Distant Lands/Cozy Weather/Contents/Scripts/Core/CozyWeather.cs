// Distant Lands 2021.



using DistantLands.Cozy.Data;
using UnityEngine;

namespace DistantLands.Cozy
{

    [ExecuteAlways] 
    public class CozyWeather : MonoBehaviour
    {

        #region Variables
        private float m_MinCloudCover;
        private float m_MaxCloudCover;

        private float m_Cumulus;
        private float m_Cirrus;
        private float m_Altocumulus;
        private float m_Cirrostratus;
        private float m_Chemtrails;
        private float m_Nimbus;
        private float m_NimbusHeight;
        private float m_NimbusVariation;
        private float m_Border;
        private float m_BorderEffect;
        private float m_BorderVariation;


        [ColorUsage(true, true)]
        private Color m_HorizonColor;
        [ColorUsage(true, true)]
        private Color m_ZenithColor;
        [ColorUsage(true, true)]
        private Color m_CloudColor;
        [ColorUsage(true, true)]
        private Color m_CloudHighlight;
        [ColorUsage(true, true)]
        private Color m_CloudZenith;
        [HideInInspector]
        public FogColors m_FogColors;
        [HideInInspector]
        public float m_FogDensity;
        [ColorUsage(true, true)]
        private Color m_SunColor;
        [ColorUsage(true, true)]
        private Color m_FogFlareColor;
        [ColorUsage(true, true)]
        private Color m_StarColor;
        [ColorUsage(true, true)]
        private Color m_AmbientHorizon;
        [ColorUsage(true, true)]
        private Color m_AmbientZenith;


        private float m_GalaxyIntensity;
        private float m_RainbowIntensity;


        private float m_FilterSaturation;  
        private float m_FilterValue;
        private Color m_FilterColor;
        private Color m_SunFilter;
        private Color m_CloudFilter;


        private float m_WindSpeed;
        private float m_WindAmount;
        private Vector3 m_WindDirection;
        private float m_Seed;

        private float m_AdjustedScale;


        [System.Serializable]
        public class FogColors
        {
            [ColorUsage(true, true)]
            public Color color1;
            [ColorUsage(true, true)]
            public Color color2;
            [ColorUsage(true, true)]
            public Color color3;
            [ColorUsage(true, true)]
            public Color color4;
            [ColorUsage(true, true)]
            public Color color5;
        }

        [Header("Current Profiles")]
        public AtmosphereProfile m_AtmosphereProfile;
        public WeatherProfile m_WeatherProfile;
        public PerennialProfile m_PerennialProfile;

        public AtmosphereProfile atmosphereProfile
        {
            get { return m_AtmosphereProfile; }
            set
            {
                if (m_AtmosphereProfile == value) return;
                m_AtmosphereProfile = value;
            }
        }
        public PerennialProfile perennialProfile
        {
            get { return m_PerennialProfile; }
            set
            {
                if (m_PerennialProfile == value) return;
                m_PerennialProfile = value;
            }
        }

        public WeatherProfile weatherProfile
        {
            get { return m_WeatherProfile; }
            set
            {
                ChangeProfile(m_WeatherProfile);
            }
        }



        [Header("Options")]
        public bool lockToCamera = true;
        public bool allowRuntimeChanges = true;
        public bool mobileMode = false;
        public float sunDirection;
        public float sunPitch;
        public float weatherTransitionSpeed;




        private Light m_SunLight;
        private MeshRenderer m_Clouds;
        private MeshRenderer m_Skysphere;
        private MeshRenderer m_FogDome;
        [Header("References")]
        [SerializeField]
        private ParticleSystem[] m_Stars;
        [SerializeField]
        private ParticleSystem[] m_CloudParticles;


        #endregion

        #region Modules

        [HideInInspector]
        public CozyAudio cozyAudio;
        [HideInInspector]
        public CozyMaterialManager cozyMaterials;
        [HideInInspector]
        public CozyClimate climate;
        [HideInInspector]
        public CozyCalendar calender;
        [HideInInspector]
        public CozyAmbienceManager ambience;
        [HideInInspector]
        public CozyForecast forecast;
        [HideInInspector]
        public CozyTriggerManager triggerManager;
        [HideInInspector]
        public CozyLightningManager lightningManager;
        [HideInInspector]
        public CozySaveLoad saveLoad;

        #endregion






        public Transform GetChild(string name)
        {

            foreach (Transform i in transform.GetComponentsInChildren<Transform>())
                if (i.name == name)
                    return i;

            return null;

        }
        public Transform GetChild(string name, Transform parent)
        {

            foreach (Transform i in parent.GetComponentsInChildren<Transform>())
                if (i.name == name)
                    return i;

            return null;

        }


        void Awake()
        {

            SetupReferences();
            SetupModules();

            if (Application.isPlaying)
                SetupWeatherFX();
            

        }

        // Start is called before the first frame update
        void Start()
        {

            

            m_Seed = Random.value * 1000;

            ResetVariables();

            if (mobileMode)
            {
                CloudDome.sharedMaterial.shader = Shader.Find("Distant Lands/Cozy/Stylized Clouds Mobile");
                SkyDome.sharedMaterial.shader = Shader.Find("Distant Lands/Cozy/Stylized Sky Mobile");
            }
            else
            {
                CloudDome.sharedMaterial.shader = Shader.Find("Distant Lands/Cozy/Stylized Clouds Desktop");
                SkyDome.sharedMaterial.shader = Shader.Find("Distant Lands/Cozy/Stylized Sky Desktop");

            }

        }

        // Update is called once per frame
        public void Update() 
        {

            if (!Application.isPlaying)
                SetupModules();

            if (m_WeatherProfile == null || m_AtmosphereProfile == null || m_PerennialProfile == null)
            {

                Debug.LogWarning("Cozy Weather requires an active weather profile, an active perennial profile and an active atmosphere profile to function properly.\nPlease ensure that the active CozyWeather script contains all necessary profile references.");
                return;
            }

            if (allowRuntimeChanges)
            ManageWind();

            if (Application.isPlaying)
            {
                if (allowRuntimeChanges)
                    SetProperties();
            }
            else
                ResetVariables();


            if (allowRuntimeChanges)
            {
                SetGlobalVariables();
                SetShaderVariables();
            }

            if (Camera.main && lockToCamera)
            {
                transform.position = Camera.main.transform.position;
                m_AdjustedScale = Camera.main.farClipPlane / 1000;

                transform.localScale = Vector3.one * m_AdjustedScale;

            }

        }



        public void SetupModules()
        {

            if (!cozyAudio)
                if (GetComponent<CozyAudio>())
                    cozyAudio = GetComponent<CozyAudio>();
            if (!climate)
                if (GetComponent<CozyClimate>())
                    climate = GetComponent<CozyClimate>();
            if (!cozyMaterials)
                if (GetComponent<CozyMaterialManager>())
                    cozyMaterials = GetComponent<CozyMaterialManager>();
            if (!calender)
                if (GetComponent<CozyCalendar>())
                    calender = GetComponent<CozyCalendar>();
            if (!forecast)
                if (GetComponent<CozyForecast>())
                    forecast = GetComponent<CozyForecast>();
            if (!ambience)
                if (GetComponent<CozyAmbienceManager>())
                    ambience = GetComponent<CozyAmbienceManager>();
            if (!triggerManager)
                if (GetComponent<CozyTriggerManager>())
                    triggerManager = GetComponent<CozyTriggerManager>();
            if (!lightningManager)
                if (GetComponent<CozyLightningManager>())
                    lightningManager = GetComponent<CozyLightningManager>();
            if (!saveLoad)
                if (GetComponent<CozySaveLoad>())
                    saveLoad = GetComponent<CozySaveLoad>();


        }


        public void SetupReferences()
        {

            m_SunLight = GetChild("Sun").GetComponent<Light>();
            m_Skysphere = GetChild("Skydome").GetComponent<MeshRenderer>();
            m_Clouds = GetChild("Foreground Clouds").GetComponent<MeshRenderer>();
            m_FogDome = GetChild("Fog").GetComponent<MeshRenderer>();

        }

        public void SetupWeatherFX()
        {

            if (!forecast)
            if (weatherProfile.particleFX)
            {
                ParticleSystem system = Instantiate(weatherProfile.particleFX, transform.GetChild(2)).GetComponent<ParticleSystem>();

                system.gameObject.name = weatherProfile.name;


                if (triggerManager)
                {
                    ParticleSystem.TriggerModule triggers = system.trigger;

                    triggers.enter = ParticleSystemOverlapAction.Kill;
                    triggers.inside = ParticleSystemOverlapAction.Kill;
                    for (int j = 0; j < triggerManager.cozyTriggers.Count; j++)
                        triggers.SetCollider(j, triggerManager.cozyTriggers[j]);
                }
            }
        }


        public void ManageWind()
        {

            float i = m_PerennialProfile.ticksPerDay * Mathf.PerlinNoise(m_Seed, Time.time / 100000);

            m_WindDirection = new Vector3(Mathf.Sin(i), 0, Mathf.Cos(i));

        }

        


        public string FormatTime(float ticks, bool militaryTime) 
        {

            int minutes = Mathf.RoundToInt(ticks * 4);
            int hours = (minutes - minutes % 60) / 60;
            minutes -= hours * 60;

            if (militaryTime)
                return "" + hours.ToString("D2") + ":" + minutes.ToString("D2");
            else if (hours == 0)
                return "" + 12 + ":" + minutes.ToString("D2") + "AM";
            else if (hours == 12)
                return "" + 12 + ":" + minutes.ToString("D2") + "PM";
            else if (hours > 12)
                return "" + (hours - 12) + ":" + minutes.ToString("D2") + "PM";
            else
                return "" + (hours) + ":" + minutes.ToString("D2") + "AM";

        }

        public void SetFilterColors ()
        {

            m_FilterColor = WeatherLerp(m_FilterColor, m_WeatherProfile.weatherFilter.colorFilter);
            m_FilterSaturation = WeatherLerp(m_FilterSaturation, m_WeatherProfile.weatherFilter.saturation);
            m_FilterValue = WeatherLerp(m_FilterValue, m_WeatherProfile.weatherFilter.value);
            m_SunFilter = WeatherLerp(m_SunFilter, m_WeatherProfile.sunFilter);
            m_CloudFilter = WeatherLerp(m_CloudFilter, m_WeatherProfile.cloudFilter);



        }

        public void SetGlobalVariables()
        {

            Material i = m_FogDome.sharedMaterial;

            Shader.SetGlobalColor("CZY_FogColor1", m_FogColors.color1);
            Shader.SetGlobalColor("CZY_FogColor2", m_FogColors.color2);
            Shader.SetGlobalColor("CZY_FogColor3", m_FogColors.color3);
            Shader.SetGlobalColor("CZY_FogColor4", m_FogColors.color4);
            Shader.SetGlobalColor("CZY_FogColor5", m_FogColors.color5);

            Shader.SetGlobalFloat("CZY_FogColorStart1", i.GetFloat("_ColorStart1"));
            Shader.SetGlobalFloat("CZY_FogColorStart2", i.GetFloat("_ColorStart2"));
            Shader.SetGlobalFloat("CZY_FogColorStart3", i.GetFloat("_ColorStart3"));
            Shader.SetGlobalFloat("CZY_FogColorStart4", i.GetFloat("_ColorStart4"));

            Shader.SetGlobalFloat("CZY_FogIntensity", i.GetFloat("_FogIntensity"));
            Shader.SetGlobalFloat("CZY_FogOffset", i.GetFloat("_FogOffset"));
            Shader.SetGlobalFloat("CZY_FogSmoothness", i.GetFloat("_FogSmoothness"));
            Shader.SetGlobalFloat("CZY_FogDepthMultiplier", m_FogDensity);

            Shader.SetGlobalColor("CZY_LightColor", m_FogFlareColor);
            Shader.SetGlobalVector("CZY_SunDirection", -m_SunLight.transform.forward);
            Shader.SetGlobalFloat("CZY_LightFalloff", i.GetFloat("_LightFalloff"));
            Shader.SetGlobalFloat("CZY_LightIntensity", i.GetFloat("LightIntensity"));


            Shader.SetGlobalFloat("CZY_WindSpeed", m_WindSpeed);
            Shader.SetGlobalVector("CZY_WindDirection", m_WindDirection * m_WindAmount);

        }

        public void SetShaderVariables()
        {

            m_Skysphere.sharedMaterial.SetColor("_ZenithColor", m_ZenithColor);
            m_Skysphere.sharedMaterial.SetColor("_HorizonColor", m_HorizonColor);
            m_Skysphere.sharedMaterial.SetColor("_StarColor", m_StarColor);
            m_Skysphere.sharedMaterial.SetFloat("_GalaxyMultiplier", m_GalaxyIntensity);
            m_Skysphere.sharedMaterial.SetFloat("_RainbowIntensity", m_RainbowIntensity);

            m_Clouds.sharedMaterial.SetFloat("_MinCloudCover", m_MinCloudCover);
            m_Clouds.sharedMaterial.SetFloat("_MaxCloudCover", m_MaxCloudCover);
            m_Clouds.sharedMaterial.SetColor("_CloudColor", m_CloudColor);
            m_Clouds.sharedMaterial.SetColor("_CloudHighlightColor", m_CloudHighlight);
            m_Clouds.sharedMaterial.SetColor("_AltoCloudColor", m_CloudZenith);
            m_Clouds.sharedMaterial.SetVector("_SunDirection", -m_SunLight.transform.forward);
            m_Clouds.sharedMaterial.SetVector("_StormDirection", -m_WindDirection);
            m_Clouds.sharedMaterial.SetFloat("_CumulusCoverageMultiplier", m_Cumulus);
            m_Clouds.sharedMaterial.SetFloat("_NimbusMultiplier", m_Nimbus);
            m_Clouds.sharedMaterial.SetFloat("_NimbusHeight", m_NimbusHeight);
            m_Clouds.sharedMaterial.SetFloat("_NimbusVariation", m_NimbusVariation);
            m_Clouds.sharedMaterial.SetFloat("_BorderHeight", m_Border);
            m_Clouds.sharedMaterial.SetFloat("_BorderEffect", m_BorderEffect);
            m_Clouds.sharedMaterial.SetFloat("_BorderVariation", m_BorderVariation);
            m_Clouds.sharedMaterial.SetFloat("_AltocumulusMultiplier", m_Altocumulus);
            m_Clouds.sharedMaterial.SetFloat("_CirrostratusMultiplier", m_Cirrostratus);
            m_Clouds.sharedMaterial.SetFloat("_ChemtrailsMultiplier", m_Chemtrails);
            m_Clouds.sharedMaterial.SetFloat("_CirrusMultiplier", m_Cirrus);


            m_SunLight.transform.parent.eulerAngles = new Vector3(0, sunDirection, sunPitch);
            m_SunLight.transform.localEulerAngles = new Vector3(((m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay) * 360) - 90, 0, 0);
            m_SunLight.color = m_SunColor;
            SetStarColors(m_StarColor);
            SetCloudColors(m_CloudColor);


            RenderSettings.ambientSkyColor = m_AmbientZenith;
            RenderSettings.ambientEquatorColor = m_AmbientHorizon * (1 - (m_MaxCloudCover / 2));
            RenderSettings.ambientGroundColor = m_AmbientHorizon * Color.gray * (1 - (m_MaxCloudCover / 2));




            if (lockToCamera)
                m_FogDome.sharedMaterial.SetFloat("_FogSmoothness", 100 * m_AdjustedScale);
            m_FogDome.sharedMaterial.SetFloat("_FogDepthMultiplier", m_FogDensity);
            m_FogDome.sharedMaterial.SetColor("_LightColor", m_FogFlareColor);
            m_FogDome.sharedMaterial.SetColor("_FogColor1", m_FogColors.color1);
            m_FogDome.sharedMaterial.SetColor("_FogColor2", m_FogColors.color2);
            m_FogDome.sharedMaterial.SetColor("_FogColor3", m_FogColors.color3);
            m_FogDome.sharedMaterial.SetColor("_FogColor4", m_FogColors.color4);
            m_FogDome.sharedMaterial.SetColor("_FogColor5", m_FogColors.color5);
            m_FogDome.sharedMaterial.SetVector("_SunDirection", -m_SunLight.transform.forward);


        }

        private void SetStarColors(Color color)
        {
            foreach (ParticleSystem i in m_Stars)
            {
                ParticleSystem.MainModule j = i.main;
                j.startColor = color;

            }
        }

        private void SetCloudColors(Color color)
        {
            foreach (ParticleSystem i in m_CloudParticles)
            {
                ParticleSystem.MainModule j = i.main;
                j.startColor = color; 
                
                ParticleSystem.TrailModule k = i.trails;
                k.colorOverLifetime = color;

            }
        }

        public void SetProperties()
        {
            
            SetFilterColors();

            m_MinCloudCover = WeatherLerp(m_MinCloudCover, m_WeatherProfile.cloudSettings.cloudCoverage.x);
            m_MaxCloudCover = WeatherLerp(m_MaxCloudCover, m_WeatherProfile.cloudSettings.cloudCoverage.y);
            m_ZenithColor = FilterColor(m_AtmosphereProfile.skyZenithColor);
            m_HorizonColor = FilterColor(m_AtmosphereProfile.skyHorizonColor);
            m_CloudColor = FilterColor(m_AtmosphereProfile.cloudColor) * m_CloudFilter;
            m_CloudHighlight = FilterColor(m_AtmosphereProfile.cloudHighlightColor) * m_SunFilter;
            m_CloudZenith = FilterColor(m_AtmosphereProfile.highAltitudeCloudColor) * m_CloudFilter;
            m_SunColor = FilterColor(m_AtmosphereProfile.sunlightColor) * m_SunFilter;
            m_StarColor = FilterColor(m_AtmosphereProfile.starColor);
            m_GalaxyIntensity = m_AtmosphereProfile.galaxyIntensity.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay);
            if (cozyMaterials)
                m_RainbowIntensity = cozyMaterials.useRainbow ? cozyMaterials.m_Wetness * (1 - m_StarColor.a) : 0;
            else
                m_RainbowIntensity = 0;

            m_Cumulus = WeatherLerp(m_Cumulus, m_WeatherProfile.cloudSettings.cumulusCoverage);
            m_Altocumulus = WeatherLerp(m_Altocumulus, m_WeatherProfile.cloudSettings.altocumulusCoverage);
            m_Cirrus = WeatherLerp(m_Cirrus, m_WeatherProfile.cloudSettings.cirrusCoverage);
            m_Cirrostratus = WeatherLerp(m_Cirrostratus, m_WeatherProfile.cloudSettings.cirrostratusCoverage);
            m_Chemtrails = WeatherLerp(m_Chemtrails, m_WeatherProfile.cloudSettings.chemtrailCoverage);
            m_Nimbus = WeatherLerp(m_Nimbus, m_WeatherProfile.cloudSettings.nimbusCoverage);
            m_NimbusHeight = WeatherLerp(m_NimbusHeight, m_WeatherProfile.cloudSettings.nimbusHeightEffect);
            m_NimbusVariation = WeatherLerp(m_NimbusVariation, m_WeatherProfile.cloudSettings.nimbusVariation);
            m_Border = WeatherLerp(m_Border, m_WeatherProfile.cloudSettings.borderHeight, 3);
            m_BorderEffect = WeatherLerp(m_BorderEffect, m_WeatherProfile.cloudSettings.borderEffect);
            m_BorderVariation = WeatherLerp(m_BorderVariation, m_WeatherProfile.cloudSettings.borderVariation, 3);



            m_AmbientHorizon = FilterColor(m_AtmosphereProfile.ambientLightHorizonColor);
            m_AmbientZenith = FilterColor(m_AtmosphereProfile.ambientLightZenithColor);
                                                                                                         

            m_FogDensity = WeatherLerp(m_FogDensity, m_WeatherProfile.fogDensity);
            m_FogFlareColor = FilterColor(m_AtmosphereProfile.fogFlareColor);
            m_FogColors.color1 = FilterColor(m_AtmosphereProfile.fogColor1);
            m_FogColors.color2 = FilterColor(m_AtmosphereProfile.fogColor2);
            m_FogColors.color3 = FilterColor(m_AtmosphereProfile.fogColor3);
            m_FogColors.color4 = FilterColor(m_AtmosphereProfile.fogColor4);
            m_FogColors.color5 = FilterColor(m_AtmosphereProfile.fogColor5);

            m_WindAmount = WeatherLerp(m_WindAmount, m_WeatherProfile.windAmount);
            m_WindSpeed = WeatherLerp(m_WindSpeed, m_WeatherProfile.windSpeed);


        }

        public void ResetVariables()
        {


            m_FilterColor = m_WeatherProfile.weatherFilter.colorFilter;
            m_FilterSaturation = m_WeatherProfile.weatherFilter.saturation;
            m_FilterValue = m_WeatherProfile.weatherFilter.value;
            m_SunFilter = m_WeatherProfile.sunFilter;
            m_CloudFilter = m_WeatherProfile.cloudFilter;
            m_GalaxyIntensity = m_AtmosphereProfile.galaxyIntensity.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay);
            if (cozyMaterials)
                m_RainbowIntensity = cozyMaterials.useRainbow ? cozyMaterials.m_Wetness * (1 - m_StarColor.a) : 0;
            else
                m_RainbowIntensity = 0;

            m_MinCloudCover = m_WeatherProfile.cloudSettings.cloudCoverage.x;
            m_MaxCloudCover = m_WeatherProfile.cloudSettings.cloudCoverage.y;


            m_CloudColor = FilterColor(m_AtmosphereProfile.cloudColor.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay)) * m_CloudFilter;
            m_CloudZenith = FilterColor(m_AtmosphereProfile.highAltitudeCloudColor.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay)) * m_CloudFilter;
            m_CloudHighlight = FilterColor(m_AtmosphereProfile.cloudHighlightColor.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay)) * m_SunFilter;
            m_HorizonColor = FilterColor(m_AtmosphereProfile.skyHorizonColor.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay));
            m_ZenithColor = FilterColor(m_AtmosphereProfile.skyZenithColor.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay));
            m_StarColor = FilterColor(m_AtmosphereProfile.starColor);


            m_Cumulus = m_WeatherProfile.cloudSettings.cumulusCoverage;
            m_Altocumulus = m_WeatherProfile.cloudSettings.altocumulusCoverage;
            m_Cirrus = m_WeatherProfile.cloudSettings.cirrusCoverage;
            m_Cirrostratus = m_WeatherProfile.cloudSettings.cirrostratusCoverage;
            m_Chemtrails = m_WeatherProfile.cloudSettings.chemtrailCoverage;
            m_Nimbus = m_WeatherProfile.cloudSettings.nimbusCoverage;
            m_NimbusHeight = m_WeatherProfile.cloudSettings.nimbusHeightEffect;
            m_NimbusVariation = m_WeatherProfile.cloudSettings.nimbusVariation;
            m_Border = m_WeatherProfile.cloudSettings.borderHeight;
            m_BorderEffect = m_WeatherProfile.cloudSettings.borderEffect;
            m_BorderVariation = m_WeatherProfile.cloudSettings.borderVariation;


            m_SunColor = m_AtmosphereProfile.sunlightColor.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay) * m_SunFilter;
            m_AmbientHorizon = FilterColor(m_AtmosphereProfile.ambientLightHorizonColor.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay));
            m_AmbientZenith = FilterColor(m_AtmosphereProfile.ambientLightZenithColor.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay));

            m_FogDensity = m_WeatherProfile.fogDensity;
            m_FogFlareColor = FilterColor(m_AtmosphereProfile.fogFlareColor.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay));
            m_FogColors.color1 = FilterColor(m_AtmosphereProfile.fogColor1.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay));
            m_FogColors.color2 = FilterColor(m_AtmosphereProfile.fogColor2.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay));
            m_FogColors.color3 = FilterColor(m_AtmosphereProfile.fogColor3.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay));
            m_FogColors.color4 = FilterColor(m_AtmosphereProfile.fogColor4.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay));
            m_FogColors.color5 = FilterColor(m_AtmosphereProfile.fogColor5.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay));


            m_WindAmount = m_WeatherProfile.windAmount;
            m_WindSpeed = m_WeatherProfile.windSpeed;

        }

        public float WeatherLerp(float start, float target) { return Mathf.Lerp(start, target, Time.deltaTime * weatherTransitionSpeed * m_PerennialProfile.ModifiedTickSpeed()); }
        public float WeatherLerp(float start, float target, float speedMultiplier) { return Mathf.Lerp(start, target, Time.deltaTime * weatherTransitionSpeed * speedMultiplier * m_PerennialProfile.ModifiedTickSpeed()); }

        public Color WeatherLerp(Color start, Color target) { return Color.Lerp(start, target, Time.deltaTime * weatherTransitionSpeed * m_PerennialProfile.ModifiedTickSpeed()); }
        public Color WeatherLerp(Color start, Gradient target) { return Color.Lerp(start, target.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay), Time.deltaTime * weatherTransitionSpeed * m_PerennialProfile.ModifiedTickSpeed()); }
        public Color AtmosGradient(Gradient target) { return Color.Lerp(target.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay), FilterColor(target.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay)), Time.deltaTime * weatherTransitionSpeed * m_PerennialProfile.ModifiedTickSpeed()); }

        public Color FilterColor(Color color)
        {

            float h;
            float s;
            float v;
            float a = color.a;
            Color j;

            Color.RGBToHSV(color, out h, out s, out v);

            s = Mathf.Clamp(s + m_FilterSaturation, 0, 10);
            v = Mathf.Clamp(v + m_FilterValue, 0, 10);

            j = Color.HSVToRGB(h, s, v);

            j *= m_FilterColor;
            j.a = a;

            return j;

        }

        public Color FilterColor(Gradient color)
        {

            float h;
            float s;
            float v;
            float a = color.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay).a;
            Color j;

            Color.RGBToHSV(color.Evaluate(m_PerennialProfile.currentTicks / m_PerennialProfile.ticksPerDay), out h, out s, out v);


            s = Mathf.Clamp(s + m_FilterSaturation, 0, 10);
            v = Mathf.Clamp(v + m_FilterValue, 0, 10);

            j = Color.HSVToRGB(h, s, v, true);

            j *= m_FilterColor;
            j.a = a;

            return j;

        }

        public void ChangeProfile(WeatherProfile profile)
        {

            m_WeatherProfile = profile;


            if (!forecast)
                if (m_WeatherProfile.particleFX)
                    if (GetChild(m_WeatherProfile.name, transform.GetChild(2)) == null)
                    {
                        ParticleSystem system = Instantiate(m_WeatherProfile.particleFX, transform.GetChild(2)).GetComponent<ParticleSystem>();

                        system.gameObject.name = m_WeatherProfile.name;


                        if (triggerManager)
                        {
                            ParticleSystem.TriggerModule triggers = system.trigger;

                            triggers.enter = ParticleSystemOverlapAction.Kill;
                            triggers.inside = ParticleSystemOverlapAction.Kill;
                            for (int j = 0; j < triggerManager.cozyTriggers.Count; j++)
                                triggers.SetCollider(j, triggerManager.cozyTriggers[j]);
                        }
                    }

            if (cozyAudio)
                cozyAudio.ChangeSound(profile);
            

        }

        public MeshRenderer CloudDome
        {
            get { return m_Clouds; }
        }
        public Light Sun
        {
            get { return m_SunLight; }
        }
        public MeshRenderer FogDome
        {
            get { return m_FogDome; }
        }
        public MeshRenderer SkyDome
        {
            get { return m_Skysphere; }
        }

        public void SkipTicks(float ticksToSkip)
        {

            m_PerennialProfile.currentTicks += ticksToSkip;
            GetComponent<CozyForecast>().SkipTicks(ticksToSkip);
            GetComponent<CozyAmbienceManager>().SkipTicks(ticksToSkip);
            ResetVariables();

        }

        static public CozyWeather instance
        {

            get { if (FindObjectOfType<CozyWeather>()) return FindObjectOfType<CozyWeather>(); else return null; }

        }

    }
}