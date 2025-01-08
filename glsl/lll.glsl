varying vec4 vColor;
void main(void) {
//热力贴图颜色
    gl_FragColor.rgb = vColor.rgb; 
//增加透明度，限制范围
    gl_FragColor.a = clamp(vColor.a * 10., 0., 1.);

}