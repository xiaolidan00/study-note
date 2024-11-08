float PI = 3.1415926;
float rad = 3.1415926 / 180.;
uniform vec2 uResolution;
uniform vec2 uSize;
uniform float radius;

varying vec2 vUv;
      //经纬度坐标转为三维坐标
vec3 lnglat2pos(vec2 p) {
    float lng = p.x * rad;
    float lat = p.y * rad;
    float x = cos(lat) * cos(lng);
    float y = cos(lat) * sin(lng);
    float z = sin(lat);
    return vec3(x, z, y);
}
void main() {
    vUv = vec2(position.z);
            //转换成经纬度
    vec2 p = vec2(position.x, -position.y) - vec2(180., 90.);
           //经纬度转三维坐标
    vec3 newPosition = radius * lnglat2pos(p);
    gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.);

}