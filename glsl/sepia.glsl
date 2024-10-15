#iChannel0 "./test.png"
float amount = 0.9;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 textCoord = (fragCoord.xy) / iResolution.xy;
    vec4 color = texture2D(iChannel0, textCoord);
    vec3 c = color.rgb;

    color.r = dot(c, vec3(1.0 - 0.607 * amount, 0.769 * amount, 0.189 * amount));
    color.g = dot(c, vec3(0.349 * amount, 1.0 - 0.314 * amount, 0.168 * amount));
    color.b = dot(c, vec3(0.272 * amount, 0.534 * amount, 1.0 - 0.869 * amount));

    fragColor = vec4(min(vec3(1.0), color.rgb), color.a);

}