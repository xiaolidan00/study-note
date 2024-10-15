#iChannel0 "./tex.jpg"

float d = 0.1;
// 图形平滑
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 textCoord = (fragCoord.xy) / iResolution.xy;
    fragColor = (texture2D(iChannel0, vec2(textCoord.x + d, textCoord.y)) + texture2D(iChannel0, vec2(textCoord.x, textCoord.y + d)) + texture2D(iChannel0, vec2(textCoord.x - d, textCoord.y)) + texture2D(iChannel0, vec2(textCoord.x, textCoord.y - d))) / 4.0;
}
