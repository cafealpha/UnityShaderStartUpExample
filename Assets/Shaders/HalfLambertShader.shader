﻿Shader "Custom/HalfLambertShader" {
	Properties{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("NormalMap", 2D) = "bump"{}
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }

			CGPROGRAM
			#pragma surface surf CustomLambert


			sampler2D _MainTex;
			sampler2D _BumpMap;

			struct Input {
				float2 uv_MainTex;
				float2 uv_BumpMap;
			};

			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutput o) {
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
				o.Albedo = c.rgb;
				o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
				o.Alpha = c.a;
			}

			float4 LightingCustomLambert(SurfaceOutput s, float3 lightDir, float atten) {
				//노말연산
				float ndotl = dot(s.Normal, lightDir)*0.5 +0.5;
				return pow(ndotl, 3);


			}

			ENDCG
	}
		FallBack "Diffuse"
}