shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec3 color_light : source_color = vec3(0.42, 0.60, 0.18);
uniform vec3 color_dark : source_color = vec3(0.14, 0.28, 0.08);
uniform float noise_scale = 6.0;
uniform float roughness_val : hint_range(0.0, 1.0) = 0.9;

varying vec2 world_xz;

void vertex() {
    world_xz = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xz;
}

// cheap hash-based value noise, no texture needed
float hash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.13);
    p3 += dot(p3, p3.yzx + 3.333);
    return fract((p3.x + p3.y) * p3.z);
}
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    // layer two noise scales so it doesn't look like a uniform grid
    float n = noise(world_xz * noise_scale);
    n += 0.5 * noise(world_xz * noise_scale * 2.7);
    n /= 1.5;

    ALBEDO = mix(color_dark, color_light, n);
    ROUGHNESS = roughness_val;
}