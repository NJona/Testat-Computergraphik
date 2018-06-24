Shader "Hidden/ForceFieldShader"
{
	Properties
	{
		_WindSourcePosition("Wind Source Position",Vector) = (0,0,0)
		_MainTex("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Tags{ "RenderType" = "Opaque" }
		LOD 100

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

			float4 _WindSourcePosition;
			float4 _Color;

			v2f vert(appdata_base v)
			{
				v2f o;
				//o.vertex = UnityObjectToClipPos(v.vertex);
				float4 worldVertex = mul(unity_ObjectToWorld, v.vertex);
				float4 windDirection = worldVertex - _WindSourcePosition;
				float distance = length(worldVertex - _WindSourcePosition);

				float4 newWorldVertex = worldVertex;
				float crossProduct = dot(windDirection, -v.normal);
				float force = 1 / distance;

				newWorldVertex = worldVertex + ((1 * force)*windDirection);



				o.vertex = mul(UNITY_MATRIX_VP, newWorldVertex);
				return o;
			}

			sampler2D _MainTex;

			fixed4 frag(v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}

			ENDCG
	}
	}
}
