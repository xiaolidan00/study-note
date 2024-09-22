//计算每个渲染顶点和视点（相机）的距离
float getDistance(sampler2D depthTexture, vec2 texCoords) {
    float depth = czm_unpackDepth(texture2D(depthTexture, texCoords));
    if(depth == 0.0) {
        return czm_infinity;
    }
    vec4 eyeCoordinate = czm_windowToEyeCoordinates(gl_FragCoord.xy, depth);
    return -eyeCoordinate.z / eyeCoordinate.w;
}
//按距离进行插值计算
float interpolateByDistance(vec4 nearFarScalar, float distance) {
    float startDistance = nearFarScalar.x;
    float startValue = nearFarScalar.y;
    float endDistance = nearFarScalar.z;
    float endValue = nearFarScalar.w;
    float t = clamp((distance - startDistance) / (endDistance - startDistance), 0.0, 1.0);
    return mix(startValue, endValue, t);
}

//计算透明度
vec4 alphaBlend(vec4 sourceColor, vec4 destinationColor) {
    return sourceColor * vec4(sourceColor.aaa, 1.0) + destinationColor * (1.0 - sourceColor.a);
}

uniform sampler2D colorTexture;//颜色纹理，内置变量
uniform sampler2D depthTexture;//深度纹理，内置变量
varying vec2 v_textureCoordinates;//屏幕采样点坐标，内置变量
uniform vec4 fogByDistance;
uniform vec4 fogColor;
void main(void) {
    float distance = getDistance(depthTexture, v_textureCoordinates);
    vec4 sceneColor = texture2D(colorTexture, v_textureCoordinates);
    float blendAmount = interpolateByDistance(fogByDistance, distance);
    vec4 finalFogColor = vec4(fogColor.rgb, fogColor.a * blendAmount);
    gl_FragColor = alphaBlend(finalFogColor, sceneColor);
}