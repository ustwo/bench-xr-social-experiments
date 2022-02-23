// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FORGE3D/Planets HD/Thunderstorm"
{
	Properties
	{
		_NormalMap("Normal Map", 2D) = "white" {}
		_NormalUVTiling("Normal UV Tiling", Float) = 0
		_NormalUVSpeed("Normal UV Speed", Float) = 0
		_NormalTiling("Normal Tiling", Float) = 0
		_NormalSpeed("Normal Speed", Float) = 0
		_NormlalDistortionFactor("Normlal Distortion Factor", Range( -1 , 1)) = 0
		_NormalScale("Normal Scale", Float) = 0
		_DistortionMap("Distortion Map", 2D) = "white" {}
		_DistortionUVMap("Distortion UV Map", 2D) = "white" {}
		_DistortionUVTiling("Distortion UV Tiling", Float) = 0
		_DistortionUVSpeed("Distortion UV Speed", Float) = 0
		_DistortionTiling("Distortion Tiling", Float) = 0
		_DistortionSpeed("Distortion Speed", Float) = 0
		_DistortionFactor("Distortion Factor", Range( -1 , 1)) = 0
		_TintHigh("Tint High", Color) = (0,0,0,0)
		_TintLow("Tint Low", Color) = (0,0,0,0)
		_DetailPow("Detail Pow", Float) = 0
		_DetailBoost("Detail Boost", Float) = 0
		_SpecularColor("Specular Color", Color) = (0,0,0,0)
		_Specular("Specular", Range( 0.03 , 1)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.5
		_ScatterMap("Scatter Map", 2D) = "white" {}
		_ScatterColor("Scatter Color", Color) = (0,0,0,0)
		_ScatterBoost("Scatter Boost", Range( 0 , 5)) = 1
		_ScatterIndirect("Scatter Indirect", Range( 0 , 1)) = 0
		_ScatterStretch("Scatter Stretch", Range( -2 , 2)) = 0
		_ScatterCenterShift("Scatter Center Shift", Range( -2 , 2)) = 0
		_FrenselMult("Frensel Mult", Range( 0 , 10)) = 0
		_FresnelPower("Fresnel Power", Range( 0 , 10)) = 0
		_FresnelColor("Fresnel Color", Color) = (0.4558824,0.4558824,0.4558824,1)
		_LightingMaskMap("Lighting Mask Map", 2D) = "white" {}
		_LightingMap("Lighting Map", 2D) = "white" {}
		_LightingMaskATiling("Lighting Mask A Tiling", Float) = 0
		_LightingMaskBTiling("Lighting Mask B Tiling", Float) = 0
		_LightingMaskAUVSpeed("Lighting Mask A UV Speed", Float) = 0
		_LightingMaskBUVSpeed("Lighting Mask B UV Speed", Float) = 0
		_LightingATiling("Lighting A Tiling", Float) = 0
		_LightingBTiling("Lighting B Tiling", Float) = 0
		_LightingAFrequency("Lighting A Frequency", Float) = 0
		_LightingBFrequency("Lighting B Frequency", Float) = 0
		_LightningSineMult("Lightning Sine Mult", Float) = 0
		_LigntingMaskPow("Lignting Mask Pow", Float) = 0
		_LightningBoost("Lightning Boost", Float) = 5
		_LightningColor("Lightning Color", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float3 viewDir;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _ScatterMap;
		uniform float _ScatterCenterShift;
		uniform float _ScatterStretch;
		uniform float4 _ScatterColor;
		uniform float _ScatterBoost;
		uniform float _ScatterIndirect;
		uniform sampler2D _NormalMap;
		uniform float _NormalTiling;
		uniform float _NormalSpeed;
		uniform float _NormalUVTiling;
		uniform float _NormalUVSpeed;
		uniform float _NormlalDistortionFactor;
		uniform float _NormalScale;
		uniform float _FresnelPower;
		uniform float _FrenselMult;
		uniform float4 _FresnelColor;
		uniform float4 _TintLow;
		uniform float4 _TintHigh;
		uniform sampler2D _DistortionMap;
		uniform float _DistortionTiling;
		uniform float _DistortionSpeed;
		uniform sampler2D _DistortionUVMap;
		uniform float _DistortionUVTiling;
		uniform float _DistortionUVSpeed;
		uniform float _DistortionFactor;
		uniform float _DetailPow;
		uniform float _DetailBoost;
		uniform float4 _SpecularColor;
		uniform float _Specular;
		uniform float _Smoothness;
		uniform float _LightningSineMult;
		uniform sampler2D _LightingMaskMap;
		uniform float _LightingMaskATiling;
		uniform float _LightingMaskAUVSpeed;
		uniform float _LightingMaskBTiling;
		uniform float _LightingMaskBUVSpeed;
		uniform float _LigntingMaskPow;
		uniform sampler2D _LightingMap;
		uniform float _LightingATiling;
		uniform float _LightingAFrequency;
		uniform float _LightingBTiling;
		uniform float _LightingBFrequency;
		uniform float _LightningBoost;
		uniform float4 _LightningColor;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float4 transform4_g156 = mul(unity_ObjectToWorld,float4( ase_vertexNormal , 0.0 ));
			float4 normalizeResult6_g156 = normalize( transform4_g156 );
			float3 temp_output_1_0_g157 = normalizeResult6_g156.xyz;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult7_g156 = normalize( ase_worldlightDir );
			float dotResult4_g157 = dot( temp_output_1_0_g157 , normalizeResult7_g156 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult8_g156 = normalize( ase_worldViewDir );
			float dotResult7_g157 = dot( temp_output_1_0_g157 , normalizeResult8_g156 );
			float2 appendResult10_g157 = (float2(( ( dotResult4_g157 / 2.0 ) + 0.5 ) , dotResult7_g157));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			SurfaceOutputStandardSpecular s13 = (SurfaceOutputStandardSpecular ) 0;
			float4 appendResult63_g154 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g154 = mul( unity_WorldToObject, appendResult63_g154 );
			float4 temp_cast_2 = (5.0).xxxx;
			float4 temp_output_4_0_g154 = pow( abs( temp_output_57_0_g154 ) , temp_cast_2 );
			float4 break6_g154 = temp_output_4_0_g154;
			float4 projNormal10_g154 = ( temp_output_4_0_g154 / ( break6_g154.x + break6_g154.y + break6_g154.z ) );
			float4 appendResult62_g154 = (float4(ase_worldPos , 1.0));
			float4 break26_g154 = mul( unity_WorldToObject, appendResult62_g154 );
			float2 appendResult27_g154 = (float2(break26_g154.z , break26_g154.y));
			float4 nSign18_g154 = sign( temp_output_57_0_g154 );
			float4 break20_g154 = nSign18_g154;
			float2 appendResult21_g154 = (float2(break20_g154.x , 1.0));
			float temp_output_29_0_g154 = _NormalTiling;
			float temp_output_10_0_g152 = ( _Time.y * _NormalSpeed );
			float2 appendResult12_g152 = (float2(temp_output_10_0_g152 , temp_output_10_0_g152));
			float4 appendResult63_g153 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g153 = mul( unity_WorldToObject, appendResult63_g153 );
			float4 temp_cast_3 = (5.0).xxxx;
			float4 temp_output_4_0_g153 = pow( abs( temp_output_57_0_g153 ) , temp_cast_3 );
			float4 break6_g153 = temp_output_4_0_g153;
			float4 projNormal10_g153 = ( temp_output_4_0_g153 / ( break6_g153.x + break6_g153.y + break6_g153.z ) );
			float4 appendResult62_g153 = (float4(ase_worldPos , 1.0));
			float4 break26_g153 = mul( unity_WorldToObject, appendResult62_g153 );
			float2 appendResult27_g153 = (float2(break26_g153.z , break26_g153.y));
			float4 nSign18_g153 = sign( temp_output_57_0_g153 );
			float4 break20_g153 = nSign18_g153;
			float2 appendResult21_g153 = (float2(break20_g153.x , 1.0));
			float temp_output_29_0_g153 = _NormalUVTiling;
			float temp_output_2_0_g152 = ( _Time.y * _NormalUVSpeed );
			float2 appendResult5_g152 = (float2(temp_output_2_0_g152 , temp_output_2_0_g152));
			float2 temp_output_65_0_g153 = appendResult5_g152;
			float2 appendResult32_g153 = (float2(break26_g153.x , break26_g153.z));
			float2 appendResult22_g153 = (float2(break20_g153.y , 1.0));
			float2 appendResult34_g153 = (float2(break26_g153.x , break26_g153.y));
			float2 appendResult25_g153 = (float2(-break20_g153.z , 1.0));
			float4 break11_g152 = ( saturate( ( ( projNormal10_g153.x * tex2D( _NormalMap, ( ( appendResult27_g153 * appendResult21_g153 * temp_output_29_0_g153 ) + temp_output_65_0_g153 ) ) ) + ( projNormal10_g153.y * tex2D( _NormalMap, ( ( temp_output_29_0_g153 * appendResult32_g153 * appendResult22_g153 ) + temp_output_65_0_g153 ) ) ) + ( projNormal10_g153.z * tex2D( _NormalMap, ( temp_output_65_0_g153 + ( temp_output_29_0_g153 * appendResult34_g153 * appendResult25_g153 ) ) ) ) ) ) * _NormlalDistortionFactor );
			float2 appendResult13_g152 = (float2(break11_g152.r , break11_g152.g));
			float2 temp_output_65_0_g154 = ( appendResult12_g152 + appendResult13_g152 );
			float2 appendResult32_g154 = (float2(break26_g154.x , break26_g154.z));
			float2 appendResult22_g154 = (float2(break20_g154.y , 1.0));
			float2 appendResult34_g154 = (float2(break26_g154.x , break26_g154.y));
			float2 appendResult25_g154 = (float2(-break20_g154.z , 1.0));
			float3 normalUnpacked24 = UnpackScaleNormal( saturate( ( ( projNormal10_g154.x * tex2D( _NormalMap, ( ( appendResult27_g154 * appendResult21_g154 * temp_output_29_0_g154 ) + temp_output_65_0_g154 ) ) ) + ( projNormal10_g154.y * tex2D( _NormalMap, ( ( temp_output_29_0_g154 * appendResult32_g154 * appendResult22_g154 ) + temp_output_65_0_g154 ) ) ) + ( projNormal10_g154.z * tex2D( _NormalMap, ( temp_output_65_0_g154 + ( temp_output_29_0_g154 * appendResult34_g154 * appendResult25_g154 ) ) ) ) ) ), _NormalScale );
			float3 normalizeResult5_g155 = normalize( normalUnpacked24 );
			float dotResult14_g155 = dot( i.viewDir , normalizeResult5_g155 );
			float4 appendResult63_g150 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g150 = mul( unity_WorldToObject, appendResult63_g150 );
			float4 temp_cast_5 = (5.0).xxxx;
			float4 temp_output_4_0_g150 = pow( abs( temp_output_57_0_g150 ) , temp_cast_5 );
			float4 break6_g150 = temp_output_4_0_g150;
			float4 projNormal10_g150 = ( temp_output_4_0_g150 / ( break6_g150.x + break6_g150.y + break6_g150.z ) );
			float4 appendResult62_g150 = (float4(ase_worldPos , 1.0));
			float4 break26_g150 = mul( unity_WorldToObject, appendResult62_g150 );
			float2 appendResult27_g150 = (float2(break26_g150.z , break26_g150.y));
			float4 nSign18_g150 = sign( temp_output_57_0_g150 );
			float4 break20_g150 = nSign18_g150;
			float2 appendResult21_g150 = (float2(break20_g150.x , 1.0));
			float temp_output_29_0_g150 = _DistortionTiling;
			float temp_output_10_0_g149 = ( _Time.y * _DistortionSpeed );
			float2 appendResult12_g149 = (float2(temp_output_10_0_g149 , temp_output_10_0_g149));
			float4 appendResult63_g151 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g151 = mul( unity_WorldToObject, appendResult63_g151 );
			float4 temp_cast_6 = (5.0).xxxx;
			float4 temp_output_4_0_g151 = pow( abs( temp_output_57_0_g151 ) , temp_cast_6 );
			float4 break6_g151 = temp_output_4_0_g151;
			float4 projNormal10_g151 = ( temp_output_4_0_g151 / ( break6_g151.x + break6_g151.y + break6_g151.z ) );
			float4 appendResult62_g151 = (float4(ase_worldPos , 1.0));
			float4 break26_g151 = mul( unity_WorldToObject, appendResult62_g151 );
			float2 appendResult27_g151 = (float2(break26_g151.z , break26_g151.y));
			float4 nSign18_g151 = sign( temp_output_57_0_g151 );
			float4 break20_g151 = nSign18_g151;
			float2 appendResult21_g151 = (float2(break20_g151.x , 1.0));
			float temp_output_29_0_g151 = _DistortionUVTiling;
			float temp_output_2_0_g149 = ( _Time.y * _DistortionUVSpeed );
			float2 appendResult5_g149 = (float2(temp_output_2_0_g149 , temp_output_2_0_g149));
			float2 temp_output_65_0_g151 = appendResult5_g149;
			float2 appendResult32_g151 = (float2(break26_g151.x , break26_g151.z));
			float2 appendResult22_g151 = (float2(break20_g151.y , 1.0));
			float2 appendResult34_g151 = (float2(break26_g151.x , break26_g151.y));
			float2 appendResult25_g151 = (float2(-break20_g151.z , 1.0));
			float4 break11_g149 = ( saturate( ( ( projNormal10_g151.x * tex2D( _DistortionUVMap, ( ( appendResult27_g151 * appendResult21_g151 * temp_output_29_0_g151 ) + temp_output_65_0_g151 ) ) ) + ( projNormal10_g151.y * tex2D( _DistortionUVMap, ( ( temp_output_29_0_g151 * appendResult32_g151 * appendResult22_g151 ) + temp_output_65_0_g151 ) ) ) + ( projNormal10_g151.z * tex2D( _DistortionUVMap, ( temp_output_65_0_g151 + ( temp_output_29_0_g151 * appendResult34_g151 * appendResult25_g151 ) ) ) ) ) ) * _DistortionFactor );
			float2 appendResult13_g149 = (float2(break11_g149.r , break11_g149.g));
			float2 temp_output_65_0_g150 = ( appendResult12_g149 + appendResult13_g149 );
			float2 appendResult32_g150 = (float2(break26_g150.x , break26_g150.z));
			float2 appendResult22_g150 = (float2(break20_g150.y , 1.0));
			float2 appendResult34_g150 = (float2(break26_g150.x , break26_g150.y));
			float2 appendResult25_g150 = (float2(-break20_g150.z , 1.0));
			float4 temp_cast_7 = (_DetailPow).xxxx;
			float4 temp_output_9_0 = saturate( ( pow( saturate( ( ( projNormal10_g150.x * tex2D( _DistortionMap, ( ( appendResult27_g150 * appendResult21_g150 * temp_output_29_0_g150 ) + temp_output_65_0_g150 ) ) ) + ( projNormal10_g150.y * tex2D( _DistortionMap, ( ( temp_output_29_0_g150 * appendResult32_g150 * appendResult22_g150 ) + temp_output_65_0_g150 ) ) ) + ( projNormal10_g150.z * tex2D( _DistortionMap, ( temp_output_65_0_g150 + ( temp_output_29_0_g150 * appendResult34_g150 * appendResult25_g150 ) ) ) ) ) ) , temp_cast_7 ) * _DetailBoost ) );
			float4 lerpResult5 = lerp( _TintLow , _TintHigh , temp_output_9_0.r);
			s13.Albedo = ( ( ( saturate( pow( saturate( ( 1.0 - dotResult14_g155 ) ) , _FresnelPower ) ) * _FrenselMult ) * _FresnelColor ) + saturate( lerpResult5 ) ).rgb;
			s13.Normal = WorldNormalVector( i , normalUnpacked24 );
			s13.Emission = float3( 0,0,0 );
			s13.Specular = ( _SpecularColor * temp_output_9_0 * _Specular ).rgb;
			s13.Smoothness = _Smoothness;
			s13.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi13 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g13 = UnityGlossyEnvironmentSetup( s13.Smoothness, data.worldViewDir, s13.Normal, float3(0,0,0));
			gi13 = UnityGlobalIllumination( data, s13.Occlusion, s13.Normal, g13 );
			#endif

			float3 surfResult13 = LightingStandardSpecular ( s13, viewDir, gi13 ).rgb;
			surfResult13 += s13.Emission;

			#ifdef UNITY_PASS_FORWARDADD//13
			surfResult13 -= s13.Emission;
			#endif//13
			float4 temp_cast_11 = (0.0).xxxx;
			float clampResult20_g158 = clamp( sin( ( _Time.y * ( 2.0 * UNITY_PI ) ) ) , 0.3 , 1.0 );
			float clampResult29_g158 = clamp( sin( ( _Time.y * ( 5.0 * UNITY_PI ) ) ) , 0.5 , 1.0 );
			float clampResult30_g158 = clamp( sin( ( _Time.y * ( 10.0 * UNITY_PI ) ) ) , 0.7 , 1.0 );
			float sine32_g158 = ( clampResult20_g158 * clampResult29_g158 * clampResult30_g158 );
			float4 appendResult63_g160 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g160 = mul( unity_WorldToObject, appendResult63_g160 );
			float4 temp_cast_12 = (5.0).xxxx;
			float4 temp_output_4_0_g160 = pow( abs( temp_output_57_0_g160 ) , temp_cast_12 );
			float4 break6_g160 = temp_output_4_0_g160;
			float4 projNormal10_g160 = ( temp_output_4_0_g160 / ( break6_g160.x + break6_g160.y + break6_g160.z ) );
			float4 appendResult62_g160 = (float4(ase_worldPos , 1.0));
			float4 break26_g160 = mul( unity_WorldToObject, appendResult62_g160 );
			float2 appendResult27_g160 = (float2(break26_g160.z , break26_g160.y));
			float4 nSign18_g160 = sign( temp_output_57_0_g160 );
			float4 break20_g160 = nSign18_g160;
			float2 appendResult21_g160 = (float2(break20_g160.x , 1.0));
			float temp_output_29_0_g160 = _LightingMaskATiling;
			float mulTime7_g158 = _Time.y * _LightingMaskAUVSpeed;
			float2 temp_cast_13 = (mulTime7_g158).xx;
			float2 temp_output_65_0_g160 = temp_cast_13;
			float2 appendResult32_g160 = (float2(break26_g160.x , break26_g160.z));
			float2 appendResult22_g160 = (float2(break20_g160.y , 1.0));
			float2 appendResult34_g160 = (float2(break26_g160.x , break26_g160.y));
			float2 appendResult25_g160 = (float2(-break20_g160.z , 1.0));
			float4 appendResult63_g159 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g159 = mul( unity_WorldToObject, appendResult63_g159 );
			float4 temp_cast_14 = (5.0).xxxx;
			float4 temp_output_4_0_g159 = pow( abs( temp_output_57_0_g159 ) , temp_cast_14 );
			float4 break6_g159 = temp_output_4_0_g159;
			float4 projNormal10_g159 = ( temp_output_4_0_g159 / ( break6_g159.x + break6_g159.y + break6_g159.z ) );
			float4 appendResult62_g159 = (float4(ase_worldPos , 1.0));
			float4 break26_g159 = mul( unity_WorldToObject, appendResult62_g159 );
			float2 appendResult27_g159 = (float2(break26_g159.z , break26_g159.y));
			float4 nSign18_g159 = sign( temp_output_57_0_g159 );
			float4 break20_g159 = nSign18_g159;
			float2 appendResult21_g159 = (float2(break20_g159.x , 1.0));
			float temp_output_29_0_g159 = _LightingMaskBTiling;
			float mulTime10_g158 = _Time.y * _LightingMaskBUVSpeed;
			float2 temp_cast_15 = (mulTime10_g158).xx;
			float2 temp_output_65_0_g159 = temp_cast_15;
			float2 appendResult32_g159 = (float2(break26_g159.x , break26_g159.z));
			float2 appendResult22_g159 = (float2(break20_g159.y , 1.0));
			float2 appendResult34_g159 = (float2(break26_g159.x , break26_g159.y));
			float2 appendResult25_g159 = (float2(-break20_g159.z , 1.0));
			float4 lightningMask14_g158 = ( saturate( ( ( projNormal10_g160.x * tex2D( _LightingMaskMap, ( ( appendResult27_g160 * appendResult21_g160 * temp_output_29_0_g160 ) + temp_output_65_0_g160 ) ) ) + ( projNormal10_g160.y * tex2D( _LightingMaskMap, ( ( temp_output_29_0_g160 * appendResult32_g160 * appendResult22_g160 ) + temp_output_65_0_g160 ) ) ) + ( projNormal10_g160.z * tex2D( _LightingMaskMap, ( temp_output_65_0_g160 + ( temp_output_29_0_g160 * appendResult34_g160 * appendResult25_g160 ) ) ) ) ) ) * saturate( ( ( projNormal10_g159.x * tex2D( _LightingMaskMap, ( ( appendResult27_g159 * appendResult21_g159 * temp_output_29_0_g159 ) + temp_output_65_0_g159 ) ) ) + ( projNormal10_g159.y * tex2D( _LightingMaskMap, ( ( temp_output_29_0_g159 * appendResult32_g159 * appendResult22_g159 ) + temp_output_65_0_g159 ) ) ) + ( projNormal10_g159.z * tex2D( _LightingMaskMap, ( temp_output_65_0_g159 + ( temp_output_29_0_g159 * appendResult34_g159 * appendResult25_g159 ) ) ) ) ) ) );
			float4 temp_cast_16 = (_LigntingMaskPow).xxxx;
			float4 lightningMaskSine39_g158 = saturate( pow( ( _LightningSineMult * sine32_g158 * lightningMask14_g158 ) , temp_cast_16 ) );
			float4 appendResult63_g162 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g162 = mul( unity_WorldToObject, appendResult63_g162 );
			float4 temp_cast_17 = (5.0).xxxx;
			float4 temp_output_4_0_g162 = pow( abs( temp_output_57_0_g162 ) , temp_cast_17 );
			float4 break6_g162 = temp_output_4_0_g162;
			float4 projNormal10_g162 = ( temp_output_4_0_g162 / ( break6_g162.x + break6_g162.y + break6_g162.z ) );
			float4 appendResult62_g162 = (float4(ase_worldPos , 1.0));
			float4 break26_g162 = mul( unity_WorldToObject, appendResult62_g162 );
			float2 appendResult27_g162 = (float2(break26_g162.z , break26_g162.y));
			float4 nSign18_g162 = sign( temp_output_57_0_g162 );
			float4 break20_g162 = nSign18_g162;
			float2 appendResult21_g162 = (float2(break20_g162.x , 1.0));
			float temp_output_29_0_g162 = _LightingATiling;
			float mulTime45_g158 = _Time.y * _LightingAFrequency;
			float2 temp_cast_18 = (( floor( mulTime45_g158 ) * 0.9 )).xx;
			float2 temp_output_65_0_g162 = temp_cast_18;
			float2 appendResult32_g162 = (float2(break26_g162.x , break26_g162.z));
			float2 appendResult22_g162 = (float2(break20_g162.y , 1.0));
			float2 appendResult34_g162 = (float2(break26_g162.x , break26_g162.y));
			float2 appendResult25_g162 = (float2(-break20_g162.z , 1.0));
			float4 appendResult63_g161 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g161 = mul( unity_WorldToObject, appendResult63_g161 );
			float4 temp_cast_19 = (5.0).xxxx;
			float4 temp_output_4_0_g161 = pow( abs( temp_output_57_0_g161 ) , temp_cast_19 );
			float4 break6_g161 = temp_output_4_0_g161;
			float4 projNormal10_g161 = ( temp_output_4_0_g161 / ( break6_g161.x + break6_g161.y + break6_g161.z ) );
			float4 appendResult62_g161 = (float4(ase_worldPos , 1.0));
			float4 break26_g161 = mul( unity_WorldToObject, appendResult62_g161 );
			float2 appendResult27_g161 = (float2(break26_g161.z , break26_g161.y));
			float4 nSign18_g161 = sign( temp_output_57_0_g161 );
			float4 break20_g161 = nSign18_g161;
			float2 appendResult21_g161 = (float2(break20_g161.x , 1.0));
			float temp_output_29_0_g161 = _LightingBTiling;
			float mulTime46_g158 = _Time.y * _LightingBFrequency;
			float2 temp_cast_20 = (( 0.9 * floor( mulTime46_g158 ) )).xx;
			float2 temp_output_65_0_g161 = temp_cast_20;
			float2 appendResult32_g161 = (float2(break26_g161.x , break26_g161.z));
			float2 appendResult22_g161 = (float2(break20_g161.y , 1.0));
			float2 appendResult34_g161 = (float2(break26_g161.x , break26_g161.y));
			float2 appendResult25_g161 = (float2(-break20_g161.z , 1.0));
			float lightning50_g158 = ( saturate( ( ( projNormal10_g162.x * tex2D( _LightingMap, ( ( appendResult27_g162 * appendResult21_g162 * temp_output_29_0_g162 ) + temp_output_65_0_g162 ) ) ) + ( projNormal10_g162.y * tex2D( _LightingMap, ( ( temp_output_29_0_g162 * appendResult32_g162 * appendResult22_g162 ) + temp_output_65_0_g162 ) ) ) + ( projNormal10_g162.z * tex2D( _LightingMap, ( temp_output_65_0_g162 + ( temp_output_29_0_g162 * appendResult34_g162 * appendResult25_g162 ) ) ) ) ) ) * saturate( ( ( projNormal10_g161.x * tex2D( _LightingMap, ( ( appendResult27_g161 * appendResult21_g161 * temp_output_29_0_g161 ) + temp_output_65_0_g161 ) ) ) + ( projNormal10_g161.y * tex2D( _LightingMap, ( ( temp_output_29_0_g161 * appendResult32_g161 * appendResult22_g161 ) + temp_output_65_0_g161 ) ) ) + ( projNormal10_g161.z * tex2D( _LightingMap, ( temp_output_65_0_g161 + ( temp_output_29_0_g161 * appendResult34_g161 * appendResult25_g161 ) ) ) ) ) ) * _LightningBoost ).r;
			c.rgb = ( saturate( ( saturate( ( saturate( ( saturate( ( tex2D( _ScatterMap, ( ( _ScatterCenterShift + appendResult10_g157 ) * _ScatterStretch ) ) * _ScatterColor * ase_lightColor ) ) * _ScatterBoost ) ) + _ScatterIndirect ) ) * float4( surfResult13 , 0.0 ) ) ) + max( temp_cast_11 , ( lightningMaskSine39_g158 * lightning50_g158 * _LightningColor ) ) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma exclude_renderers xboxseries playstation switch nomrt 
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 tSpace0 : TEXCOORD1;
				float4 tSpace1 : TEXCOORD2;
				float4 tSpace2 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
-1763;45;1589;922;-10.0937;118.58;1;True;True
Node;AmplifyShaderEditor.FunctionNode;64;-1927.437,322.3087;Inherit;False;TriplanarDoubleUVDist;8;;149;9e960dc58a88b2d4496ab2f61061459e;0;0;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1862.668,431.739;Float;False;Property;_DetailPow;Detail Pow;18;0;Create;True;0;0;0;False;0;False;0;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;6;-1599.668,343.739;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1656.668,544.739;Float;False;Property;_DetailBoost;Detail Boost;19;0;Create;True;0;0;0;False;0;False;0;0.71;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1381.668,362.739;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;9;-1225.668,360.739;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;65;-1856.686,690.6788;Inherit;False;TriplanarNormalUVDist;0;;152;1a5fcd4739bcd5240a12b19949e4bb06;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;3;-792.2358,-134.4913;Float;False;Property;_TintLow;Tint Low;17;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.008001738,0.06445529,0.2720588,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-797.436,41.00867;Float;False;Property;_TintHigh;Tint High;16;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5955881,0.8995942,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;28;-832.4755,227.1503;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-1549.028,678.8254;Float;False;normalUnpacked;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;5;-440.6682,89.73895;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-422.4291,-37.81881;Inherit;False;24;normalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;31;-125.4292,-34.81888;Inherit;False;Fresnel;30;;155;f8c497a0c2d6d334f8e7138f24a77d5f;0;1;22;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;16;-453.8198,203.46;Float;False;Property;_SpecularColor;Specular Color;20;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4485294,0.8402634,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;12;-216.3682,93.43896;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-518.8198,400.46;Float;False;Property;_Specular;Specular;21;0;Create;True;0;0;0;False;0;False;1;1;0.03;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-194.5665,228.3412;Inherit;False;24;normalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-181.3197,315.5601;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-515.8198,485.46;Float;False;Property;_Smoothness;Smoothness;22;0;Create;True;0;0;0;False;0;False;0.5;0.458;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;161.2449,40.63271;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;13;459.4874,222.5784;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;36;519.2449,-16.36731;Inherit;False;ScatterColor;23;;156;5984f944e2b849e44aad6ac4d7027dc1;0;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;815.2449,215.6327;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;43;1012.566,218.7081;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;66;862.5657,372.7081;Inherit;False;Lightning;34;;158;1ce3b38b84803624a906f5fc443424fd;0;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;1212.566,220.7081;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1632.305,-19.89405;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;FORGE3D/Planets HD/Thunderstorm;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;64;0
WireConnection;6;1;7;0
WireConnection;8;0;6;0
WireConnection;8;1;10;0
WireConnection;9;0;8;0
WireConnection;28;0;9;0
WireConnection;24;0;65;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;5;2;28;0
WireConnection;31;22;32;0
WireConnection;12;0;5;0
WireConnection;17;0;16;0
WireConnection;17;1;9;0
WireConnection;17;2;14;0
WireConnection;35;0;31;0
WireConnection;35;1;12;0
WireConnection;13;0;35;0
WireConnection;13;1;25;0
WireConnection;13;3;17;0
WireConnection;13;4;15;0
WireConnection;38;0;36;0
WireConnection;38;1;13;0
WireConnection;43;0;38;0
WireConnection;42;0;43;0
WireConnection;42;1;66;0
WireConnection;0;13;42;0
ASEEND*/
//CHKSM=6512EF8C6C861EB9AB84785D06FA4E82049D1B98