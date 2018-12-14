Shader "Custom/HoloShader" {
	Properties{
		_BumpMap("NormalMap", 2D) = "white" {}
	}
		SubShader{
			Tags { "RenderType" = "Opaque" "Queue"="Transparent"}

			CGPROGRAM
			#pragma surface surf nolight noambient alpha:fade

			sampler2D _BumpMap;

			struct Input {
				float2 uv_BumpMap;
				float3 viewDir;
				float3 worldPos;
			};

			fixed4 _Color;

			void surf(Input IN, inout SurfaceOutput o) {
				o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
				o.Emission = float3(0, 1, 0);
				float rim = saturate(dot(o.Normal, IN.viewDir));
				//o.Albedo = c.rgb;
				//o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
				rim = pow(1 - rim, 3) + pow(frac(IN.worldPos.g * 3 - _Time.y), 30);
				//o.Emission = pow(1 - rim, _RimPower) * _RimColor.rgb;
				o.Alpha = rim;
			}

			float4 Lightingnolight(SurfaceOutput s, float3 lightDir, float atten) {
				return float4(0, 0, 0, s.Alpha);
			}

			ENDCG
		}
			FallBack "Transparent/Diffuse"
}
