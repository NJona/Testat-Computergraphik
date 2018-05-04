Shader "Unlit/SepiaEffectShader"
{
	Properties
	{
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType" = "Transparent" }
		LOD 100


		// Grab the screen behind the object into _GrabTexture
		GrabPass
		{
		}


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 grabPosUV : TEXCOORD0;
			};

			// Vertex-Shader
			v2f vert (appdata v)
			{
				v2f o;
				// clip space of the vertex
				o.pos = UnityObjectToClipPos(v.vertex);
				// texture coordinate
				o.grabPosUV = ComputeGrabScreenPos(o.pos);

				return o;
			}
			
			sampler2D _GrabTexture;

			// Fragment-Shader

			fixed4 frag (v2f i) : SV_Target
			{
				// Get the Color of the Pixel from Position
				//half4 pixelColor = tex2D(_GrabTexture, float2(i.grabPosUV.x, i.grabPosUV.y));
				half4 pixelColor = tex2D(_GrabTexture, i.grabPosUV);
								
				// Convert RGB Values to Sepia Values
				float tr = 0.393*pixelColor.r + 0.769*pixelColor.g + 0.189*pixelColor.b;
				float tg = 0.349*pixelColor.r + 0.686*pixelColor.g + 0.168*pixelColor.b;
				float tb = 0.272*pixelColor.r + 0.534*pixelColor.g + 0.131*pixelColor.b;

				// Check if values are in range -> else convert
				if (tr > 255) tr = 255;
				if (tg > 255) tg = 255;
				if (tb > 255) tb = 255;

				// Create Sepia Color from Values
				float4 pixelColorSepia = float4(tr, tg, tb, pixelColor.a);
				
				// Return Sepia Color
				return pixelColorSepia;
				
			}
			ENDCG
		}
	}
}
