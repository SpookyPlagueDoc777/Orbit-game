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
<<<<<<< Updated upstream:Scenes/UI/hud_overlay.gdshader
	vec2 uv = UV;
	vec4 base = texture(TEXTURE, uv); // whatever is behind this overlay

	// --- Vignette (soft darkening toward the edges) ---
	vec2 centered = uv - vec2(0.5);
	float dist = length(centered) * vignette_softness;
	float vignette = smoothstep(0.3, 1.0, dist) * vignette_strength;

	// --- Faint grid lines (very subtle, HUD feel) ---
	vec2 grid_uv = uv * (1.0 / (grid_size / 1000.0));
	vec2 grid_frac = abs(fract(grid_uv - 0.5) - 0.5);
	float grid_line = 1.0 - smoothstep(0.0, 0.02, min(grid_frac.x, grid_frac.y));
	float grid = grid_line * grid_opacity;

	// --- Slow scanning line sweeping top to bottom ---
	float sweep_pos = fract(TIME * scanline_speed);
	float dist_to_sweep = abs(uv.y - sweep_pos);
	float scan = smoothstep(scanline_width, 0.0, dist_to_sweep) * scanline_opacity;

	// --- Combine ---
	vec3 tinted_edge = mix(base.rgb, tint_color.rgb, vignette * 0.5);
	vec3 result = tinted_edge - vignette * 0.3; // darken edges
	result += tint_color.rgb * grid;
	result += tint_color.rgb * scan;

	COLOR = vec4(result, base.a);
}
=======
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
>>>>>>> Stashed changes:Shaders/hud_overlay.gdshader
