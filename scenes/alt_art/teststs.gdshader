shader_type canvas_item;

uniform vec4 primary_color : source_color;
uniform vec4 secondary_color : source_color;
uniform vec4 accent_color : source_color;
uniform vec4 accent_2_color : source_color; // NEW!

uniform vec4 new_primary_color : source_color;

uniform float tolerance : hint_range(0.0, 1.0);

vec3 rgb2hsv(vec3 c) {
    float cmax = max(c.r, max(c.g, c.b));
    float cmin = min(c.r, min(c.g, c.b));
    float delta = cmax - cmin;

    float h = 0.0;
    if (delta > 0.0) {
        if (cmax == c.r) {
            h = mod((c.g - c.b) / delta, 6.0);
        } else if (cmax == c.g) {
            h = (c.b - c.r) / delta + 2.0;
        } else {
            h = (c.r - c.g) / delta + 4.0;
        }
        h /= 6.0;
        if (h < 0.0) h += 1.0;
    }

    float s = cmax == 0.0 ? 0.0 : delta / cmax;
    float v = cmax;

    return vec3(h, s, v);
}

vec3 hsv2rgb(vec3 c) {
    float h = c.x * 6.0;
    float s = c.y;
    float v = c.z;

    int i = int(floor(h));
    float f = h - float(i);
    float p = v * (1.0 - s);
    float q = v * (1.0 - s * f);
    float t = v * (1.0 - s * (1.0 - f));

    if (i == 0) return vec3(v, t, p);
    if (i == 1) return vec3(q, v, p);
    if (i == 2) return vec3(p, v, t);
    if (i == 3) return vec3(p, q, v);
    if (i == 4) return vec3(t, p, v);
    return vec3(v, p, q);
}

vec3 apply_offset(vec3 base, vec3 offset) {
    vec3 result = base + offset;
    result.x = mod(result.x, 1.0); // wrap hue
    result.y = clamp(result.y, 0.0, 1.0);
    result.z = clamp(result.z, 0.0, 1.0);
    return result;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    vec3 hsv_primary = rgb2hsv(primary_color.rgb);
    vec3 hsv_secondary = rgb2hsv(secondary_color.rgb);
    vec3 hsv_accent = rgb2hsv(accent_color.rgb);
    vec3 hsv_accent_2 = rgb2hsv(accent_2_color.rgb); // NEW
    vec3 hsv_new_primary = rgb2hsv(new_primary_color.rgb);

    vec3 offset_secondary = hsv_secondary - hsv_primary;
    vec3 offset_accent = hsv_accent - hsv_primary;
    vec3 offset_accent_2 = hsv_accent_2 - hsv_primary; // NEW

    vec3 hsv_new_secondary = apply_offset(hsv_new_primary, offset_secondary);
    vec3 hsv_new_accent = apply_offset(hsv_new_primary, offset_accent);
    vec3 hsv_new_accent_2 = apply_offset(hsv_new_primary, offset_accent_2); // NEW

    vec3 rgb_new_secondary = hsv2rgb(hsv_new_secondary);
    vec3 rgb_new_accent = hsv2rgb(hsv_new_accent);
    vec3 rgb_new_accent_2 = hsv2rgb(hsv_new_accent_2); // NEW

    float d_primary = distance(tex_color.rgb, primary_color.rgb);
    float d_secondary = distance(tex_color.rgb, secondary_color.rgb);
    float d_accent = distance(tex_color.rgb, accent_color.rgb);
    float d_accent_2 = distance(tex_color.rgb, accent_2_color.rgb); // NEW

    if (d_primary < tolerance) {
        tex_color.rgb = new_primary_color.rgb;
    } else if (d_secondary < tolerance) {
        tex_color.rgb = rgb_new_secondary;
    } else if (d_accent < tolerance) {
        tex_color.rgb = rgb_new_accent;
    } else if (d_accent_2 < tolerance) {
        tex_color.rgb = rgb_new_accent_2;
    }

    COLOR = tex_color;
}