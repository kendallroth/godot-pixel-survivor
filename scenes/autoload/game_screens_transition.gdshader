shader_type canvas_item;

uniform sampler2D transition_texture : filter_nearest;
uniform vec4 transition_color : source_color;
uniform float percent : hint_range(0.0, 1.0);

// Called for every pixel the material is visible on.
void fragment() {
	vec4 transition_texture_color = texture(transition_texture, UV);
    if (transition_texture_color.r > percent) {
        COLOR.a = 0.0;
    } else {
        COLOR = transition_color;
    }
}
