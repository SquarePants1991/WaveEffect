precision highp float;

varying vec3 fragNormal;
varying vec2 fragUV;

uniform sampler2D diffuseMap;
uniform float time;

bool shouldBeColored(float waveAmplitude, float waveHeight, float phase, float period) {
    float x = fragUV.x * period; // x轴范围0～period
    float y = 1.0 - fragUV.y;
    float topY = (sin(x + phase) + 1.0) / 2.0 * waveAmplitude - waveAmplitude / 2.0 + waveHeight;
    return y <= topY;
}

void main(void) {
    vec4 color = texture2D(diffuseMap, fragUV);

    float baseFactor = (sin(time / 4.5) + 1.0) / 2.0;
    float heightFactor = baseFactor;
    float phaseFactor = time * 3.14;
    float period = 3.14 * 1.4; // 周期
    
    vec4 finalColor = vec4(0.2, 0.2, 0.2, 1.0);
    
    if (shouldBeColored(0.07, heightFactor, phaseFactor, period)) {
        finalColor = finalColor * 0.0 + vec4(1.0, 0.4, 0.4, 1.0);
    }
    if (shouldBeColored(0.05, heightFactor - 0.02, phaseFactor - 0.25, period)) {
        finalColor = finalColor * 0.4 + vec4(1.0, 0.1, 0.1, 1.0) * 0.6;
    }
    
    gl_FragColor = finalColor * color.a;
}
