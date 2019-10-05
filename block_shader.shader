shader_type canvas_item;

uniform sampler2D break_viewport;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.a = texture(break_viewport, SCREEN_UV).r;
}