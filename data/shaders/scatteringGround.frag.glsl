//
// Atmospheric scattering fragment shader, ground version
//
// Original code: Copyright (c) 2004 Sean O'Neil
//
// http://http.developer.nvidia.com/GPUGems2/gpugems2_chapter16.html
//

varying vec4 primaryColor;
varying vec4 secondaryColor;

void main(void)
{
	//gl_FragColor = gl_Color * (0.25 * secondaryColor) + primaryColor;
	//ideally this would be blended with whatever fancy terrain rendering we want (specular, bump etc)
	gl_FragColor = primaryColor + gl_Color * secondaryColor;

#ifdef ZHACK
	SetFragDepth(gl_TexCoord[6].z);
#endif
}

