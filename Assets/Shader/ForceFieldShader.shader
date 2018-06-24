// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/ForceFieldShader"
{
	Properties
	{
		_WindSourcePosition ("Wind Source Position",Vector) = (0,0,0)
		_Color("Color",Color) = (0,0,0,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			float4 _WindSourcePosition;
			float4 _WindSourceVector;
			float4 _Color;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				float4 worldVertex = mul(unity_ObjectToWorld, v.vertex);
				float4 windDirection = worldVertex - _WindSourcePosition;
				float distance = length(worldVertex- _WindSourcePosition);

				float4 newWorldVertex = worldVertex;
				float crossProduct = dot(windDirection, -v.normal);
				float force = 1 / distance;

				newWorldVertex = worldVertex + ((1*force)*windDirection);
				


				o.vertex = mul(UNITY_MATRIX_VP, newWorldVertex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = _Color;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
