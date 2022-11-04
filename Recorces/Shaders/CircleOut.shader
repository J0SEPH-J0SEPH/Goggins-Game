shader_type canvas_item;

uniform vec2 center;

uniform float size;
float Circle(vec2 cords, vec2 Centure, float Radius){
	
	
	return step(Radius,length(cords+Centure));
}

void fragment(){
	float ratio = SCREEN_PIXEL_SIZE.x/SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5,0.0))/vec2(ratio,1.0)+vec2(0.5,0.0);
	
	float circle = Circle(scaledUV,center,size);
	vec4 color = textureLod(SCREEN_TEXTURE,SCREEN_UV, 0.0);
	
	color.rgb -= vec3(circle);
	
	
	COLOR = color;
}