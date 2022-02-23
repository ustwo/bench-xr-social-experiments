// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FORGE3D/Planets HD/Lava"
{
	Properties
	{
		_HeightMap("Height Map", 2D) = "white" {}
		_ScatterMap("Scatter Map", 2D) = "white" {}
		_ScatterColor("Scatter Color", Color) = (0,0,0,0)
		_ScatterBoost("Scatter Boost", Range( 0 , 5)) = 1
		_ScatterIndirect("Scatter Indirect", Range( 0 , 1)) = 0
		_ScatterStretch("Scatter Stretch", Range( -2 , 2)) = 0
		_ScatterCenterShift("Scatter Center Shift", Range( -2 , 2)) = 0
		_DetailMap("Detail Map", 2D) = "white" {}
		_MagmaMap("Magma Map", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "white" {}
		_NormalScale("Normal Scale", Float) = 0
		_NormalTiling("Normal Tiling", Float) = 0
		_HeightTiling("Height Tiling", Float) = 2
		_DetailTiling("Detail Tiling", Float) = 2
		_MagmaTiling("Magma Tiling", Float) = 2
		_LavaMaskTiling("Lava Mask Tiling", Float) = 2
		_SpecularColor("Specular Color", Color) = (0,0,0,0)
		_Specular("Specular", Range( 0.03 , 1)) = 0.03
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_SpecularBoost("Specular Boost", Float) = 0.03
		_LavaLow("Lava Low", Color) = (0,0,0,0)
		_LavaMid("Lava Mid", Color) = (0,0,0,0)
		_LavaHigh("Lava High", Color) = (0,0,0,0)
		_LavaFactorsX("Lava Factors X", Range( 0 , 1)) = 0
		_LavaFactorsY("Lava Factors Y", Range( 0 , 1)) = 0
		_LavaFactorsZ("Lava Factors Z", Range( 0 , 1)) = 0
		_LavaDetail("Lava Detail", Range( 0 , 1)) = 0
		_DetailExp("Detail Exp", Float) = 0
		_HeightDetail("Height Detail", Float) = 0
		_LavaMaskFactorsX("Lava Mask Factors X", Float) = 0
		_LavaMaskFactorsY("Lava Mask Factors Y", Float) = 0
		_LavaMaskPower("Lava Mask Power", Float) = 0
		_LavaMaskBoost("Lava Mask Boost", Float) = 0
		_LavaPasstrough("Lava Passtrough", Range( 0 , 0.1)) = 0.02
		_MagmaColorMin("Magma Color Min", Color) = (0,0,0,0)
		_MagmaColorMax("Magma Color Max", Color) = (0,0,0,0)
		_MagmaPower("Magma Power", Float) = 0
		_MagmaBoost("Magma Boost", Float) = 0
		_MagmaGlow("Magma Glow", Float) = 0
		_FrenselMult("Frensel Mult", Range( 0 , 10)) = 0
		_FresnelPower("Fresnel Power", Range( 0 , 10)) = 0
		_FresnelColor("Fresnel Color", Color) = (0.4558824,0.4558824,0.4558824,1)
		_DistortionMap("Distortion Map", 2D) = "white" {}
		_DistortionUVTiling("Distortion UV Tiling", Float) = 0
		_DistortionUVSpeed("Distortion UV Speed", Float) = 0
		_DistortionTiling("Distortion Tiling", Float) = 0
		_DistortionSpeed("Distortion Speed", Float) = 0
		_DistortionFactor("Distortion Factor", Range( -1 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
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
		uniform float4 _LavaLow;
		uniform float4 _LavaMid;
		uniform float _DetailExp;
		uniform sampler2D _DetailMap;
		uniform float _DetailTiling;
		uniform sampler2D _HeightMap;
		uniform float _HeightTiling;
		uniform float _HeightDetail;
		uniform float _LavaFactorsX;
		uniform float _LavaDetail;
		uniform float _LavaFactorsY;
		uniform float _LavaFactorsZ;
		uniform float4 _LavaHigh;
		uniform sampler2D _NormalMap;
		uniform float _NormalTiling;
		uniform float _NormalScale;
		uniform float _Specular;
		uniform float4 _SpecularColor;
		uniform float _SpecularBoost;
		uniform float _Smoothness;
		uniform float _FresnelPower;
		uniform float _FrenselMult;
		uniform float4 _FresnelColor;
		uniform sampler2D _DistortionMap;
		uniform float _DistortionTiling;
		uniform float _DistortionSpeed;
		uniform float _DistortionUVTiling;
		uniform float _DistortionUVSpeed;
		uniform float _DistortionFactor;
		uniform float4 _MagmaColorMin;
		uniform float4 _MagmaColorMax;
		uniform sampler2D _MagmaMap;
		uniform float _MagmaTiling;
		uniform float _MagmaPower;
		uniform float _MagmaBoost;
		uniform float _LavaMaskTiling;
		uniform float _LavaMaskFactorsX;
		uniform float _LavaMaskFactorsY;
		uniform float _LavaMaskPower;
		uniform float _LavaMaskBoost;
		uniform float _MagmaGlow;
		uniform float _LavaPasstrough;


		inline float4 TriplanarSampling193( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
			yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
			zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float4 transform4_g87 = mul(unity_ObjectToWorld,float4( ase_vertexNormal , 0.0 ));
			float4 normalizeResult6_g87 = normalize( transform4_g87 );
			float3 temp_output_1_0_g88 = normalizeResult6_g87.xyz;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult7_g87 = normalize( ase_worldlightDir );
			float dotResult4_g88 = dot( temp_output_1_0_g88 , normalizeResult7_g87 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult8_g87 = normalize( ase_worldViewDir );
			float dotResult7_g88 = dot( temp_output_1_0_g88 , normalizeResult8_g87 );
			float2 appendResult10_g88 = (float2(( ( dotResult4_g88 / 2.0 ) + 0.5 ) , dotResult7_g88));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			SurfaceOutputStandardSpecular s185 = (SurfaceOutputStandardSpecular ) 0;
			float4 appendResult63_g67 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g67 = mul( unity_WorldToObject, appendResult63_g67 );
			float4 temp_cast_4 = (5.0).xxxx;
			float4 temp_output_4_0_g67 = pow( abs( temp_output_57_0_g67 ) , temp_cast_4 );
			float4 break6_g67 = temp_output_4_0_g67;
			float4 projNormal10_g67 = ( temp_output_4_0_g67 / ( break6_g67.x + break6_g67.y + break6_g67.z ) );
			float4 appendResult62_g67 = (float4(ase_worldPos , 1.0));
			float4 break26_g67 = mul( unity_WorldToObject, appendResult62_g67 );
			float2 appendResult27_g67 = (float2(break26_g67.z , break26_g67.y));
			float4 nSign18_g67 = sign( temp_output_57_0_g67 );
			float4 break20_g67 = nSign18_g67;
			float2 appendResult21_g67 = (float2(break20_g67.x , 1.0));
			float temp_output_29_0_g67 = _DetailTiling;
			float2 temp_output_65_0_g67 = float2( 0,0 );
			float2 appendResult32_g67 = (float2(break26_g67.x , break26_g67.z));
			float2 appendResult22_g67 = (float2(break20_g67.y , 1.0));
			float2 appendResult34_g67 = (float2(break26_g67.x , break26_g67.y));
			float2 appendResult25_g67 = (float2(-break20_g67.z , 1.0));
			float4 break138 = saturate( ( ( projNormal10_g67.x * tex2D( _DetailMap, ( ( appendResult27_g67 * appendResult21_g67 * temp_output_29_0_g67 ) + temp_output_65_0_g67 ) ) ) + ( projNormal10_g67.y * tex2D( _DetailMap, ( ( temp_output_29_0_g67 * appendResult32_g67 * appendResult22_g67 ) + temp_output_65_0_g67 ) ) ) + ( projNormal10_g67.z * tex2D( _DetailMap, ( temp_output_65_0_g67 + ( temp_output_29_0_g67 * appendResult34_g67 * appendResult25_g67 ) ) ) ) ) );
			float detailTex146 = saturate( ( _DetailExp * pow( ( break138.r * break138.g ) , _DetailExp ) * 5000.0 ) );
			float4 appendResult63_g69 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g69 = mul( unity_WorldToObject, appendResult63_g69 );
			float4 temp_cast_5 = (5.0).xxxx;
			float4 temp_output_4_0_g69 = pow( abs( temp_output_57_0_g69 ) , temp_cast_5 );
			float4 break6_g69 = temp_output_4_0_g69;
			float4 projNormal10_g69 = ( temp_output_4_0_g69 / ( break6_g69.x + break6_g69.y + break6_g69.z ) );
			float4 appendResult62_g69 = (float4(ase_worldPos , 1.0));
			float4 break26_g69 = mul( unity_WorldToObject, appendResult62_g69 );
			float2 appendResult27_g69 = (float2(break26_g69.z , break26_g69.y));
			float4 nSign18_g69 = sign( temp_output_57_0_g69 );
			float4 break20_g69 = nSign18_g69;
			float2 appendResult21_g69 = (float2(break20_g69.x , 1.0));
			float temp_output_29_0_g69 = _HeightTiling;
			float2 temp_output_65_0_g69 = float2( 0,0 );
			float2 appendResult32_g69 = (float2(break26_g69.x , break26_g69.z));
			float2 appendResult22_g69 = (float2(break20_g69.y , 1.0));
			float2 appendResult34_g69 = (float2(break26_g69.x , break26_g69.y));
			float2 appendResult25_g69 = (float2(-break20_g69.z , 1.0));
			float detaledHeight167 = saturate( ( detailTex146 * saturate( ( saturate( ( ( projNormal10_g69.x * tex2D( _HeightMap, ( ( appendResult27_g69 * appendResult21_g69 * temp_output_29_0_g69 ) + temp_output_65_0_g69 ) ) ) + ( projNormal10_g69.y * tex2D( _HeightMap, ( ( temp_output_29_0_g69 * appendResult32_g69 * appendResult22_g69 ) + temp_output_65_0_g69 ) ) ) + ( projNormal10_g69.z * tex2D( _HeightMap, ( temp_output_65_0_g69 + ( temp_output_29_0_g69 * appendResult34_g69 * appendResult25_g69 ) ) ) ) ) ).r * _HeightDetail ) ) ) );
			float temp_output_2_0_g71 = saturate( ( _LavaFactorsX - _LavaDetail ) );
			float detaledHeight01178 = saturate( saturate( ( ( detaledHeight167 - temp_output_2_0_g71 ) / ( saturate( ( _LavaFactorsY - _LavaDetail ) ) - temp_output_2_0_g71 ) ) ) );
			float temp_output_6_0_g78 = ( detaledHeight01178 / _LavaFactorsZ );
			float3 lerpResult8_g78 = lerp( _LavaLow.rgb , _LavaMid.rgb , saturate( temp_output_6_0_g78 ));
			float3 lerpResult12_g78 = lerp( lerpResult8_g78 , _LavaHigh.rgb , saturate( ( temp_output_6_0_g78 - 1.0 ) ));
			s185.Albedo = lerpResult12_g78;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 triplanar193 = TriplanarSampling193( _NormalMap, ase_vertex3Pos, ase_vertexNormal, 1.0, _NormalTiling, 1.0, 0 );
			float3 normalUnpacked196 = UnpackScaleNormal( triplanar193, _NormalScale );
			s185.Normal = WorldNormalVector( i , normalUnpacked196 );
			s185.Emission = float3( 0,0,0 );
			s185.Specular = saturate( ( detailTex146 * _Specular * _SpecularColor * _SpecularBoost ) ).rgb;
			s185.Smoothness = ( ( 1.0 - detailTex146 ) * _Smoothness );
			s185.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi185 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g185 = UnityGlossyEnvironmentSetup( s185.Smoothness, data.worldViewDir, s185.Normal, float3(0,0,0));
			gi185 = UnityGlobalIllumination( data, s185.Occlusion, s185.Normal, g185 );
			#endif

			float3 surfResult185 = LightingStandardSpecular ( s185, viewDir, gi185 ).rgb;
			surfResult185 += s185.Emission;

			#ifdef UNITY_PASS_FORWARDADD//185
			surfResult185 -= s185.Emission;
			#endif//185
			float3 baseColor213 = surfResult185;
			SurfaceOutputStandard s283 = (SurfaceOutputStandard ) 0;
			float3 temp_cast_9 = (1.0).xxx;
			s283.Albedo = temp_cast_9;
			s283.Normal = WorldNormalVector( i , normalUnpacked196 );
			s283.Emission = float3( 0,0,0 );
			s283.Metallic = 0.0;
			s283.Smoothness = 0.0;
			s283.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi283 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g283 = UnityGlossyEnvironmentSetup( s283.Smoothness, data.worldViewDir, s283.Normal, float3(0,0,0));
			gi283 = UnityGlobalIllumination( data, s283.Occlusion, s283.Normal, g283 );
			#endif

			float3 surfResult283 = LightingStandard ( s283, viewDir, gi283 ).rgb;
			surfResult283 += s283.Emission;

			#ifdef UNITY_PASS_FORWARDADD//283
			surfResult283 -= s283.Emission;
			#endif//283
			float3 normalizeResult5_g77 = normalize( normalUnpacked196 );
			float dotResult14_g77 = dot( i.viewDir , normalizeResult5_g77 );
			float detailX235 = break138.r;
			float4 fresnel268 = saturate( ( ( ( saturate( pow( saturate( ( 1.0 - dotResult14_g77 ) ) , _FresnelPower ) ) * _FrenselMult ) * _FresnelColor ) * detailX235 ) );
			float4 appendResult63_g85 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g85 = mul( unity_WorldToObject, appendResult63_g85 );
			float4 temp_cast_11 = (5.0).xxxx;
			float4 temp_output_4_0_g85 = pow( abs( temp_output_57_0_g85 ) , temp_cast_11 );
			float4 break6_g85 = temp_output_4_0_g85;
			float4 projNormal10_g85 = ( temp_output_4_0_g85 / ( break6_g85.x + break6_g85.y + break6_g85.z ) );
			float4 appendResult62_g85 = (float4(ase_worldPos , 1.0));
			float4 break26_g85 = mul( unity_WorldToObject, appendResult62_g85 );
			float2 appendResult27_g85 = (float2(break26_g85.z , break26_g85.y));
			float4 nSign18_g85 = sign( temp_output_57_0_g85 );
			float4 break20_g85 = nSign18_g85;
			float2 appendResult21_g85 = (float2(break20_g85.x , 1.0));
			float temp_output_29_0_g85 = _DistortionTiling;
			float temp_output_10_0_g84 = ( _Time.y * _DistortionSpeed );
			float2 appendResult12_g84 = (float2(temp_output_10_0_g84 , temp_output_10_0_g84));
			float4 appendResult63_g86 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g86 = mul( unity_WorldToObject, appendResult63_g86 );
			float4 temp_cast_12 = (5.0).xxxx;
			float4 temp_output_4_0_g86 = pow( abs( temp_output_57_0_g86 ) , temp_cast_12 );
			float4 break6_g86 = temp_output_4_0_g86;
			float4 projNormal10_g86 = ( temp_output_4_0_g86 / ( break6_g86.x + break6_g86.y + break6_g86.z ) );
			float4 appendResult62_g86 = (float4(ase_worldPos , 1.0));
			float4 break26_g86 = mul( unity_WorldToObject, appendResult62_g86 );
			float2 appendResult27_g86 = (float2(break26_g86.z , break26_g86.y));
			float4 nSign18_g86 = sign( temp_output_57_0_g86 );
			float4 break20_g86 = nSign18_g86;
			float2 appendResult21_g86 = (float2(break20_g86.x , 1.0));
			float temp_output_29_0_g86 = _DistortionUVTiling;
			float temp_output_2_0_g84 = ( _Time.y * _DistortionUVSpeed );
			float2 appendResult5_g84 = (float2(temp_output_2_0_g84 , temp_output_2_0_g84));
			float2 temp_output_65_0_g86 = appendResult5_g84;
			float2 appendResult32_g86 = (float2(break26_g86.x , break26_g86.z));
			float2 appendResult22_g86 = (float2(break20_g86.y , 1.0));
			float2 appendResult34_g86 = (float2(break26_g86.x , break26_g86.y));
			float2 appendResult25_g86 = (float2(-break20_g86.z , 1.0));
			float4 break11_g84 = ( saturate( ( ( projNormal10_g86.x * tex2D( _DistortionMap, ( ( appendResult27_g86 * appendResult21_g86 * temp_output_29_0_g86 ) + temp_output_65_0_g86 ) ) ) + ( projNormal10_g86.y * tex2D( _DistortionMap, ( ( temp_output_29_0_g86 * appendResult32_g86 * appendResult22_g86 ) + temp_output_65_0_g86 ) ) ) + ( projNormal10_g86.z * tex2D( _DistortionMap, ( temp_output_65_0_g86 + ( temp_output_29_0_g86 * appendResult34_g86 * appendResult25_g86 ) ) ) ) ) ) * _DistortionFactor );
			float2 appendResult13_g84 = (float2(break11_g84.r , break11_g84.g));
			float2 temp_output_65_0_g85 = ( appendResult12_g84 + appendResult13_g84 );
			float2 appendResult32_g85 = (float2(break26_g85.x , break26_g85.z));
			float2 appendResult22_g85 = (float2(break20_g85.y , 1.0));
			float2 appendResult34_g85 = (float2(break26_g85.x , break26_g85.y));
			float2 appendResult25_g85 = (float2(-break20_g85.z , 1.0));
			float4 appendResult63_g70 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g70 = mul( unity_WorldToObject, appendResult63_g70 );
			float4 temp_cast_13 = (5.0).xxxx;
			float4 temp_output_4_0_g70 = pow( abs( temp_output_57_0_g70 ) , temp_cast_13 );
			float4 break6_g70 = temp_output_4_0_g70;
			float4 projNormal10_g70 = ( temp_output_4_0_g70 / ( break6_g70.x + break6_g70.y + break6_g70.z ) );
			float4 appendResult62_g70 = (float4(ase_worldPos , 1.0));
			float4 break26_g70 = mul( unity_WorldToObject, appendResult62_g70 );
			float2 appendResult27_g70 = (float2(break26_g70.z , break26_g70.y));
			float4 nSign18_g70 = sign( temp_output_57_0_g70 );
			float4 break20_g70 = nSign18_g70;
			float2 appendResult21_g70 = (float2(break20_g70.x , 1.0));
			float temp_output_29_0_g70 = _MagmaTiling;
			float2 temp_output_65_0_g70 = float2( 0,0 );
			float2 appendResult32_g70 = (float2(break26_g70.x , break26_g70.z));
			float2 appendResult22_g70 = (float2(break20_g70.y , 1.0));
			float2 appendResult34_g70 = (float2(break26_g70.x , break26_g70.y));
			float2 appendResult25_g70 = (float2(-break20_g70.z , 1.0));
			float4 temp_output_214_0 = saturate( ( ( projNormal10_g70.x * tex2D( _MagmaMap, ( ( appendResult27_g70 * appendResult21_g70 * temp_output_29_0_g70 ) + temp_output_65_0_g70 ) ) ) + ( projNormal10_g70.y * tex2D( _MagmaMap, ( ( temp_output_29_0_g70 * appendResult32_g70 * appendResult22_g70 ) + temp_output_65_0_g70 ) ) ) + ( projNormal10_g70.z * tex2D( _MagmaMap, ( temp_output_65_0_g70 + ( temp_output_29_0_g70 * appendResult34_g70 * appendResult25_g70 ) ) ) ) ) );
			float4 temp_cast_14 = (_MagmaPower).xxxx;
			float4 magmaDetial234 = saturate( ( saturate( pow( temp_output_214_0 , temp_cast_14 ) ) * _MagmaBoost * temp_output_214_0 ) );
			float4 appendResult63_g68 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g68 = mul( unity_WorldToObject, appendResult63_g68 );
			float4 temp_cast_15 = (2.0).xxxx;
			float4 temp_output_4_0_g68 = pow( abs( temp_output_57_0_g68 ) , temp_cast_15 );
			float4 break6_g68 = temp_output_4_0_g68;
			float4 projNormal10_g68 = ( temp_output_4_0_g68 / ( break6_g68.x + break6_g68.y + break6_g68.z ) );
			float4 appendResult62_g68 = (float4(ase_worldPos , 1.0));
			float4 break26_g68 = mul( unity_WorldToObject, appendResult62_g68 );
			float2 appendResult27_g68 = (float2(break26_g68.z , break26_g68.y));
			float4 nSign18_g68 = sign( temp_output_57_0_g68 );
			float4 break20_g68 = nSign18_g68;
			float2 appendResult21_g68 = (float2(break20_g68.x , 1.0));
			float temp_output_29_0_g68 = _LavaMaskTiling;
			float2 temp_output_65_0_g68 = float2( 0,0 );
			float2 appendResult32_g68 = (float2(break26_g68.x , break26_g68.z));
			float2 appendResult22_g68 = (float2(break20_g68.y , 1.0));
			float2 appendResult34_g68 = (float2(break26_g68.x , break26_g68.y));
			float2 appendResult25_g68 = (float2(-break20_g68.z , 1.0));
			float lavaMaskMap229 = saturate( ( ( projNormal10_g68.x * tex2D( _HeightMap, ( ( appendResult27_g68 * appendResult21_g68 * temp_output_29_0_g68 ) + temp_output_65_0_g68 ) ) ) + ( projNormal10_g68.y * tex2D( _HeightMap, ( ( temp_output_29_0_g68 * appendResult32_g68 * appendResult22_g68 ) + temp_output_65_0_g68 ) ) ) + ( projNormal10_g68.z * tex2D( _HeightMap, ( temp_output_65_0_g68 + ( temp_output_29_0_g68 * appendResult34_g68 * appendResult25_g68 ) ) ) ) ) ).r;
			float dotResult254 = dot( i.viewDir , normalUnpacked196 );
			float lavaMask272 = saturate( ( magmaDetial234.r + ( saturate( ( saturate( pow( saturate( ( 1.0 - lavaMaskMap229 ) ) , _LavaMaskFactorsX ) ) * _LavaMaskFactorsY ) ) * saturate( ( saturate( pow( dotResult254 , _LavaMaskPower ) ) * _LavaMaskBoost ) ) ) ) );
			float4 lerpResult274 = lerp( _MagmaColorMin , _MagmaColorMax , lavaMask272);
			float4 lavaColor277 = ( saturate( ( ( projNormal10_g85.x * tex2D( _DistortionMap, ( ( appendResult27_g85 * appendResult21_g85 * temp_output_29_0_g85 ) + temp_output_65_0_g85 ) ) ) + ( projNormal10_g85.y * tex2D( _DistortionMap, ( ( temp_output_29_0_g85 * appendResult32_g85 * appendResult22_g85 ) + temp_output_65_0_g85 ) ) ) + ( projNormal10_g85.z * tex2D( _DistortionMap, ( temp_output_65_0_g85 + ( temp_output_29_0_g85 * appendResult34_g85 * appendResult25_g85 ) ) ) ) ) ) * lerpResult274 * _MagmaGlow );
			c.rgb = ( saturate( ( saturate( ( saturate( ( saturate( ( tex2D( _ScatterMap, ( ( _ScatterCenterShift + appendResult10_g88 ) * _ScatterStretch ) ) * _ScatterColor * ase_lightColor ) ) * _ScatterBoost ) ) + _ScatterIndirect ) ) * ( float4( baseColor213 , 0.0 ) + ( float4( surfResult283 , 0.0 ) * fresnel268 ) ) ) ) + ( ( lavaColor277 * lavaMask272 ) * float4( saturate( ( _LavaPasstrough + surfResult283 ) ) , 0.0 ) ) ).rgb;
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
-1763;45;1589;922;718.1249;1183.808;1.687434;True;True
Node;AmplifyShaderEditor.RangedFloatNode;133;-492.5569,-703.8184;Float;False;Property;_DetailTiling;Detail Tiling;14;0;Create;True;0;0;0;False;0;False;2;2.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;132;-497.3967,-907.0871;Float;True;Property;_DetailMap;Detail Map;8;0;Create;True;0;0;0;False;0;False;None;7bfa2038811711f43b9b2a102f5b9ef7;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;136;-212.9422,-903.2474;Inherit;False;Triplanar;-1;;67;61abc9e6202a1a94ab1548c8ccbc2e48;0;4;36;SAMPLER2D;0.0;False;29;FLOAT;0;False;2;FLOAT;5;False;65;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-474.9816,-180.0085;Float;False;Property;_LavaMaskTiling;Lava Mask Tiling;16;0;Create;True;0;0;0;False;0;False;2;1.29;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;142;-489.3993,-518.8726;Float;True;Property;_HeightMap;Height Map;0;0;Create;True;0;0;0;False;0;False;None;33a772a7be45592459471ef3fcbd4e47;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.BreakToComponentsNode;138;59.69622,-901.6342;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;226;-212.4865,-231.9746;Inherit;False;Triplanar;-1;;68;61abc9e6202a1a94ab1548c8ccbc2e48;0;4;36;SAMPLER2D;0.0;False;29;FLOAT;0;False;2;FLOAT;2;False;65;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;192;-92.37891,20.9383;Float;True;Property;_NormalMap;Normal Map;10;0;Create;True;0;0;0;False;0;False;None;60ed4462d9c7b96499eb1a4ed5db49bf;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;191;-91.8899,221.7792;Float;False;Property;_NormalTiling;Normal Tiling;12;0;Create;True;0;0;0;False;0;False;0;3.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;193;167.8278,24.54628;Inherit;True;Spherical;Object;False;Top Texture 2;_TopTexture2;white;0;None;Mid Texture 2;_MidTexture2;white;0;None;Bot Texture 2;_BotTexture2;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;194;346.3918,228.5305;Float;False;Property;_NormalScale;Normal Scale;11;0;Create;True;0;0;0;False;0;False;0;-1.22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;228;52.67383,-229.3097;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;163;184.1019,-1057.288;Float;False;Property;_DetailExp;Detail Exp;28;0;Create;True;0;0;0;False;0;False;0;0.87;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;326.6007,-903.8726;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;3189.567,922.8467;Float;False;Property;_MagmaTiling;Magma Tiling;15;0;Create;True;0;0;0;False;0;False;2;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;134;518.6178,-903.6335;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;166;459.7019,-1127.488;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;5000;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;215;3184.727,719.5782;Float;True;Property;_MagmaMap;Magma Map;9;0;Create;True;0;0;0;False;0;False;None;efa7c5cd9a6811d44b8c94c3c331201a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.UnpackScaleNormalNode;195;597.0527,25.46639;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;143;-471.3993,-325.8726;Float;False;Property;_HeightTiling;Height Tiling;13;0;Create;True;0;0;0;False;0;False;2;2.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;229;345.8156,-233.3071;Float;False;lavaMaskMap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;244;4029.651,61.21515;Inherit;False;229;lavaMaskMap;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;141;-232.3993,-512.8726;Inherit;False;Triplanar;-1;;69;61abc9e6202a1a94ab1548c8ccbc2e48;0;4;36;SAMPLER2D;0.0;False;29;FLOAT;0;False;2;FLOAT;5;False;65;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;214;3469.181,723.4182;Inherit;False;Triplanar;-1;;70;61abc9e6202a1a94ab1548c8ccbc2e48;0;4;36;SAMPLER2D;0.0;False;29;FLOAT;0;False;2;FLOAT;5;False;65;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;196;872.2377,18.50697;Float;False;normalUnpacked;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;217;3536.454,882.8323;Float;False;Property;_MagmaPower;Magma Power;37;0;Create;True;0;0;0;False;0;False;0;2.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;680.7016,-1063.788;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;1000;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;153;715.0361,-916.0713;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;220;3774.454,722.8323;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;256;4152.658,470.5074;Inherit;False;196;normalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;155;104.1018,-359.1874;Float;False;Property;_HeightDetail;Height Detail;29;0;Create;True;0;0;0;False;0;False;0;0.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;246;4255.617,66.51323;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;255;4187.158,300.0071;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;144;48.60071,-512.8726;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;218;3885.454,825.8323;Float;False;Property;_MagmaBoost;Magma Boost;38;0;Create;True;0;0;0;False;0;False;0;888;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;146;898.4141,-916.097;Float;False;detailTex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;221;3948.454,723.8323;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;249;4341.859,162.3618;Float;False;Property;_LavaMaskFactorsX;Lava Mask Factors X;30;0;Create;True;0;0;0;False;0;False;0;10.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;4432.314,424.4274;Float;False;Property;_LavaMaskPower;Lava Mask Power;32;0;Create;True;0;0;0;False;0;False;0;4.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;247;4429.86,70.3618;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;254;4422.158,305.0071;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;312.1019,-472.2874;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;248;4641.862,74.3618;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;257;4685.317,301.4274;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;157;461.6021,-476.1873;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;147;405.3009,-591.5728;Inherit;False;146;detailTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;4126.454,720.8323;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;225;4370.931,745.8948;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;252;4828.862,75.3618;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;675.631,-375.3737;Float;False;Property;_LavaFactorsX;Lava Factors X;24;0;Create;True;0;0;0;False;0;False;0;0.745;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;671.1091,-296.3696;Float;False;Property;_LavaDetail;Lava Detail;27;0;Create;True;0;0;0;False;0;False;0;0.649;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;259;4731.317,419.4274;Float;False;Property;_LavaMaskBoost;Lava Mask Boost;33;0;Create;True;0;0;0;False;0;False;0;3.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;250;4739.862,170.3618;Float;False;Property;_LavaMaskFactorsY;Lava Mask Factors Y;31;0;Create;True;0;0;0;False;0;False;0;3.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;260;4841.317,301.4274;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;672.3959,-207.8755;Float;False;Property;_LavaFactorsY;Lava Factors Y;25;0;Create;True;0;0;0;False;0;False;0;0.758;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;162;655.302,-585.3875;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;173;966.6312,-357.3737;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;4992.862,80.3618;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;5000.317,301.4274;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;174;969.6312,-244.3735;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;160;819.102,-587.9873;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;234;4620.982,740.1832;Float;False;magmaDetial;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;176;1144.376,-310.1707;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;262;5153.317,302.4274;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;1008.302,-539.8874;Float;False;detaledHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;175;1144.631,-382.3737;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;264;5073.974,-102.2409;Inherit;False;234;magmaDetial;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;253;5151.091,67.45267;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;265;5342.673,-101.9409;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;5347.742,71.1476;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;233;3172.133,1119.562;Inherit;False;196;normalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;169;1323.91,-410.7233;Inherit;False;Linstep;-1;;71;aade3b0317e32b148b41ee41b85032e6;0;3;4;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;235;405.3693,-730.9871;Float;False;detailX;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;200;2082.349,-97.0036;Float;False;Property;_SpecularColor;Specular Color;17;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.6397059,0.4562608,0.4562608,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;205;2040.56,271.9925;Float;False;Property;_SpecularBoost;Specular Boost;20;0;Create;True;0;0;0;False;0;False;0.03;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;198;2088.854,96.48244;Inherit;False;146;detailTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;243;3429.75,1124.092;Inherit;False;Fresnel;40;;77;f8c497a0c2d6d334f8e7138f24a77d5f;0;1;22;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;237;3459.81,1213.339;Inherit;False;235;detailX;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;266;5626.074,47.6591;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;177;1532.91,-414.7233;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;202;2037.349,193.9965;Float;False;Property;_Specular;Specular;18;0;Create;True;0;0;0;False;0;False;0.03;0.326;0.03;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;182;1759.91,63.27673;Float;False;Property;_LavaHigh;Lava High;23;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2499999,0.1992899,0.1764705,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;3702.81,1125.339;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;199;2039.984,353.0802;Float;False;Property;_Smoothness;Smoothness;19;0;Create;True;0;0;0;False;0;False;0;0.921;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;178;1690.91,-427.7233;Float;False;detaledHeight01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;181;1755.91,-112.7233;Float;False;Property;_LavaMid;Lava Mid;22;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2573529,0.003784606,0.003784606,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;2454.349,89.99643;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;212;2445.988,236.0645;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;1728.922,247.0016;Float;False;Property;_LavaFactorsZ;Lava Factors Z;26;0;Create;True;0;0;0;False;0;False;0;0.937;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;180;1751.91,-286.7233;Float;False;Property;_LavaLow;Lava Low;21;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.3088234,0.1362456,0.1362456,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;267;5777.186,39.53471;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;2434.336,9.572575;Inherit;False;196;normalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;272;5944.078,34.66083;Float;False;lavaMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;179;2100.91,-260.7233;Inherit;False;Ramp3;-1;;78;d38b6eed89401a040a9f914ae79b3d2f;0;5;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;5;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;206;2627.449,233.7819;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;269;3886.583,1125.671;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;204;2693.349,107.9964;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;282;6269.269,680.0158;Float;False;Constant;_Float1;Float 1;35;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;273;5872.078,720.6608;Inherit;False;272;lavaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;271;5848.078,544.6608;Float;False;Property;_MagmaColorMax;Magma Color Max;36;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.6397059,0.3424306,0.0940743,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;290;6187.482,753.0476;Inherit;False;196;normalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;270;5843.078,363.6608;Float;False;Property;_MagmaColorMin;Magma Color Min;35;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.5588235,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;268;4061.583,1119.671;Float;False;fresnel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;185;2869.314,37.61211;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CustomStandardSurface;283;6480.07,680.4159;Inherit;False;Metallic;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;274;6193.078,431.6608;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;213;3317.469,34.21539;Float;False;baseColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;288;6547.596,888.4902;Inherit;False;268;fresnel;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;276;6194.116,557.3349;Float;False;Property;_MagmaGlow;Magma Glow;39;0;Create;True;0;0;0;False;0;False;0;1111;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;299;6142.52,346.9752;Inherit;False;TriplanarUVDist;44;;84;01791187aaf871246af28f7438b407d3;0;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;289;6899.482,709.0476;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;6849.969,209.5274;Inherit;False;213;baseColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;292;6436.51,592.8249;Float;False;Property;_LavaPasstrough;Lava Passtrough;34;0;Create;True;0;0;0;False;0;False;0.02;0.05;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;6401.116,346.3349;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;296;7267.51,127.8249;Inherit;False;ScatterColor;1;;87;5984f944e2b849e44aad6ac4d7027dc1;0;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;291;6760.51,597.8249;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;279;6638.116,433.3349;Inherit;False;272;lavaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;281;7302.269,212.0158;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;277;6605.116,345.3349;Float;False;lavaColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;6858.116,342.3349;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;297;7460.51,183.8249;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;293;6898.51,601.8249;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;298;7664.51,189.8249;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;7093.569,342.1158;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;295;7893.51,223.8249;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;8113.301,-18.8024;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;FORGE3D/Planets HD/Lava;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;136;36;132;0
WireConnection;136;29;133;0
WireConnection;138;0;136;0
WireConnection;226;36;142;0
WireConnection;226;29;227;0
WireConnection;193;0;192;0
WireConnection;193;3;191;0
WireConnection;228;0;226;0
WireConnection;139;0;138;0
WireConnection;139;1;138;1
WireConnection;134;0;139;0
WireConnection;134;1;163;0
WireConnection;195;0;193;0
WireConnection;195;1;194;0
WireConnection;229;0;228;0
WireConnection;141;36;142;0
WireConnection;141;29;143;0
WireConnection;214;36;215;0
WireConnection;214;29;216;0
WireConnection;196;0;195;0
WireConnection;164;0;163;0
WireConnection;164;1;134;0
WireConnection;164;2;166;0
WireConnection;153;0;164;0
WireConnection;220;0;214;0
WireConnection;220;1;217;0
WireConnection;246;0;244;0
WireConnection;144;0;141;0
WireConnection;146;0;153;0
WireConnection;221;0;220;0
WireConnection;247;0;246;0
WireConnection;254;0;255;0
WireConnection;254;1;256;0
WireConnection;156;0;144;0
WireConnection;156;1;155;0
WireConnection;248;0;247;0
WireConnection;248;1;249;0
WireConnection;257;0;254;0
WireConnection;257;1;258;0
WireConnection;157;0;156;0
WireConnection;222;0;221;0
WireConnection;222;1;218;0
WireConnection;222;2;214;0
WireConnection;225;0;222;0
WireConnection;252;0;248;0
WireConnection;260;0;257;0
WireConnection;162;0;147;0
WireConnection;162;1;157;0
WireConnection;173;0;171;0
WireConnection;173;1;170;0
WireConnection;251;0;252;0
WireConnection;251;1;250;0
WireConnection;261;0;260;0
WireConnection;261;1;259;0
WireConnection;174;0;172;0
WireConnection;174;1;170;0
WireConnection;160;0;162;0
WireConnection;234;0;225;0
WireConnection;176;0;174;0
WireConnection;262;0;261;0
WireConnection;167;0;160;0
WireConnection;175;0;173;0
WireConnection;253;0;251;0
WireConnection;265;0;264;0
WireConnection;263;0;253;0
WireConnection;263;1;262;0
WireConnection;169;4;167;0
WireConnection;169;2;175;0
WireConnection;169;3;176;0
WireConnection;235;0;138;0
WireConnection;243;22;233;0
WireConnection;266;0;265;0
WireConnection;266;1;263;0
WireConnection;177;0;169;0
WireConnection;236;0;243;0
WireConnection;236;1;237;0
WireConnection;178;0;177;0
WireConnection;203;0;198;0
WireConnection;203;1;202;0
WireConnection;203;2;200;0
WireConnection;203;3;205;0
WireConnection;212;0;198;0
WireConnection;267;0;266;0
WireConnection;272;0;267;0
WireConnection;179;1;180;0
WireConnection;179;2;181;0
WireConnection;179;3;182;0
WireConnection;179;5;184;0
WireConnection;179;4;178;0
WireConnection;206;0;212;0
WireConnection;206;1;199;0
WireConnection;269;0;236;0
WireConnection;204;0;203;0
WireConnection;268;0;269;0
WireConnection;185;0;179;0
WireConnection;185;1;197;0
WireConnection;185;3;204;0
WireConnection;185;4;206;0
WireConnection;283;0;282;0
WireConnection;283;1;290;0
WireConnection;274;0;270;0
WireConnection;274;1;271;0
WireConnection;274;2;273;0
WireConnection;213;0;185;0
WireConnection;289;0;283;0
WireConnection;289;1;288;0
WireConnection;275;0;299;0
WireConnection;275;1;274;0
WireConnection;275;2;276;0
WireConnection;291;0;292;0
WireConnection;291;1;283;0
WireConnection;281;0;280;0
WireConnection;281;1;289;0
WireConnection;277;0;275;0
WireConnection;278;0;277;0
WireConnection;278;1;279;0
WireConnection;297;0;296;0
WireConnection;297;1;281;0
WireConnection;293;0;291;0
WireConnection;298;0;297;0
WireConnection;284;0;278;0
WireConnection;284;1;293;0
WireConnection;295;0;298;0
WireConnection;295;1;284;0
WireConnection;0;13;295;0
ASEEND*/
//CHKSM=C584DCD96C1D35EC94616DE0854882EFE084B5B8