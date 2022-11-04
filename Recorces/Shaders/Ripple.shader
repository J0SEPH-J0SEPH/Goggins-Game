shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform float size;
uniform float Power;
void fragment(){
	//float usize = sin(TIME);
	float ratio = SCREEN_PIXEL_SIZE.x/SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5,0.0))/vec2(ratio,1.0)+vec2(0.5,0.0);
	float mask = (1.0-smoothstep(size-0.1, size,length(scaledUV - center)))*
	smoothstep(size-0.3, size-0.05,length(scaledUV - center))*Power;
	
	vec2 disp = normalize(scaledUV-center) * force*mask;	
	COLOR = textureLod(SCREEN_TEXTURE,SCREEN_UV-disp, 0.0);
	//COLOR.rgb = vec3(mask);
}

