#iChannel0 "./test.png"

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 textCoord = (fragCoord.xy) / iResolution.xy;
    vec4 colorL = texture2D(iChannel0, textCoord);
    vec4 colorR = texture2D(iChannel0, vec2(textCoord.x + 0.05, textCoord.y));

    fragColor = vec4(colorL.g * 0.7 + colorL.b * 0.3, colorR.g, colorR.b, colorL.a + colorR.a) * 1.1;
}
