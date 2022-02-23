// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FORGE3D/Planets HD/Ice"
{
	Properties
	{
		_ColorBoost("Color Boost", Float) = 0
		_FrenselMult("Frensel Mult", Range( 0 , 10)) = 0
		_FresnelPower("Fresnel Power", Range( 0 , 10)) = 0
		_FresnelColor("Fresnel Color", Color) = (0.4558824,0.4558824,0.4558824,1)
		_ColorMap("Color Map", 2D) = "white" {}
		_ScatterMap("Scatter Map", 2D) = "white" {}
		_ScatterColor("Scatter Color", Color) = (0,0,0,0)
		_ScatterBoost("Scatter Boost", Range( 0 , 5)) = 1
		_ScatterIndirect("Scatter Indirect", Range( 0 , 1)) = 0
		_ScatterStretch("Scatter Stretch", Range( -2 , 2)) = 0
		_ScatterCenterShift("Scatter Center Shift", Range( -2 , 2)) = 0
		_DetailMap("Detail Map", 2D) = "white" {}
		_HeightMap("Height Map", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "white" {}
		_ColorTiling("Color Tiling", Float) = 0
		_DetailTiling("Detail Tiling", Float) = 0
		_HeightTiling("Height Tiling", Float) = 0
		_NormalTiling("Normal Tiling", Float) = 0
		_NormalScale("Normal Scale", Float) = 0
		_IceFactorA("Ice Factor A", Float) = 0
		_IceFactorB("Ice Factor B", Float) = 0
		_IceFactorC("Ice Factor C", Float) = 0
		_IceDetail("Ice Detail", Float) = 0
		_RampHigh("RampHigh", Color) = (0,0,0,0)
		_RampMid("RampMid", Color) = (0,0,0,0)
		_RampLow("RampLow", Color) = (0,0,0,0)
		_SpecularColor("Specular Color", Color) = (0,0,0,0)
		_Specular("Specular", Range( 0 , 15)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
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
		uniform sampler2D _NormalMap;
		uniform float _NormalTiling;
		uniform float _NormalScale;
		uniform float _FresnelPower;
		uniform float _FrenselMult;
		uniform float4 _FresnelColor;
		uniform float4 _RampLow;
		uniform float4 _RampMid;
		uniform sampler2D _HeightMap;
		uniform float _HeightTiling;
		uniform sampler2D _DetailMap;
		uniform float _DetailTiling;
		uniform float _IceDetail;
		uniform float _IceFactorA;
		uniform float _IceFactorB;
		uniform float _IceFactorC;
		uniform float4 _RampHigh;
		uniform sampler2D _ColorMap;
		uniform float _ColorTiling;
		uniform float _ColorBoost;
		uniform float _Specular;
		uniform float4 _SpecularColor;
		uniform float _Smoothness;


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


		inline float4 TriplanarSampling11( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		inline float4 TriplanarSampling34( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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
			float4 transform4_g42 = mul(unity_ObjectToWorld,float4( ase_vertexNormal , 0.0 ));
			float4 normalizeResult6_g42 = normalize( transform4_g42 );
			float3 temp_output_1_0_g43 = normalizeResult6_g42.xyz;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult7_g42 = normalize( ase_worldlightDir );
			float dotResult4_g43 = dot( temp_output_1_0_g43 , normalizeResult7_g42 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult8_g42 = normalize( ase_worldViewDir );
			float dotResult7_g43 = dot( temp_output_1_0_g43 , normalizeResult8_g42 );
			float2 appendResult10_g43 = (float2(( ( dotResult4_g43 / 2.0 ) + 0.5 ) , dotResult7_g43));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			SurfaceOutputStandardSpecular s186 = (SurfaceOutputStandardSpecular ) 0;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 triplanar5 = TriplanarSampling5( _NormalMap, ase_vertex3Pos, ase_vertexNormal, 5.0, _NormalTiling, 1.0, 0 );
			float3 normalUnpacked30 = UnpackScaleNormal( triplanar5, _NormalScale );
			float3 normalizeResult5_g39 = normalize( normalUnpacked30 );
			float dotResult14_g39 = dot( i.viewDir , normalizeResult5_g39 );
			float4 triplanar11 = TriplanarSampling11( _HeightMap, ase_vertex3Pos, ase_vertexNormal, 5.0, _HeightTiling, 1.0, 0 );
			float4 height40 = triplanar11;
			float4 triplanar17 = TriplanarSampling17( _DetailMap, ase_vertex3Pos, ase_vertexNormal, 5.0, _DetailTiling, 1.0, 0 );
			float4 detail41 = triplanar17;
			float4 break45 = detail41;
			float detailTexture50 = pow( ( break45.x * break45.y ) , 0.5 );
			float detaledHeight61 = ( height40.x + ( ( detailTexture50 - 0.5 ) * 2.0 * _IceDetail ) );
			float temp_output_2_0_g8 = ( _IceFactorA - _IceDetail );
			float detaledHeightLinStep66 = saturate( ( ( detaledHeight61 - temp_output_2_0_g8 ) / ( ( _IceDetail + _IceFactorB ) - temp_output_2_0_g8 ) ) );
			float temp_output_6_0_g12 = ( detaledHeightLinStep66 / _IceFactorC );
			float3 lerpResult8_g12 = lerp( _RampLow.rgb , _RampMid.rgb , saturate( temp_output_6_0_g12 ));
			float3 lerpResult12_g12 = lerp( lerpResult8_g12 , _RampHigh.rgb , saturate( ( temp_output_6_0_g12 - 1.0 ) ));
			float4 triplanar34 = TriplanarSampling34( _ColorMap, ase_vertex3Pos, ase_vertexNormal, 5.0, _ColorTiling, 1.0, 0 );
			float4 colorMap42 = triplanar34;
			float4 detailedDepthColor78 = saturate( ( float4( lerpResult12_g12 , 0.0 ) * colorMap42 * _ColorBoost ) );
			s186.Albedo = ( ( ( saturate( pow( saturate( ( 1.0 - dotResult14_g39 ) ) , _FresnelPower ) ) * _FrenselMult ) * _FresnelColor ) + detailedDepthColor78 ).rgb;
			s186.Normal = WorldNormalVector( i , normalUnpacked30 );
			s186.Emission = float3( 0,0,0 );
			s186.Specular = ( detailTexture50 * _Specular * _SpecularColor ).rgb;
			s186.Smoothness = _Smoothness;
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
			c.rgb = saturate( ( saturate( ( saturate( ( saturate( ( tex2D( _ScatterMap, ( ( _ScatterCenterShift + appendResult10_g43 ) * _ScatterStretch ) ) * _ScatterColor * ase_lightColor ) ) * _ScatterBoost ) ) + _ScatterIndirect ) ) * float4( surfResult186 , 0.0 ) ) ).rgb;
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
-1763;45;1589;922;-1882.738;320.384;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;19;-1324.853,738.1995;Float;False;Property;_DetailTiling;Detail Tiling;17;0;Create;True;0;0;0;False;0;False;0;4.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1324.312,545.6213;Float;True;Property;_DetailMap;Detail Map;13;0;Create;True;0;0;0;False;0;False;None;7724a736e87fa3f4090aae706ce65051;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TriplanarNode;17;-1053.163,549.1136;Inherit;True;Spherical;Object;False;Top Texture 1;_TopTexture1;white;0;None;Mid Texture 1;_MidTexture1;white;0;None;Bot Texture 1;_BotTexture1;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-680.7454,543.7905;Float;False;detail;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-283.4542,878.4276;Inherit;False;41;detail;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BreakToComponentsNode;45;-80.58265,885.2847;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;185.1719,887.3782;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-1328.516,-244.1932;Float;True;Property;_HeightMap;Height Map;14;0;Create;True;0;0;0;False;0;False;None;6efa5a45e862b3e42b00e7200673069d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;9;-1320.261,-26.69205;Float;False;Property;_HeightTiling;Height Tiling;18;0;Create;True;0;0;0;False;0;False;0;1.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;47;352.7003,887.4083;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;11;-1070.561,-116.086;Inherit;True;Spherical;Object;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;0;None;Bot Texture 0;_BotTexture0;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;519.4676,879.6008;Float;False;detailTexture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;40;-672.3846,-120.1863;Float;False;height;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;672.868,736.1003;Inherit;False;40;height;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;54;800.2663,983.6005;Float;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;790.9855,1092.539;Float;False;Property;_IceDetail;Ice Detail;24;0;Create;True;0;0;0;False;0;False;0;-0.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;796.3669,886.1006;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;1023.866,908.2001;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;2;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;59;926.6652,741.9991;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;55;1218.665,856.2006;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;789.1541,1285.331;Float;False;Property;_IceFactorB;Ice Factor B;22;0;Create;True;0;0;0;False;0;False;0;0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;778.3278,1184.858;Float;False;Property;_IceFactorA;Ice Factor A;21;0;Create;True;0;0;0;False;0;False;0;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;64;1036.995,1081.165;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;1380.616,849.2003;Float;False;detaledHeight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;1042.593,1190.976;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;68;1650.055,855.0765;Inherit;False;Linstep;-1;;8;aade3b0317e32b148b41ee41b85032e6;0;3;4;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1316.279,1077.637;Float;False;Property;_ColorTiling;Color Tiling;16;0;Create;True;0;0;0;False;0;False;0;2.17;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;35;-1315.738,886.0596;Float;True;Property;_ColorMap;Color Map;5;0;Create;True;0;0;0;False;0;False;None;59f151085127e024b884a82ba7337ce8;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TriplanarNode;34;-1045.589,888.5515;Inherit;True;Spherical;Object;False;Top Texture 2;_TopTexture2;white;0;None;Mid Texture 2;_MidTexture2;white;0;None;Bot Texture 2;_BotTexture2;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;1921.649,845.4989;Float;False;detaledHeightLinStep;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;71;1661.411,1111.327;Float;False;Property;_RampLow;RampLow;27;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.8102292,0.8557675,0.8676471,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-670.9986,883.5765;Float;False;colorMap;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;73;1661.411,1454.327;Float;False;Property;_RampHigh;RampHigh;25;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.8379109,0.9118125,0.9264706,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;70;1691.128,1618.006;Float;False;Property;_IceFactorC;Ice Factor C;23;0;Create;True;0;0;0;False;0;False;0;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;72;1661.411,1281.327;Float;False;Property;_RampMid;RampMid;26;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.8927336,0.939512,0.9485294,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;74;1654.761,1703.245;Inherit;False;66;detaledHeightLinStep;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1329.599,348.1625;Float;False;Property;_NormalTiling;Normal Tiling;19;0;Create;True;0;0;0;False;0;False;0;2.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1330.088,147.3217;Float;True;Property;_NormalMap;Normal Map;15;0;Create;True;0;0;0;False;0;False;None;67aa65b4b20a2964c9d24e4ac793da0c;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;69;2018.528,1258.346;Inherit;False;Ramp3;-1;;12;d38b6eed89401a040a9f914ae79b3d2f;0;5;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;5;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-891.3169,354.9139;Float;False;Property;_NormalScale;Normal Scale;20;0;Create;True;0;0;0;False;0;False;0;0.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;2047.231,1437.75;Inherit;False;42;colorMap;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TriplanarNode;5;-1069.881,150.9297;Inherit;True;Spherical;Object;False;Top Texture 3;_TopTexture3;white;0;None;Mid Texture 3;_MidTexture3;white;0;None;Bot Texture 3;_BotTexture3;white;1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;5;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;254;2069.488,1522.108;Float;False;Property;_ColorBoost;Color Boost;0;0;Create;True;0;0;0;False;0;False;0;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;6;-640.6559,151.8498;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;2292.204,1262.038;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;255;2458.488,1258.108;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-365.4708,144.8904;Float;False;normalUnpacked;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;2646.455,1248.039;Float;False;detailedDepthColor;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;251;1233.06,421.8713;Inherit;False;30;normalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;80;1083.473,157.0699;Float;False;Property;_SpecularColor;Specular Color;28;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.8529412,0.9695739,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;62;1628.559,-94.24882;Inherit;False;78;detailedDepthColor;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;82;1082.414,63.00317;Float;False;Property;_Specular;Specular;29;0;Create;True;0;0;0;False;0;False;0;5;0;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;250;1668.164,346.9999;Inherit;False;Fresnel;1;;39;f8c497a0c2d6d334f8e7138f24a77d5f;0;1;22;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;1084.8,-19.32494;Inherit;False;50;detailTexture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;1639.187,-3.403538;Inherit;False;30;normalUnpacked;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;83;1632.738,176.0605;Float;False;Property;_Smoothness;Smoothness;30;0;Create;True;0;0;0;False;0;False;0;0.426;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;252;1976.966,-129.8492;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;1424.402,29.95498;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;186;2086.753,19.80185;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;253;2257.164,-65.00012;Inherit;False;ScatterColor;6;;42;5984f944e2b849e44aad6ac4d7027dc1;0;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;2508.164,35.99988;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;249;2653.164,39.99988;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3002.691,-191.2415;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;FORGE3D/Planets HD/Ice;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;18;0
WireConnection;17;3;19;0
WireConnection;41;0;17;0
WireConnection;45;0;44;0
WireConnection;46;0;45;0
WireConnection;46;1;45;1
WireConnection;47;0;46;0
WireConnection;11;0;10;0
WireConnection;11;3;9;0
WireConnection;50;0;47;0
WireConnection;40;0;11;0
WireConnection;52;0;50;0
WireConnection;53;0;52;0
WireConnection;53;1;54;0
WireConnection;53;2;43;0
WireConnection;59;0;48;0
WireConnection;55;0;59;0
WireConnection;55;1;53;0
WireConnection;64;0;38;0
WireConnection;64;1;43;0
WireConnection;61;0;55;0
WireConnection;65;0;43;0
WireConnection;65;1;39;0
WireConnection;68;4;61;0
WireConnection;68;2;64;0
WireConnection;68;3;65;0
WireConnection;34;0;35;0
WireConnection;34;3;36;0
WireConnection;66;0;68;0
WireConnection;42;0;34;0
WireConnection;69;1;71;0
WireConnection;69;2;72;0
WireConnection;69;3;73;0
WireConnection;69;5;70;0
WireConnection;69;4;74;0
WireConnection;5;0;3;0
WireConnection;5;3;4;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;76;0;69;0
WireConnection;76;1;77;0
WireConnection;76;2;254;0
WireConnection;255;0;76;0
WireConnection;30;0;6;0
WireConnection;78;0;255;0
WireConnection;250;22;251;0
WireConnection;252;0;250;0
WireConnection;252;1;62;0
WireConnection;81;0;79;0
WireConnection;81;1;82;0
WireConnection;81;2;80;0
WireConnection;186;0;252;0
WireConnection;186;1;31;0
WireConnection;186;3;81;0
WireConnection;186;4;83;0
WireConnection;248;0;253;0
WireConnection;248;1;186;0
WireConnection;249;0;248;0
WireConnection;0;13;249;0
ASEEND*/
//CHKSM=549844114D2F5989E2D1C79D287B332C64427BA2