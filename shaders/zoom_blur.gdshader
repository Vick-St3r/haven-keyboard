shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center = vec2(0.5, 0.5);
uniform float strength : hint_range(0, 2.0) = 0.1;
uniform int samples = 10;

void fragment() {
	// Called for every pixel the material is visible on.
	// zoom blur effect
	vec2 uv = SCREEN_UV;
	vec2 dir = center - uv;
	vec2 blur = dir * strength * 0.01;
	vec4 color = vec4(0.0);
	for (int i = 0; i < samples; i++) {
		color += texture(screen_texture, uv);
		uv += blur;
	}
	color /= float(samples);
	COLOR = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
