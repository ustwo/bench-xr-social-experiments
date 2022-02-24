// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FORGE3D/Planets HD/Sun Corona"
{
	Properties
	{
		_EdgeFadeFalloff("Edge Fade Falloff", Float) = 0
		_EdgeFadeBoost("Edge Fade Boost", Float) = 0
		_CoronaMap("Corona Map", 2D) = "white" {}
		_DischargeTileY("Discharge Tile Y", Float) = 0
		_DischargeTileX("Discharge Tile X", Float) = 0
		_DischargePanSpeed("Discharge Pan Speed", Float) = 0
		_CoronaFluidTile("Corona Fluid Tile", Float) = 0
		_CoronaFluidInfluence("Corona Fluid Influence", Float) = 0
		_SolarStormFalloff("Solar Storm Falloff", Float) = 0
		_SolarStormPower("Solar Storm Power", Float) = 0
		_CoronaTileX("Corona Tile X", Float) = 0
		_CoronaTileY("Corona Tile Y", Float) = 0
		_CoronaSpeed("Corona Speed", Float) = 0
		_CoronaAmp("Corona Amp", Float) = 0
		_CoronaExp("Corona Exp", Float) = 0
		_CoronaBoost("Corona Boost", Float) = 0
		_CoronaFalloff("Corona Falloff", Float) = 0
		_CoronaColor("Corona Color", Color) = (0,0,0,0)
		_DepthFade("Depth Fade", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend One One
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma exclude_renderers xboxseries playstation switch nomrt 
		#pragma surface surf StandardCustomLighting keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
			float3 worldNormal;
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

		uniform float4 _CoronaColor;
		uniform sampler2D _CoronaMap;
		uniform float _DischargePanSpeed;
		uniform float _DischargeTileX;
		uniform float _DischargeTileY;
		uniform float _CoronaFluidTile;
		uniform float _CoronaFluidInfluence;
		uniform float _SolarStormFalloff;
		uniform float _SolarStormPower;
		uniform float _CoronaBoost;
		uniform float _CoronaFalloff;
		uniform float _CoronaSpeed;
		uniform float _CoronaTileX;
		uniform float _CoronaTileY;
		uniform float _CoronaAmp;
		uniform float _CoronaExp;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFade;
		uniform float _EdgeFadeFalloff;
		uniform float _EdgeFadeBoost;


		float2 _rotator14_g26( float speed, float2 uv )
		{
			uv -=0.5;
			float s = sin ( speed );
			float c = cos ( speed );
				           
			float2x2 rotationMatrix = float2x2( c, -s, s, c);
			rotationMatrix *=0.5;
			rotationMatrix +=0.5;
			rotationMatrix = rotationMatrix * 2-1;
			uv = mul ( uv, rotationMatrix );
			uv += 0.5;
			return uv;
		}


		float2 _rotator14_g17( float speed, float2 uv )
		{
			uv -=0.5;
			float s = sin ( speed );
			float c = cos ( speed );
				           
			float2x2 rotationMatrix = float2x2( c, -s, s, c);
			rotationMatrix *=0.5;
			rotationMatrix +=0.5;
			rotationMatrix = rotationMatrix * 2-1;
			uv = mul ( uv, rotationMatrix );
			uv += 0.5;
			return uv;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
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
			float speed14_g26 = 4.0;
			float2 uv14_g26 = ( i.uv_texcoord * 2.0 );
			float2 local_rotator14_g26 = _rotator14_g26( speed14_g26 , uv14_g26 );
			float2 temp_cast_0 = (0.5).xx;
			float2 temp_cast_1 = (2.0).xx;
			float2 break10_g27 = pow( ( i.uv_texcoord - temp_cast_0 ) , temp_cast_1 );
			float cMaskC96 = saturate( ( 1.0 - pow( ( 3.75 * sqrt( ( ( 0.65 * break10_g27.x ) + ( 0.65 * break10_g27.y ) ) ) ) , 3.0 ) ) );
			float cNoiseE109 = ( pow( tex2D( _CoronaMap, local_rotator14_g26 ).r , 1.25 ) * 2.0 * cMaskC96 );
			float temp_output_30_0 = ( _DischargePanSpeed * _Time.x );
			float2 _Vector0 = float2(0,-1);
			float2 temp_output_11_0 = ( i.uv_texcoord * 2.0 );
			float2 temp_cast_2 = (1.0).xx;
			float2 temp_output_5_0_g22 = ( temp_output_11_0 - temp_cast_2 );
			float2 break15_g22 = temp_output_5_0_g22;
			float temp_output_22_0_g22 = ( -atan2( break15_g22.y , break15_g22.x ) / ( 2.0 * UNITY_PI ) );
			float ifLocalVar18_g22 = 0;
			if( -atan2( break15_g22.y , break15_g22.x ) >= 0.0 )
				ifLocalVar18_g22 = temp_output_22_0_g22;
			else
				ifLocalVar18_g22 = ( ( -atan2( break15_g22.y , break15_g22.x ) + ( 2.0 * UNITY_PI ) ) / ( 2.0 * UNITY_PI ) );
			float2 temp_cast_3 = (1.0).xx;
			float2 temp_cast_4 = (2.0).xx;
			float2 break10_g22 = pow( temp_output_5_0_g22 , temp_cast_4 );
			float2 appendResult27_g22 = (float2(( ( _DischargeTileX * 0.5 ) * ifLocalVar18_g22 ) , ( sqrt( ( break10_g22.x + break10_g22.y ) ) * ( 0.5 * _DischargeTileY ) )));
			float2 panner2 = ( temp_output_30_0 * _Vector0 + appendResult27_g22);
			float2 uvA22 = panner2;
			float cNoiseA37 = tex2D( _CoronaMap, uvA22 ).g;
			float2 temp_cast_5 = (1.0).xx;
			float2 temp_output_5_0_g18 = ( temp_output_11_0 - temp_cast_5 );
			float2 break15_g18 = temp_output_5_0_g18;
			float temp_output_22_0_g18 = ( -atan2( break15_g18.y , break15_g18.x ) / ( 2.0 * UNITY_PI ) );
			float ifLocalVar18_g18 = 0;
			if( -atan2( break15_g18.y , break15_g18.x ) >= 0.0 )
				ifLocalVar18_g18 = temp_output_22_0_g18;
			else
				ifLocalVar18_g18 = ( ( -atan2( break15_g18.y , break15_g18.x ) + ( 2.0 * UNITY_PI ) ) / ( 2.0 * UNITY_PI ) );
			float2 temp_cast_6 = (1.0).xx;
			float2 temp_cast_7 = (2.0).xx;
			float2 break10_g18 = pow( temp_output_5_0_g18 , temp_cast_7 );
			float2 appendResult27_g18 = (float2(( _DischargeTileX * ifLocalVar18_g18 ) , ( sqrt( ( break10_g18.x + break10_g18.y ) ) * _DischargeTileY )));
			float2 panner26 = ( temp_output_30_0 * _Vector0 + appendResult27_g18);
			float2 uvB23 = panner26;
			float speed14_g17 = ( _Time.x * 0.2 );
			float2 uv14_g17 = ( i.uv_texcoord * _CoronaFluidTile * 4.0 );
			float2 local_rotator14_g17 = _rotator14_g17( speed14_g17 , uv14_g17 );
			float cNoiseC48 = ( tex2D( _CoronaMap, local_rotator14_g17 ).r * _CoronaFluidInfluence );
			float cNoiseB54 = tex2D( _CoronaMap, ( uvB23 + cNoiseC48 ) ).r;
			float sStorm70 = ( pow( ( cNoiseA37 * cNoiseB54 ) , _SolarStormFalloff ) * _SolarStormPower );
			float2 temp_cast_8 = (0.5).xx;
			float2 temp_cast_9 = (2.0).xx;
			float2 break10_g24 = pow( ( i.uv_texcoord - temp_cast_8 ) , temp_cast_9 );
			float cMaskA82 = ( ( 1.0 - saturate( ( 1.0 - pow( ( 4.0 * sqrt( ( ( 1.0 * break10_g24.x ) + ( 1.0 * break10_g24.y ) ) ) ) , 3.0 ) ) ) ) * 3.5 );
			float2 temp_cast_10 = (0.5).xx;
			float2 temp_cast_11 = (2.0).xx;
			float2 break10_g25 = pow( ( i.uv_texcoord - temp_cast_10 ) , temp_cast_11 );
			float cMaskB85 = saturate( pow( ( cMaskA82 * saturate( ( 1.0 - pow( ( 2.25 * sqrt( ( ( 1.0 * break10_g25.x ) + ( 1.0 * break10_g25.y ) ) ) ) , 0.01 ) ) ) * _CoronaBoost ) , _CoronaFalloff ) );
			float2 temp_cast_12 = (1.0).xx;
			float2 temp_output_5_0_g23 = ( temp_output_11_0 - temp_cast_12 );
			float2 break15_g23 = temp_output_5_0_g23;
			float temp_output_22_0_g23 = ( -atan2( break15_g23.y , break15_g23.x ) / ( 2.0 * UNITY_PI ) );
			float ifLocalVar18_g23 = 0;
			if( -atan2( break15_g23.y , break15_g23.x ) >= 0.0 )
				ifLocalVar18_g23 = temp_output_22_0_g23;
			else
				ifLocalVar18_g23 = ( ( -atan2( break15_g23.y , break15_g23.x ) + ( 2.0 * UNITY_PI ) ) / ( 2.0 * UNITY_PI ) );
			float2 temp_cast_13 = (1.0).xx;
			float2 temp_cast_14 = (2.0).xx;
			float2 break10_g23 = pow( temp_output_5_0_g23 , temp_cast_14 );
			float2 appendResult27_g23 = (float2(( _CoronaTileX * ifLocalVar18_g23 ) , ( sqrt( ( break10_g23.x + break10_g23.y ) ) * _CoronaTileY )));
			float2 panner27 = ( ( _Time.x * _CoronaSpeed ) * _Vector0 + appendResult27_g23);
			float2 uvC24 = panner27;
			float cNoiseD57 = tex2D( _CoronaMap, uvC24 ).g;
			float corona74 = pow( ( cNoiseD57 * _CoronaAmp ) , _CoronaExp );
			float coronaAddCMaskB91 = ( cMaskB85 + corona74 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth120 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth120 = abs( ( screenDepth120 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFade ) );
			float3 ase_worldPos = i.worldPos;
			float3 normalizeResult28_g36 = normalize( ( _WorldSpaceCameraPos - ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float3 normalizeResult27_g36 = normalize( mul( float4( ase_vertexNormal , 0.0 ), unity_WorldToObject ).xyz );
			float dotResult9_g36 = dot( normalizeResult28_g36 , normalizeResult27_g36 );
			o.Emission = ( _CoronaColor * ( ( cNoiseE109 * sStorm70 ) + coronaAddCMaskB91 ) * 5.0 * cMaskB85 * saturate( distanceDepth120 ) * saturate( ( pow( abs( dotResult9_g36 ) , _EdgeFadeFalloff ) * _EdgeFadeBoost ) ) ).rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
-1763;45;1589;922;-2527.689;-404.3097;1;True;True
Node;AmplifyShaderEditor.TimeNode;43;-46.78578,1432.149;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;1.957005,1578.144;Float;False;Constant;_Float6;Float 6;10;0;Create;True;0;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-331.9664,1385.415;Float;False;Property;_CoronaFluidTile;Corona Fluid Tile;8;0;Create;True;0;0;0;False;0;False;0;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-262.9666,1496.414;Float;False;Constant;_Float5;Float 5;10;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-352.9664,1210.416;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1209.846,-185.4452;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-61.96666,1285.416;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;198.9571,1431.144;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1096.598,-44.7226;Float;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1136.38,411.4676;Float;False;Property;_CoronaTileY;Corona Tile Y;13;0;Create;True;0;0;0;False;0;False;0;0.81;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-406.8849,162.7367;Float;False;Property;_CoronaSpeed;Corona Speed;14;0;Create;True;0;0;0;False;0;False;0;0.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1139.598,220.2774;Float;False;Property;_DischargeTileY;Discharge Tile Y;5;0;Create;True;0;0;0;False;0;False;0;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-921.5986,-178.7226;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;110;382.0782,1282.758;Inherit;False;CoronaRotator;-1;;17;06e52d2d68369fb4f91c128e0a027a2b;0;2;3;FLOAT2;0,0;False;4;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-411.9775,-163.8012;Float;False;Property;_DischargePanSpeed;Discharge Pan Speed;7;0;Create;True;0;0;0;False;0;False;0;1.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1137.598,66.27739;Float;False;Property;_DischargeTileX;Discharge Tile X;6;0;Create;True;0;0;0;False;0;False;0;13.19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1130.38,317.4676;Float;False;Property;_CoronaTileX;Corona Tile X;12;0;Create;True;0;0;0;False;0;False;0;2.41;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;25;-428.8768,-76.7019;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;35;321.3644,382.0269;Float;True;Property;_CoronaMap;Corona Map;4;0;Create;True;0;0;0;False;0;False;None;68236edf1cee9c5468e7564db3dfd62e;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;19;-649.7301,233.1387;Inherit;False;PolarCoord;-1;;23;7bd33c57396bf16438e6df4f365b765b;0;3;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-121.0291,147.7325;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;706.6565,1463.148;Float;False;Property;_CoronaFluidInfluence;Corona Fluid Influence;9;0;Create;True;0;0;0;False;0;False;0;2.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;656.4333,1253.22;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;32;-136.1567,-12.55856;Float;False;Constant;_Vector0;Vector 0;7;0;Create;True;0;0;0;False;0;False;0,-1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;18;-666.8,43.65461;Inherit;False;PolarCoord;-1;;18;7bd33c57396bf16438e6df4f365b765b;0;3;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-124.6782,-128.7012;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1111.598,137.2774;Float;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-909.5986,163.2774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;27;113.7546,184.7734;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-910.5986,59.2774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;1028.656,1434.149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;26;113.7547,31.37354;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;310.6893,180.8101;Float;False;uvC;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;1192.567,1431.807;Float;False;cNoiseC;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;311.884,27.68857;Float;False;uvB;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;14;-659,-182;Inherit;False;PolarCoord;-1;;22;7bd33c57396bf16438e6df4f365b765b;0;3;2;FLOAT2;0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;1012.398,151.248;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;51;198.2472,683.6603;Inherit;False;23;uvB;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;94;1911.153,86.53137;Inherit;False;CoronaMask;-1;;24;cc04430f019e320459a73a9737a93acc;0;5;1;FLOAT2;0,0;False;3;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT;4;False;5;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;195.2472,773.6603;Inherit;False;48;cNoiseC;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;2;93.87492,-185.4563;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;406.0399,964.2058;Inherit;False;24;uvC;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;55;782.1559,939.8109;Inherit;True;Property;_TextureSample3;Texture Sample 3;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;301.1014,-183.6197;Float;False;uvA;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;432.2472,701.6603;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;81;2131.032,84.88846;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;2130.032,164.8885;Float;False;Constant;_Float7;Float 7;17;0;Create;True;0;0;0;False;0;False;3.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;2312.032,82.88846;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;1088.566,983.4199;Float;False;cNoiseD;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;50;769.2027,679.8411;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;34;613.9567,-212.7563;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;71;1303.058,-154.1981;Inherit;False;57;cNoiseD;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;1077.251,699.337;Float;False;cNoiseB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;1313.036,-62.40624;Float;False;Property;_CoronaAmp;Corona Amp;15;0;Create;True;0;0;0;False;0;False;0;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;925.507,-168.3408;Float;False;cNoiseA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;93;2478.868,203.2298;Inherit;False;CoronaMask;-1;;25;cc04430f019e320459a73a9737a93acc;0;5;1;FLOAT2;0,0;False;3;FLOAT;1;False;2;FLOAT;1;False;4;FLOAT;2.25;False;5;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;82;2462.199,77.56902;Float;False;cMaskA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;2501.866,369.6186;Float;False;Property;_CoronaBoost;Corona Boost;17;0;Create;True;0;0;0;False;0;False;0;45.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;1087.434,303.4943;Float;False;Constant;_Float8;Float 8;17;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;1309.534,-489.7766;Inherit;False;37;cNoiseA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;2723.366,321.8187;Float;False;Property;_CoronaFalloff;Corona Falloff;18;0;Create;True;0;0;0;False;0;False;0;3.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;2740.362,161.723;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;1306.934,-416.9766;Inherit;False;54;cNoiseB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;1091.333,387.9945;Float;False;Constant;_Float9;Float 9;17;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;1298.034,280.0942;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;61;1316.33,18.12283;Float;False;Property;_CoronaExp;Corona Exp;16;0;Create;True;0;0;0;False;0;False;0;2.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1533.651,-134.4329;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;1315.731,-340.3005;Float;False;Property;_SolarStormFalloff;Solar Storm Falloff;10;0;Create;True;0;0;0;False;0;False;0;2.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;86;2920.762,162.123;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;95;1913.93,289.7608;Inherit;False;CoronaMask;-1;;27;cc04430f019e320459a73a9737a93acc;0;5;1;FLOAT2;0,0;False;3;FLOAT;0.65;False;2;FLOAT;0.65;False;4;FLOAT;3.75;False;5;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;73;1704.948,-132.7858;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;111;1454.4,297.8069;Inherit;False;CoronaRotator;-1;;26;06e52d2d68369fb4f91c128e0a027a2b;0;2;3;FLOAT2;0,0;False;4;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;1547.733,-485.4765;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;1948.794,728.5995;Float;False;Constant;_Float10;Float 10;17;0;Create;True;0;0;0;False;0;False;1.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;97;1824.844,528.6859;Inherit;True;Property;_TextureSample4;Texture Sample 4;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;1313.113,-262.4738;Float;False;Property;_SolarStormPower;Solar Storm Power;11;0;Create;True;0;0;0;False;0;False;0;311.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;87;3106.396,162.7867;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;96;2155.908,288.6248;Float;False;cMaskC;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;1871.302,-134.4329;Float;False;corona;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;68;1726.229,-485.2766;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;88;3303.443,254.6575;Inherit;False;74;corona;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;85;3274.362,158.723;Float;False;cMaskB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;104;2165.643,557.2769;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;2176.425,661.5081;Float;False;Constant;_Float11;Float 11;17;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;2148.869,747.7687;Inherit;False;96;cMaskC;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;1918.995,-486.3427;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;2357.333,643.5372;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;3562.086,171.3147;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;2091.993,-491.3427;Float;False;sStorm;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;2658.189,982.3097;Float;False;Property;_DepthFade;Depth Fade;20;0;Create;True;0;0;0;False;0;False;0;2091.44;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;3717.086,164.3147;Float;False;coronaAddCMaskB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;2594.549,734.5899;Inherit;False;70;sStorm;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;2546.625,638.745;Float;False;cNoiseE;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;2826.974,671.0926;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;120;2846.189,984.3097;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;2704.772,838.8211;Inherit;False;91;coronaAddCMaskB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;64;2955.281,488.0568;Float;False;Property;_CoronaColor;Corona Color;19;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.1102939,0.7791074,1,0.053;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;114;3012.672,690.2617;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;137;3020.189,1078.31;Inherit;False;EdgeFade;1;;36;2dc743b47f4214b4e91929be3ab03f38;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;125;3046.189,980.31;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;3021.189,892.3097;Inherit;False;85;cMaskB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;3018.663,805.2752;Float;False;Constant;_Float12;Float 12;17;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;3440.2,645.1412;Inherit;False;6;6;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3669.866,590.6648;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;FORGE3D/Planets HD/Sun Corona;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0;True;False;0;True;Transparent;;Transparent;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Spherical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;41;0;39;0
WireConnection;41;1;40;0
WireConnection;41;2;42;0
WireConnection;44;0;43;1
WireConnection;44;1;45;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;110;3;41;0
WireConnection;110;4;44;0
WireConnection;19;2;11;0
WireConnection;19;3;20;0
WireConnection;19;4;21;0
WireConnection;31;0;25;1
WireConnection;31;1;29;0
WireConnection;36;0;35;0
WireConnection;36;1;110;0
WireConnection;18;2;11;0
WireConnection;18;3;8;0
WireConnection;18;4;9;0
WireConnection;30;0;28;0
WireConnection;30;1;25;1
WireConnection;17;0;16;0
WireConnection;17;1;9;0
WireConnection;27;0;19;0
WireConnection;27;2;32;0
WireConnection;27;1;31;0
WireConnection;15;0;8;0
WireConnection;15;1;16;0
WireConnection;47;0;36;1
WireConnection;47;1;46;0
WireConnection;26;0;18;0
WireConnection;26;2;32;0
WireConnection;26;1;30;0
WireConnection;24;0;27;0
WireConnection;48;0;47;0
WireConnection;23;0;26;0
WireConnection;14;2;11;0
WireConnection;14;3;15;0
WireConnection;14;4;17;0
WireConnection;94;1;76;0
WireConnection;2;0;14;0
WireConnection;2;2;32;0
WireConnection;2;1;30;0
WireConnection;55;0;35;0
WireConnection;55;1;56;0
WireConnection;22;0;2;0
WireConnection;52;0;51;0
WireConnection;52;1;53;0
WireConnection;81;0;94;0
WireConnection;78;0;81;0
WireConnection;78;1;79;0
WireConnection;57;0;55;2
WireConnection;50;0;35;0
WireConnection;50;1;52;0
WireConnection;34;0;35;0
WireConnection;34;1;22;0
WireConnection;54;0;50;1
WireConnection;37;0;34;2
WireConnection;93;1;76;0
WireConnection;82;0;78;0
WireConnection;84;0;82;0
WireConnection;84;1;93;0
WireConnection;84;2;62;0
WireConnection;99;0;76;0
WireConnection;99;1;100;0
WireConnection;72;0;71;0
WireConnection;72;1;60;0
WireConnection;86;0;84;0
WireConnection;86;1;63;0
WireConnection;95;1;76;0
WireConnection;73;0;72;0
WireConnection;73;1;61;0
WireConnection;111;3;99;0
WireConnection;111;4;103;0
WireConnection;67;0;65;0
WireConnection;67;1;66;0
WireConnection;97;0;35;0
WireConnection;97;1;111;0
WireConnection;87;0;86;0
WireConnection;96;0;95;0
WireConnection;74;0;73;0
WireConnection;68;0;67;0
WireConnection;68;1;58;0
WireConnection;85;0;87;0
WireConnection;104;0;97;1
WireConnection;104;1;105;0
WireConnection;69;0;68;0
WireConnection;69;1;59;0
WireConnection;106;0;104;0
WireConnection;106;1;107;0
WireConnection;106;2;108;0
WireConnection;89;0;85;0
WireConnection;89;1;88;0
WireConnection;70;0;69;0
WireConnection;91;0;89;0
WireConnection;109;0;106;0
WireConnection;115;0;109;0
WireConnection;115;1;113;0
WireConnection;120;0;121;0
WireConnection;114;0;115;0
WireConnection;114;1;112;0
WireConnection;125;0;120;0
WireConnection;118;0;64;0
WireConnection;118;1;114;0
WireConnection;118;2;116;0
WireConnection;118;3;119;0
WireConnection;118;4;125;0
WireConnection;118;5;137;0
WireConnection;0;2;118;0
ASEEND*/
//CHKSM=99FB3E1B8CD17AED292F6B089F16A560AF93C160