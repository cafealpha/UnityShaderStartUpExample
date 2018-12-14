﻿Shader "Custom/BlinkShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_MaskTex("Mask", 2D) = "white" {}
		_RampTex("Ramp", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _MaskTex;
		sampler2D _RampTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_MaskTex;
			float2 uv_RampTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 m = tex2D(_MaskTex, IN.uv_MaskTex);
			fixed4 Ramp = tex2D(_RampTex, float2(_Time.y * 0.3, 0.5));
			o.Albedo = c.rgb;
			o.Emission = c.rgb * m.g * Ramp.r;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
