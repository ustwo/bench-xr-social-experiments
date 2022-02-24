// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FORGE3D/Planets HD/Sun"
{
	Properties
	{
		_SurfraceMap("Surfrace Map", 2D) = "white" {}
		_DistortionUVMap("Distortion UV Map", 2D) = "white" {}
		_DistortionUVTiling("Distortion UV Tiling", Float) = 0
		_DistortionUVSpeed("Distortion UV Speed", Float) = 0
		_SunRTiling("Sun R Tiling", Float) = 0
		_SunGTiling("Sun G Tiling", Float) = 0
		_SurfaceSpeed("Surface Speed", Float) = 0
		_DistortionFactor("Distortion Factor", Range( -1 , 1)) = 0
		TriplanarFalloff("Triplanar Falloff", Float) = 0
		_Cool("Cool", Color) = (0,0,0,0)
		_Warm("Warm", Color) = (0,0,0,0)
		_Hot("Hot", Color) = (0,0,0,0)
		_SurfaceMult("Surface Mult", Float) = 50
		_SurfacePower("Surface Power", Float) = 0
		_FlakesMult("Flakes Mult", Float) = 50
		_FlakesPower("Flakes Power", Float) = 0
		_FrenselMult("Frensel Mult", Range( 0 , 10)) = 0
		_FresnelPower("Fresnel Power", Range( 0 , 10)) = 0
		_FresnelColor("Fresnel Color", Color) = (0.4558824,0.4558824,0.4558824,1)
		_Boost("Boost", Float) = 0
		_VertexTile("Vertex Tile", Float) = 20786
		_VertexSpeed("Vertex Speed", Float) = 33
		_VertexPower("Vertex Power", Float) = 0.003
		_VertexFalloff("Vertex Falloff", Float) = 3
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma exclude_renderers xboxseries playstation switch nomrt 
		#pragma surface surf Standard keepalpha noshadow noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float3 viewDir;
		};

		uniform float _VertexFalloff;
		uniform float _VertexTile;
		uniform float _VertexSpeed;
		uniform float _VertexPower;
		uniform float4 _Cool;
		uniform float4 _Warm;
		uniform float TriplanarFalloff;
		uniform sampler2D _SurfraceMap;
		uniform float _SunGTiling;
		uniform float _SurfaceSpeed;
		uniform sampler2D _DistortionUVMap;
		uniform float _DistortionUVTiling;
		uniform float _DistortionUVSpeed;
		uniform float _DistortionFactor;
		uniform float _SurfacePower;
		uniform float _SurfaceMult;
		uniform float _SunRTiling;
		uniform float _FlakesPower;
		uniform float _FlakesMult;
		uniform float4 _Hot;
		uniform float _FresnelPower;
		uniform float _FrenselMult;
		uniform float4 _FresnelColor;
		uniform float _Boost;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 normalizeResult7_g60 = normalize( ( _WorldSpaceCameraPos - ase_worldPos ) );
			float dotResult12_g60 = dot( ase_vertexNormal , normalizeResult7_g60 );
			float4 transform4_g60 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			v.vertex.xyz += ( pow( ( 1.0 - abs( dotResult12_g60 ) ) , _VertexFalloff ) * ( sin( ( ( ( float4( ase_worldPos , 0.0 ) - transform4_g60 ) * _VertexTile ) + ( _VertexSpeed * _Time.x ) ) ) * _VertexPower ) ).xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float4 temp_cast_0 = (0.0).xxxx;
			float4 appendResult63_g57 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g57 = mul( unity_WorldToObject, appendResult63_g57 );
			float4 temp_cast_1 = (TriplanarFalloff).xxxx;
			float4 temp_output_4_0_g57 = pow( abs( temp_output_57_0_g57 ) , temp_cast_1 );
			float4 break6_g57 = temp_output_4_0_g57;
			float4 projNormal10_g57 = ( temp_output_4_0_g57 / ( break6_g57.x + break6_g57.y + break6_g57.z ) );
			float3 ase_worldPos = i.worldPos;
			float4 appendResult62_g57 = (float4(ase_worldPos , 1.0));
			float4 break26_g57 = mul( unity_WorldToObject, appendResult62_g57 );
			float2 appendResult27_g57 = (float2(break26_g57.z , break26_g57.y));
			float4 nSign18_g57 = sign( temp_output_57_0_g57 );
			float4 break20_g57 = nSign18_g57;
			float2 appendResult21_g57 = (float2(break20_g57.x , 1.0));
			float temp_output_29_0_g57 = _SunGTiling;
			float temp_output_10_0_g55 = ( _Time.y * _SurfaceSpeed );
			float2 appendResult12_g55 = (float2(temp_output_10_0_g55 , temp_output_10_0_g55));
			float4 appendResult63_g58 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g58 = mul( unity_WorldToObject, appendResult63_g58 );
			float4 temp_cast_2 = (TriplanarFalloff).xxxx;
			float4 temp_output_4_0_g58 = pow( abs( temp_output_57_0_g58 ) , temp_cast_2 );
			float4 break6_g58 = temp_output_4_0_g58;
			float4 projNormal10_g58 = ( temp_output_4_0_g58 / ( break6_g58.x + break6_g58.y + break6_g58.z ) );
			float4 appendResult62_g58 = (float4(ase_worldPos , 1.0));
			float4 break26_g58 = mul( unity_WorldToObject, appendResult62_g58 );
			float2 appendResult27_g58 = (float2(break26_g58.z , break26_g58.y));
			float4 nSign18_g58 = sign( temp_output_57_0_g58 );
			float4 break20_g58 = nSign18_g58;
			float2 appendResult21_g58 = (float2(break20_g58.x , 1.0));
			float temp_output_29_0_g58 = _DistortionUVTiling;
			float temp_output_2_0_g55 = ( _Time.y * _DistortionUVSpeed );
			float2 appendResult5_g55 = (float2(temp_output_2_0_g55 , temp_output_2_0_g55));
			float2 temp_output_65_0_g58 = appendResult5_g55;
			float2 appendResult32_g58 = (float2(break26_g58.x , break26_g58.z));
			float2 appendResult22_g58 = (float2(break20_g58.y , 1.0));
			float2 appendResult34_g58 = (float2(break26_g58.x , break26_g58.y));
			float2 appendResult25_g58 = (float2(-break20_g58.z , 1.0));
			float4 break11_g55 = ( saturate( ( ( projNormal10_g58.x * tex2D( _DistortionUVMap, ( ( appendResult27_g58 * appendResult21_g58 * temp_output_29_0_g58 ) + temp_output_65_0_g58 ) ) ) + ( projNormal10_g58.y * tex2D( _DistortionUVMap, ( ( temp_output_29_0_g58 * appendResult32_g58 * appendResult22_g58 ) + temp_output_65_0_g58 ) ) ) + ( projNormal10_g58.z * tex2D( _DistortionUVMap, ( temp_output_65_0_g58 + ( temp_output_29_0_g58 * appendResult34_g58 * appendResult25_g58 ) ) ) ) ) ) * _DistortionFactor );
			float2 appendResult13_g55 = (float2(break11_g55.r , break11_g55.g));
			float2 temp_output_15_0_g55 = ( appendResult12_g55 + appendResult13_g55 );
			float2 temp_output_65_0_g57 = temp_output_15_0_g55;
			float2 appendResult32_g57 = (float2(break26_g57.x , break26_g57.z));
			float2 appendResult22_g57 = (float2(break20_g57.y , 1.0));
			float2 appendResult34_g57 = (float2(break26_g57.x , break26_g57.y));
			float2 appendResult25_g57 = (float2(-break20_g57.z , 1.0));
			float temp_output_76_22 = saturate( ( ( projNormal10_g57.x * tex2D( _SurfraceMap, ( ( appendResult27_g57 * appendResult21_g57 * temp_output_29_0_g57 ) + temp_output_65_0_g57 ) ) ) + ( projNormal10_g57.y * tex2D( _SurfraceMap, ( ( temp_output_29_0_g57 * appendResult32_g57 * appendResult22_g57 ) + temp_output_65_0_g57 ) ) ) + ( projNormal10_g57.z * tex2D( _SurfraceMap, ( temp_output_65_0_g57 + ( temp_output_29_0_g57 * appendResult34_g57 * appendResult25_g57 ) ) ) ) ) ).g;
			float4 lerpResult12 = lerp( ( _Cool * 100.0 * _Cool.a ) , ( _Warm * 100.0 * _Warm.a ) , ( pow( temp_output_76_22 , _SurfacePower ) * _SurfaceMult ));
			float4 appendResult63_g56 = (float4((WorldNormalVector( i , float3(0,0,1) )) , 0.0));
			float4 temp_output_57_0_g56 = mul( unity_WorldToObject, appendResult63_g56 );
			float4 temp_cast_3 = (TriplanarFalloff).xxxx;
			float4 temp_output_4_0_g56 = pow( abs( temp_output_57_0_g56 ) , temp_cast_3 );
			float4 break6_g56 = temp_output_4_0_g56;
			float4 projNormal10_g56 = ( temp_output_4_0_g56 / ( break6_g56.x + break6_g56.y + break6_g56.z ) );
			float4 appendResult62_g56 = (float4(ase_worldPos , 1.0));
			float4 break26_g56 = mul( unity_WorldToObject, appendResult62_g56 );
			float2 appendResult27_g56 = (float2(break26_g56.z , break26_g56.y));
			float4 nSign18_g56 = sign( temp_output_57_0_g56 );
			float4 break20_g56 = nSign18_g56;
			float2 appendResult21_g56 = (float2(break20_g56.x , 1.0));
			float temp_output_29_0_g56 = _SunRTiling;
			float2 temp_output_65_0_g56 = temp_output_15_0_g55;
			float2 appendResult32_g56 = (float2(break26_g56.x , break26_g56.z));
			float2 appendResult22_g56 = (float2(break20_g56.y , 1.0));
			float2 appendResult34_g56 = (float2(break26_g56.x , break26_g56.y));
			float2 appendResult25_g56 = (float2(-break20_g56.z , 1.0));
			float3 normalizeResult5_g59 = normalize( float4(0,0,1,0).xyz );
			float dotResult14_g59 = dot( i.viewDir , normalizeResult5_g59 );
			o.Emission = max( temp_cast_0 , ( ( ( lerpResult12 * temp_output_76_22 ) + ( ( pow( saturate( ( ( projNormal10_g56.x * tex2D( _SurfraceMap, ( ( appendResult27_g56 * appendResult21_g56 * temp_output_29_0_g56 ) + temp_output_65_0_g56 ) ) ) + ( projNormal10_g56.y * tex2D( _SurfraceMap, ( ( temp_output_29_0_g56 * appendResult32_g56 * appendResult22_g56 ) + temp_output_65_0_g56 ) ) ) + ( projNormal10_g56.z * tex2D( _SurfraceMap, ( temp_output_65_0_g56 + ( temp_output_29_0_g56 * appendResult34_g56 * appendResult25_g56 ) ) ) ) ) ).r , _FlakesPower ) * _FlakesMult ) * _Hot * _Hot.a ) + ( ( saturate( pow( saturate( ( 1.0 - dotResult14_g59 ) ) , _FresnelPower ) ) * _FrenselMult ) * _FresnelColor ) ) * _Boost ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
-1763;45;1589;922;1606.706;452.6733;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;38;-916.4182,200.9623;Float;False;Property;_SurfacePower;Surface Power;14;0;Create;True;0;0;0;False;0;False;0;1.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;76;-1335.171,-128.1096;Inherit;False;TriplanarSun;0;;55;42e513d8602709b41bcd284c568c637f;0;0;2;FLOAT;0;FLOAT;22
Node;AmplifyShaderEditor.PowerNode;5;-663.1229,106;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1344.685,-229.3575;Float;False;Property;_FlakesPower;Flakes Power;16;0;Create;True;0;0;0;False;0;False;0;0.89;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-681,-446;Float;False;Property;_Cool;Cool;10;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4339998,0.1279998,0,0.597;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-676,-160;Float;False;Property;_Warm;Warm;11;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0.6392157,0.2509802,0.808;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-643,-257;Float;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-650.3419,220.8335;Float;False;Property;_SurfaceMult;Surface Mult;13;0;Create;True;0;0;0;False;0;False;50;27.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-430,-176;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;100;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;39;-1125.59,-435.5202;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-445.1229,107;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-412,-441;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;100;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1114.182,-243.6361;Float;False;Property;_FlakesMult;Flakes Mult;15;0;Create;True;0;0;0;False;0;False;50;29.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-965.1233,360.1252;Float;False;Property;_Hot;Hot;12;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0.4039214,0,0.1019608;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;12;-211,-286;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector4Node;37;-21.14105,161.2794;Float;False;Constant;_Vector0;Vector 0;7;0;Create;True;0;0;0;False;0;False;0,0,1,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-907.5911,-434.5202;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-654.4595,343.1888;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;12.54444,-283.3886;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;47;255.0919,52.3579;Inherit;False;Fresnel;17;;59;f8c497a0c2d6d334f8e7138f24a77d5f;0;1;22;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;540.2617,-263.6221;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;43;599.0388,-39.13812;Float;False;Property;_Boost;Boost;21;0;Create;True;0;0;0;False;0;False;0;6.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;785.4385,-380.634;Float;False;Constant;_Float0;Float 0;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;715.7163,-263.9561;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;45;956.1862,-279.6083;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;74;949.4691,-114.128;Inherit;False;VertexDistortion;22;;60;8339451d007d1194dbd86f109f7dfff2;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-204.1751,-128.4286;Float;False;Constant;_Float3;Float 3;4;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1195.855,-514.3106;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;FORGE3D/Planets HD/Sun;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;7;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;76;22
WireConnection;5;1;38;0
WireConnection;14;0;9;0
WireConnection;14;1;17;0
WireConnection;14;2;9;4
WireConnection;39;0;76;0
WireConnection;39;1;32;0
WireConnection;6;0;5;0
WireConnection;6;1;40;0
WireConnection;16;0;8;0
WireConnection;16;1;17;0
WireConnection;16;2;8;4
WireConnection;12;0;16;0
WireConnection;12;1;14;0
WireConnection;12;2;6;0
WireConnection;41;0;39;0
WireConnection;41;1;7;0
WireConnection;27;0;41;0
WireConnection;27;1;10;0
WireConnection;27;2;10;4
WireConnection;29;0;12;0
WireConnection;29;1;76;22
WireConnection;47;22;37;0
WireConnection;31;0;29;0
WireConnection;31;1;27;0
WireConnection;31;2;47;0
WireConnection;42;0;31;0
WireConnection;42;1;43;0
WireConnection;45;0;46;0
WireConnection;45;1;42;0
WireConnection;0;2;45;0
WireConnection;0;11;74;0
ASEEND*/
//CHKSM=DE7383B4DEACEC7102A066655B7E3893DAE36625