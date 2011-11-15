uniform float time;
//varying vec3 tnorm;
varying vec3 glpos;
void main(void)
{
vec3 tnorm = normalize(vec3(gl_TexCoord[1]));
#ifdef DIM
	//vec3 tnorm = normalize(vec3(gl_TexCoord[1]));
	vec4 diff = vec4(0.0);
	for (int i=0; i<NUM_LIGHTS; ++i) {
		float nDotVP = max(0.0, dot(tnorm, normalize(vec3(gl_LightSource[i].position))));
		diff += gl_LightSource[i].diffuse * nDotVP;
	}
#else
	vec4 diff = vec4(1.0,1.0,1.0,1.0);
#endif
  float feature_size = 1.0; //smaller numbers give a larger feature size
	//float poo = abs(snoise(vec4(glpos.x, glpos.y, glpos.z, time)));
	//float poo = octavenoise(2, 0.5, 2.0, glpos, feature_size, time)/2.0;
	float poo = octavenoise(3, 0.95, 2.0, tnorm, feature_size, time)/4.0;
	poo *= ridged_octavenoise(3, 0.95, 2.0, tnorm, feature_size*2.5, time*0.25)/4.0;
	poo += billow_octavenoise(3, 0.575, 2.0, tnorm, feature_size*0.5, time*1.333)/4.0;
	poo += combo_octavenoise(3, 0.7, 2.0, tnorm, feature_size*5.675, time*3.0)/4.0;
	//float poo = octavenoise(2, 0.9, 2.0, vec3(tnorm.x, tnorm.y, tnorm.z), 2.0);
	//float poo = 0.1 + abs(snoise(vec4(tnorm.x, tnorm.y, tnorm.z, time)));
	//float poo = octavenoise(2, 0.5, 2.0, gl_TexCoord[0], time);

	gl_FragColor = diff*gl_Color + gl_LightModel.ambient*gl_Color;
	gl_FragColor *= gl_FrontMaterial.emission * gl_FrontMaterial.emission;
	gl_FragColor *= vec4(clamp(0.25+poo, 0.1, 1.0), poo, poo, gl_FragColor.w);
	//gl_Position *= poo;

#ifdef ZHACK
	SetFragDepth(gl_TexCoord[6].z);
#endif
}
