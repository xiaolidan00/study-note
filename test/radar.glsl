void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord / iResolution.xy;

    // Time varying pixel color
    vec3 col = vec3(1.0, 0., 0.);

    float d = length(uv - vec2(0.5));
    // Output to screen
    fragColor = vec4(col, sign(clamp(d - sin(iTime) * 0.5, 0., 1.)));
}