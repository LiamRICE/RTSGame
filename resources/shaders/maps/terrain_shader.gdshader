shader_type spatial;
//render_mode wireframe;
//uniform vec2 uv_offset;
//uniform vec2 uv_scale;
uniform sampler2D random_noise;

uniform sampler2D terrain_diffuse;
uniform sampler2D terrain_normal_map;

uniform sampler2D grass_diffuse;
uniform sampler2D grass_normal_map;
uniform sampler2D grass_arm;

uniform sampler2D rock_diffuse;
uniform sampler2D rock_normal_map;
uniform sampler2D rock_arm;

uniform sampler2D cliff_diffuse;
uniform sampler2D cliff_normal_map;
uniform sampler2D cliff_arm;

uniform sampler2D sand_diffuse;
uniform sampler2D sand_normal_map;
uniform sampler2D sand_arm;

uniform sampler2D snow_diffuse;
uniform sampler2D snow_normal_map;
uniform sampler2D snow_arm;

void vertex() {
	// vertex shader code goes here
}

void fragment() {
	// Convert the fragment coordinate from local space to world space
	vec4 global_vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	// Calculate the weight of the overall texture versus the local texture
	float dst = distance(CAMERA_POSITION_WORLD, global_vertex.rgb);
	// Calculate the mix factor between the global texture and the local texture
	float mix_value = clamp(-0.001 * dst + 1.0, 0, 1);
	
	// Hiding texture tiling
	//texture(random_noise, UV).rgb
	
	// Grass texture albedo and mix with terrain texture
	vec3 diff = mix(texture(grass_diffuse, UV * 400.0).rgb, texture(grass_diffuse, UV * 449.0).rgb, texture(random_noise, UV * 5.0).r) * vec3(0.558, 1.288, 0.969);
	ALBEDO = mix(texture(terrain_diffuse, UV).rgb, diff, mix_value);
	//ALBEDO = texture(random_noise, UV * 5.0).rgb;
	
	// Normal mapping
	vec3 norm = mix(texture(grass_normal_map, UV * 400.0).rgb, texture(grass_normal_map, UV * 449.0).rgb, texture(random_noise, UV * 5.0).r) * 1.0;
	NORMAL_MAP = mix(texture(terrain_normal_map, UV).rgb, norm, mix_value) * 1.0;
	
	//ALBEDO = texture(diffuse, UV).xyz;
	//NORMAL_MAP = texture(normal_map, UV).xyz;
	//AO = texture(arm, UV).r;
	//ROUGHNESS = texture(arm, UV).g;
	//METALLIC = texture(arm, UV).b;
}
