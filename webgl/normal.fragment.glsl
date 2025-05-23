#version 300 es
#define varying in
layout(location = 0) out highp vec4 pc_fragColor;
#define gl_FragColor pc_fragColor
#define gl_FragDepthEXT gl_FragDepth
#define texture2D texture
#define textureCube texture
#define texture2DProj textureProj
#define texture2DLodEXT textureLod
#define texture2DProjLodEXT textureProjLod
#define textureCubeLodEXT textureLod
#define texture2DGradEXT textureGrad
#define texture2DProjGradEXT textureProjGrad
#define textureCubeGradEXT textureGrad
precision highp float;
precision highp int;
precision highp sampler2D;
precision highp samplerCube;
precision highp sampler3D;
precision highp sampler2DArray;
precision highp sampler2DShadow;
precision highp samplerCubeShadow;
precision highp sampler2DArrayShadow;
precision highp isampler2D;
precision highp isampler3D;
precision highp isamplerCube;
precision highp isampler2DArray;
precision highp usampler2D;
precision highp usampler3D;
precision highp usamplerCube;
precision highp usampler2DArray;

#define HIGH_PRECISION
#define SHADER_TYPE MeshNormalMaterial
#define SHADER_NAME 
#define USE_NORMALMAP
#define USE_NORMALMAP_TANGENTSPACE
#define DOUBLE_SIDED
uniform mat4 viewMatrix;
uniform vec3 cameraPosition;
uniform bool isOrthographic;
#define OPAQUE
vec4 LinearTransferOETF(in vec4 value) {
    return value;
}
vec4 sRGBTransferEOTF(in vec4 value) {
    return vec4(mix(pow(value.rgb * 0.9478672986f + vec3(0.0521327014f), vec3(2.4f)), value.rgb * 0.0773993808f, vec3(lessThanEqual(value.rgb, vec3(0.04045f)))), value.a);
}
vec4 sRGBTransferOETF(in vec4 value) {
    return vec4(mix(pow(value.rgb, vec3(0.41666f)) * 1.055f - vec3(0.055f), value.rgb * 12.92f, vec3(lessThanEqual(value.rgb, vec3(0.0031308f)))), value.a);
}
vec4 linearToOutputTexel(vec4 value) {
    return sRGBTransferOETF(vec4(value.rgb * mat3(1.0000f, -0.0000f, -0.0000f, -0.0000f, 1.0000f, 0.0000f, 0.0000f, 0.0000f, 1.0000f), value.a));
}
float luminance(const in vec3 rgb) {
    const vec3 weights = vec3(0.2126f, 0.7152f, 0.0722f);
    return dot(weights, rgb);
}

#define NORMAL
uniform float opacity;
#if defined( FLAT_SHADED ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP_TANGENTSPACE )
varying vec3 vViewPosition;
#endif
vec3 packNormalToRGB(const in vec3 normal) {
    return normalize(normal) * 0.5f + 0.5f;
}
vec3 unpackRGBToNormal(const in vec3 rgb) {
    return 2.0f * rgb.xyz - 1.0f;
}
const float PackUpscale = 256.f / 255.f;
const float UnpackDownscale = 255.f / 256.f;
const float ShiftRight8 = 1.f / 256.f;
const float Inv255 = 1.f / 255.f;
const vec4 PackFactors = vec4(1.0f, 256.0f, 256.0f * 256.0f, 256.0f * 256.0f * 256.0f);
const vec2 UnpackFactors2 = vec2(UnpackDownscale, 1.0f / PackFactors.g);
const vec3 UnpackFactors3 = vec3(UnpackDownscale / PackFactors.rg, 1.0f / PackFactors.b);
const vec4 UnpackFactors4 = vec4(UnpackDownscale / PackFactors.rgb, 1.0f / PackFactors.a);
vec4 packDepthToRGBA(const in float v) {
    if(v <= 0.0f)
        return vec4(0.f, 0.f, 0.f, 0.f);
    if(v >= 1.0f)
        return vec4(1.f, 1.f, 1.f, 1.f);
    float vuf;
    float af = modf(v * PackFactors.a, vuf);
    float bf = modf(vuf * ShiftRight8, vuf);
    float gf = modf(vuf * ShiftRight8, vuf);
    return vec4(vuf * Inv255, gf * PackUpscale, bf * PackUpscale, af);
}
vec3 packDepthToRGB(const in float v) {
    if(v <= 0.0f)
        return vec3(0.f, 0.f, 0.f);
    if(v >= 1.0f)
        return vec3(1.f, 1.f, 1.f);
    float vuf;
    float bf = modf(v * PackFactors.b, vuf);
    float gf = modf(vuf * ShiftRight8, vuf);
    return vec3(vuf * Inv255, gf * PackUpscale, bf);
}
vec2 packDepthToRG(const in float v) {
    if(v <= 0.0f)
        return vec2(0.f, 0.f);
    if(v >= 1.0f)
        return vec2(1.f, 1.f);
    float vuf;
    float gf = modf(v * 256.f, vuf);
    return vec2(vuf * Inv255, gf);
}
float unpackRGBAToDepth(const in vec4 v) {
    return dot(v, UnpackFactors4);
}
float unpackRGBToDepth(const in vec3 v) {
    return dot(v, UnpackFactors3);
}
float unpackRGToDepth(const in vec2 v) {
    return v.r * UnpackFactors2.r + v.g * UnpackFactors2.g;
}
vec4 pack2HalfToRGBA(const in vec2 v) {
    vec4 r = vec4(v.x, fract(v.x * 255.0f), v.y, fract(v.y * 255.0f));
    return vec4(r.x - r.y / 255.0f, r.y, r.z - r.w / 255.0f, r.w);
}
vec2 unpackRGBATo2Half(const in vec4 v) {
    return vec2(v.x + (v.y / 255.0f), v.z + (v.w / 255.0f));
}
float viewZToOrthographicDepth(const in float viewZ, const in float near, const in float far) {
    return (viewZ + near) / (near - far);
}
float orthographicDepthToViewZ(const in float depth, const in float near, const in float far) {
    return depth * (near - far) - near;
}
float viewZToPerspectiveDepth(const in float viewZ, const in float near, const in float far) {
    return ((near + viewZ) * far) / ((far - near) * viewZ);
}
float perspectiveDepthToViewZ(const in float depth, const in float near, const in float far) {
    return (near * far) / ((far - near) * depth - far);
}
#if defined( USE_UV ) || defined( USE_ANISOTROPY )
varying vec2 vUv;
#endif
#ifdef USE_MAP
varying vec2 vMapUv;
#endif
#ifdef USE_ALPHAMAP
varying vec2 vAlphaMapUv;
#endif
#ifdef USE_LIGHTMAP
varying vec2 vLightMapUv;
#endif
#ifdef USE_AOMAP
varying vec2 vAoMapUv;
#endif
#ifdef USE_BUMPMAP
varying vec2 vBumpMapUv;
#endif
#ifdef USE_NORMALMAP
varying vec2 vNormalMapUv;
#endif
#ifdef USE_EMISSIVEMAP
varying vec2 vEmissiveMapUv;
#endif
#ifdef USE_METALNESSMAP
varying vec2 vMetalnessMapUv;
#endif
#ifdef USE_ROUGHNESSMAP
varying vec2 vRoughnessMapUv;
#endif
#ifdef USE_ANISOTROPYMAP
varying vec2 vAnisotropyMapUv;
#endif
#ifdef USE_CLEARCOATMAP
varying vec2 vClearcoatMapUv;
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
varying vec2 vClearcoatNormalMapUv;
#endif
#ifdef USE_CLEARCOAT_ROUGHNESSMAP
varying vec2 vClearcoatRoughnessMapUv;
#endif
#ifdef USE_IRIDESCENCEMAP
varying vec2 vIridescenceMapUv;
#endif
#ifdef USE_IRIDESCENCE_THICKNESSMAP
varying vec2 vIridescenceThicknessMapUv;
#endif
#ifdef USE_SHEEN_COLORMAP
varying vec2 vSheenColorMapUv;
#endif
#ifdef USE_SHEEN_ROUGHNESSMAP
varying vec2 vSheenRoughnessMapUv;
#endif
#ifdef USE_SPECULARMAP
varying vec2 vSpecularMapUv;
#endif
#ifdef USE_SPECULAR_COLORMAP
varying vec2 vSpecularColorMapUv;
#endif
#ifdef USE_SPECULAR_INTENSITYMAP
varying vec2 vSpecularIntensityMapUv;
#endif
#ifdef USE_TRANSMISSIONMAP
uniform mat3 transmissionMapTransform;
varying vec2 vTransmissionMapUv;
#endif
#ifdef USE_THICKNESSMAP
uniform mat3 thicknessMapTransform;
varying vec2 vThicknessMapUv;
#endif
#ifndef FLAT_SHADED
varying vec3 vNormal;
	#ifdef USE_TANGENT
varying vec3 vTangent;
varying vec3 vBitangent;
	#endif
#endif
#ifdef USE_BUMPMAP
uniform sampler2D bumpMap;
uniform float bumpScale;
vec2 dHdxy_fwd() {
    vec2 dSTdx = dFdx(vBumpMapUv);
    vec2 dSTdy = dFdy(vBumpMapUv);
    float Hll = bumpScale * texture2D(bumpMap, vBumpMapUv).x;
    float dBx = bumpScale * texture2D(bumpMap, vBumpMapUv + dSTdx).x - Hll;
    float dBy = bumpScale * texture2D(bumpMap, vBumpMapUv + dSTdy).x - Hll;
    return vec2(dBx, dBy);
}
vec3 perturbNormalArb(vec3 surf_pos, vec3 surf_norm, vec2 dHdxy, float faceDirection) {
    vec3 vSigmaX = normalize(dFdx(surf_pos.xyz));
    vec3 vSigmaY = normalize(dFdy(surf_pos.xyz));
    vec3 vN = surf_norm;
    vec3 R1 = cross(vSigmaY, vN);
    vec3 R2 = cross(vN, vSigmaX);
    float fDet = dot(vSigmaX, R1) * faceDirection;
    vec3 vGrad = sign(fDet) * (dHdxy.x * R1 + dHdxy.y * R2);
    return normalize(abs(fDet) * surf_norm - vGrad);
}
#endif
#ifdef USE_NORMALMAP
uniform sampler2D normalMap;
uniform vec2 normalScale;
#endif
#ifdef USE_NORMALMAP_OBJECTSPACE
uniform mat3 normalMatrix;
#endif
#if ! defined ( USE_TANGENT ) && ( defined ( USE_NORMALMAP_TANGENTSPACE ) || defined ( USE_CLEARCOAT_NORMALMAP ) || defined( USE_ANISOTROPY ) )
mat3 getTangentFrame(vec3 eye_pos, vec3 surf_norm, vec2 uv) {
    vec3 q0 = dFdx(eye_pos.xyz);
    vec3 q1 = dFdy(eye_pos.xyz);
    vec2 st0 = dFdx(uv.st);
    vec2 st1 = dFdy(uv.st);
    vec3 N = surf_norm;
    vec3 q1perp = cross(q1, N);
    vec3 q0perp = cross(N, q0);
    vec3 T = q1perp * st0.x + q0perp * st1.x;
    vec3 B = q1perp * st0.y + q0perp * st1.y;
    float det = max(dot(T, T), dot(B, B));
    float scale = (det == 0.0f) ? 0.0f : inversesqrt(det);
    return mat3(T * scale, B * scale, N);
}
#endif
#if defined( USE_LOGDEPTHBUF )
uniform float logDepthBufFC;
varying float vFragDepth;
varying float vIsPerspective;
#endif
#if 0 > 0
varying vec3 vClipPosition;
uniform vec4 clippingPlanes[0];
#endif
void main() {
    vec4 diffuseColor = vec4(0.0f, 0.0f, 0.0f, opacity);
#if 0 > 0
    vec4 plane;
	#ifdef ALPHA_TO_COVERAGE
    float distanceToPlane, distanceGradient;
    float clipOpacity = 1.0f;

		#if 0 < 0
    float unionClipOpacity = 1.0f;

    clipOpacity *= 1.0f - unionClipOpacity;
		#endif
    diffuseColor.a *= clipOpacity;
    if(diffuseColor.a == 0.0f)
        discard;
	#else

		#if 0 < 0
    bool clipped = true;

    if(clipped)
        discard;
		#endif
	#endif
#endif
#if defined( USE_LOGDEPTHBUF )
    gl_FragDepth = vIsPerspective == 0.0f ? gl_FragCoord.z : log2(vFragDepth) * logDepthBufFC * 0.5f;
#endif
    float faceDirection = gl_FrontFacing ? 1.0f : -1.0f;
#ifdef FLAT_SHADED
    vec3 fdx = dFdx(vViewPosition);
    vec3 fdy = dFdy(vViewPosition);
    vec3 normal = normalize(cross(fdx, fdy));
#else
    vec3 normal = normalize(vNormal);
	#ifdef DOUBLE_SIDED
    normal *= faceDirection;
	#endif
#endif
#if defined( USE_NORMALMAP_TANGENTSPACE ) || defined( USE_CLEARCOAT_NORMALMAP ) || defined( USE_ANISOTROPY )
	#ifdef USE_TANGENT
    mat3 tbn = mat3(normalize(vTangent), normalize(vBitangent), normal);
	#else
    mat3 tbn = getTangentFrame(-vViewPosition, normal,
		#if defined( USE_NORMALMAP )
    vNormalMapUv
		#elif defined( USE_CLEARCOAT_NORMALMAP )
    vClearcoatNormalMapUv
		#else
    vUv
		#endif
    );
	#endif
	#if defined( DOUBLE_SIDED ) && ! defined( FLAT_SHADED )
    tbn[0] *= faceDirection;
    tbn[1] *= faceDirection;
	#endif
#endif
#ifdef USE_CLEARCOAT_NORMALMAP
	#ifdef USE_TANGENT
    mat3 tbn2 = mat3(normalize(vTangent), normalize(vBitangent), normal);
	#else
    mat3 tbn2 = getTangentFrame(-vViewPosition, normal, vClearcoatNormalMapUv);
	#endif
	#if defined( DOUBLE_SIDED ) && ! defined( FLAT_SHADED )
    tbn2[0] *= faceDirection;
    tbn2[1] *= faceDirection;
	#endif
#endif
    vec3 nonPerturbedNormal = normal;
#ifdef USE_NORMALMAP_OBJECTSPACE
    normal = texture2D(normalMap, vNormalMapUv).xyz * 2.0f - 1.0f;
	#ifdef FLIP_SIDED
    normal = -normal;
	#endif
	#ifdef DOUBLE_SIDED
    normal = normal * faceDirection;
	#endif
    normal = normalize(normalMatrix * normal);
#elif defined( USE_NORMALMAP_TANGENTSPACE )
    vec3 mapN = texture2D(normalMap, vNormalMapUv).xyz * 2.0f - 1.0f;
    mapN.xy *= normalScale;
    normal = normalize(tbn * mapN);
#elif defined( USE_BUMPMAP )
    normal = perturbNormalArb(-vViewPosition, normal, dHdxy_fwd(), faceDirection);
#endif
    gl_FragColor = vec4(packNormalToRGB(normal), diffuseColor.a);
	#ifdef OPAQUE
    gl_FragColor.a = 1.0f;
	#endif
}