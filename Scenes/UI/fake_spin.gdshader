shader_type canvas_item;

uniform float speed : hint_range(-10.0, 10.0) = 1.0;
uniform float frequency : hint_range(0.1, 5.0) = 1.0;
uniform bool sphere_mode = false;
uniform float edge_shadow : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	// Center the UVs from -1.0 to 1.0
	vec2 uv = UV * 2.0 - 1.0;
	
	// Calculate depth map based on mode (Cylinder vs Sphere)
	float d = sphere_mode ? dot(uv, uv) : uv.x * uv.x;
	
	// If we are outside the fake 3D shape, discard or make transparent
	if (d > 1.0) {
		discard;
	}
	
	// Map flat UVs to a curved surface
	vec2 curved_uv = uv;
	curved_uv.x = asin(uv.x) / (3.14159265 / 2.0);
	if (sphere_mode) {
		curved_uv.y = asin(uv.y) / (3.14159265 / 2.0);
	}
	
	// Bring UVs back to 0.0 - 1.0 range and apply movement over time
	vec2 final_uv = curved_uv * 0.5 + 0.5;
	final_uv.x = fract(final_uv.x * frequency + TIME * speed);
	
	// Sample the texture
	vec4 tex_color = texture(TEXTURE, final_uv);
	
	// Add a simple vignette/shadow at the edges to give a lighting illusion
	float lighting = 1.0 - (d * edge_shadow);
	tex_color.rgb *= lighting;
	
	COLOR = tex_color;
}