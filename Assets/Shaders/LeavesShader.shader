Shader "Custom/LeavesShader" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cutoff("Cutoff", float) = 0.5
		_Move("Move", Range(0,0.5)) = 0.1
		_Timing("Timing", Range(0,5)) = 1
	}
	SubShader {
		Tags { "RenderType"="TransparentCutout" "Queue"="AlphaTest" }

		CGPROGRAM
		#pragma surface surf Lambert alphatest:_Cutoff vertex:vert addshadow

		sampler2D _MainTex;
		float _Move;
		float _Timing;

		void vert(inout appdata_full v) {
			//버텍스컬러가 지정되지 않은 경우(값이 1일때) 영향을 받지 않음
			if (v.color.g == 1 && v.color.r == 1 && v.color.b == 1)
				return;
			else 
				v.vertex.x += sin(_Time.y * _Timing)* _Move * v.color.g;
		}


		struct Input {
			float2 uv_MainTex;
			float4 color:COLOR;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			//o.Emission = IN.color.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"
}
