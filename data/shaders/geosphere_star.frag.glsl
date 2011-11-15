uniform float time;
//varying vec3 tnorm;
varying vec3 glpos;
void main(void)
{
//vec3 tnorm = normalize(vec3(gl_TexCoord[1]));
#ifdef DIM
	vec3 tnorm = normalize(vec3(gl_TexCoord[1]));
	vec4 diff = vec4(0.0);
	for (int i=0; i<NUM_LIGHTS; ++i) {
		float nDotVP = max(0.0, dot(tnorm, normalize(vec3(gl_LightSource[i].position))));
		diff += gl_LightSource[i].diffuse * nDotVP;
	}
#else
	vec4 diff = vec4(1.0,1.0,1.0,1.0);
#endif
  float jizm = 0.000001; //this should relate to feature size, smaller = larger
	//float poo = abs(snoise(vec4(glpos.x, glpos.y, glpos.z, time)));
	float poo = octavenoise(2, 0.01, 2.0, vec3(glpos.x, glpos.y, glpos.z), jizm, time)/2.0;
	//float poo = octavenoise(2, 0.9, 2.0, vec3(tnorm.x, tnorm.y, tnorm.z), 2.0);
	//float poo = 0.1 + abs(snoise(vec4(tnorm.x, tnorm.y, tnorm.z, time)));
	//float poo = octavenoise(2, 0.5, 2.0, gl_TexCoord[0], time);

	gl_FragColor = diff*gl_Color + gl_LightModel.ambient*gl_Color;
	gl_FragColor *= gl_FrontMaterial.emission * gl_FrontMaterial.emission * 10.0;
	gl_FragColor = vec4((1.25-poo), 0.25+poo, 0.25+poo, gl_FragColor.w);
	//gl_Position *= poo;

#ifdef ZHACK
	SetFragDepth(gl_TexCoord[6].z);
#endif
}
