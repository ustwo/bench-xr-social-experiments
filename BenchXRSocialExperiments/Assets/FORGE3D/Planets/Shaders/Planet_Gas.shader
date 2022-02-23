// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FORGE3D/Planets HD/Gas"
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
		_UVDistortionMap("UV Distortion Map", 2D) = "white" {}
		_UVSpeed("UV Speed", Vector) = (0,0,0,0)
		_UVDistortionSpeed("UV Distortion Speed", Vector) = (0,0,0,0)
		_Tint("Tint", Color) = (0,0,0,0)
		_SpecularTint("Specular Tint", Color) = (0,0,0,0)
		_UVDistortion("UV Distortion", Range( 0 , 1)) = 0
		_Specular("Specular", Range( 0.003 , 5)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_FrenselMult("Frensel Mult", Range( 0 , 10)) = 0
		_FresnelPower("Fresnel Power", Range( 0 , 10)) = 0
		_FresnelColor("Fresnel Color", Color) = (0.4558824,0.4558824,0.4558824,1)
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
			float2 uv_texcoord;
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
		uniform float _FresnelPower;
		uniform float _FrenselMult;
		uniform float4 _FresnelColor;
		uniform float4 _Tint;
		uniform sampler2D _HeightMap;
		uniform float2 _UVSpeed;
		uniform float4 _HeightMap_ST;
		uniform sampler2D _UVDistortionMap;
		uniform float2 _UVDistortionSpeed;
		uniform float4 _UVDistortionMap_ST;
		uniform float _UVDistortion;
		uniform float _Specular;
		uniform float4 _SpecularTint;
		uniform float _Smoothness;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float4 transform4_g40 = mul(unity_ObjectToWorld,float4( ase_vertexNormal , 0.0 ));
			float4 normalizeResult6_g40 = normalize( transform4_g40 );
			float3 temp_output_1_0_g41 = normalizeResult6_g40.xyz;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult7_g40 = normalize( ase_worldlightDir );
			float dotResult4_g41 = dot( temp_output_1_0_g41 , normalizeResult7_g40 );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 normalizeResult8_g40 = normalize( ase_worldViewDir );
			float dotResult7_g41 = dot( temp_output_1_0_g41 , normalizeResult8_g40 );
			float2 appendResult10_g41 = (float2(( ( dotResult4_g41 / 2.0 ) + 0.5 ) , dotResult7_g41));
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			SurfaceOutputStandardSpecular s26 = (SurfaceOutputStandardSpecular ) 0;
			float3 normalizeResult5_g39 = normalize( float4(0,0,1,0).xyz );
			float dotResult14_g39 = dot( i.viewDir , normalizeResult5_g39 );
			float2 uv_HeightMap = i.uv_texcoord * _HeightMap_ST.xy + _HeightMap_ST.zw;
			float2 panner39 = ( _Time.y * _UVSpeed + uv_HeightMap);
			float2 uv_UVDistortionMap = i.uv_texcoord * _UVDistortionMap_ST.xy + _UVDistortionMap_ST.zw;
			float2 panner11 = ( _Time.y * _UVDistortionSpeed + uv_UVDistortionMap);
			float4 tex2DNode1 = tex2D( _HeightMap, ( panner39 + ( tex2D( _UVDistortionMap, panner11 ).r * _UVDistortion ) ) );
			s26.Albedo = ( ( ( saturate( pow( saturate( ( 1.0 - dotResult14_g39 ) ) , _FresnelPower ) ) * _FrenselMult ) * _FresnelColor ) + ( _Tint * tex2DNode1 * 2.0 ) ).rgb;
			s26.Normal = ase_worldNormal;
			s26.Emission = float3( 0,0,0 );
			s26.Specular = ( tex2DNode1 * _Specular * _SpecularTint ).rgb;
			s26.Smoothness = ( ( 1.0 - tex2DNode1 ) * _Smoothness ).r;
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
			c.rgb = saturate( ( saturate( ( saturate( ( saturate( ( tex2D( _ScatterMap, ( ( _ScatterCenterShift + appendResult10_g41 ) * _ScatterStretch ) ) * _ScatterColor * ase_lightColor ) ) * _ScatterBoost ) ) + _ScatterIndirect ) ) * float4( surfResult26 , 0.0 ) ) ).rgb;
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
				float2 customPack1 : TEXCOORD1;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				surfIN.uv_texcoord = IN.customPack1.xy;
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
-1763;45;1589;922;1802.354;766.3505;1.325801;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;21;-2011.518,-370.3658;Float;True;Property;_UVDistortionMap;UV Distortion Map;8;0;Create;True;0;0;0;False;0;False;None;b07171a0de46b944c812630772b834f1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector2Node;14;-1720.901,-236.5001;Float;False;Property;_UVDistortionSpeed;UV Distortion Speed;10;0;Create;True;0;0;0;False;0;False;0,0;-0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;13;-1721.901,-113.5001;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1717.901,-358.4996;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;11;-1432.901,-197.5001;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;20;-1155.138,-491.9363;Float;True;Property;_HeightMap;Height Map;0;0;Create;True;0;0;0;False;0;False;None;aca7ed0456526f144895da1d00aa1ad1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector2Node;40;-973.2736,78.54243;Float;False;Property;_UVSpeed;UV Speed;9;0;Create;True;0;0;0;False;0;False;0,0;-0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;23;-1232.817,-210.4655;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-1214.937,-13.53701;Float;False;Property;_UVDistortion;UV Distortion;13;0;Create;True;0;0;0;False;0;False;0;0.033;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;41;-974.2736,201.5424;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-896.4372,-307.3373;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;39;-685.2739,117.5423;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-892.5359,-185.1375;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-568.8378,-215.0374;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-393.4,-248.3;Inherit;True;Property;;;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;32;-397.7551,-641.8317;Float;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;0;False;0;False;0,0,1,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-66.43701,-413.4687;Float;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;24;-406.2153,-439.2665;Float;False;Property;_Tint;Tint;11;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-35.71544,-332.6664;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;30;-113.6553,-553.0319;Inherit;False;Fresnel;16;;39;f8c497a0c2d6d334f8e7138f24a77d5f;0;1;22;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-377,45.5;Float;False;Property;_Smoothness;Smoothness;15;0;Create;True;0;0;0;False;0;False;0;0.198;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-299.1395,140.3309;Float;False;Property;_SpecularTint;Specular Tint;12;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.989858,0.9705881,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-377,-37.5;Float;False;Property;_Specular;Specular;14;0;Create;True;0;0;0;False;0;False;0;0.32;0.003;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;36;-4.039465,120.8309;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;2.4,0.9999988;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;244.2606,-357.5691;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;4.599999,-146.5;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;27;415.0464,-318.5574;Inherit;False;ScatterColor;1;;40;5984f944e2b849e44aad6ac4d7027dc1;0;0;1;COLOR;0
Node;AmplifyShaderEditor.CustomStandardSurface;26;350.8462,-208.6574;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;614.0464,-237.5574;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;29;978.0464,-227.5574;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;35;37.56055,-211.9692;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1271.999,-481.7;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;FORGE3D/Planets HD/Gas;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;2;21;0
WireConnection;11;0;10;0
WireConnection;11;2;14;0
WireConnection;11;1;13;0
WireConnection;23;0;21;0
WireConnection;23;1;11;0
WireConnection;18;2;20;0
WireConnection;39;0;18;0
WireConnection;39;2;40;0
WireConnection;39;1;41;0
WireConnection;17;0;23;1
WireConnection;17;1;16;0
WireConnection;15;0;39;0
WireConnection;15;1;17;0
WireConnection;1;0;20;0
WireConnection;1;1;15;0
WireConnection;25;0;24;0
WireConnection;25;1;1;0
WireConnection;25;2;38;0
WireConnection;30;22;32;0
WireConnection;36;0;1;0
WireConnection;7;0;36;0
WireConnection;7;1;5;0
WireConnection;33;0;30;0
WireConnection;33;1;25;0
WireConnection;6;0;1;0
WireConnection;6;1;4;0
WireConnection;6;2;34;0
WireConnection;26;0;33;0
WireConnection;26;3;6;0
WireConnection;26;4;7;0
WireConnection;28;0;27;0
WireConnection;28;1;26;0
WireConnection;29;0;28;0
WireConnection;35;0;1;1
WireConnection;0;13;29;0
ASEEND*/
//CHKSM=40E0BA581A4C037C4AA77D1DE5E7F51D6156B1EC