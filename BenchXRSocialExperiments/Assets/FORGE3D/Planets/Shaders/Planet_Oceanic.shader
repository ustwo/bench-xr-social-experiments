// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FORGE3D/Planets HD/Oceanic"
{
	Properties
	{
		_GlobalBoost("Global Boost", Float) = 1
		_NormalMap("Normal Map", 2D) = "white" {}
		_NormalTiling("Normal Tiling", Float) = 0
		_FrenselMult("Frensel Mult", Range( 0 , 10)) = 0
		_FresnelPower("Fresnel Power", Range( 0 , 10)) = 0
		_FresnelColor("Fresnel Color", Color) = (0.4558824,0.4558824,0.4558824,1)
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
		_NormalScale("Normal Scale", Float) = 0
		_HeightMap("Height Map", 2D) = "white" {}
		_HeightTiling("Height Tiling", Float) = 0
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
		uniform float4 _WaterShoreColor;
		uniform float4 _WaterDeepColor;
		uniform float4 _WaterShallowColor;
		uniform sampler2D _HeightMap;
		uniform float _HeightTiling;
		uniform float _WaterDetailFactor;
		uniform float _WaterDetailBoost;
		uniform float _WaterShoreFactor;
		uniform float _GlobalBoost;
		uniform sampler2D _NormalMap;
		uniform float _NormalTiling;
		uniform float _NormalScale;
		uniform float _FresnelPower;
		uniform float _FrenselMult;
		uniform float4 _FresnelColor;
		uniform float _WaterSpecular;
		uniform float4 _WaterSpecularColor;
		uniform float _WaterSmoothness;


		float2 rotateUV1_g271( float time, float2 uv, float speed )
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
			float time1_g271 = _Time.y;
			float2 uv2_CloudsTop = i.uv2_texcoord2 * _CloudsTop_ST.xy + _CloudsTop_ST.zw;
			float2 uv1_g271 = uv2_CloudsTop;
			float speed1_g271 = _CloudsTopSpeed;
			float2 localrotateUV1_g271 = rotateUV1_g271( time1_g271 , uv1_g271 , speed1_g271 );
			float2 poleUV63_g270 = localrotateUV1_g271;
			float cloudPole76_g270 = tex2D( _CloudsTop, poleUV63_g270 ).r;
			float2 uv_CloudsMiddle = i.uv_texcoord * _CloudsMiddle_ST.xy + _CloudsMiddle_ST.zw;
			float2 break53_g270 = uv_CloudsMiddle;
			float2 appendResult55_g270 = (float2(( break53_g270.x + ( _CloudsMiddleSpeed * _Time.y ) ) , break53_g270.y));
			float2 bellyUV56_g270 = appendResult55_g270;
			float cloudBelly73_g270 = tex2D( _CloudsMiddle, bellyUV56_g270 ).r;
			float2 uv_Gradient = i.uv_texcoord * _Gradient_ST.xy + _Gradient_ST.zw;
			float gradientMap93_g270 = pow( tex2D( _Gradient, uv_Gradient ).r , _CloudsBlendWeight );
			float lerpResult25_g270 = lerp( cloudPole76_g270 , cloudBelly73_g270 , gradientMap93_g270);
			float cloudMix80_g270 = lerpResult25_g270;
			float4 temp_output_96_0 = saturate( ( cloudMix80_g270 * _CloudsTint * _CloudsBoost ) );
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
			float2 shadowUVPole47_g270 = (( 0.005 * ase_worldlightDir )).xx;
			float cloudPoleShadow94_g270 = tex2D( _CloudsTop, ( poleUV63_g270 + shadowUVPole47_g270 ) ).r;
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 normalizeResult36_g270 = normalize( mul( ase_worldToTangent, ase_worldlightDir ) );
			float2 shadowUVBelly46_g270 = (( normalizeResult36_g270 * 0.005 )).xx;
			float cloudBellyShadow85_g270 = tex2D( _CloudsMiddle, ( shadowUVBelly46_g270 + bellyUV56_g270 ) ).r;
			float lerpResult95_g270 = lerp( cloudPoleShadow94_g270 , cloudBellyShadow85_g270 , ( gradientMap93_g270 + 0.1 ));
			float cloudMixShadow99_g270 = saturate( pow( ( 1.0 - lerpResult95_g270 ) , ( _CloudShadows * 50.0 ) ) );
			float temp_output_96_122 = cloudMixShadow99_g270;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 triplanar5 = TriplanarSampling5( _HeightMap, ase_vertex3Pos, ase_vertexNormal, 5.0, _HeightTiling, 1.0, 0 );
			float4 height6 = triplanar5;
			float4 break22 = height6;
			float depth11_g268 = saturate( ( pow( ( break22.x * break22.z ) , _WaterDetailFactor ) * _WaterDetailBoost ) );
			float4 lerpResult19_g268 = lerp( _WaterDeepColor , _WaterShallowColor , depth11_g268);
			float shoreMask16_g268 = saturate( pow( 1.0 , _WaterShoreFactor ) );
			float4 lerpResult23_g268 = lerp( ( _WaterShoreColor + lerpResult19_g268 ) , lerpResult19_g268 , shoreMask16_g268);
			float4 waterColor25_g268 = lerpResult23_g268;
			float4 lerpResult27_g268 = lerp( float4( float3( 0,0,0 ) , 0.0 ) , waterColor25_g268 , 1.0);
			float4 triplanar51 = TriplanarSampling51( _NormalMap, ase_vertex3Pos, ase_vertexNormal, 5.0, _NormalTiling, 1.0, 0 );
			float3 normalUnpacked54 = UnpackScaleNormal( triplanar51, _NormalScale );
			float3 normalizeResult5_g269 = normalize( normalUnpacked54 );
			float dotResult14_g269 = dot( i.viewDir , normalizeResult5_g269 );
			s26.Albedo = ( temp_output_96_122 * saturate( ( saturate( ( lerpResult27_g268 * _GlobalBoost ) ) + ( ( saturate( pow( saturate( ( 1.0 - dotResult14_g269 ) ) , _FresnelPower ) ) * _FrenselMult ) * _FresnelColor ) ) ) ).rgb;
			s26.Normal = WorldNormalVector( i , normalUnpacked54 );
			s26.Emission = float3( 0,0,0 );
			s26.Specular = ( saturate( ( _WaterSpecular * ( depth11_g268 + 0.1 ) * _WaterSpecularColor ) ) * _GlobalBoost ).rgb;
			s26.Smoothness = ( temp_output_96_122 * _WaterSmoothness );
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
			c.rgb = saturate( ( saturate( ( saturate( ( saturate( ( tex2D( _ScatterMap, ( ( _ScatterCenterShift + appendResult10_g273 ) * _ScatterStretch ) ) * _ScatterColor * ase_lightColor ) ) * _ScatterBoost ) ) + _ScatterIndirect ) ) * float4( saturate( ( saturate( ( surfResult87 * 5.0 ) ) + saturate( surfResult26 ) ) ) , 0.0 ) ) ).rgb;
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
-1763;45;1589;922;1071.642;1323.944;2.143981;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1584.791,-395.6999;Float;True;Property;_HeightMap;Height Map;25;0;Create;True;0;0;0;False;0;False;None;55fbd9d9fe902ce4da243d30cc44ec25;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;4;-1576.536,-178.1983;Float;False;Property;_HeightTiling;Height Tiling;26;0;Create;True;0;0;0;False;0;False;0;3.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;5;-1322.935,-292.2925;Inherit;True;Spherical;Object;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;0;None;Bot Texture 0;_BotTexture0;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;6;-945.5557,-295.0933;Float;False;height;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1577.052,283.4705;Float;False;Property;_NormalTiling;Normal Tiling;2;0;Create;True;0;0;0;False;0;False;0;10.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;49;-1585.307,65.96893;Float;True;Property;_NormalMap;Normal Map;1;0;Create;True;0;0;0;False;0;False;None;0599186f31eb63147a58a91719aca678;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;23;70.30082,-489.5881;Inherit;False;6;height;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TriplanarNode;51;-1323.452,169.3763;Inherit;True;Spherical;Object;False;Top Texture 1;_TopTexture1;white;0;None;Mid Texture 1;_MidTexture1;white;0;None;Bot Texture 1;_BotTexture1;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-1237.554,391.696;Float;False;Property;_NormalScale;Normal Scale;24;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;52;-921.5544,168.696;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BreakToComponentsNode;22;282.4919,-484.8134;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;138;320.1146,-317.3461;Float;False;Constant;_Float2;Float 2;10;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;137;587.622,-403.2938;Inherit;False;Water;14;;268;e187dfe8b39989f44abd5e4c0deac419;0;5;4;FLOAT;0;False;3;FLOAT;0;False;26;FLOAT;1;False;12;FLOAT;1;False;1;FLOAT3;0,0,0;False;3;COLOR;0;COLOR;28;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;134;900.3143,18.613;Float;False;Property;_GlobalBoost;Global Boost;0;0;Create;True;0;0;0;False;0;False;1;1.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-649.0061,163.0985;Float;False;normalUnpacked;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;778.8408,-198.1184;Inherit;False;54;normalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;1000.303,-486.0499;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;143;1174.503,-474.3499;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;132;1071.242,-269.974;Inherit;False;Fresnel;3;;269;f8c497a0c2d6d334f8e7138f24a77d5f;0;1;22;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;96;1242.731,-733.9436;Inherit;False;Clouds;27;;270;b41fa152b94c44b4e9f91f67316d221d;0;0;2;FLOAT;122;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;84;1289.949,-594.1465;Float;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;0;False;0;False;0.003;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;1356.123,-395.8434;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;76;1531.443,-395.9202;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;86;1573.95,-642.1465;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;87;1749.852,-713.3472;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;1251.203,-80.45014;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;1525.255,-182.4215;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;1829.852,-491.3471;Float;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;1715.117,-409.0131;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;26;1986.369,-298.7584;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;2025.85,-664.3472;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;135;2460.916,-273.487;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;90;2181.849,-659.3472;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;2753.849,-427.347;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;97;2893.639,-519.1441;Inherit;False;ScatterColor;7;;272;5984f944e2b849e44aad6ac4d7027dc1;0;0;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;99;2918.639,-427.1441;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;3158.639,-469.1441;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;2299.016,-178.687;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;94;3374.995,-465.805;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3570.129,-698.0769;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;FORGE3D/Planets HD/Oceanic;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;0
WireConnection;5;3;4;0
WireConnection;6;0;5;0
WireConnection;51;0;49;0
WireConnection;51;3;50;0
WireConnection;52;0;51;0
WireConnection;52;1;53;0
WireConnection;22;0;23;0
WireConnection;137;4;22;0
WireConnection;137;3;22;2
WireConnection;137;26;138;0
WireConnection;137;12;138;0
WireConnection;54;0;52;0
WireConnection;144;0;137;0
WireConnection;144;1;134;0
WireConnection;143;0;144;0
WireConnection;132;22;55;0
WireConnection;70;0;143;0
WireConnection;70;1;132;0
WireConnection;76;0;70;0
WireConnection;86;0;96;0
WireConnection;86;1;84;0
WireConnection;87;0;96;0
WireConnection;87;3;86;0
WireConnection;142;0;137;28
WireConnection;142;1;134;0
WireConnection;93;0;96;122
WireConnection;93;1;137;35
WireConnection;92;0;96;122
WireConnection;92;1;76;0
WireConnection;26;0;92;0
WireConnection;26;1;55;0
WireConnection;26;3;142;0
WireConnection;26;4;93;0
WireConnection;89;0;87;0
WireConnection;89;1;88;0
WireConnection;135;0;26;0
WireConnection;90;0;89;0
WireConnection;91;0;90;0
WireConnection;91;1;135;0
WireConnection;99;0;91;0
WireConnection;98;0;97;0
WireConnection;98;1;99;0
WireConnection;133;0;26;0
WireConnection;94;0;98;0
WireConnection;0;13;94;0
ASEEND*/
//CHKSM=B263A53506A40EE6D316E708BEF7A9BA2E04F2B3