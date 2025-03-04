shader_type canvas_item;

uniform vec3 color1 : source_color = vec3(0);
uniform vec3 color2 : source_color = vec3(1);
uniform float offset : hint_range(-1, 1, 0.05) = 0;
uniform float pixelise : hint_range(1, 1000, 1) = 1;
uniform bool generate_offset = true;
uniform float wavy : hint_range(0, 100, 2) = 0;
uniform float wave_width : hint_range(1.0, 10.0, 1.0) = 1.0;

void fragment() {
	vec2 uv = UV;
	float value = uv.y+offset;
	value += sin(uv.x*(1.0/wave_width)*90.0)*wavy/1000.0;
	if (!generate_offset) {
		if (value > 1.0) {
			value = 1.0;
		} else if (value < 0.0) {
			value = 0.0;
		}
	}
	value = floor(value*pixelise)/pixelise;
	COLOR.rgb = mix(color1,color2,value);
}