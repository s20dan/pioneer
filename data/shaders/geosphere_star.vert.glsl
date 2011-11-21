uniform float time;
uniform vec3 geosphereCenter;
uniform float geosphereScale;
//varying vec3 glpos;
void main(void)
{
#ifdef ZHACK
	gl_Position = logarithmicTransform();
#else
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
#endif

  float feature_size = 0.000001; //smaller numbers give a larger feature size
  //float time1 = time;
  //if (gl_Color.z > 0.99) time1 = 0;
  float col = 1.0 - clamp((gl_Color.z - 0.9)*10.0, 0.0, 1.0);
	
	gl_TexCoord[0] = gl_ModelViewMatrix * gl_Vertex;
	vec3 tnorm = gl_NormalMatrix * gl_Normal;
	gl_TexCoord[1] = vec4(tnorm.x, tnorm.y, tnorm.z, 0.0);
	vec3 glpos = gl_TexCoord[0] - geosphereCenter;
	//glpos *= normalize(gl_Vertex);
	glpos *= geosphereScale;
	//float n1a = combo_octavenoise(1, 1.45, 2.0, glpos, feature_size*0.01, time*0.35);
	float n1 = 1.0;
	n1 -= billow_octavenoise(1, 0.95, 2.0, glpos, feature_size*0.01, time*0.25)*0.025;
	n1 *= n1;
	gl_Color += clamp(n1, 0.0, 1.0) * col;
	//vec3 tempcol = gl_Color + (clamp(n1, 0.02, 1.0)*col);
	float n2 = octavenoise(1, 0.95, 2.0, gl_Color, feature_size*1000.0, time*0.3)*0.08;
	n2 = clamp(n2, 0.0, 1.0);
	//n3 += billow_octavenoise(3, 0.575, 2.0, gl_Color, feature_size*0.5, time*1.333)/4.0;
	//n4 += combo_octavenoise(3, 0.7, 2.0, gl_Color, feature_size*5.675, time*3.0)/4.0;
	gl_FrontColor = gl_Color;
	gl_FrontColor += n2 * col;
	//gl_Position *= clamp(n1a*1.5, 0.5, 1.5);
}
