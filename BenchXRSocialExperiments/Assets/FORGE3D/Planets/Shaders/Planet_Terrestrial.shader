// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FORGE3D/Planets HD/Terrestrial"
{
	Properties
	{
		_GlobalBoost("Global Boost", Float) = 1
		_FresnelLandColor("Fresnel Land Color", Color) = (0.4558824,0.4558824,0.4558824,1)
		_FresnelLandPower("Fresnel Land Power", Range( 0.003 , 25)) = 0.003
		_FrenselLandMult("Frensel Land Mult", Range( 0 , 10)) = 0
		_FresnelWaterColor("Fresnel Water Color", Color) = (0.4558824,0.4558824,0.4558824,1)
		_FresnelWaterPower("Fresnel Water Power", Range( 0.003 , 25)) = 0.003
		_FresnelWaterMult("Fresnel Water Mult", Range( 0 , 10)) = 0
		_CityLightMap("City Light Map", 2D) = "white" {}
		_CityLightUVMap("CityLight UV Map", 2D) = "white" {}
		_CityLightMaskMap("CityLight Mask Map", 2D) = "white" {}
		_CityLightColor("CityLight Color", Color) = (0,0,0,0)
		_CityLightPopulation("CityLight Population", Float) = 0
		_ScatterMap("Scatter Map", 2D) = "white" {}
		_ScatterColor("Scatter Color", Color) = (0,0,0,0)
		_ScatterBoost("Scatter Boost", Range( 0 , 5)) = 1
		_ScatterIndirect("Scatter Indirect", Range( 0 , 1)) = 0
		_ScatterStretch("Scatter Stretch", Range( -2 , 2)) = 0
		_ScatterCenterShift("Scatter Center Shift", Range( -2 , 2)) = 0
		_WaterShoreFactor("Water Shore Factor", Float) = 0
		_WaterDetailFactor("Water Detail Factor", Float) = 0
		_WaterDetailBoost("Water Detail Boost", Float) = 0
		_WaterShallowColor("Water Shallow Color", Color) = (0,0,0,0)
		_WaterShoreColor("Water Shore Color", Color) = (0,0,0,0)
		_WaterDeepColor("Water Deep Color", Color) = (0,0,0,0)
		_WaterSpecularColor("Water Specular Color", Color) = (1,1,1,1)
		_WaterSpecular("Water Specular", Range( 0.003 , 1)) = 0.003
		_WaterSmoothness("Water Smoothness", Range( 0 , 1)) = 0
		_LandSpecular("Land Specular", Range( 0.03 , 1)) = 0.03
		_LandSmoothness("Land Smoothness", Range( 0 , 1)) = 0.03
		_NormalMap("Normal Map", 2D) = "white" {}
		_NormalTiling("Normal Tiling", Float) = 0
		_NormalFresnelScale("Normal Fresnel Scale", Float) = 0
		_NormalScale("Normal Scale", Float) = 0
		_HeightMap("Height Map", 2D) = "white" {}
		_HeightTiling("Height Tiling", Float) = 0
		_LandMask("Land Mask", 2D) = "white" {}
		_BaseColor("Base Color", Color) = (0.5220588,0.5220588,0.5220588,0)
		_DesertColor("Desert Color", Color) = (0.4779412,0.4779412,0.4779412,1)
		_DesertCoverage("Desert Coverage", Range( 0 , 1)) = 1
		_DesertFactors("Desert Factors", Range( 0 , 50)) = 0.5
		_VegetationColor("Vegetation Color", Color) = (0.4779412,0.4779412,0.4779412,1)
		_VegetationCoverage("Vegetation Coverage", Range( 0 , 1)) = 1
		_VegetationFactors("Vegetation Factors", Range( 0 , 20)) = 0.5
		_MountainColor("Mountain Color", Color) = (0.4779412,0.4779412,0.4779412,1)
		_MountainCoverage("Mountain Coverage", Range( 0 , 1)) = 1
		_MountainFactors("Mountain Factors", Range( 0 , 50)) = 0.5
		_Gradient("Gradient", 2D) = "white" {}
		_CloudsTop("Clouds Top", 2D) = "white" {}
		_CloudsMiddle("Clouds Middle", 2D) = "white" {}
		_CloudsBlendWeight("Clouds Blend Weight", Range( 0 , 1)) = 0
		_CloudsTopSpeed("Clouds Top Speed", Range( -0.02 , 0.02)) = 0
		_CloudsMiddleSpeed("Clouds Middle Speed", Range( -0.02 , 0.02)) = 0
		_CloudsTint("Clouds Tint", Color) = (0,0,0,0)
		_CloudShadows("Cloud Shadows", Range( 0 , 1)) = 0.03
		_CloudsBoost("Clouds Output", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma exclude_renderers xboxseries playstation switch nomrt 
		#pragma surface surf StandardCustomLighting keepalpha noshadow 
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float2 uv2_texcoord2;
			float2 uv_texcoord;
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
		uniform sampler2D _CloudsTop;
		uniform float4 _CloudsTop_ST;
		uniform float _CloudsTopSpeed;
		uniform sampler2D _CloudsMiddle;
		uniform float4 _CloudsMiddle_ST;
		uniform float _CloudsMiddleSpeed;
		uniform sampler2D _Gradient;
		uniform float4 _Gradient_ST;
		uniform float _CloudsBlendWeight;
		uniform float4 _CloudsTint;
		uniform float _CloudsBoost;
		uniform float _CloudShadows;
		uniform float _GlobalBoost;
		uniform float4 _BaseColor;
		uniform sampler2D _HeightMap;
		uniform float _HeightTiling;
		uniform float4 _DesertColor;
		uniform float _DesertCoverage;
		uniform float _DesertFactors;
		uniform float4 _VegetationColor;
		uniform float _VegetationCoverage;
		uniform float _VegetationFactors;
		uniform float4 _MountainColor;
		uniform float _MountainCoverage;
		uniform float _MountainFactors;
		uniform float4 _WaterShoreColor;
		uniform float4 _WaterDeepColor;
		uniform float4 _WaterShallowColor;
		uniform float _WaterDetailFactor;
		uniform float _WaterDetailBoost;
		uniform sampler2D _LandMask;
		uniform float4 _LandMask_ST;
		uniform float _WaterShoreFactor;
		uniform sampler2D _NormalMap;
		uniform float _NormalTiling;
		uniform float _NormalFresnelScale;
		uniform float _NormalScale;
		uniform float _FresnelLandPower;
		uniform float _FrenselLandMult;
		uniform float4 _FresnelLandColor;
		uniform float _FresnelWaterPower;
		uniform float _FresnelWaterMult;
		uniform float4 _FresnelWaterColor;
		uniform float _LandSpecular;
		uniform float _WaterSpecular;
		uniform float4 _WaterSpecularColor;
		uniform float _LandSmoothness;
		uniform float _WaterSmoothness;
		uniform float4 _CityLightColor;
		uniform sampler2D _CityLightMaskMap;
		uniform float4 _CityLightMaskMap_ST;
		uniform sampler2D _CityLightMap;
		uniform sampler2D _CityLightUVMap;
		uniform float4 _CityLightUVMap_ST;
		uniform float _CityLightPopulation;


		float2 rotateUV1_g269( float time, float2 uv, float speed )
		{
				
				uv -= 0.5;
				float s = sin ( speed * time );
				float c = cos ( speed * time );
				float2x2 rotationMatrix = float2x2( c, -s, s, c);
				rotationMatrix *= 0.5;
				rotationMatrix += 0.5;
				rotationMatrix = rotationMatrix * 2 - 1;
				uv = mul ( uv, rotationMatrix );
				return uv + 0.5;
		}


		inline float4 TriplanarSampling5( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling51( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float4 transform4_g272 = mul(unity_ObjectToWorld,float4( ase_vertexNormal , 0.0 ));
			float4 normalizeResult6_g272 = normalize( transform4_g272 );
			float3 temp_output_1_0_g273 = normalizeResult6_g272.xyz;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult7_g272 = normalize( ase_worldlightDir );
			float dotResult4_g273 = dot( temp_output_1_0_g273 , normalizeResult7_g272 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult8_g272 = normalize( ase_worldViewDir );
			float dotResult7_g273 = dot( temp_output_1_0_g273 , normalizeResult8_g272 );
			float2 appendResult10_g273 = (float2(( ( dotResult4_g273 / 2.0 ) + 0.5 ) , dotResult7_g273));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			SurfaceOutputStandardSpecular s87 = (SurfaceOutputStandardSpecular ) 0;
			float time1_g269 = _Time.y;
			float2 uv2_CloudsTop = i.uv2_texcoord2 * _CloudsTop_ST.xy + _CloudsTop_ST.zw;
			float2 uv1_g269 = uv2_CloudsTop;
			float speed1_g269 = _CloudsTopSpeed;
			float2 localrotateUV1_g269 = rotateUV1_g269( time1_g269 , uv1_g269 , speed1_g269 );
			float2 poleUV63_g268 = localrotateUV1_g269;
			float cloudPole76_g268 = tex2D( _CloudsTop, poleUV63_g268 ).r;
			float2 uv_CloudsMiddle = i.uv_texcoord * _CloudsMiddle_ST.xy + _CloudsMiddle_ST.zw;
			float2 break53_g268 = uv_CloudsMiddle;
			float2 appendResult55_g268 = (float2(( break53_g268.x + ( _CloudsMiddleSpeed * _Time.y ) ) , break53_g268.y));
			float2 bellyUV56_g268 = appendResult55_g268;
			float cloudBelly73_g268 = tex2D( _CloudsMiddle, bellyUV56_g268 ).r;
			float2 uv_Gradient = i.uv_texcoord * _Gradient_ST.xy + _Gradient_ST.zw;
			float gradientMap93_g268 = pow( tex2D( _Gradient, uv_Gradient ).r , _CloudsBlendWeight );
			float lerpResult25_g268 = lerp( cloudPole76_g268 , cloudBelly73_g268 , gradientMap93_g268);
			float cloudMix80_g268 = lerpResult25_g268;
			float4 temp_output_96_0 = saturate( ( cloudMix80_g268 * _CloudsTint * _CloudsBoost ) );
			s87.Albedo = temp_output_96_0.rgb;
			s87.Normal = ase_worldNormal;
			s87.Emission = float3( 0,0,0 );
			float4 temp_cast_3 = (0.003).xxxx;
			s87.Specular = max( temp_output_96_0 , temp_cast_3 ).rgb;
			s87.Smoothness = 0.0;
			s87.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi87 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g87 = UnityGlossyEnvironmentSetup( s87.Smoothness, data.worldViewDir, s87.Normal, float3(0,0,0));
			gi87 = UnityGlobalIllumination( data, s87.Occlusion, s87.Normal, g87 );
			#endif

			float3 surfResult87 = LightingStandardSpecular ( s87, viewDir, gi87 ).rgb;
			surfResult87 += s87.Emission;

			#ifdef UNITY_PASS_FORWARDADD//87
			surfResult87 -= s87.Emission;
			#endif//87
			SurfaceOutputStandardSpecular s26 = (SurfaceOutputStandardSpecular ) 0;
			float2 shadowUVPole47_g268 = (( 0.005 * ase_worldlightDir )).xx;
			float cloudPoleShadow94_g268 = tex2D( _CloudsTop, ( poleUV63_g268 + shadowUVPole47_g268 ) ).r;
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 normalizeResult36_g268 = normalize( mul( ase_worldToTangent, ase_worldlightDir ) );
			float2 shadowUVBelly46_g268 = (( normalizeResult36_g268 * 0.005 )).xx;
			float cloudBellyShadow85_g268 = tex2D( _CloudsMiddle, ( shadowUVBelly46_g268 + bellyUV56_g268 ) ).r;
			float lerpResult95_g268 = lerp( cloudPoleShadow94_g268 , cloudBellyShadow85_g268 , ( gradientMap93_g268 + 0.1 ));
			float cloudMixShadow99_g268 = saturate( pow( ( 1.0 - lerpResult95_g268 ) , ( _CloudShadows * 50.0 ) ) );
			float temp_output_96_122 = cloudMixShadow99_g268;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 triplanar5 = TriplanarSampling5( _HeightMap, ase_vertex3Pos, ase_vertexNormal, 5.0, _HeightTiling, 1.0, 0 );
			float4 height6 = triplanar5;
			float4 break16 = height6;
			float temp_output_10_0_g19 = break16.z;
			float lerpResult16_g19 = lerp( 0.0 , 1.0 , ( ( _DesertCoverage - ( break16.x * temp_output_10_0_g19 ) ) * _DesertFactors ));
			float4 lerpResult19_g19 = lerp( float4( ( _BaseColor * height6.x ).rgb , 0.0 ) , ( _DesertColor * temp_output_10_0_g19 ) , saturate( lerpResult16_g19 ));
			float lerpResult16_g232 = lerp( 0.0 , 1.0 , ( ( _VegetationCoverage - ( break16.x * break16.z ) ) * _VegetationFactors ));
			float4 lerpResult19_g232 = lerp( float4( saturate( lerpResult19_g19 ).rgb , 0.0 ) , ( _VegetationColor * break16.y ) , saturate( lerpResult16_g232 ));
			float lerpResult16_g233 = lerp( 0.0 , 1.0 , ( ( _MountainCoverage - break16.z ) * _MountainFactors ));
			float4 lerpResult19_g233 = lerp( float4( saturate( lerpResult19_g232 ).rgb , 0.0 ) , ( break16.x * _MountainColor ) , saturate( lerpResult16_g233 ));
			float4 temp_output_15_0 = saturate( lerpResult19_g233 );
			float4 break22 = height6;
			float depth11_g236 = saturate( ( pow( ( break22.x * break22.z ) , _WaterDetailFactor ) * _WaterDetailBoost ) );
			float4 lerpResult19_g236 = lerp( _WaterDeepColor , _WaterShallowColor , depth11_g236);
			float2 uv_LandMask = i.uv_texcoord * _LandMask_ST.xy + _LandMask_ST.zw;
			float4 tex2DNode2 = tex2D( _LandMask, uv_LandMask );
			float shoreMask16_g236 = saturate( pow( tex2DNode2.g , _WaterShoreFactor ) );
			float4 lerpResult23_g236 = lerp( ( _WaterShoreColor + lerpResult19_g236 ) , lerpResult19_g236 , shoreMask16_g236);
			float4 waterColor25_g236 = lerpResult23_g236;
			float4 lerpResult27_g236 = lerp( float4( temp_output_15_0.rgb , 0.0 ) , waterColor25_g236 , tex2DNode2.r);
			float4 triplanar51 = TriplanarSampling51( _NormalMap, ase_vertex3Pos, ase_vertexNormal, 5.0, _NormalTiling, 1.0, 0 );
			float3 fresnelNormalUnpacked73 = UnpackScaleNormal( triplanar51, _NormalFresnelScale );
			float3 normalUnpacked54 = UnpackScaleNormal( triplanar51, _NormalScale );
			float3 lerpResult80 = lerp( fresnelNormalUnpacked73 , normalUnpacked54 , tex2DNode2.r);
			float3 normalizeResult5_g267 = normalize( lerpResult80 );
			float dotResult14_g267 = dot( i.viewDir , normalizeResult5_g267 );
			float temp_output_15_0_g267 = saturate( ( 1.0 - dotResult14_g267 ) );
			float4 lerpResult32_g267 = lerp( ( ( saturate( pow( temp_output_15_0_g267 , _FresnelLandPower ) ) * _FrenselLandMult ) * _FresnelLandColor ) , ( ( saturate( pow( temp_output_15_0_g267 , _FresnelWaterPower ) ) * _FresnelWaterMult ) * _FresnelWaterColor ) , tex2DNode2.r);
			s26.Albedo = ( temp_output_96_122 * saturate( ( saturate( ( _GlobalBoost * lerpResult27_g236 ) ) + saturate( ( float4( ase_lightColor.rgb , 0.0 ) * lerpResult32_g267 ) ) ) ) ).rgb;
			float4 normalizeResult60 = normalize( float4(0,0,1,0) );
			float4 lerpResult66 = lerp( float4( normalUnpacked54 , 0.0 ) , normalizeResult60 , tex2DNode2.r);
			s26.Normal = WorldNormalVector( i , lerpResult66.xyz );
			s26.Emission = float3( 0,0,0 );
			float4 lerpResult47 = lerp( ( temp_output_15_0 * _LandSpecular ) , saturate( ( _WaterSpecular * ( depth11_g236 + 0.1 ) * _WaterSpecularColor ) ) , tex2DNode2.r);
			s26.Specular = lerpResult47.rgb;
			float lerpResult48 = lerp( ( _LandSmoothness * ( break16.x + break16.y + break16.z ) ) , _WaterSmoothness , tex2DNode2.r);
			s26.Smoothness = ( temp_output_96_122 * saturate( lerpResult48 ) );
			s26.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi26 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g26 = UnityGlossyEnvironmentSetup( s26.Smoothness, data.worldViewDir, s26.Normal, float3(0,0,0));
			gi26 = UnityGlobalIllumination( data, s26.Occlusion, s26.Normal, g26 );
			#endif

			float3 surfResult26 = LightingStandardSpecular ( s26, viewDir, gi26 ).rgb;
			surfResult26 += s26.Emission;

			#ifdef UNITY_PASS_FORWARDADD//26
			surfResult26 -= s26.Emission;
			#endif//26
			float2 uv_CityLightMaskMap = i.uv_texcoord * _CityLightMaskMap_ST.xy + _CityLightMaskMap_ST.zw;
			float mask19_g270 = tex2D( _CityLightMaskMap, uv_CityLightMaskMap ).r;
			float2 uv_CityLightUVMap = i.uv_texcoord * _CityLightUVMap_ST.xy + _CityLightUVMap_ST.zw;
			float4 tex2DNode12_g270 = tex2D( _CityLightUVMap, uv_CityLightUVMap );
			float2 appendResult20_g270 = (float2(tex2DNode12_g270.r , tex2DNode12_g270.g));
			float2 detailUV21_g270 = appendResult20_g270;
			float cityLightMap24_g270 = ( mask19_g270 * tex2D( _CityLightMap, detailUV21_g270 ).r );
			float3 lerpResult5_g271 = lerp( _WorldSpaceLightPos0.xyz , ( _WorldSpaceLightPos0.xyz - ase_worldPos ) , _WorldSpaceLightPos0.w);
			float3 normalizeResult6_g271 = normalize( lerpResult5_g271 );
			float dotResult1_g271 = dot( normalizeResult6_g271 , ase_worldNormal );
			float temp_output_30_0_g270 = ( 1.0 - saturate( ( dotResult1_g271 * ase_lightAtten ) ) );
			c.rgb = saturate( ( saturate( ( saturate( ( saturate( ( tex2D( _ScatterMap, ( ( _ScatterCenterShift + appendResult10_g273 ) * _ScatterStretch ) ) * _ScatterColor * ase_lightColor ) ) * _ScatterBoost ) ) + _ScatterIndirect ) ) * saturate( ( float4( saturate( ( surfResult87 * 5.0 ) ) , 0.0 ) + float4( surfResult26 , 0.0 ) + ( _CityLightColor * pow( cityLightMap24_g270 , ( 1.0 / _CityLightPopulation ) ) * ( 1.0 - tex2DNode2.r ) * saturate( ( temp_output_30_0_g270 * temp_output_30_0_g270 * temp_output_30_0_g270 * temp_output_30_0_g270 ) ) ) ) ) ) ).rgb;
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
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
-1763;45;1589;922;1868.14;405.1682;1;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1584.791,-395.6999;Float;True;Property;_HeightMap;Height Map;37;0;Create;True;0;0;0;False;0;False;None;a01e51192e20ad542bf77849171a65d9;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;4;-1576.536,-178.1983;Float;False;Property;_HeightTiling;Height Tiling;38;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;5;-1322.935,-292.2925;Inherit;True;Spherical;Object;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;0;None;Bot Texture 0;_BotTexture0;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-945.5557,-295.0933;Float;False;height;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1577.052,283.4705;Float;False;Property;_NormalTiling;Normal Tiling;34;0;Create;True;0;0;0;False;0;False;0;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;49;-1585.307,65.96893;Float;True;Property;_NormalMap;Normal Map;33;0;Create;True;0;0;0;False;0;False;None;3c13bc84830f236458594e2f6cc9c04a;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;1;-677.4996,-291.3;Inherit;False;BaseColor;40;;18;436e5fd3b4e5f564d91908d8a8c53f20;0;1;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;16;-710.702,-106.6947;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;17;-375.2998,-241.896;Inherit;False;DesertColor;42;;19;1b595ba52fc886e48b4be4810312f928;0;3;3;FLOAT;0;False;10;FLOAT;0;False;6;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TriplanarNode;51;-1323.452,169.3763;Inherit;True;Spherical;Object;False;Top Texture 1;_TopTexture1;white;0;None;Mid Texture 1;_MidTexture1;white;0;None;Bot Texture 1;_BotTexture1;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-1237.554,391.696;Float;False;Property;_NormalScale;Normal Scale;36;0;Create;True;0;0;0;False;0;False;0;-0.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-1233.957,479.2798;Float;False;Property;_NormalFresnelScale;Normal Fresnel Scale;35;0;Create;True;0;0;0;False;0;False;0;3.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;71;-915.9163,331.573;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;13;-51.60282,-171.6952;Inherit;False;VegetationColor;46;;232;7b054f74514e3c545b05ee9d3cc768b8;0;4;23;FLOAT;0;False;10;FLOAT;0;False;3;FLOAT;0;False;6;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;70.30082,-489.5881;Inherit;False;6;height;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;52;-921.5544,168.696;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-649.0061,163.0985;Float;False;normalUnpacked;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-634.9438,326.6002;Float;False;fresnelNormalUnpacked;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;2;233.8507,-327.3218;Inherit;True;Property;_LandMask;Land Mask;39;0;Create;True;0;0;0;False;0;False;-1;None;1744fab73973e9347836cd337c5a59d6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;22;282.4919,-484.8134;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.FunctionNode;15;240.8973,-79.39526;Inherit;False;MountainColor;50;;233;4181dbe52ccd82c468b472a633e7f96c;0;3;3;FLOAT;0;False;10;FLOAT;0;False;6;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;43;587.622,-403.2938;Inherit;False;Water;21;;236;e187dfe8b39989f44abd5e4c0deac419;0;5;4;FLOAT;0;False;3;FLOAT;0;False;26;FLOAT;0;False;12;FLOAT;0;False;1;FLOAT3;0,0,0;False;3;COLOR;0;COLOR;28;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;55;862.8409,259.8816;Inherit;False;54;normalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;126;740.366,-503.9382;Float;False;Property;_GlobalBoost;Global Boost;0;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;857.3555,583.1948;Inherit;False;73;fresnelNormalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;45;227.1252,145.1049;Float;False;Property;_LandSmoothness;Land Smoothness;32;0;Create;True;0;0;0;False;0;False;0.03;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;80;1198.739,499.9872;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;44.43475,188.9308;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;924.366,-489.9382;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;84;1289.949,-594.1465;Float;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;0;False;0;False;0.003;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;500.7089,169.5665;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;129;1049.029,-256.8683;Inherit;False;FresnelLandWater;1;;267;3e95808d42a13c34980842be780f16a4;0;2;24;FLOAT;0;False;22;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;127;1127.366,-474.9382;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;96;1242.731,-733.9436;Inherit;False;Clouds;54;;268;b41fa152b94c44b4e9f91f67316d221d;0;0;2;FLOAT;122;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;131;745.1375,329.4932;Float;False;Constant;_Vector0;Vector 0;19;0;Create;True;0;0;0;False;0;False;0,0,1,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;86;1573.95,-642.1465;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;227.1252,48.10492;Float;False;Property;_LandSpecular;Land Specular;31;0;Create;True;0;0;0;False;0;False;0.03;1;0.03;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;1370.123,-319.8434;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;48;924.1252,106.1049;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;87;1749.852,-713.3472;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;95;1222.357,46.49732;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;76;1522.043,-315.7202;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;60;946.5662,333.408;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;88;1829.852,-491.3471;Float;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;594.1252,-54.89508;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;47;909.1252,-55.89508;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;1535.255,-229.4215;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;2025.85,-664.3472;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;66;1196.843,341.7189;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;1762.817,-337.5131;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;26;2115.369,-321.7584;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;90;2181.849,-659.3472;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;125;1997.639,-90.1441;Inherit;False;CityLights;8;;270;4cc89f4a87600d74dbfda0723672d233;0;1;17;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;2318.849,-442.347;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;97;2339.639,-537.1441;Inherit;False;ScatterColor;14;;272;5984f944e2b849e44aad6ac4d7027dc1;0;0;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;99;2483.639,-442.1441;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;2723.639,-484.1441;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;94;2939.995,-480.805;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;635.043,-208.7202;Inherit;False;73;fresnelNormalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3130.129,-725.0769;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;FORGE3D/Planets HD/Terrestrial;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;5;3;4;0
WireConnection;6;0;5;0
WireConnection;1;1;6;0
WireConnection;16;0;6;0
WireConnection;17;3;16;0
WireConnection;17;10;16;2
WireConnection;17;6;1;0
WireConnection;51;0;49;0
WireConnection;51;3;50;0
WireConnection;71;0;51;0
WireConnection;71;1;74;0
WireConnection;13;23;16;0
WireConnection;13;10;16;1
WireConnection;13;3;16;2
WireConnection;13;6;17;0
WireConnection;52;0;51;0
WireConnection;52;1;53;0
WireConnection;54;0;52;0
WireConnection;73;0;71;0
WireConnection;22;0;23;0
WireConnection;15;3;16;0
WireConnection;15;10;16;2
WireConnection;15;6;13;0
WireConnection;43;4;22;0
WireConnection;43;3;22;2
WireConnection;43;26;2;1
WireConnection;43;12;2;2
WireConnection;43;1;15;0
WireConnection;80;0;81;0
WireConnection;80;1;55;0
WireConnection;80;2;2;1
WireConnection;68;0;16;0
WireConnection;68;1;16;1
WireConnection;68;2;16;2
WireConnection;128;0;126;0
WireConnection;128;1;43;0
WireConnection;67;0;45;0
WireConnection;67;1;68;0
WireConnection;129;24;2;1
WireConnection;129;22;80;0
WireConnection;127;0;128;0
WireConnection;86;0;96;0
WireConnection;86;1;84;0
WireConnection;70;0;127;0
WireConnection;70;1;129;0
WireConnection;48;0;67;0
WireConnection;48;1;43;35
WireConnection;48;2;2;1
WireConnection;87;0;96;0
WireConnection;87;3;86;0
WireConnection;95;0;48;0
WireConnection;76;0;70;0
WireConnection;60;0;131;0
WireConnection;46;0;15;0
WireConnection;46;1;44;0
WireConnection;47;0;46;0
WireConnection;47;1;43;28
WireConnection;47;2;2;1
WireConnection;93;0;96;122
WireConnection;93;1;95;0
WireConnection;89;0;87;0
WireConnection;89;1;88;0
WireConnection;66;0;55;0
WireConnection;66;1;60;0
WireConnection;66;2;2;1
WireConnection;92;0;96;122
WireConnection;92;1;76;0
WireConnection;26;0;92;0
WireConnection;26;1;66;0
WireConnection;26;3;47;0
WireConnection;26;4;93;0
WireConnection;90;0;89;0
WireConnection;125;17;2;1
WireConnection;91;0;90;0
WireConnection;91;1;26;0
WireConnection;91;2;125;0
WireConnection;99;0;91;0
WireConnection;98;0;97;0
WireConnection;98;1;99;0
WireConnection;94;0;98;0
WireConnection;0;13;94;0
ASEEND*/
//CHKSM=8E5A05935165F47B855CC4BD92955A03D73E7736