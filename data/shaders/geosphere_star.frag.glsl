uniform float time;
void main(void)
{
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

	float poo = abs(snoise(vec4(gl_TexCoord[0].x, gl_TexCoord[1].y, gl_TexCoord[2].z, time)));

	gl_FragColor = diff*gl_Color + gl_LightModel.ambient*gl_Color;
	gl_FragColor *= gl_FrontMaterial.emission * gl_FrontMaterial.emission * 10.0;
	gl_FragColor *= poo;

#ifdef ZHACK
	SetFragDepth(gl_TexCoord[6].z);
#endif
}
