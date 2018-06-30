Shader "Unlit/SobelOperatorShader"
{
	Properties
	{
		
	}
	SubShader
	{
		// Settings
		Cull Off ZWrite Off ZTest Always
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
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
			v2f vert(appdata v)
			{
				v2f o;
				// clip space of the vertex
				o.pos = UnityObjectToClipPos(v.vertex);
				// texture coordinate
				o.grabPosUV = ComputeGrabScreenPos(o.pos);

			return o;
			}

			//Texture from GrabPass
			sampler2D _GrabTexture;
			//TexelSize for adding neighborpixels
			float4 _GrabTexture_TexelSize;
			

			// Fragment-Shader
			float4 frag(v2f i) : SV_Target
			{
				float4 Gx = float4(0, 0, 0, 0);
				float4 Gy = float4(0, 0, 0, 0);

				//Function to add Pixel from x Direction
				#define ADDPIXEL(weight, offset_x, offset_y) tex2D(_GrabTexture, float2(i.grabPosUV.x + _GrabTexture_TexelSize.x * offset_x, i.grabPosUV.y + _GrabTexture_TexelSize.y * offset_y)) * weight

				//Calculate Gx gradient
				//				|  1  0 -1 |
				//Gx = Sx * A = |  2  0 -2 | * A
				//				|  1  0 -1 |
				Gx += ADDPIXEL( 1, -1.0, -1.0);
				Gx += ADDPIXEL( 0,  0.0, -1.0);
				Gx += ADDPIXEL(-1,  1.0, -1.0);
				Gx += ADDPIXEL( 2, -1.0,  0.0);
				Gx += ADDPIXEL( 0,  0.0,  0.0);
				Gx += ADDPIXEL(-2,  1.0,  0.0);
				Gx += ADDPIXEL( 1, -1.0,  1.0);
				Gx += ADDPIXEL( 0,  0.0,  1.0);
				Gx += ADDPIXEL(-1,  1.0,  1.0);

				//Calculate Gy gradient
				//				|  1  2  1 |
				//Gy = Sy * A = |  0  0  0 | * A
				//				| -1 -2 -1 |
				Gy += ADDPIXEL( 1, -1.0, -1.0);
				Gy += ADDPIXEL( 2,  0.0, -1.0);
				Gy += ADDPIXEL( 1,  1.0, -1.0);
				Gy += ADDPIXEL( 0, -1.0,  0.0);
				Gy += ADDPIXEL( 0,  0.0,  0.0);
				Gy += ADDPIXEL( 0,  1.0,  0.0);
				Gy += ADDPIXEL(-1, -1.0,  1.0);
				Gy += ADDPIXEL(-2,  0.0,  1.0);
				Gy += ADDPIXEL(-1,  1.0,  1.0);

				//Calculate vectorial value G = sqrt( Gx^2 + Gy^2)
				float G = sqrt(Gx * Gx + Gy * Gy);
				
				//return Sobel Value as Color
				return float4(G, G, G, 1);
			}
			ENDCG
		}

	}
}
