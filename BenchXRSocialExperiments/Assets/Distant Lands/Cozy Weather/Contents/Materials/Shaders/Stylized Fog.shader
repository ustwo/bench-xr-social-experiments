// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distant Lands/Cozy/Stylized Fog"
{
	Properties
	{
		[HDR]_FogColor1("Fog Color 1", Color) = (1,0,0.8999224,1)
		[HDR]_FogColor2("Fog Color 2", Color) = (1,0,0,1)
		[HDR]_FogColor3("Fog Color 3", Color) = (1,0,0.7469492,1)
		[HDR]_FogColor4("Fog Color 4", Color) = (0,0.8501792,1,1)
		[HDR]_FogColor5("Fog Color 5", Color) = (0.164721,0,1,1)
		_ColorStart1("Color Start 1", Float) = 1
		_ColorStart2("Color Start 2", Float) = 2
		_ColorStart3("Color Start 3", Float) = 3
		_ColorStart4("Color Start 4", Float) = 4
		[HideInInspector]_SunDirection("Sun Direction", Vector) = (0,0,0,0)
		_FogDepthMultiplier("Fog Depth Multiplier", Float) = 1
		_LightFalloff("Light Falloff", Float) = 1
		LightIntensity("Light Intensity", Float) = 0
		[HDR]_LightColor("Light Color", Color) = (0,0,0,0)
		_FogSmoothness("Fog Smoothness", Float) = 0
		_FogIntensity("Fog Intensity", Float) = 1
		_FogOffset("Fog Offset", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Pass
		{
			ColorMask 0
			ZWrite On
		}

		Tags{ "RenderType" = "HeightFog"  "Queue" = "Transparent+1" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Front
		ZWrite Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float4 screenPos;
			float3 worldPos;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float4 _FogColor1;
		uniform float4 _FogColor2;
		uniform float _FogDepthMultiplier;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _ColorStart1;
		uniform float4 _FogColor3;
		uniform float _ColorStart2;
		uniform float4 _FogColor4;
		uniform float _ColorStart3;
		uniform float4 _FogColor5;
		uniform float _ColorStart4;
		uniform float4 _LightColor;
		uniform float3 _SunDirection;
		uniform half LightIntensity;
		uniform half _LightFalloff;
		uniform float _FogSmoothness;
		uniform float _FogOffset;
		uniform float _FogIntensity;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 screenColor42_g19 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,ase_grabScreenPos.xy/ase_grabScreenPos.w);
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float eyeDepth7_g19 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float temp_output_15_0_g19 = ( _FogDepthMultiplier * sqrt( eyeDepth7_g19 ) );
			float temp_output_1_0_g20 = temp_output_15_0_g19;
			float4 lerpResult28_g20 = lerp( _FogColor1 , _FogColor2 , saturate( ( temp_output_1_0_g20 / _ColorStart1 ) ));
			float4 lerpResult41_g20 = lerp( saturate( lerpResult28_g20 ) , _FogColor3 , saturate( ( ( _ColorStart1 - temp_output_1_0_g20 ) / ( _ColorStart1 - _ColorStart2 ) ) ));
			float4 lerpResult35_g20 = lerp( lerpResult41_g20 , _FogColor4 , saturate( ( ( _ColorStart2 - temp_output_1_0_g20 ) / ( _ColorStart2 - _ColorStart3 ) ) ));
			float4 lerpResult113_g20 = lerp( lerpResult35_g20 , _FogColor5 , saturate( ( ( _ColorStart3 - temp_output_1_0_g20 ) / ( _ColorStart3 - _ColorStart4 ) ) ));
			float4 temp_output_65_0_g19 = lerpResult113_g20;
			float3 hsvTorgb31_g19 = RGBToHSV( _LightColor.rgb );
			float3 hsvTorgb32_g19 = RGBToHSV( temp_output_65_0_g19.rgb );
			float3 hsvTorgb39_g19 = HSVToRGB( float3(hsvTorgb31_g19.x,hsvTorgb31_g19.y,( hsvTorgb31_g19.z * hsvTorgb32_g19.z )) );
			float3 ase_worldPos = i.worldPos;
			float3 normalizeResult5_g19 = normalize( ( ase_worldPos - _WorldSpaceCameraPos ) );
			float dotResult6_g19 = dot( normalizeResult5_g19 , _SunDirection );
			half LightMask27_g19 = saturate( pow( abs( ( (dotResult6_g19*0.5 + 0.5) * LightIntensity ) ) , _LightFalloff ) );
			float temp_output_26_0_g19 = ( temp_output_65_0_g19.a * saturate( temp_output_15_0_g19 ) );
			float4 lerpResult43_g19 = lerp( temp_output_65_0_g19 , float4( hsvTorgb39_g19 , 0.0 ) , saturate( ( LightMask27_g19 * ( 1.5 * temp_output_26_0_g19 ) ) ));
			float4 lerpResult46_g19 = lerp( screenColor42_g19 , lerpResult43_g19 , temp_output_26_0_g19);
			o.Emission = lerpResult46_g19.rgb;
			o.Alpha = saturate( ( ( 1.0 - saturate( ( ( ( ( ase_worldPos - _WorldSpaceCameraPos ).y * 0.1 ) * ( 1.0 / _FogSmoothness ) ) + ( 1.0 - _FogOffset ) ) ) ) * _FogIntensity ) );
		}

		ENDCG
	}
}
/*ASEBEGIN
Version=18912
0;1080.571;2194;606;1367.835;130.6317;1;True;False
Node;AmplifyShaderEditor.FunctionNode;209;-538.0328,149.3626;Inherit;False;Stylized Fog ASE Function;0;;19;649d2917c22fd754aa7be82b00ec0d80;0;1;58;FLOAT3;0,0,0;False;2;COLOR;0;FLOAT;56
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;;0;0;Unlit;Distant Lands/Cozy/Stylized Fog;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Front;2;False;-1;7;False;-1;False;0;False;-1;0;False;-1;True;0;Custom;0.5;True;False;1;True;Custom;HeightFog;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;20;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;0;2;209;0
WireConnection;0;9;209;56
ASEEND*/
//CHKSM=BCDB74049826BF5D0EEF07D827A76101E2DFA820