shader_type canvas_item;

// --- Tweakable uniforms (adjust live in the Inspector) ---
uniform vec4 tint_color : source_color = vec4(0.4, 0.75, 1.0, 1.0); // sci-fi blue
uniform float vignette_strength : hint_range(0.0, 1.5) = 0.6;
uniform float vignette_softness : hint_range(0.1, 2.0) = 0.8;

uniform float grid_size : hint_range(10.0, 200.0) = 60.0;
uniform float grid_opacity : hint_range(0.0, 0.3) = 0.05;

uniform float scanline_speed : hint_range(0.0, 2.0) = 0.25;
uniform float scanline_width : hint_range(0.005, 0.2) = 0.05;
uniform float scanline_opacity : hint_range(0.0, 1.0) = 0.15;

void fragment() {
	vec2 uv = UV;

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

	// --- Combine: alpha comes only from the effect strength, so anywhere
	// none of these apply is fully transparent and shows the game underneath.
	float alpha = clamp(vignette + grid + scan, 0.0, 1.0);
	COLOR = vec4(tint_color.rgb, alpha);
}
