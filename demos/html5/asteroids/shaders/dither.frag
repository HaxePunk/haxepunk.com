#version 120

varying vec2 vTexCoord;
uniform sampler2D uImage0;
uniform vec2 uResolution;

const int indexMatrix4x4[16] = int[](
	0,  8,  2,  10,
	12, 4,  14, 6,
	3,  11, 1,  9,
	15, 7,  13, 5
);

float indexValue() {
	int x = int(mod(gl_FragCoord.x, 4));
	int y = int(mod(gl_FragCoord.y, 4));
	return indexMatrix4x4[(x + y * 4)] / 16.0;
}

float dither(float color) {
	float closestColor = (color < 0.5) ? 0 : 1;
	float secondClosestColor = 1 - closestColor;
	float d = indexValue();
	float distance = abs(closestColor - color);
	return (distance < d) ? closestColor : secondClosestColor;
}

void main () {
	vec4 color = texture2D(uImage0, vec2(vTexCoord.x, vTexCoord.y));
	float d = dither(pow(color.r * color.g * color.b / color.a, 0.25));
	gl_FragColor = vec4(color.rgb * d, 1.0);
}
