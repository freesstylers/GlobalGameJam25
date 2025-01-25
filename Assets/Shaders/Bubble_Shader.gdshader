shader_type spatial;

//Referencia: https://www.youtube.com/watch?v=sj4BeJKhe_Y
// https://github.com/sjvnnings/godot-bubble-shader-tutorial/blob/main/bubble_shader_tutorial/shader_bubble.shader
uniform sampler2D noise; //Ruido para la burbuja
uniform vec4 bubble_color : source_color;
uniform float alpha_bubble = -0.55;
uniform float height_multiplier = 0.2;
uniform float noise_sample_size = 0.04;
uniform float animation_speed = 0.03;
uniform float radio = 2.0;
uniform float metallic = 0.2;
uniform float roughness = 0.2;

float fresnel(vec3 normal, mat4 camera_matrix){
	vec3 view_direction_world = (camera_matrix * vec4(0.0,0.0,1.0 - alpha_bubble,0.0)).xyz;
	vec3 normal_world = (camera_matrix * vec4(normal,0.0)).xyz;
	
	float d = dot(view_direction_world, normal_world);
	d = abs(d);
	d = clamp(d, 0.0, 1.0);
	
	return 1.0 - d;
}

void vertex() {
	float height = texture(noise, VERTEX.xz * noise_sample_size + TIME * animation_speed).r * radio;
	VERTEX += NORMAL * height * height_multiplier;
}

void fragment() {
	ROUGHNESS = roughness;
	ALPHA = fresnel(NORMAL, MODEL_MATRIX) * bubble_color.a;
	ALBEDO = bubble_color.rgb;
	METALLIC = metallic;
}