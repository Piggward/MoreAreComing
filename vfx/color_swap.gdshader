shader_type canvas_item;

uniform int color_count = 1;

uniform vec4 target_colors[8] : source_color;
uniform vec4 replace_colors[8] : source_color;
uniform float tolerance : hint_range(0.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    for (int i = 0; i < color_count; i++) {
        float dist = distance(tex_color.rgb, target_colors[i].rgb);
        if (dist < tolerance) {
            tex_color.rgb = replace_colors[i].rgb;
            break; // Replace only once
        }
    }

    COLOR = tex_color;
}