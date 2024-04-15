shader_type spatial;
render_mode unshaded;
uniform sampler2D viewport_texture;

void fragment() {
	vec4 tex = texture(viewport_texture, UV).rgba;
    ALBEDO = tex.rgb;
	//ALPHA = tex.a;
}