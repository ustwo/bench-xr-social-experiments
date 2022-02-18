// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// This shader works only if DepthTextureMode.Depth is enabled on camera (camera.depthTextureMode = DepthTextureMode.Depth;). With this shader you have the script (TurnOnDepthBuffer.cs) and you have to attach it to your camera 

Shader "Unlit/WaterToon"
{
    Properties{

        //_MainTex is the alpha map texture - _ColorMainTex is the water color - _MainTexAlpha is the alpha of texture (0 - 1) - _SpeedOffsetMainTextureX is the water speed Y axis (uv.x) - _SpeedOffsetMainTextureY is the water speed Z axis (uv.y)
        [Header(Water)]
        [Space(5)]
        _MainTex("Alpha Map", 2D) = "white" {}
        _ColorMainTex("Color", Color) = (0.76,0.82,1,1)
        _MainTexAlpha("Texture Alpha", Range(0, 1)) = 1
        _SpeedOffsetMainTextureX("Speed Offset X", Range(0, 10)) = 3
        _SpeedOffsetMainTextureY("Speed Offset Y", Range(0, 10)) = 3
        [Space(20)]

        // _WaveSpeed is how fast the wave moves - _WaveDirection is how high are waves - _WaveDirection is the direction of the waves
        [Header(Wave)]
        [Space(5)]
        _WaveForceY("Force Vertical", Range(0, 10)) = 3.0
        _WaveSpeed("Wave Speed", Range(0, 100)) = 30.0
        [Space(20)]

        //_GradientTexture is a texture that allow you to obtain a dark/light color - _SpeedOffsetGradientX is the gradient texture speed X axis (uv.x) - _SpeedOffsetGradientY is the gradient texture speed Y axis (uv.y)
        [Header(Dark Light Gradient)]
        [Space(5)]
        _GradientTexture("Gradient Texture", 2D) = "white" {}
        _SpeedOffsetGradientX("Speed offset X", Range(-10, 10)) = 2
        _SpeedOffsetGradientY("Speed offset Y", Range(-10, 10)) = 2
        [Space(20)]

        //_FoamNoise is a texture for create the foam - _ColorFoam is the base color of the foam  -  _FoamDepth is the Softness/hardness of the foam
        [Header(Foam)]
        [Space(5)]
        _FoamNoise("Foam Texture", 2D) = "white" {}
        _ColorFoam("Color", Color) = (1,1,1,0)
        _FoamDepth("Softness", Range(0, 10)) = 0.2
        _Frequency("Frequency", Range(0, 50)) = 10
        _WaveHeight("Foam Height", Range(0, 10)) = 0.2
        _WaveWidth("Foam Width", Range(1, 20)) = 5
        [Space(20)]

        // _ColorShadow is the color of the objects underwater - _Depth is the hardness/dimension of the shadow
        [Header(Underwater Shadow)]
        [Space(5)]
        [Toggle]_ShadowUnderwater("Shadow On/Off", Float) = 0
        _ColorShadow("Shadow Color", Color) = (1,1,1,1)
        _Depth("Hardness", Range(0, 10)) = 0.2
        [Space(20)]

        //_Darker is a toggle button to choose if you want to have a dark/light effect based on camera position - _DistanceColor is the darkest color you get  -  _DistanceDarken is how far the camera has to be to obtain a dark/light effect
        // _Alpha is the transparency and _Radius is how far the darkest color start.
        [Header(Dark Light Camera Distance)]
        [Space(5)]
        [Toggle]_Darker("_Dark On/Off", Float) = 0
        _DistanceColor("Color", Color) = (1,1,1,1)
        _DistanceAlpha("Distance Alpha", Range(0, 10)) = 1
        _DistanceRadius("Radius", Range(0, 100)) = 40.0
        _DistanceDarken("Darkness", Range(0, 100)) = 10.0


    }
        SubShader{

            Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
            LOD 200
            ZWrite Off


            Pass
            {
                Blend SrcAlpha OneMinusSrcAlpha
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag 
                #include "UnityCG.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv2 : TEXCOORD2;
                    float2 uv3 : TEXCOORD3;
                    float2 screenuv : TEXCOORD1;
                    float dist : TEXCOORD4;
                };

                struct v2f
                {
                    float4 pos : SV_POSITION;
                    float4 uv : TEXCOORD0;
                    float2 uv2 : TEXCOORD2;
                    float2 uv3 : TEXCOORD3;
                    float2 screenuv : TEXCOORD1;
                    float dist : TEXCOORD4;

                };

                float _ScaleFactor;

                //Main Texture params
                sampler2D _MainTex;
                float4 _MainTex_ST;
                float _SpeedOffsetMainTextureX;
                float _SpeedOffsetMainTextureY;

                // Wave params
                float _WaveSpeed;
                float _WaveForceY;

                //Gradient Texture params
                sampler2D _GradientTexture;
                float4 _GradientTexture_ST;
                float _SpeedOffsetGradientX;
                float _SpeedOffsetGradientY;

                //Foam Texture params
                sampler2D _FoamNoise;
                float4 _FoamNoise_ST;

                // Darker with camera distance params
                float _DistanceDarken;

                v2f vert(appdata v)
                {
                    v2f o;

                    // Waves function. This create a waves effect on Y axis given _WaveForceY, _WaveSpeed. It also sets the direction of the waves given _WaveDirection (X, Z)
                    float phase = _Time * _WaveSpeed;
                    float4 wpos = -mul(unity_WorldToObject, v.vertex);
                    float offsetX = (wpos.x + (wpos.z * 0.2)) * 0.5;
                    float x = phase + offsetX;
                    wpos.y = wpos.y + ((sin(x) * sin(2.2 * x + 5.52) * sin(2.9 * x + 0.93) * sin(4.6 * x + 8.94)) / 4 * _WaveForceY);
                    v.vertex = mul(unity_ObjectToWorld, wpos);
                    o.pos = UnityObjectToClipPos(v.vertex);

                    // Waving Texture. This change the UV offset of the alpha map texture to obtain a 2D waving effect
                    o.uv = ComputeScreenPos(o.pos);
                    v.screenuv.x += sin((v.vertex.x + v.vertex.y)) * 0.01 + _Time * _SpeedOffsetMainTextureX;
                    v.screenuv.y += cos((v.vertex.x - v.vertex.y) + _Time.g * 2.7) * 0.01 + _Time * _SpeedOffsetMainTextureY;
                    o.screenuv = TRANSFORM_TEX(v.screenuv, _MainTex);

                    //Gradient Texture. This change the gradient texture UV offset to obtain a dark/light effect
                    o.uv2 = v.uv2;
                    v.uv2.x = v.screenuv.x;
                    v.uv2.x += _Time * _SpeedOffsetGradientX;
                    v.uv2.y = v.screenuv.y;
                    v.uv2.x += _Time * _SpeedOffsetGradientY;
                    o.uv2 = TRANSFORM_TEX(v.uv2, _GradientTexture);

                    //Foam Texture. This change the foam texture UV offset to obtain a sliding and inhomogeneous foam effect
                    o.uv3 = v.uv3;
                    v.uv3.x = v.screenuv.x;
                    v.uv3.x += _Time * _SpeedOffsetMainTextureX;
                    v.uv3.y = v.screenuv.y;
                    v.uv3.y += _Time * _SpeedOffsetMainTextureY;
                    o.uv3 = TRANSFORM_TEX(v.uv3, _FoamNoise);

                    o.dist = length(WorldSpaceViewDir(v.vertex));

                    return o;
                }

                //Main Texture params
                fixed4 _ColorMainTex;
                float _MainTexAlpha;

                //Foam Texture params
                float4 _ColorFoam;
                half _FoamDepth;
                half _WaveHeight;
                half _Frequency;
                half _WaveWidth;

                // Shadow near wall params
                sampler2D _CameraDepthTexture;
                half _Depth;
                fixed4 _ColorShadow;
                float _ShadowUnderwater;

                //Darker with camera distance params
                float _Darker;
                float _DistanceAlpha;
                float4 _DistanceColor;
                float _DistanceRadius;

                half4 frag(v2f i) : SV_Target
                {
                    //Alpha Texture
                    fixed4 MainTexture = tex2D(_MainTex, i.screenuv);
                //This is the same map of alpha texture that I use to mask the black parts of the map and obtain only the light/white ones.
                fixed4 MainTextureReverse = tex2D(_MainTex, i.screenuv);

                //Gradient Texture 
                fixed4 GradientWater = tex2D(_GradientTexture, i.uv2);

                //Foam Texture
                fixed4 FoamTexture = tex2D(_FoamNoise, i.uv3);
                fixed4 FoamTextureReverse = tex2D(_FoamNoise, i.uv3);



                // Shadow near wall underwater costant
                half Fix = -0.9;

                // I check intersecting parts to evaluate which shader part is foam, which is shadow and which is water
                float2 uv = i.uv.xy / i.uv.w;
                half lin = LinearEyeDepth(tex2D(_CameraDepthTexture, uv).r);
                half dist = i.uv.w - Fix;
                half depth = lin - dist;

                // Now I mask my texture so that only white / light parts are seen and I add an alpha channel to my main texture
                MainTexture.a = MainTextureReverse.r + _MainTexAlpha;
                FoamTexture.a = FoamTextureReverse.r + 1.0;

                //Offset Wave
                half MinFoamDimension = 0.2;

                // I set the frequency and the functions of foam parts. The small foam is a base foam with a simple sinusoidal function so that you will never have straight line, Foam Wave is the bigger one and it follow the main texture wave function
                half x = i.uv3.x;
                half y = i.uv3.y;
                half smallFoamWave = sin(x * _Frequency + 2 * x) / _WaveWidth;
                smallFoamWave += cos(y * _Frequency + 2 * y) / _WaveWidth;
                half FoamWave = (sin(x) + sin(2.2 * x * _Frequency + 5.52) + sin(2.9 * x * _Frequency + 0.93) + sin(4.6 * x * _Frequency + 8.94)) / 4;
                FoamWave += (cos(y * _Frequency) + cos(2.2 * y * _Frequency + 5.52) + cos(2.9 * y * _Frequency + 0.93) + cos(4.6 * y * _Frequency + 8.94)) / 4;

                // I create a transparent color
                fixed4 TransparentColor = fixed4(0,0,0,0);


                // Gradient wth camera distance. 
                // _Darker On / Off. If distant parts are darker than close ones
                fixed4 gradient;
                fixed4 MainTextureTransparentWithAlpha;


                if (_Darker) {
                    if (i.dist > 0 && i.dist < _DistanceRadius) {
                        gradient = lerp(_ColorMainTex, _DistanceColor, i.dist / _DistanceDarken);
                        // I give the alpha channel to main texture and I add the distance gradient texture. Then I cutoff the intersection with other meshes
                        MainTextureTransparentWithAlpha = fixed4(MainTexture.rgb + gradient.rgb * GradientWater.rgb, MainTexture.a);
                    }

                    else {
                        gradient = lerp(_ColorMainTex, _DistanceColor, _DistanceRadius / _DistanceDarken);
                        // I give the alpha channel to main texture and I add the distance gradient texture. Then I cutoff the intersection with other meshes
                        MainTextureTransparentWithAlpha = fixed4(gradient.rgb , MainTexture.a);
                        MainTextureTransparentWithAlpha = lerp(_ColorMainTex , gradient, saturate(depth * _DistanceAlpha / _Depth));
                    }
                }
                else {
                    gradient = _ColorMainTex;
                    MainTextureTransparentWithAlpha = fixed4(MainTexture.rgb + gradient.rgb * GradientWater.rgb, MainTexture.a);
                }


                // I give to my foam texture it's color and it's alpha, Then I cutoff the intersection with other meshes and with other wave parts
                fixed4 FoamTextureTransparentWithAlpha = fixed4(FoamTexture.rgb + _ColorFoam.rgb, FoamTexture.a);
                fixed4 FoamTextureCutOff = lerp(FoamTextureTransparentWithAlpha, MainTextureTransparentWithAlpha, saturate((depth + MinFoamDimension - _WaveHeight + smallFoamWave) / (_FoamDepth)));
                fixed4 FoamTextureCutOff2 = lerp(FoamTextureTransparentWithAlpha, MainTextureTransparentWithAlpha, saturate((depth + FoamWave) + MinFoamDimension) / 1.2);

                // I get the sum of foam and water
                fixed4 ResultFoamTexture = lerp(FoamTextureCutOff, FoamTextureCutOff2, saturate(1 - ((depth + FoamWave) + MinFoamDimension) / _FoamDepth));

                // I get the shadow of underwater parts and i sum it with my main texture
                fixed4 ShadowEffect = lerp(_ColorShadow, MainTextureTransparentWithAlpha  , saturate(depth / _Depth));

                fixed4 MergedEffect;
                // I add the shadow to my result
                if (_ShadowUnderwater)
                    MergedEffect = lerp(ResultFoamTexture,ShadowEffect, saturate(depth / _Depth));
                else
                    MergedEffect = ResultFoamTexture;

                return MergedEffect;
            }
            ENDCG

        }

        }
            FallBack "Diffuse"
    

}
