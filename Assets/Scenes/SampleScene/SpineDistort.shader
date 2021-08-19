Shader "Unlit/SpineDistort"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap("Pixel snap", Float) = 0
	}

		SubShader
		{
			Tags
			{
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
				"PreviewType" = "Plane"
				"CanUseSpriteAtlas" = "True"
			}

			Cull Off
			Lighting Off
			ZWrite Off
			Blend One OneMinusSrcAlpha

			Pass
			{
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile _ PIXELSNAP_ON
				#include "UnityCG.cginc"

				struct appdata_t
				{
					float4 vertex   : POSITION;
					float4 color    : COLOR;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float4 vertex   : SV_POSITION;
					fixed4 color : COLOR;
					float2 uv  : TEXCOORD0;
				};

				fixed4 _Color;
				fixed4 _MainTex_ST;
				float _angle = 60;

				v2f vert(appdata_t v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					o.color = v.color * _Color;
					#ifdef PIXELSNAP_ON
					o.vertex = UnityPixelSnap(o.vertex);
					#endif
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);

					fixed radian = _angle / 180 * 3.14159;
					fixed cosTheta = cos(radian);
					fixed sinTheta = sin(radian);

					half2 center = half2(0, -0.5);
					v.vertex.zy -= center;

					half z = v.vertex.z * cosTheta - v.vertex.y * sinTheta;
					half y = v.vertex.z * sinTheta + v.vertex.y * cosTheta;
					v.vertex = half4(v.vertex.x, y, z, v.vertex.w);

					v.vertex.zy += center;

					float4 pos = UnityObjectToClipPos(v.vertex);
					o.vertex.z = pos.z / pos.w * o.vertex.w;

					return o;
				}

				sampler2D _MainTex;
				sampler2D _AlphaTex;
				float _AlphaSplitEnabled;

				fixed4 SampleSpriteTexture(float2 uv)
				{
					fixed4 color = tex2D(_MainTex, uv);

	#if UNITY_TEXTURE_ALPHASPLIT_ALLOWED
					if (_AlphaSplitEnabled)
						color.a = tex2D(_AlphaTex, uv).r;
	#endif //UNITY_TEXTURE_ALPHASPLIT_ALLOWED

					return color;
				}

				fixed4 frag(v2f IN) : SV_Target
				{
					fixed4 c = SampleSpriteTexture(IN.uv) * IN.color;
					c.rgb *= c.a;
					return c;
				}
			ENDCG
			}
		}
}
