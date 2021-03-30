shader_type spatial;
render_mode ambient_light_disabled;
uniform vec4 default_color : hint_color = vec4(1.0);
uniform sampler2D base_ramp : hint_albedo;
uniform bool reverse;

void light(){
	
	float total_ramp_colors = float(textureSize(base_ramp, 0).x);
	float shade_factor = 2.0 / total_ramp_colors;
	float color_pos_factor = 1.0 / total_ramp_colors;
	float color_pos = 0.0 - color_pos_factor;

	if (reverse){
		color_pos_factor = -color_pos_factor;
		color_pos = 1.0 - color_pos_factor;
	}
	
	float NdotL = dot(NORMAL, LIGHT);
	vec4 selected_color = default_color.rgba;

	for(float shadeValue = -1.0; shadeValue <= 1.0; shadeValue = shadeValue + shade_factor) {
		
		if (NdotL >= shadeValue && NdotL < shadeValue + shade_factor) {
			selected_color = texture(base_ramp, vec2(color_pos + color_pos_factor, 0)).rgba;
			color_pos = 0.0 - color_pos_factor;
			break;
		}
		else {
			color_pos = color_pos + color_pos_factor;
		}
	}

	DIFFUSE_LIGHT += selected_color.rgb;

}