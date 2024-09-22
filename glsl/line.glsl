czm_material czm_getMaterial(czm_materialInput materialInput) {
    float time = czm_frameNumber / 60.0;
    czm_material material = czm_getDefaultMaterial(materialInput);
    vec2 st = materialInput.st;
    vec4 colorImage = texture2D(image, vec2(fract(3.0 * st.s - time), st.s));
    material.alpha = colorImage.a * color.a;
    material.diffuse = (colorImage.rgb + color.rgb) / 2.0;
    return material;
}
