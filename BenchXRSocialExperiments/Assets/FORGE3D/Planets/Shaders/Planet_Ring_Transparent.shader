// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FORGE3D/Planets HD/Ring Transparent"
{
	Properties
	{
		_DetailMap("Detail Map", 2D) = "white" {}
		_RingTint("Ring Tint", Color) = (0,0,0,0)
		_RingSize("Ring Size", Float) = 0
		_RingOffset("Ring Offset", Float) = 0
		_ShadowVertex("Shadow Vertex", Float) = 1
		_ShadowPenumbra("Shadow Penumbra", Range( 0 , 1)) = 0
		_Specular("Specular", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma exclude_renderers xboxseries playstation switch nomrt 
		#pragma surface surf StandardSpecular alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
		};

		uniform sampler2D _DetailMap;
		uniform float _RingOffset;
		uniform float _RingSize;
		uniform float4 _RingTint;
		uniform float _ShadowPenumbra;
		uniform float _ShadowVertex;
		uniform float _Specular;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float temp_output_14_0 = ( _RingOffset + 1.0 );
			float4 appendResult18 = (float4(( ( length( ase_vertex3Pos ) - temp_output_14_0 ) / ( _RingSize - temp_output_14_0 ) ) , 0.5 , 0.0 , 0.0));
			float4 tex2DNode1 = tex2D( _DetailMap, appendResult18.xy );
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_objectlightDir = normalize( ObjSpaceLightDir( ase_vertex4Pos ) );
			float3 normalizeResult65 = normalize( ase_objectlightDir );
			float3 temp_output_68_0 = ( ase_vertex3Pos * _ShadowVertex );
			float smoothstepResult42 = smoothstep( ( 1.0 - _ShadowPenumbra ) , ( _ShadowPenumbra + 1.0 ) , length( cross( normalizeResult65 , temp_output_68_0 ) ));
			float dotResult44 = dot( temp_output_68_0 , normalizeResult65 );
			o.Albedo = ( tex2DNode1 * _RingTint * saturate( ( smoothstepResult42 + saturate( dotResult44 ) ) ) ).rgb;
			float3 temp_cast_2 = (_Specular).xxx;
			o.Specular = temp_cast_2;
			o.Smoothness = _Smoothness;
			o.Alpha = ( tex2DNode1 * _RingTint.a ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
-1763;45;1589;922;860.297;413.201;1;True;True
Node;AmplifyShaderEditor.PosVertexDataNode;39;-2972.637,191.145;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;69;-2977.334,340.8945;Float;False;Property;_ShadowVertex;Shadow Vertex;4;0;Create;True;0;0;0;False;0;False;1;0.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;98;-2895.781,-152.0755;Inherit;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2497.563,218.4417;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;65;-2507.397,58.63863;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;10;-2235.599,-418.8001;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-2004.199,-333.6001;Float;False;Property;_RingOffset;Ring Offset;3;0;Create;True;0;0;0;False;0;False;0;7.89;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;11;-2000.599,-417.8001;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1841.2,-213.6001;Float;False;Property;_RingSize;Ring Size;2;0;Create;True;0;0;0;False;0;False;0;5.99;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-1829.2,-326.6001;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2404.442,-137.7912;Float;False;Property;_ShadowPenumbra;Shadow Penumbra;5;0;Create;True;0;0;0;False;0;False;0;0.024;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;40;-2204.26,140.5096;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-2078.857,-154.7905;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;41;-2010.556,136.6095;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;44;-2201.656,257.509;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-1636.2,-204.6001;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-1634.2,-379.6001;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-2077.556,-55.49046;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;17;-1349.2,-249.6001;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;42;-1780.55,119.6089;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;46;-1981.349,265.3089;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1447.051,131.2084;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-1211.2,-249.6001;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;47;-746.5491,132.3083;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1021.099,-70.7;Float;False;Property;_RingTint;Ring Tint;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1023,-275;Inherit;True;Property;_DetailMap;Detail Map;0;0;Create;True;0;0;0;False;0;False;-1;None;8214250b6feeb994ab7f79609ac0579a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;79;-1998.853,545.8279;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;24;-1776.287,441.7041;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-565,-293;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;97;-2905.722,20.99105;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;21;-2250.488,397.5041;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;59;-1606.13,439.8143;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-333.1848,-144.5138;Float;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-553.7997,-108.4;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;78;-2280.092,554.8906;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;94;-332.5421,-218.3771;Float;False;Property;_Specular;Specular;6;0;Create;True;0;0;0;False;0;False;0;0.205;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;54;-33.14049,-286.0647;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;FORGE3D/Planets HD/Ring Transparent;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.1;True;False;0;False;Transparent;;Transparent;All;14;d3d9;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;68;0;39;0
WireConnection;68;1;69;0
WireConnection;65;0;98;0
WireConnection;11;0;10;0
WireConnection;14;0;4;0
WireConnection;40;0;65;0
WireConnection;40;1;68;0
WireConnection;35;1;49;0
WireConnection;41;0;40;0
WireConnection;44;0;68;0
WireConnection;44;1;65;0
WireConnection;16;0;3;0
WireConnection;16;1;14;0
WireConnection;15;0;11;0
WireConnection;15;1;14;0
WireConnection;37;0;49;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;42;0;41;0
WireConnection;42;1;35;0
WireConnection;42;2;37;0
WireConnection;46;0;44;0
WireConnection;43;0;42;0
WireConnection;43;1;46;0
WireConnection;18;0;17;0
WireConnection;47;0;43;0
WireConnection;1;1;18;0
WireConnection;79;0;78;0
WireConnection;24;0;21;0
WireConnection;24;1;79;0
WireConnection;8;0;1;0
WireConnection;8;1;2;0
WireConnection;8;2;47;0
WireConnection;59;0;24;0
WireConnection;9;0;1;0
WireConnection;9;1;2;4
WireConnection;54;0;8;0
WireConnection;54;3;94;0
WireConnection;54;4;95;0
WireConnection;54;9;9;0
ASEEND*/
//CHKSM=DBC98F74266F3A80217FBF6EE499931EDD53EE93