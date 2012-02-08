uniform sampler2DRect fboTex;
varying vec2 texcoord;
// downscale stage of making the bloom texture

void main(void)
{
  #define threshold log(0.1)
	const float delta = 0.001;
	vec3 col = vec3(texture2DRect(fboTex, texcoord.st));
	gl_FragColor = vec4(log(delta + dot(col, vec3(0.2126,0.7152,0.0722)))); //vec3(0.299,0.587,0.114)
	gl_FragColor.g = step(threshold,gl_FragColor.g);
}

//{
//	#define threshold log(0.1)
//	const float delta = 0.001;//0.299,0.587,0.114
//	vec3 col = vec3(texture2DRect(fboTex, texcoord.st));
//	gl_FragColor = vec4(log(delta + dot(col, vec3(0.2126, 0.7152, 0.0722))));
//	gl_FragColor.g = step(threshold,gl_FragColor.g);
//}