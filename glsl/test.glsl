float PI = acos(-1.0);
uniform vec2 uOffset;
varying vec2 vUv;
float getMove(float u, float offset) {
    float a = u * PI * 2.0;
    return sin(a + PI * 0.25) * u * offset;
}
float getHeight(float u, float offset) {
    float a = u * PI * 3.0;
    return cos(a) * u * offset;
}

void main(void) {
    vUv = uv;
    float m = getMove(uv.x, uOffset.x);
    float h = getHeight(uv.x, uOffset.y);

    vec3 newPosition = position;
    newPosition.x = newPosition.x + m;
    newPosition.y = newPosition.y + h;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);
}