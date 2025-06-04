shader_type canvas_item;

uniform float amplitude = 20.0;
uniform float frequency = 10;

void fragment() {
    float y = UV.y - 0.4;

    float wave = sin(TIME * frequency);
    float offset = wave * y * y * amplitude * TEXTURE_PIXEL_SIZE.x;

    COLOR = texture(TEXTURE, UV + vec2(offset, 0.0));
}
