Shader "Hidden/LensDistortionShader"
{
	Properties
	{
		_K1("Radial Distortion K1", Range(-5,5)) = 0
		_K2("Radial Distortion K2", Range(-5,5)) = 0
		_P1("Tangential Distortion P1", Range(-5,5)) = 0
		_P2("Tangential Distortion P2", Range(-5,5)) = 0
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// "Queue"="Transparent": Draw ourselves after all opaque geometry
		// "IgnoreProjector"="True": Don't be affected by any Projectors
		// "RenderType"="Transparent": Declare RenderType as transparent
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

		// Grab the screen behind the object into Default _GrabTexture
		// https://docs.unity3d.com/Manual/SL-GrabPass.html
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
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;

				// use UnityObjectToClipPos from UnityCG.cginc to calculate 
				// the clip-space of the vertex
				o.vertex = UnityObjectToClipPos(v.vertex);

				// use ComputeGrabScreenPos function from UnityCG.cginc
				// to get the correct texture coordinate
				o.uv = ComputeGrabScreenPos(o.vertex);

				return o;
			}
			
			// define effect variables to use in Fragement Shader
			sampler2D _GrabTexture;

			float _K1;
			float _K2;
			float _P1;
			float _P2;

			fixed4 frag (v2f i) : SV_Target
			{
				//get vertex coordinates (between 0 and 1)
				float2 coords = i.uv;

				//change y coordinate direction
				coords.y = 1 - coords.y;

				//center the texture coordinates (original center 0.5/0.5 is now 0/0 and original 0/0 is now -0.5/-0.5)
				//-> you need this for the brown-conrady model to work, 
				//otherwise it would only distort in one direction, because there are no minus values
				float xu = coords.x - 0.5;
				float yu = coords.y - 0.5;

				//calculate the radius to the projection center
				float r = sqrt((xu*xu) + (yu*yu));
				float r2 = r * r;
				float r4 = r2 * r2;
				
				//Brown Conrady Model
				float xd = xu + xu * (_K1 * r2 + _K2 * r4) + (_P1 * (r2 + 2 * (xu*xu)) + 2 * _P2 * xu * yu);
				float yd = yu + yu * (_K1 * r2 + _K2 * r4) + (_P1 * (r2 + 2 * (yu*yu)) + 2 * _P2 * xu * yu);

				//re calculate the normalized coordinates
				xd = xd + 0.5;
				yd = yd + 0.5;

				//re change y coordinate direction
				yd = 1 - yd;

				//return the correct color for the calculated coordinate
				return tex2D(_GrabTexture, float2(xd, yd));
			}
			ENDCG
		}
	}
}
