uniform float time;
void main(void)
{
#ifdef ZHACK
	gl_Position = logarithmicTransform();
#else
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
#endif
	gl_PointSize = 0.3 + 5.0*gl_Color.x*gl_Color.y*gl_Color.z;
	gl_FrontColor = gl_Color;
}

