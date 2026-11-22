shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec2 center = vec2(0.5, 0.5);
uniform float strength : hint_range(0, 2.0) = 0.1;
uniform float size : hint_range(0, 2.0) = 0;
uniform float thickness;

void fragment() {
	// Called for every pixel the material is visible on.
	
	// shockwave effect
	float aspect_ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(aspect_ratio, 1.0) + vec2(0.5, 0);
	float mask = (1.0 - smoothstep(size-0.3, size, length(scaledUV - center))) * smoothstep(size-thickness-0.3, size-thickness, length(scaledUV - center));
	vec2 disp = normalize(scaledUV - center) * strength * 0.1 * mask;
	COLOR = texture(screen_texture, UV-disp);
	COLOR.r = texture(screen_texture, UV-disp*1.1).r;
	COLOR.b = texture(screen_texture, UV-disp*0.9).b;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
