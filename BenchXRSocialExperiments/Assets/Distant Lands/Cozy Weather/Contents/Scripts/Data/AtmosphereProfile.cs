// Distant Lands 2021.



using UnityEngine;



namespace DistantLands.Cozy.Data
{

    [System.Serializable]
    [CreateAssetMenu(menuName = "Distant Lands/Cozy/Atmosphere Profile", order = 361)]
    public class AtmosphereProfile : ScriptableObject
    {


        [Tooltip("Sets the color of the zenith (or top) of the skybox at a certain time. Starts and ends at midnight.")]
        [GradientUsage(true)]
        public Gradient skyZenithColor;
        [Tooltip("Sets the color of the horizon (or middle) of the skybox at a certain time. Starts and ends at midnight.")]
        [GradientUsage(true)]
        public Gradient skyHorizonColor;

        [Tooltip("Sets the main color of the clouds at a certain time. Starts and ends at midnight.")]
        [GradientUsage(true)]
        public Gradient cloudColor;
        [Tooltip("Sets the highlight color of the clouds at a certain time. Starts and ends at midnight.")]
        [GradientUsage(true)]
        public Gradient cloudHighlightColor;
        [Tooltip("Sets the color of the high altitude clouds at a certain time. Starts and ends at midnight.")]
        [GradientUsage(true)]
        public Gradient highAltitudeCloudColor;
        [Tooltip("Sets the color of the sun light source at a certain time. Starts and ends at midnight.")]
        [GradientUsage(true)]
        public Gradient sunlightColor;
        [Tooltip("Sets the color of the star particle FX and textures at a certain time. Starts and ends at midnight.")]
        [GradientUsage(true)]
        public Gradient starColor;
        [Tooltip("Sets the color of the zenith (or top) of the ambient scene lighting at a certain time. Starts and ends at midnight.")]
        [GradientUsage(true)]
        public Gradient ambientLightHorizonColor;
        [Tooltip("Sets the color of the horizon (or middle) of the ambient scene lighting at a certain time. Starts and ends at midnight.")]
        [GradientUsage(true)]
        public Gradient ambientLightZenithColor;
        [Tooltip("Sets the intensity of the galaxy effects at a certain time. Starts and ends at midnight.")]
        public AnimationCurve galaxyIntensity;


        [GradientUsage(true)]
        public Gradient fogColor1;
        [GradientUsage(true)]
        public Gradient fogColor2;
        [GradientUsage(true)]
        public Gradient fogColor3;
        [GradientUsage(true)]
        public Gradient fogColor4;
        [GradientUsage(true)]
        public Gradient fogColor5;
        [GradientUsage(true)]
        public Gradient fogFlareColor;


        [HideInInspector]
        public float gradientExponent = 0.364f;
        [HideInInspector]
        public Vector2 atmosphereVariation = new Vector2(0.3f, 0.7f);
        [HideInInspector]
        public float atmosphereBias = 1;
        [HideInInspector]
        public float sunSize = 0.7f;    
        [HideInInspector]
        [ColorUsage(false, true)]
        public Color sunColor;
        [HideInInspector]
        public float sunFalloff = 43.7f;
        [HideInInspector]
        [ColorUsage(false, true)]
        public Color sunFlareColor;
        [HideInInspector]
        public float moonFalloff = 24.4f;
        [HideInInspector]
        [ColorUsage(false, true)]
        public Color moonFlareColor;
        [HideInInspector]
        [ColorUsage(false, true)]
        public Color galaxy1Color;
        [HideInInspector]
        [ColorUsage(false, true)]
        public Color galaxy2Color;
        [HideInInspector]
        [ColorUsage(false, true)]
        public Color galaxy3Color;
        [HideInInspector]
        [ColorUsage(false, true)]
        public Color lightScatteringColor;
        [HideInInspector]
        public float rainbowPosition = 78.7f;
        [HideInInspector]
        public float rainbowWidth = 11;

        [HideInInspector]
        public float fogStart1 = 2;
        [HideInInspector]
        public float fogStart2 = 5;
        [HideInInspector]
        public float fogStart3 = 10;
        [HideInInspector]
        public float fogStart4 = 30;
        [HideInInspector]
        public float fogHeight = 0.85f;
        [HideInInspector]
        public float fogLightFlareIntensity = 1;
        [HideInInspector]
        public float fogLightFlareFalloff = 21;
        [HideInInspector]
        [ColorUsage(false, true)]
        public Color cloudMoonColor;
        [HideInInspector]
        public float cloudSunHighlightFalloff = 14.1f;
        [HideInInspector]
        public float cloudMoonHighlightFalloff = 22.9f;
        [HideInInspector]
        public float cloudWindSpeed = 3;
        [HideInInspector]
        public float clippingThreshold = 0.5f;
        [HideInInspector]
        public float cloudMainScale = 20;
        [HideInInspector]
        public float cloudDetailScale = 2.3f;
        [HideInInspector]
        public float cloudDetailAmount = 30;
        [HideInInspector]
        public float acScale = 1;
        [HideInInspector]
        public float cirroMoveSpeed = 0.5f;
        [HideInInspector]
        public float cirrusMoveSpeed = 0.5f;
        [HideInInspector]
        public float chemtrailsMoveSpeed = 0.5f;



    }
}