shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float scanline_count : hint_range(0.0, 1080.0) = 320.0;
uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.15;
uniform float scanline_speed : hint_range(-10.0, 10.0) = 1.0;

uniform float vignette_intensity : hint_range(0.0, 2.0) = 0.4;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;

uniform float warp_amount : hint_range(0.0, 5.0) = 0.2;
uniform float chromatic_aberration : hint_range(0.0, 0.02) = 0.0015;

vec2 warp(vec2 uv) {
	vec2 delta = uv - 0.5;
	float dist = dot(delta, delta);
	return uv + delta * dist * (warp_amount * 0.1);
}

void fragment() {
	// Screen curvature warp
	vec2 warped_uv = warp(SCREEN_UV);
	
	// Black out areas warped outside screen bounds
	if (warped_uv.x < 0.0 || warped_uv.x > 1.0 || warped_uv.y < 0.0 || warped_uv.y > 1.0) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else {
		// Chromatic Aberration sampling
		float r = texture(SCREEN_TEXTURE, warped_uv + vec2(chromatic_aberration, 0.0)).r;
		float g = texture(SCREEN_TEXTURE, warped_uv).g;
		float b = texture(SCREEN_TEXTURE, warped_uv - vec2(chromatic_aberration, 0.0)).b;
		vec3 base_color = vec3(r, g, b);
		
		// Rolling Scanlines
		float scanline = sin((warped_uv.y + TIME * scanline_speed * 0.02) * scanline_count * 3.14159);
		scanline = (scanline + 1.0) * 0.5;
		scanline = pow(scanline, 1.5);
		base_color -= scanline * scanline_intensity;
		
		// Vignette Effect
		vec2 uv_dist = warped_uv * (1.0 - warped_uv.yx);
		float vig = uv_dist.x * uv_dist.y * 15.0;
		vig = clamp(pow(vig, vignette_intensity), 0.0, 1.0);
		base_color = mix(base_color * vig, base_color, 1.0 - vignette_opacity);
		
		COLOR = vec4(base_color, 1.0);
	}
}