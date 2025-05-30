shader_type canvas_item;

uniform float spawn_anim : hint_range(0.0, 3.0, 0.1) = 3.0;
uniform float offset : hint_range(0.0, 1.0) = 0.0;
uniform float death_animation : hint_range(0.0, 100.0) = 0.0;
uniform bool is_client;
uniform int status : hint_range(0, 6) = 0;
uniform float raise_alpha : hint_range(0, 200, 1) = 0.0;
uniform bool is_raise = true;
uniform bool is_confused = false;

const vec3 apparition_color = vec3(1,0,0);
const float status_alpha = 0.3;
const vec3 burned_color = vec3(1,0.4,0);
const vec3 frozen_color = vec3(0,1,1);
const vec3 paralyzed_color = vec3(1,1,0);
const vec3 poisoned_color = vec3(0.5,0,0.5);
const vec3 sleep_color = vec3(-0.9,-0.9,-0.3);
const vec3 poisonedG_color = vec3(0.7,-1,0.7);

const vec3 raise_color = vec3(1.0,0.5,0.3);
const vec3 unraise_color = vec3(0.3,0.5,1.0);
const float arrow_width = 0.7;
const float arrow_speed = 0.8;
const float num_v_x = 5.0;
const float num_v_y = 5.0;

vec3 get_raise_arrows(vec3 color, vec2 uv) {
	vec3 effect_color = is_raise ? raise_color : unraise_color;
	float direction = is_raise ? 1.0 : -1.0;
	float v_width = 1.0 / num_v_x;
	float v_height = 1.0 / num_v_y;
	uv.y += TIME * arrow_speed * direction;
	uv.x += v_width/2.0 * float(is_raise);
	vec2 v_grid_pos = vec2(fract(uv.x / v_width), fract(uv.y / v_height));
	float distance_to_v = abs(v_grid_pos.x - 0.5) - (v_grid_pos.y - 0.5);
	float ar_wt = arrow_width/num_v_y;
	vec3 final_color = mix(color, effect_color, raise_alpha/255.0 * float(abs(distance_to_v-ar_wt) > ar_wt));
	
	return final_color;
}

void fragment() {
	//Death anim
	vec2 uv = UV;
	uv.y -= death_animation/100.0;
	COLOR = texture(TEXTURE,uv);
	
	//Animation pokeball
	if (spawn_anim <= 1.0) {
		vec3 inv_color = vec3(abs(1.0-apparition_color.x),abs(1.0-apparition_color.y),abs(1.0-apparition_color.z));
		vec3 modulation = vec3(1,1,1)-(inv_color*(1.0-pow(spawn_anim,2)));
		COLOR.rgb = modulation;
		COLOR.a *= sqrt(spawn_anim);
	} else {
		vec3 modulation = vec3((spawn_anim-1.0)/2.0);
		COLOR.rgb /= modulation;
	}
	
	//Status
	if (status == 1) { COLOR.rgb += burned_color*status_alpha;}
	else if (status == 2) { COLOR.rgb += frozen_color*status_alpha;}
	else if (status == 3) { COLOR.rgb += paralyzed_color*status_alpha;}
	else if (status == 4) { COLOR.rgb += poisoned_color*status_alpha;}
	else if (status == 5) { COLOR.rgb += sleep_color*status_alpha;}
	else if (status == 6) { COLOR.rgb += poisonedG_color*status_alpha;}
	
	//Raise Stats
	COLOR.rgb = get_raise_arrows(COLOR.rgb, UV);
	
	//Confused Effect
	if (is_confused) {
		float frequency = 60.0;
		float speed = 5.0;
		float force = 1.0;
		uv.x += sin(uv.y * frequency + TIME * speed) * 0.005 * force;
		COLOR = texture(TEXTURE,uv);
		COLOR.r += sin(TIME)*0.15;
		COLOR.g += cos(TIME)*0.18;
	}
}

void vertex(){
	//Offset
	VERTEX.y += 2.1 + offset;
	
	//Status Anim
	if (status == 3) {
		float gap = 4.0;
		float anim = 0.7;
		if (mod(TIME,gap+anim)<anim) {
			VERTEX.x += sin(TIME*100.0)/2.0;
		}
	} else if (status != 2 && status != 5) {
		float time = 7.0;
		if (status == 1) time = 3.5;
		if (is_client) {
			VERTEX.y += sin(TIME*time)/2.0;
		} else {
			VERTEX.y += cos(TIME*time)/2.0;
		}
	}
}