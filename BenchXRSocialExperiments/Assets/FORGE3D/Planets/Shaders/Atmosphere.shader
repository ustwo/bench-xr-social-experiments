// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FORGE3D/Planets HD/Atmosphere"
{
	Properties
	{
		_AtmosphereSample("Atmosphere Sample", 2D) = "black" {}
		_ScatteringOffset("Scattering Offset", Float) = 0
		_ScatteringColor("Scattering Color", Color) = (0,0,0,0)
		_ScatteringIntensity("Scattering Intensity", Float) = 0
		_ScatteringFactor("Scattering Factor", Float) = 0
		_GlowOffset("Glow Offset", Float) = 0
		_GlowColor("Glow Color", Color) = (0,0,0,0)
		_GlowIntensity("Glow Intensity", Float) = 0
		_GlowFactor("Glow Factor", Float) = 0
		_LightExp("Light Exp", Float) = 0
		_LightMultiply("Light Multiply", Float) = 0
		_VertexOffset("Vertex Offset", Float) = 0
		_UVOffset("UV Offset", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "ForceNoShadowCasting" = "True" }
		Cull Back
		ZWrite Off
		Blend One One
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma exclude_renderers xboxseries playstation switch nomrt 
		#pragma surface surf StandardCustomLighting keepalpha noshadow nofog vertex:vertexDataFunc 
		struct Input
		{
			float3 worldNormal;
			float3 worldPos;
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

		uniform float _VertexOffset;
		uniform float _ScatteringOffset;
		uniform float _ScatteringFactor;
		uniform float _ScatteringIntensity;
		uniform sampler2D _AtmosphereSample;
		uniform float _UVOffset;
		uniform float4 _ScatteringColor;
		uniform float _GlowOffset;
		uniform float _GlowFactor;
		uniform float4 _GlowColor;
		uniform float _GlowIntensity;
		uniform float _LightMultiply;
		uniform float _LightExp;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( _VertexOffset * ase_vertexNormal * 0.1 );
			v.vertex.w = 1;
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
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float4 transform111 = mul(unity_ObjectToWorld,float4( ase_vertexNormal , 0.0 ));
			float4 normalizeResult110 = normalize( transform111 );
			float4 normalDirection114 = normalizeResult110;
			float3 ase_worldPos = i.worldPos;
			float3 normalizeResult46 = normalize( ( _WorldSpaceCameraPos - ase_worldPos ) );
			float3 viewDirection115 = normalizeResult46;
			float dotResult34 = dot( normalDirection114 , float4( viewDirection115 , 0.0 ) );
			float ndv117 = dotResult34;
			float temp_output_122_0 = abs( ndv117 );
			float offsetScattering129 = saturate( ( ( ( _ScatteringOffset / 10.0 ) + temp_output_122_0 ) * 1000.0 ) );
			float4 scatterMap137 = ( offsetScattering129 * pow( ( 1.0 - saturate( ndv117 ) ) , _ScatteringFactor ) * _ScatteringIntensity * ( tex2D( _AtmosphereSample, ( _UVOffset + (saturate( ndv117 )).xx ) ) * _ScatteringColor ) );
			float offsetInnerRing130 = saturate( ( ( temp_output_122_0 + ( _GlowOffset / 10.0 ) ) * 1000.0 ) );
			float4 innerRing158 = ( offsetInnerRing130 * saturate( ( pow( ( 1.0 - saturate( ndv117 ) ) , _GlowFactor ) * _GlowColor * _GlowIntensity ) ) );
			float3 normalizeResult355 = normalize( _WorldSpaceLightPos0.xyz );
			float3 normalizeResult333 = normalize( ( _WorldSpaceLightPos0.xyz - ase_worldPos ) );
			float3 lerpResult354 = lerp( normalizeResult355 , normalizeResult333 , _WorldSpaceLightPos0.w);
			float dotResult311 = dot( float4( lerpResult354 , 0.0 ) , normalDirection114 );
			float dotResult364 = dot( -lerpResult354 , viewDirection115 );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			c.rgb = ( ( scatterMap137 + innerRing158 ) * saturate( pow( saturate( ( dotResult311 + ( max( dotResult364 , -0.22 ) * _LightMultiply ) ) ) , _LightExp ) ) * ase_lightAtten * ase_lightColor ).rgb;
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
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
-1763;45;1589;922;1042.519;1255.152;1;True;True
Node;AmplifyShaderEditor.NormalVertexDataNode;31;-1751.394,-345.0524;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;42;-1428.635,-12.24866;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;41;-1505.651,-165.6768;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;111;-1343.809,-342.413;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;43;-1168.277,-171.1259;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;46;-991.0186,-169.7245;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;110;-1089.411,-341.1152;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-797.7698,-174.7919;Float;False;viewDirection;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-891.7585,-347.1782;Float;False;normalDirection;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;34;-530.4116,-307.9989;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;331;1054.863,13.47795;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightPos;327;1006.54,-100.5018;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;117;-374.901,-313.226;Float;False;ndv;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-1158.017,-1277.134;Float;False;Property;_GlowOffset;Glow Offset;6;0;Create;True;0;0;0;False;0;False;0;-5.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;329;1330.449,-95.50182;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-1131.808,-1395.107;Inherit;False;117;ndv;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-1193.986,-1503.918;Float;False;Property;_ScatteringOffset;Scattering Offset;2;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;127;-934.631,-1272.98;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;120;-940.0937,-1500.464;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;122;-936.6398,-1389.927;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;355;1329.835,5.907329;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-863.1373,-893.4591;Inherit;False;117;ndv;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;149;1384.946,-672.9391;Inherit;False;117;ndv;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;333;1495.84,-89.85937;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;-776.9139,-1499.8;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;-777.6435,-1295.815;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;150;1593.393,-663.5354;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;132;-670.4704,-890.6049;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;354;1722.259,14.81726;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;363;1941.315,475.804;Inherit;False;115;viewDirection;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-612.7917,-1299.242;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1000;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;362;2028.436,370.0004;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwizzleNode;134;-510.9852,-892.9006;Inherit;False;FLOAT2;0;0;0;0;1;0;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-615.6324,-1500.227;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1000;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-31.28495,-1093.581;Inherit;False;117;ndv;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-661.1508,-974.5331;Float;False;Property;_UVOffset;UV Offset;14;0;Create;True;0;0;0;False;0;False;0;-0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;1731.312,-578.903;Float;False;Property;_GlowFactor;Glow Factor;9;0;Create;True;0;0;0;False;0;False;0;5.91;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;152;1751.686,-661.9682;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;364;2251.315,409.804;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;140;155.9432,-1091.327;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;286;-262.8643,-912.9684;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;348;1715.703,-310.1353;Float;False;Property;_GlowIntensity;Glow Intensity;8;0;Create;True;0;0;0;False;0;False;0;140.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;71;-404.2535,-1121.702;Float;True;Property;_AtmosphereSample;Atmosphere Sample;1;0;Create;True;0;0;0;False;0;False;None;e85c7b15423b01f43802d942f0d51b5e;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SaturateNode;222;-451.6105,-1296.544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;221;-459.6105,-1504.544;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;148;1711.763,-492.9884;Float;False;Property;_GlowColor;Glow Color;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;151;1949.161,-661.9678;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;-268.2319,-1302.523;Float;False;offsetInnerRing;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;142;280.3493,-1004.899;Float;False;Property;_ScatteringFactor;Scattering Factor;5;0;Create;True;0;0;0;False;0;False;0;3.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-280.0859,-1511.034;Float;False;offsetScattering;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;133;-98.07889,-914.1974;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;135;-53.5234,-707.9404;Float;False;Property;_ScatteringColor;Scattering Color;3;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4485293,0.612069,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;378;2404.456,394.235;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-0.22;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;2130.964,-660.4008;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;141;325.5256,-1089.4;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;310;1656.235,126.7505;Inherit;False;114;normalDirection;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;287;2230.955,553.2716;Float;False;Property;_LightMultiply;Light Multiply;11;0;Create;True;0;0;0;False;0;False;0;0.81;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;156;2298.66,-660.4008;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;446.5261,-1191.969;Inherit;False;129;offsetScattering;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;138;522.2397,-1092.895;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;367;2558.613,463.608;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.7;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;154;2218.732,-741.8987;Inherit;False;130;offsetInnerRing;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;311;1897.617,6.968979;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;522.897,-995.204;Float;False;Property;_ScatteringIntensity;Scattering Intensity;4;0;Create;True;0;0;0;False;0;False;0;85.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;232.1744,-910.3549;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;779.167,-1115.728;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;2500.839,-685.4773;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;370;2754.363,415.1484;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;377;2922.929,425.277;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;376;2912.691,531.2031;Float;False;Property;_LightExp;Light Exp;10;0;Create;True;0;0;0;False;0;False;0;2.21;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;936.0646,-1121.423;Float;False;scatterMap;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;2665.401,-690.1792;Float;False;innerRing;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;341;4049.514,38.13691;Inherit;False;158;innerRing;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;282;4040.459,-36.57463;Inherit;False;137;scatterMap;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;366;3112.211,423.1661;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;375;4185.936,313.824;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;371;3286.979,426.5699;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;374;4242.53,151.3441;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;382;4625.409,471.2952;Float;False;Constant;_Float1;Float 1;15;0;Create;True;0;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;372;4314.599,-13.49811;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;379;4606.409,246.2952;Float;False;Property;_VertexOffset;Vertex Offset;13;0;Create;True;0;0;0;False;0;False;0;0.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;380;4594.409,326.2952;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;73;2655.02,-351.5208;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;340;3908.885,-284.6493;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;357;3467.255,-156.1462;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;381;4839.409,268.2952;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;359;2211.655,8.919382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;358;2038.418,-58.93605;Float;False;Property;_ndl;ndl;12;0;Create;True;0;0;0;False;0;False;0;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;356;2517.327,3.802345;Float;False;ndl;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;351;2339.858,9.880451;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;373;4481.82,57.15957;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;279;3887.043,-157.0501;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToTangentMatrix;297;2181.422,-296.0797;Inherit;False;0;1;FLOAT3x3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;2469.622,-269.4796;Inherit;False;2;2;0;FLOAT3x3;0,0,0,0,1,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;300;2643.022,-265.0795;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;3687.279,-205.9179;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomStandardSurface;67;2828.461,-345.3569;Inherit;False;Specular;Tangent;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;281;4062.918,-159.228;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;299;2171.022,-223.6796;Inherit;False;114;normalDirection;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4985.299,-161.6906;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;FORGE3D/Planets HD/Atmosphere;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;True;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;2;False;-1;2;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;False;-1;1;False;-1;0;5;False;-1;10;False;-1;0;False;-1;2;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;111;0;31;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;46;0;43;0
WireConnection;110;0;111;0
WireConnection;115;0;46;0
WireConnection;114;0;110;0
WireConnection;34;0;114;0
WireConnection;34;1;115;0
WireConnection;117;0;34;0
WireConnection;329;0;327;1
WireConnection;329;1;331;0
WireConnection;127;0;125;0
WireConnection;120;0;119;0
WireConnection;122;0;118;0
WireConnection;355;0;327;1
WireConnection;333;0;329;0
WireConnection;123;0;120;0
WireConnection;123;1;122;0
WireConnection;126;0;122;0
WireConnection;126;1;127;0
WireConnection;150;0;149;0
WireConnection;132;0;131;0
WireConnection;354;0;355;0
WireConnection;354;1;333;0
WireConnection;354;2;327;2
WireConnection;128;0;126;0
WireConnection;362;0;354;0
WireConnection;134;0;132;0
WireConnection;124;0;123;0
WireConnection;152;0;150;0
WireConnection;364;0;362;0
WireConnection;364;1;363;0
WireConnection;140;0;139;0
WireConnection;286;0;285;0
WireConnection;286;1;134;0
WireConnection;222;0;128;0
WireConnection;221;0;124;0
WireConnection;151;0;152;0
WireConnection;151;1;153;0
WireConnection;130;0;222;0
WireConnection;129;0;221;0
WireConnection;133;0;71;0
WireConnection;133;1;286;0
WireConnection;378;0;364;0
WireConnection;155;0;151;0
WireConnection;155;1;148;0
WireConnection;155;2;348;0
WireConnection;141;0;140;0
WireConnection;156;0;155;0
WireConnection;138;0;141;0
WireConnection;138;1;142;0
WireConnection;367;0;378;0
WireConnection;367;1;287;0
WireConnection;311;0;354;0
WireConnection;311;1;310;0
WireConnection;136;0;133;0
WireConnection;136;1;135;0
WireConnection;147;0;145;0
WireConnection;147;1;138;0
WireConnection;147;2;143;0
WireConnection;147;3;136;0
WireConnection;157;0;154;0
WireConnection;157;1;156;0
WireConnection;370;0;311;0
WireConnection;370;1;367;0
WireConnection;377;0;370;0
WireConnection;137;0;147;0
WireConnection;158;0;157;0
WireConnection;366;0;377;0
WireConnection;366;1;376;0
WireConnection;371;0;366;0
WireConnection;372;0;282;0
WireConnection;372;1;341;0
WireConnection;340;0;288;0
WireConnection;381;0;379;0
WireConnection;381;1;380;0
WireConnection;381;2;382;0
WireConnection;359;0;311;0
WireConnection;359;1;358;0
WireConnection;356;0;351;0
WireConnection;351;0;359;0
WireConnection;373;0;372;0
WireConnection;373;1;371;0
WireConnection;373;2;374;0
WireConnection;373;3;375;0
WireConnection;279;0;340;0
WireConnection;298;0;297;0
WireConnection;298;1;299;0
WireConnection;300;0;298;0
WireConnection;288;1;357;0
WireConnection;67;0;73;0
WireConnection;67;1;300;0
WireConnection;281;0;279;0
WireConnection;0;13;373;0
WireConnection;0;11;381;0
ASEEND*/
//CHKSM=93756DE62C05DD49CCB2D8F573B169BE5E896DE8