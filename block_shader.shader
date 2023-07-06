shader_type canvas_item;

uniform sampler2D break_viewport;
uniform sampler2D light_viewport;

float f(float x) {
	return min(x, 1.0);
}

vec3 f3(vec3 x) {
	return vec3(f(x.x), f(x.y), f(x.z));
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= texture(break_viewport, SCREEN_UV).r;
	
	if(COLOR.a <= 0.2) discard;
	
	COLOR.rgb *= f3(texture(light_viewport, SCREEN_UV).rgb);
}