// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FORGE3D/Planets HD/Sand"
{
	Properties
	{
		_ScatterMap("Scatter Map", 2D) = "white" {}
		_ScatterColor("Scatter Color", Color) = (0,0,0,0)
		_ScatterBoost("Scatter Boost", Range( 0 , 5)) = 1
		_ScatterIndirect("Scatter Indirect", Range( 0 , 1)) = 0
		_ScatterStretch("Scatter Stretch", Range( -2 , 2)) = 0
		_ScatterCenterShift("Scatter Center Shift", Range( -2 , 2)) = 0
		_DetailMap("Detail Map", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "white" {}
		_NormalScale("Normal Scale", Float) = 0
		_NormalTiling("Normal Tiling", Float) = 0
		_DetailTiling("Detail Tiling", Float) = 0
		_SpecularColor("Specular Color", Color) = (0,0,0,0)
		_Specular("Specular", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_CloudBoost("Cloud Boost", Float) = 5
		_BaseColor("Base Color", Color) = (0.5220588,0.5220588,0.5220588,0)
		_DesertColor("Desert Color", Color) = (0.4779412,0.4779412,0.4779412,1)
		_DesertCoverage("Desert Coverage", Range( 0 , 1)) = 1
		_DesertFactors("Desert Factors", Range( 0 , 50)) = 0.5
		_AlbedoBoost("Albedo Boost", Float) = 0
		_MountainColor("Mountain Color", Color) = (0.4779412,0.4779412,0.4779412,1)
		_MountainCoverage("Mountain Coverage", Range( 0 , 1)) = 1
		_MountainFactors("Mountain Factors", Range( 0 , 50)) = 0.5
		_FrenselMult("Frensel Mult", Range( 0 , 10)) = 0
		_FresnelPower("Fresnel Power", Range( 0 , 10)) = 0
		_FresnelColor("Fresnel Color", Color) = (0.4558824,0.4558824,0.4558824,1)
		_Gradient("Gradient", 2D) = "white" {}
		_CloudsTop("Clouds Top", 2D) = "white" {}
		_CloudsMiddle("Clouds Middle", 2D) = "white" {}
		_CloudsBlendWeight("Clouds Blend Weight", Range( 0 , 1)) = 0
		_CloudsTopSpeed("Clouds Top Speed", Range( -0.02 , 0.02)) = 0
		_CloudsMiddleSpeed("Clouds Middle Speed", Range( -0.02 , 0.02)) = 0
		_CloudsTint("Clouds Tint", Color) = (0,0,0,0)
		_CloudShadows("Cloud Shadows", Range( 0 , 1)) = 0.03
		_CloudsBoost("Clouds Output", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
		uniform float _CloudBoost;
		uniform float _CloudShadows;
		uniform float4 _BaseColor;
		uniform sampler2D _DetailMap;
		uniform float _DetailTiling;
		uniform float4 _DesertColor;
		uniform float _DesertCoverage;
		uniform float _DesertFactors;
		uniform float4 _MountainColor;
		uniform float _MountainCoverage;
		uniform float _MountainFactors;
		uniform float _AlbedoBoost;
		uniform sampler2D _NormalMap;
		uniform float _NormalTiling;
		uniform float _NormalScale;
		uniform float _FresnelPower;
		uniform float _FrenselMult;
		uniform float4 _FresnelColor;
		uniform float _Specular;
		uniform float4 _SpecularColor;
		uniform float _Smoothness;


		float2 rotateUV1_g213( float time, float2 uv, float speed )
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


		inline float4 TriplanarSampling17( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float4 transform4_g216 = mul(unity_ObjectToWorld,float4( ase_vertexNormal , 0.0 ));
			float4 normalizeResult6_g216 = normalize( transform4_g216 );
			float3 temp_output_1_0_g217 = normalizeResult6_g216.xyz;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult7_g216 = normalize( ase_worldlightDir );
			float dotResult4_g217 = dot( temp_output_1_0_g217 , normalizeResult7_g216 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult8_g216 = normalize( ase_worldViewDir );
			float dotResult7_g217 = dot( temp_output_1_0_g217 , normalizeResult8_g216 );
			float2 appendResult10_g217 = (float2(( ( dotResult4_g217 / 2.0 ) + 0.5 ) , dotResult7_g217));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			SurfaceOutputStandardSpecular s494 = (SurfaceOutputStandardSpecular ) 0;
			float time1_g213 = _Time.y;
			float2 uv2_CloudsTop = i.uv2_texcoord2 * _CloudsTop_ST.xy + _CloudsTop_ST.zw;
			float2 uv1_g213 = uv2_CloudsTop;
			float speed1_g213 = _CloudsTopSpeed;
			float2 localrotateUV1_g213 = rotateUV1_g213( time1_g213 , uv1_g213 , speed1_g213 );
			float2 poleUV63_g212 = localrotateUV1_g213;
			float cloudPole76_g212 = tex2D( _CloudsTop, poleUV63_g212 ).r;
			float2 uv_CloudsMiddle = i.uv_texcoord * _CloudsMiddle_ST.xy + _CloudsMiddle_ST.zw;
			float2 break53_g212 = uv_CloudsMiddle;
			float2 appendResult55_g212 = (float2(( break53_g212.x + ( _CloudsMiddleSpeed * _Time.y ) ) , break53_g212.y));
			float2 bellyUV56_g212 = appendResult55_g212;
			float cloudBelly73_g212 = tex2D( _CloudsMiddle, bellyUV56_g212 ).r;
			float2 uv_Gradient = i.uv_texcoord * _Gradient_ST.xy + _Gradient_ST.zw;
			float gradientMap93_g212 = pow( tex2D( _Gradient, uv_Gradient ).r , _CloudsBlendWeight );
			float lerpResult25_g212 = lerp( cloudPole76_g212 , cloudBelly73_g212 , gradientMap93_g212);
			float cloudMix80_g212 = lerpResult25_g212;
			float4 temp_output_500_0 = saturate( ( cloudMix80_g212 * _CloudsTint * _CloudsBoost ) );
			s494.Albedo = temp_output_500_0.rgb;
			s494.Normal = ase_worldNormal;
			s494.Emission = float3( 0,0,0 );
			float4 temp_cast_3 = (0.003).xxxx;
			s494.Specular = max( temp_output_500_0 , temp_cast_3 ).rgb;
			s494.Smoothness = 0.0;
			s494.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi494 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g494 = UnityGlossyEnvironmentSetup( s494.Smoothness, data.worldViewDir, s494.Normal, float3(0,0,0));
			gi494 = UnityGlobalIllumination( data, s494.Occlusion, s494.Normal, g494 );
			#endif

			float3 surfResult494 = LightingStandardSpecular ( s494, viewDir, gi494 ).rgb;
			surfResult494 += s494.Emission;

			#ifdef UNITY_PASS_FORWARDADD//494
			surfResult494 -= s494.Emission;
			#endif//494
			SurfaceOutputStandardSpecular s186 = (SurfaceOutputStandardSpecular ) 0;
			float2 shadowUVPole47_g212 = (( 0.005 * ase_worldlightDir )).xx;
			float cloudPoleShadow94_g212 = tex2D( _CloudsTop, ( poleUV63_g212 + shadowUVPole47_g212 ) ).r;
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 normalizeResult36_g212 = normalize( mul( ase_worldToTangent, ase_worldlightDir ) );
			float2 shadowUVBelly46_g212 = (( normalizeResult36_g212 * 0.005 )).xx;
			float cloudBellyShadow85_g212 = tex2D( _CloudsMiddle, ( shadowUVBelly46_g212 + bellyUV56_g212 ) ).r;
			float lerpResult95_g212 = lerp( cloudPoleShadow94_g212 , cloudBellyShadow85_g212 , ( gradientMap93_g212 + 0.1 ));
			float cloudMixShadow99_g212 = saturate( pow( ( 1.0 - lerpResult95_g212 ) , ( _CloudShadows * 50.0 ) ) );
			float temp_output_500_122 = cloudMixShadow99_g212;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 triplanar17 = TriplanarSampling17( _DetailMap, ase_vertex3Pos, ase_vertexNormal, 5.0, _DetailTiling, 1.0, 0 );
			float4 detail41 = triplanar17;
			float4 break253 = detail41;
			float temp_output_10_0_g76 = break253.z;
			float lerpResult16_g76 = lerp( 0.0 , 1.0 , ( ( _DesertCoverage - ( break253.x * temp_output_10_0_g76 ) ) * _DesertFactors ));
			float4 lerpResult19_g76 = lerp( float4( ( _BaseColor * break253.x ).rgb , 0.0 ) , ( _DesertColor * temp_output_10_0_g76 ) , saturate( lerpResult16_g76 ));
			float lerpResult16_g177 = lerp( 0.0 , 1.0 , ( ( _MountainCoverage - break253.y ) * _MountainFactors ));
			float4 lerpResult19_g177 = lerp( float4( saturate( lerpResult19_g76 ).rgb , 0.0 ) , ( break253.x * _MountainColor ) , saturate( lerpResult16_g177 ));
			float4 temp_output_277_0 = saturate( lerpResult19_g177 );
			float4 triplanar5 = TriplanarSampling5( _NormalMap, ase_vertex3Pos, ase_vertexNormal, 5.0, _NormalTiling, 1.0, 0 );
			float3 normalUnpacked30 = UnpackScaleNormal( triplanar5, _NormalScale );
			float3 normalizeResult5_g178 = normalize( normalUnpacked30 );
			float dotResult14_g178 = dot( i.viewDir , normalizeResult5_g178 );
			s186.Albedo = ( temp_output_500_122 * saturate( ( saturate( ( temp_output_277_0 * temp_output_277_0 * _AlbedoBoost ) ) + ( ( saturate( pow( saturate( ( 1.0 - dotResult14_g178 ) ) , _FresnelPower ) ) * _FrenselMult ) * _FresnelColor ) ) ) ).rgb;
			s186.Normal = WorldNormalVector( i , normalUnpacked30 );
			s186.Emission = float3( 0,0,0 );
			s186.Specular = ( break253.x * _Specular * _SpecularColor ).rgb;
			s186.Smoothness = ( _Smoothness * temp_output_500_122 );
			s186.Occlusion = 1.0;

			data.light = gi.light;

			UnityGI gi186 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g186 = UnityGlossyEnvironmentSetup( s186.Smoothness, data.worldViewDir, s186.Normal, float3(0,0,0));
			gi186 = UnityGlobalIllumination( data, s186.Occlusion, s186.Normal, g186 );
			#endif

			float3 surfResult186 = LightingStandardSpecular ( s186, viewDir, gi186 ).rgb;
			surfResult186 += s186.Emission;

			#ifdef UNITY_PASS_FORWARDADD//186
			surfResult186 -= s186.Emission;
			#endif//186
			c.rgb = saturate( ( saturate( ( saturate( ( saturate( ( tex2D( _ScatterMap, ( ( _ScatterCenterShift + appendResult10_g217 ) * _ScatterStretch ) ) * _ScatterColor * ase_lightColor ) ) * _ScatterBoost ) ) + _ScatterIndirect ) ) * float4( saturate( ( saturate( ( surfResult494 * _CloudBoost ) ) + surfResult186 ) ) , 0.0 ) ) ).rgb;
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
				float4 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv2_texcoord2;
				o.customPack1.xy = v.texcoord1;
				o.customPack1.zw = customInputData.uv_texcoord;
				o.customPack1.zw = v.texcoord;
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
				surfIN.uv2_texcoord2 = IN.customPack1.xy;
				surfIN.uv_texcoord = IN.customPack1.zw;
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
-1763;45;1589;922;-1911.497;912.1483;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;19;-613.5011,661.0359;Float;False;Property;_DetailTiling;Detail Tiling;11;0;Create;True;0;0;0;False;0;False;0;1.78;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-612.9601,468.4577;Float;True;Property;_DetailMap;Detail Map;7;0;Create;True;0;0;0;False;0;False;None;75e10870555c0af4894acfe690e5daab;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TriplanarNode;17;-341.8118,471.9501;Inherit;True;Spherical;Object;False;Top Texture 1;_TopTexture1;white;0;None;Mid Texture 1;_MidTexture1;white;0;None;Bot Texture 1;_BotTexture1;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;30.60592,466.627;Float;False;detail;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;251;388.4479,-287.3243;Inherit;False;41;detail;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;253;614.6644,-283.2049;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;4;-618.2471,270.9991;Float;False;Property;_NormalTiling;Normal Tiling;10;0;Create;True;0;0;0;False;0;False;0;3.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-618.7361,70.15813;Float;True;Property;_NormalMap;Normal Map;8;0;Create;True;0;0;0;False;0;False;None;90a8dbb5ad4e5d3488848741438ff94f;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;7;-179.9657,277.7505;Float;False;Property;_NormalScale;Normal Scale;9;0;Create;True;0;0;0;False;0;False;0;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;5;-358.5297,73.76613;Inherit;True;Spherical;Object;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;0;None;Bot Texture 0;_BotTexture0;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;260;941.6013,-371.0421;Inherit;False;BaseColor;16;;75;436e5fd3b4e5f564d91908d8a8c53f20;0;1;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;275;1208.695,-418.1058;Inherit;False;DesertColor;18;;76;1b595ba52fc886e48b4be4810312f928;0;3;3;FLOAT;0;False;10;FLOAT;0;False;6;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;6;70.69546,74.68622;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;368;1499.958,-172.1199;Float;False;Property;_AlbedoBoost;Albedo Boost;22;0;Create;True;0;0;0;False;0;False;0;19.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;277;1498.801,-295.5205;Inherit;False;MountainColor;23;;177;4181dbe52ccd82c468b472a633e7f96c;0;3;3;FLOAT;0;False;10;FLOAT;0;False;6;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;345.8806,67.72682;Float;False;normalUnpacked;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;367;1828.339,-301.4905;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;1438.535,-62.25322;Inherit;False;30;normalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;371;2000.667,-301.8134;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;505;2135.709,-619.0266;Float;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;0.003;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;300;1824.06,-162.4667;Inherit;False;Fresnel;27;;178;f8c497a0c2d6d334f8e7138f24a77d5f;0;1;22;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;500;2088.491,-758.8237;Inherit;False;Clouds;31;;212;b41fa152b94c44b4e9f91f67316d221d;0;0;2;FLOAT;122;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;504;2419.709,-667.0266;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;397;2167.925,-303.5969;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;82;1080.414,47.00317;Float;False;Property;_Specular;Specular;13;0;Create;True;0;0;0;False;0;False;0;0.614;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;80;1080.473,127.0699;Float;False;Property;_SpecularColor;Specular Color;12;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0.9137931,0.875,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;83;2168.139,-56.13948;Float;False;Property;_Smoothness;Smoothness;14;0;Create;True;0;0;0;False;0;False;0;0.457;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;496;2675.61,-516.2273;Float;False;Property;_CloudBoost;Cloud Boost;15;0;Create;True;0;0;0;False;0;False;5;11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;494;2595.61,-738.2273;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;372;2326.815,-303.039;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;1424.402,29.95498;Inherit;False;3;3;0;FLOAT;1;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;465;2614.412,-413.529;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;495;2871.61,-689.2273;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;454;2658.881,-180.6583;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;186;2876.207,-364.6288;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;497;3027.61,-684.2273;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;490;3164.61,-467.2273;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;491;3330.61,-468.2273;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;510;3287.333,-557.7917;Inherit;False;ScatterColor;0;;216;5984f944e2b849e44aad6ac4d7027dc1;0;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;513;3519.333,-545.7917;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;512;3676.333,-544.7917;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;503;3897.308,-770.7274;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;FORGE3D/Planets HD/Sand;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;18;0
WireConnection;17;3;19;0
WireConnection;41;0;17;0
WireConnection;253;0;251;0
WireConnection;5;0;3;0
WireConnection;5;3;4;0
WireConnection;260;1;253;0
WireConnection;275;3;253;0
WireConnection;275;10;253;2
WireConnection;275;6;260;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;277;3;253;0
WireConnection;277;10;253;1
WireConnection;277;6;275;0
WireConnection;30;0;6;0
WireConnection;367;0;277;0
WireConnection;367;1;277;0
WireConnection;367;2;368;0
WireConnection;371;0;367;0
WireConnection;300;22;31;0
WireConnection;504;0;500;0
WireConnection;504;1;505;0
WireConnection;397;0;371;0
WireConnection;397;1;300;0
WireConnection;494;0;500;0
WireConnection;494;3;504;0
WireConnection;372;0;397;0
WireConnection;81;0;253;0
WireConnection;81;1;82;0
WireConnection;81;2;80;0
WireConnection;465;0;500;122
WireConnection;465;1;372;0
WireConnection;495;0;494;0
WireConnection;495;1;496;0
WireConnection;454;0;83;0
WireConnection;454;1;500;122
WireConnection;186;0;465;0
WireConnection;186;1;31;0
WireConnection;186;3;81;0
WireConnection;186;4;454;0
WireConnection;497;0;495;0
WireConnection;490;0;497;0
WireConnection;490;1;186;0
WireConnection;491;0;490;0
WireConnection;513;0;510;0
WireConnection;513;1;491;0
WireConnection;512;0;513;0
WireConnection;503;13;512;0
ASEEND*/
//CHKSM=EB015A73D37DD841258DD9081E8C6F08A34C11E3