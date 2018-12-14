Shader "Custom/FresnelToonShader" {
	Properties{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("NormalMap", 2D) = "bump" {}
	}
	SubShader{
		Tags { "RenderType" = "Opaque" }

		cull back
		//2nd Pass
		CGPROGRAM
		#pragma surface surf Toon

		sampler2D _MainTex;
		sampler2D _BumpMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		float4 LightingToon(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten) {
			float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;

			if (ndotl > 0.7)
			{
				ndotl = 1;
			}
			else
			{
				ndotl = 0.3;
			}
			
			//림라이트 연산
			float rim = dot(s.Normal, viewDir);
			if (rim > 0.3)
			{
				rim = 1;
			}
			else
			{
				rim = -1;
			}


			float4 final;
			final.rgb = s.Albedo * ndotl * _LightColor0.rgb *rim;
			final.a = s.Alpha;

			return final;
		}


		ENDCG
	}
	FallBack "Diffuse"
}
