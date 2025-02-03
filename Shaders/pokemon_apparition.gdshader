shader_type canvas_item;

uniform vec3 color : source_color = vec3(1,0,0);
uniform float avancement : hint_range(0.0, 3.0, 0.1) = 3.0;

void fragment() {
	if (avancement <= 1.0) {
		vec3 inv_color = vec3(abs(1.0-color.x),abs(1.0-color.y),abs(1.0-color.z));
		vec3 modulation = vec3(1,1,1)-(inv_color*(1.0-pow(avancement,2)));
		COLOR.rgb = modulation;
		COLOR.a *= sqrt(avancement);
	} else {
		vec3 modulation = vec3((avancement-1.0)/2.0);
		COLOR.rgb /= modulation;
	}
}