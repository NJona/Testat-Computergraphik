Shader "Computergraphics/Deformation" {
	Properties
	{
		_ColorRed("RGB Color Red", Range(0,255)) = 255
		_ColorGreen("RGB Color Green", Range(0,255)) = 0
		_ColorBlue("RGB Color Blue", Range(0,255)) = 0
	}
SubShader {
    Pass {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"

        struct appdata {
			float2 uv : TEXCOORD0;
            float4 vertex : POSITION;
			float3 normal : NORMAL;
        };

        struct v2f {
			float2 uv : TEXCOORD0;
            float4 position : SV_POSITION;
			fixed4 color : COLOR;
        };

		float4 _collisionPositionList[100];
		float _deformationTimeToLiveList[100];
		float _deformationTimeToLive;
		float _forceMultiplier;

		float _ColorRed;
		float _ColorGreen;
		float _ColorBlue;


        v2f vert (appdata v) {
            v2f o;

			float4 worldVertex = mul(unity_ObjectToWorld, v.vertex);

			float4 force = float4(0,0,0,0);

			//calculate force for each collision point and add to force sum
			for(int i=0;i<100;i++){
					float4 collisionDirection = worldVertex - _collisionPositionList[i];
					float distance = length(collisionDirection);

					float singleDeformationForce = (1 / distance) * (_deformationTimeToLiveList[i] / _deformationTimeToLive); 

					force = force + (_forceMultiplier * singleDeformationForce * collisionDirection);
			}

			float4 newWorldVertex = worldVertex + force;
			
			o.position = mul(UNITY_MATRIX_VP, newWorldVertex);

			o.color.x = v.normal * 0.5 + (_ColorRed / 255);
			o.color.y = v.normal * 0.5 + (_ColorGreen / 255);
			o.color.z = v.normal * 0.5 + (_ColorBlue / 255);
			o.color.w = 1.0;

            return o;
        }

        fixed4 frag (v2f i) : SV_Target 
		{
			return i.color;
		}
        ENDCG
    }
}
}