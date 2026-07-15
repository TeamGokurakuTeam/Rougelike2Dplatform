shader_type canvas_item;

uniform vec2 reveal_position;
uniform float radius = 20.0;
uniform float softness = 32.0;

varying vec2 world_pos;

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    COLOR = texture(TEXTURE, UV);
    float dist = distance(world_pos, reveal_position);
    float fade = smoothstep(radius, radius + softness, dist);
    COLOR.a *= mix(0.0, 1.0, fade);
}