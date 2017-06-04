attribute vec4 position;
attribute vec3 normal;
attribute vec2 uv;

varying vec3 fragNormal;
varying vec2 fragUV;

void main(void) {
    fragNormal = normal;
    fragUV = uv;
    gl_Position = position;
}
