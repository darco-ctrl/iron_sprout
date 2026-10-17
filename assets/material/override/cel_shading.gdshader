shader_type spatial;

render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_toon;

uniform vec4 albedo : source_color;
uniform sampler2D color_gradient;
uniform sampler2D fresnel_gradient;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float basic_fresnel = fresnel(4.0, NORMAL, VIEW);
	ALBEDO = albedo.rgb + (basic_fresnel * texture(fresnel_gradient, vec2(basic_fresnel, 0.0)).rgb * 1.0);
}

void light() {
	float dotproduct = clamp(dot(NORMAL, LIGHT), -0.9, 0.9);
	
	float light_level;

	if (dotproduct < -0.3) {
		light_level = 0.02;
	}
	else if (dotproduct < 0.0) {
		light_level = 0.05;
	}
	else {
		light_level = 1.0;
	}
		
	DIFFUSE_LIGHT += light_level * LIGHT_COLOR * ATTENUATION;
}