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
#define SHADER_TYPE MeshPhongMaterial
#define SHADER_NAME 
#define USE_BUMPMAP
#define USE_SHADOWMAP
#define SHADOWMAP_TYPE_PCF
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

#define PHONG
uniform vec3 diffuse;
uniform vec3 emissive;
uniform vec3 specular;
uniform float shininess;
uniform float opacity;
#define PI 3.141592653589793
#define PI2 6.283185307179586
#define PI_HALF 1.5707963267948966
#define RECIPROCAL_PI 0.3183098861837907
#define RECIPROCAL_PI2 0.15915494309189535
#define EPSILON 1e-6
#ifndef saturate
#define saturate( a ) clamp( a, 0.0, 1.0 )
#endif
#define whiteComplement( a ) ( 1.0 - saturate( a ) )
float pow2(const in float x) {
    return x * x;
}
vec3 pow2(const in vec3 x) {
    return x * x;
}
float pow3(const in float x) {
    return x * x * x;
}
float pow4(const in float x) {
    float x2 = x * x;
    return x2 * x2;
}
float max3(const in vec3 v) {
    return max(max(v.x, v.y), v.z);
}
float average(const in vec3 v) {
    return dot(v, vec3(0.3333333f));
}
highp float rand(const in vec2 uv) {
    const highp float a = 12.9898f, b = 78.233f, c = 43758.5453f;
    highp float dt = dot(uv.xy, vec2(a, b)), sn = mod(dt, PI);
    return fract(sin(sn) * c);
}
#ifdef HIGH_PRECISION
float precisionSafeLength(vec3 v) {
    return length(v);
}
#else
float precisionSafeLength(vec3 v) {
    float maxComponent = max3(abs(v));
    return length(v / maxComponent) * maxComponent;
}
#endif
struct IncidentLight {
    vec3 color;
    vec3 direction;
    bool visible;
};
struct ReflectedLight {
    vec3 directDiffuse;
    vec3 directSpecular;
    vec3 indirectDiffuse;
    vec3 indirectSpecular;
};
#ifdef USE_ALPHAHASH
varying vec3 vPosition;
#endif
vec3 transformDirection(in vec3 dir, in mat4 matrix) {
    return normalize((matrix * vec4(dir, 0.0f)).xyz);
}
vec3 inverseTransformDirection(in vec3 dir, in mat4 matrix) {
    return normalize((vec4(dir, 0.0f) * matrix).xyz);
}
mat3 transposeMat3(const in mat3 m) {
    mat3 tmp;
    tmp[0] = vec3(m[0].x, m[1].x, m[2].x);
    tmp[1] = vec3(m[0].y, m[1].y, m[2].y);
    tmp[2] = vec3(m[0].z, m[1].z, m[2].z);
    return tmp;
}
bool isPerspectiveMatrix(mat4 m) {
    return m[2][3] == -1.0f;
}
vec2 equirectUv(in vec3 dir) {
    float u = atan(dir.z, dir.x) * RECIPROCAL_PI2 + 0.5f;
    float v = asin(clamp(dir.y, -1.0f, 1.0f)) * RECIPROCAL_PI + 0.5f;
    return vec2(u, v);
}
vec3 BRDF_Lambert(const in vec3 diffuseColor) {
    return RECIPROCAL_PI * diffuseColor;
}
vec3 F_Schlick(const in vec3 f0, const in float f90, const in float dotVH) {
    float fresnel = exp2((-5.55473f * dotVH - 6.98316f) * dotVH);
    return f0 * (1.0f - fresnel) + (f90 * fresnel);
}
float F_Schlick(const in float f0, const in float f90, const in float dotVH) {
    float fresnel = exp2((-5.55473f * dotVH - 6.98316f) * dotVH);
    return f0 * (1.0f - fresnel) + (f90 * fresnel);
} // validated
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
#ifdef DITHERING
vec3 dithering(vec3 color) {
    float grid_position = rand(gl_FragCoord.xy);
    vec3 dither_shift_RGB = vec3(0.25f / 255.0f, -0.25f / 255.0f, 0.25f / 255.0f);
    dither_shift_RGB = mix(2.0f * dither_shift_RGB, -2.0f * dither_shift_RGB, grid_position);
    return color + dither_shift_RGB;
}
#endif
#if defined( USE_COLOR_ALPHA )
varying vec4 vColor;
#elif defined( USE_COLOR )
varying vec3 vColor;
#endif
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
#ifdef USE_MAP
uniform sampler2D map;
#endif
#ifdef USE_ALPHAMAP
uniform sampler2D alphaMap;
#endif
#ifdef USE_ALPHATEST
uniform float alphaTest;
#endif
#ifdef USE_ALPHAHASH
const float ALPHA_HASH_SCALE = 0.05f;
float hash2D(vec2 value) {
    return fract(1.0e4f * sin(17.0f * value.x + 0.1f * value.y) * (0.1f + abs(sin(13.0f * value.y + value.x))));
}
float hash3D(vec3 value) {
    return hash2D(vec2(hash2D(value.xy), value.z));
}
float getAlphaHashThreshold(vec3 position) {
    float maxDeriv = max(length(dFdx(position.xyz)), length(dFdy(position.xyz)));
    float pixScale = 1.0f / (ALPHA_HASH_SCALE * maxDeriv);
    vec2 pixScales = vec2(exp2(floor(log2(pixScale))), exp2(ceil(log2(pixScale))));
    vec2 alpha = vec2(hash3D(floor(pixScales.x * position.xyz)), hash3D(floor(pixScales.y * position.xyz)));
    float lerpFactor = fract(log2(pixScale));
    float x = (1.0f - lerpFactor) * alpha.x + lerpFactor * alpha.y;
    float a = min(lerpFactor, 1.0f - lerpFactor);
    vec3 cases = vec3(x * x / (2.0f * a * (1.0f - a)), (x - 0.5f * a) / (1.0f - a), 1.0f - ((1.0f - x) * (1.0f - x) / (2.0f * a * (1.0f - a))));
    float threshold = (x < (1.0f - a)) ? ((x < a) ? cases.x : cases.y) : cases.z;
    return clamp(threshold, 1.0e-6f, 1.0f);
}
#endif
#ifdef USE_AOMAP
uniform sampler2D aoMap;
uniform float aoMapIntensity;
#endif
#ifdef USE_LIGHTMAP
uniform sampler2D lightMap;
uniform float lightMapIntensity;
#endif
#ifdef USE_EMISSIVEMAP
uniform sampler2D emissiveMap;
#endif
#ifdef USE_ENVMAP
uniform float envMapIntensity;
uniform float flipEnvMap;
uniform mat3 envMapRotation;
	#ifdef ENVMAP_TYPE_CUBE
uniform samplerCube envMap;
	#else
uniform sampler2D envMap;
	#endif

#endif
#ifdef USE_ENVMAP
uniform float reflectivity;
	#if defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( PHONG ) || defined( LAMBERT )
		#define ENV_WORLDPOS
	#endif
	#ifdef ENV_WORLDPOS
varying vec3 vWorldPosition;
uniform float refractionRatio;
	#else
varying vec3 vReflect;
	#endif
#endif
#ifdef USE_FOG
uniform vec3 fogColor;
varying float vFogDepth;
	#ifdef FOG_EXP2
uniform float fogDensity;
	#else
uniform float fogNear;
uniform float fogFar;
	#endif
#endif
float G_BlinnPhong_Implicit() {
    return 0.25f;
}
float D_BlinnPhong(const in float shininess, const in float dotNH) {
    return RECIPROCAL_PI * (shininess * 0.5f + 1.0f) * pow(dotNH, shininess);
}
vec3 BRDF_BlinnPhong(const in vec3 lightDir, const in vec3 viewDir, const in vec3 normal, const in vec3 specularColor, const in float shininess) {
    vec3 halfDir = normalize(lightDir + viewDir);
    float dotNH = saturate(dot(normal, halfDir));
    float dotVH = saturate(dot(viewDir, halfDir));
    vec3 F = F_Schlick(specularColor, 1.0f, dotVH);
    float G = G_BlinnPhong_Implicit();
    float D = D_BlinnPhong(shininess, dotNH);
    return F * (G * D);
} // validated
uniform bool receiveShadow;
uniform vec3 ambientLightColor;
#if defined( USE_LIGHT_PROBES )
uniform vec3 lightProbe[9];
#endif
vec3 shGetIrradianceAt(in vec3 normal, in vec3 shCoefficients[9]) {
    float x = normal.x, y = normal.y, z = normal.z;
    vec3 result = shCoefficients[0] * 0.886227f;
    result += shCoefficients[1] * 2.0f * 0.511664f * y;
    result += shCoefficients[2] * 2.0f * 0.511664f * z;
    result += shCoefficients[3] * 2.0f * 0.511664f * x;
    result += shCoefficients[4] * 2.0f * 0.429043f * x * y;
    result += shCoefficients[5] * 2.0f * 0.429043f * y * z;
    result += shCoefficients[6] * (0.743125f * z * z - 0.247708f);
    result += shCoefficients[7] * 2.0f * 0.429043f * x * z;
    result += shCoefficients[8] * 0.429043f * (x * x - y * y);
    return result;
}
vec3 getLightProbeIrradiance(const in vec3 lightProbe[9], const in vec3 normal) {
    vec3 worldNormal = inverseTransformDirection(normal, viewMatrix);
    vec3 irradiance = shGetIrradianceAt(worldNormal, lightProbe);
    return irradiance;
}
vec3 getAmbientLightIrradiance(const in vec3 ambientLightColor) {
    vec3 irradiance = ambientLightColor;
    return irradiance;
}
float getDistanceAttenuation(const in float lightDistance, const in float cutoffDistance, const in float decayExponent) {
    float distanceFalloff = 1.0f / max(pow(lightDistance, decayExponent), 0.01f);
    if(cutoffDistance > 0.0f) {
        distanceFalloff *= pow2(saturate(1.0f - pow4(lightDistance / cutoffDistance)));
    }
    return distanceFalloff;
}
float getSpotAttenuation(const in float coneCosine, const in float penumbraCosine, const in float angleCosine) {
    return smoothstep(coneCosine, penumbraCosine, angleCosine);
}
#if 0 > 0
struct DirectionalLight {
    vec3 direction;
    vec3 color;
};
uniform DirectionalLight directionalLights[0];
void getDirectionalLightInfo(const in DirectionalLight directionalLight, out IncidentLight light) {
    light.color = directionalLight.color;
    light.direction = directionalLight.direction;
    light.visible = true;
}
#endif
#if 0 > 0
struct PointLight {
    vec3 position;
    vec3 color;
    float distance;
    float decay;
};
uniform PointLight pointLights[0];
void getPointLightInfo(const in PointLight pointLight, const in vec3 geometryPosition, out IncidentLight light) {
    vec3 lVector = pointLight.position - geometryPosition;
    light.direction = normalize(lVector);
    float lightDistance = length(lVector);
    light.color = pointLight.color;
    light.color *= getDistanceAttenuation(lightDistance, pointLight.distance, pointLight.decay);
    light.visible = (light.color != vec3(0.0f));
}
#endif
#if 1 > 0
struct SpotLight {
    vec3 position;
    vec3 direction;
    vec3 color;
    float distance;
    float decay;
    float coneCos;
    float penumbraCos;
};
uniform SpotLight spotLights[1];
void getSpotLightInfo(const in SpotLight spotLight, const in vec3 geometryPosition, out IncidentLight light) {
    vec3 lVector = spotLight.position - geometryPosition;
    light.direction = normalize(lVector);
    float angleCos = dot(light.direction, spotLight.direction);
    float spotAttenuation = getSpotAttenuation(spotLight.coneCos, spotLight.penumbraCos, angleCos);
    if(spotAttenuation > 0.0f) {
        float lightDistance = length(lVector);
        light.color = spotLight.color * spotAttenuation;
        light.color *= getDistanceAttenuation(lightDistance, spotLight.distance, spotLight.decay);
        light.visible = (light.color != vec3(0.0f));
    } else {
        light.color = vec3(0.0f);
        light.visible = false;
    }
}
#endif
#if 0 > 0
struct RectAreaLight {
    vec3 color;
    vec3 position;
    vec3 halfWidth;
    vec3 halfHeight;
};
uniform sampler2D ltc_1;
uniform sampler2D ltc_2;
uniform RectAreaLight rectAreaLights[0];
#endif
#if 1 > 0
struct HemisphereLight {
    vec3 direction;
    vec3 skyColor;
    vec3 groundColor;
};
uniform HemisphereLight hemisphereLights[1];
vec3 getHemisphereLightIrradiance(const in HemisphereLight hemiLight, const in vec3 normal) {
    float dotNL = dot(normal, hemiLight.direction);
    float hemiDiffuseWeight = 0.5f * dotNL + 0.5f;
    vec3 irradiance = mix(hemiLight.groundColor, hemiLight.skyColor, hemiDiffuseWeight);
    return irradiance;
}
#endif
#ifndef FLAT_SHADED
varying vec3 vNormal;
	#ifdef USE_TANGENT
varying vec3 vTangent;
varying vec3 vBitangent;
	#endif
#endif
varying vec3 vViewPosition;
struct BlinnPhongMaterial {
    vec3 diffuseColor;
    vec3 specularColor;
    float specularShininess;
    float specularStrength;
};
void RE_Direct_BlinnPhong(const in IncidentLight directLight, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight) {
    float dotNL = saturate(dot(geometryNormal, directLight.direction));
    vec3 irradiance = dotNL * directLight.color;
    reflectedLight.directDiffuse += irradiance * BRDF_Lambert(material.diffuseColor);
    reflectedLight.directSpecular += irradiance * BRDF_BlinnPhong(directLight.direction, geometryViewDir, geometryNormal, material.specularColor, material.specularShininess) * material.specularStrength;
}
void RE_IndirectDiffuse_BlinnPhong(const in vec3 irradiance, const in vec3 geometryPosition, const in vec3 geometryNormal, const in vec3 geometryViewDir, const in vec3 geometryClearcoatNormal, const in BlinnPhongMaterial material, inout ReflectedLight reflectedLight) {
    reflectedLight.indirectDiffuse += irradiance * BRDF_Lambert(material.diffuseColor);
}
#define RE_Direct				RE_Direct_BlinnPhong
#define RE_IndirectDiffuse		RE_IndirectDiffuse_BlinnPhong
#if 1 > 0
varying vec4 vSpotLightCoord[1];
#endif
#if 0 > 0
uniform sampler2D spotLightMap[0];
#endif
#ifdef USE_SHADOWMAP
	#if 0 > 0
uniform sampler2D directionalShadowMap[0];
varying vec4 vDirectionalShadowCoord[0];
struct DirectionalLightShadow {
    float shadowIntensity;
    float shadowBias;
    float shadowNormalBias;
    float shadowRadius;
    vec2 shadowMapSize;
};
uniform DirectionalLightShadow directionalLightShadows[0];
	#endif
	#if 1 > 0
uniform sampler2D spotShadowMap[1];
struct SpotLightShadow {
    float shadowIntensity;
    float shadowBias;
    float shadowNormalBias;
    float shadowRadius;
    vec2 shadowMapSize;
};
uniform SpotLightShadow spotLightShadows[1];
	#endif
	#if 0 > 0
uniform sampler2D pointShadowMap[0];
varying vec4 vPointShadowCoord[0];
struct PointLightShadow {
    float shadowIntensity;
    float shadowBias;
    float shadowNormalBias;
    float shadowRadius;
    vec2 shadowMapSize;
    float shadowCameraNear;
    float shadowCameraFar;
};
uniform PointLightShadow pointLightShadows[0];
	#endif
float texture2DCompare(sampler2D depths, vec2 uv, float compare) {
    return step(compare, unpackRGBAToDepth(texture2D(depths, uv)));
}
vec2 texture2DDistribution(sampler2D shadow, vec2 uv) {
    return unpackRGBATo2Half(texture2D(shadow, uv));
}
float VSMShadow(sampler2D shadow, vec2 uv, float compare) {
    float occlusion = 1.0f;
    vec2 distribution = texture2DDistribution(shadow, uv);
    float hard_shadow = step(compare, distribution.x);
    if(hard_shadow != 1.0f) {
        float distance = compare - distribution.x;
        float variance = max(0.00000f, distribution.y * distribution.y);
        float softness_probability = variance / (variance + distance * distance);
        softness_probability = clamp((softness_probability - 0.3f) / (0.95f - 0.3f), 0.0f, 1.0f);
        occlusion = clamp(max(hard_shadow, softness_probability), 0.0f, 1.0f);
    }
    return occlusion;
}
float getShadow(sampler2D shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord) {
    float shadow = 1.0f;
    shadowCoord.xyz /= shadowCoord.w;
    shadowCoord.z += shadowBias;
    bool inFrustum = shadowCoord.x >= 0.0f && shadowCoord.x <= 1.0f && shadowCoord.y >= 0.0f && shadowCoord.y <= 1.0f;
    bool frustumTest = inFrustum && shadowCoord.z <= 1.0f;
    if(frustumTest) {
		#if defined( SHADOWMAP_TYPE_PCF )
        vec2 texelSize = vec2(1.0f) / shadowMapSize;
        float dx0 = -texelSize.x * shadowRadius;
        float dy0 = -texelSize.y * shadowRadius;
        float dx1 = +texelSize.x * shadowRadius;
        float dy1 = +texelSize.y * shadowRadius;
        float dx2 = dx0 / 2.0f;
        float dy2 = dy0 / 2.0f;
        float dx3 = dx1 / 2.0f;
        float dy3 = dy1 / 2.0f;
        shadow = (texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx0, dy0), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(0.0f, dy0), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx1, dy0), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx2, dy2), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(0.0f, dy2), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx3, dy2), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx0, 0.0f), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx2, 0.0f), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy, shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx3, 0.0f), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx1, 0.0f), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx2, dy3), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(0.0f, dy3), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx3, dy3), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx0, dy1), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(0.0f, dy1), shadowCoord.z) +
            texture2DCompare(shadowMap, shadowCoord.xy + vec2(dx1, dy1), shadowCoord.z)) * (1.0f / 17.0f);
		#elif defined( SHADOWMAP_TYPE_PCF_SOFT )
        vec2 texelSize = vec2(1.0f) / shadowMapSize;
        float dx = texelSize.x;
        float dy = texelSize.y;
        vec2 uv = shadowCoord.xy;
        vec2 f = fract(uv * shadowMapSize + 0.5f);
        uv -= f * texelSize;
        shadow = (texture2DCompare(shadowMap, uv, shadowCoord.z) +
            texture2DCompare(shadowMap, uv + vec2(dx, 0.0f), shadowCoord.z) +
            texture2DCompare(shadowMap, uv + vec2(0.0f, dy), shadowCoord.z) +
            texture2DCompare(shadowMap, uv + texelSize, shadowCoord.z) +
            mix(texture2DCompare(shadowMap, uv + vec2(-dx, 0.0f), shadowCoord.z), texture2DCompare(shadowMap, uv + vec2(2.0f * dx, 0.0f), shadowCoord.z), f.x) +
            mix(texture2DCompare(shadowMap, uv + vec2(-dx, dy), shadowCoord.z), texture2DCompare(shadowMap, uv + vec2(2.0f * dx, dy), shadowCoord.z), f.x) +
            mix(texture2DCompare(shadowMap, uv + vec2(0.0f, -dy), shadowCoord.z), texture2DCompare(shadowMap, uv + vec2(0.0f, 2.0f * dy), shadowCoord.z), f.y) +
            mix(texture2DCompare(shadowMap, uv + vec2(dx, -dy), shadowCoord.z), texture2DCompare(shadowMap, uv + vec2(dx, 2.0f * dy), shadowCoord.z), f.y) +
            mix(mix(texture2DCompare(shadowMap, uv + vec2(-dx, -dy), shadowCoord.z), texture2DCompare(shadowMap, uv + vec2(2.0f * dx, -dy), shadowCoord.z), f.x), mix(texture2DCompare(shadowMap, uv + vec2(-dx, 2.0f * dy), shadowCoord.z), texture2DCompare(shadowMap, uv + vec2(2.0f * dx, 2.0f * dy), shadowCoord.z), f.x), f.y)) * (1.0f / 9.0f);
		#elif defined( SHADOWMAP_TYPE_VSM )
        shadow = VSMShadow(shadowMap, shadowCoord.xy, shadowCoord.z);
		#else
        shadow = texture2DCompare(shadowMap, shadowCoord.xy, shadowCoord.z);
		#endif
    }
    return mix(1.0f, shadow, shadowIntensity);
}
vec2 cubeToUV(vec3 v, float texelSizeY) {
    vec3 absV = abs(v);
    float scaleToCube = 1.0f / max(absV.x, max(absV.y, absV.z));
    absV *= scaleToCube;
    v *= scaleToCube * (1.0f - 2.0f * texelSizeY);
    vec2 planar = v.xy;
    float almostATexel = 1.5f * texelSizeY;
    float almostOne = 1.0f - almostATexel;
    if(absV.z >= almostOne) {
        if(v.z > 0.0f)
            planar.x = 4.0f - v.x;
    } else if(absV.x >= almostOne) {
        float signX = sign(v.x);
        planar.x = v.z * signX + 2.0f * signX;
    } else if(absV.y >= almostOne) {
        float signY = sign(v.y);
        planar.x = v.x + 2.0f * signY + 2.0f;
        planar.y = v.z * signY - 2.0f;
    }
    return vec2(0.125f, 0.25f) * planar + vec2(0.375f, 0.75f);
}
float getPointShadow(sampler2D shadowMap, vec2 shadowMapSize, float shadowIntensity, float shadowBias, float shadowRadius, vec4 shadowCoord, float shadowCameraNear, float shadowCameraFar) {
    float shadow = 1.0f;
    vec3 lightToPosition = shadowCoord.xyz;

    float lightToPositionLength = length(lightToPosition);
    if(lightToPositionLength - shadowCameraFar <= 0.0f && lightToPositionLength - shadowCameraNear >= 0.0f) {
        float dp = (lightToPositionLength - shadowCameraNear) / (shadowCameraFar - shadowCameraNear);
        dp += shadowBias;
        vec3 bd3D = normalize(lightToPosition);
        vec2 texelSize = vec2(1.0f) / (shadowMapSize * vec2(4.0f, 2.0f));
			#if defined( SHADOWMAP_TYPE_PCF ) || defined( SHADOWMAP_TYPE_PCF_SOFT ) || defined( SHADOWMAP_TYPE_VSM )
        vec2 offset = vec2(-1, 1) * shadowRadius * texelSize.y;
        shadow = (texture2DCompare(shadowMap, cubeToUV(bd3D + offset.xyy, texelSize.y), dp) +
            texture2DCompare(shadowMap, cubeToUV(bd3D + offset.yyy, texelSize.y), dp) +
            texture2DCompare(shadowMap, cubeToUV(bd3D + offset.xyx, texelSize.y), dp) +
            texture2DCompare(shadowMap, cubeToUV(bd3D + offset.yyx, texelSize.y), dp) +
            texture2DCompare(shadowMap, cubeToUV(bd3D, texelSize.y), dp) +
            texture2DCompare(shadowMap, cubeToUV(bd3D + offset.xxy, texelSize.y), dp) +
            texture2DCompare(shadowMap, cubeToUV(bd3D + offset.yxy, texelSize.y), dp) +
            texture2DCompare(shadowMap, cubeToUV(bd3D + offset.xxx, texelSize.y), dp) +
            texture2DCompare(shadowMap, cubeToUV(bd3D + offset.yxx, texelSize.y), dp)) * (1.0f / 9.0f);
			#else
        shadow = texture2DCompare(shadowMap, cubeToUV(bd3D, texelSize.y), dp);
			#endif
    }
    return mix(1.0f, shadow, shadowIntensity);
}
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
#ifdef USE_SPECULARMAP
uniform sampler2D specularMap;
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
    vec4 diffuseColor = vec4(diffuse, opacity);
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
    ReflectedLight reflectedLight = ReflectedLight(vec3(0.0f), vec3(0.0f), vec3(0.0f), vec3(0.0f));
    vec3 totalEmissiveRadiance = emissive;
#if defined( USE_LOGDEPTHBUF )
    gl_FragDepth = vIsPerspective == 0.0f ? gl_FragCoord.z : log2(vFragDepth) * logDepthBufFC * 0.5f;
#endif
#ifdef USE_MAP
    vec4 sampledDiffuseColor = texture2D(map, vMapUv);
	#ifdef DECODE_VIDEO_TEXTURE
    sampledDiffuseColor = sRGBTransferEOTF(sampledDiffuseColor);
	#endif
    diffuseColor *= sampledDiffuseColor;
#endif
#if defined( USE_COLOR_ALPHA )
    diffuseColor *= vColor;
#elif defined( USE_COLOR )
    diffuseColor.rgb *= vColor;
#endif
#ifdef USE_ALPHAMAP
    diffuseColor.a *= texture2D(alphaMap, vAlphaMapUv).g;
#endif
#ifdef USE_ALPHATEST
	#ifdef ALPHA_TO_COVERAGE
    diffuseColor.a = smoothstep(alphaTest, alphaTest + fwidth(diffuseColor.a), diffuseColor.a);
    if(diffuseColor.a == 0.0f)
        discard;
	#else
    if(diffuseColor.a < alphaTest)
        discard;
	#endif
#endif
#ifdef USE_ALPHAHASH
    if(diffuseColor.a < getAlphaHashThreshold(vPosition))
        discard;
#endif
    float specularStrength;
#ifdef USE_SPECULARMAP
    vec4 texelSpecular = texture2D(specularMap, vSpecularMapUv);
    specularStrength = texelSpecular.r;
#else
    specularStrength = 1.0f;
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
#ifdef USE_EMISSIVEMAP
    vec4 emissiveColor = texture2D(emissiveMap, vEmissiveMapUv);
	#ifdef DECODE_VIDEO_TEXTURE_EMISSIVE
    emissiveColor = sRGBTransferEOTF(emissiveColor);
	#endif
    totalEmissiveRadiance *= emissiveColor.rgb;
#endif
    BlinnPhongMaterial material;
    material.diffuseColor = diffuseColor.rgb;
    material.specularColor = specular;
    material.specularShininess = shininess;
    material.specularStrength = specularStrength;

    vec3 geometryPosition = -vViewPosition;
    vec3 geometryNormal = normal;
    vec3 geometryViewDir = (isOrthographic) ? vec3(0, 0, 1) : normalize(vViewPosition);
    vec3 geometryClearcoatNormal = vec3(0.0f);
#ifdef USE_CLEARCOAT
    geometryClearcoatNormal = clearcoatNormal;
#endif
#ifdef USE_IRIDESCENCE
    float dotNVi = saturate(dot(normal, geometryViewDir));
    if(material.iridescenceThickness == 0.0f) {
        material.iridescence = 0.0f;
    } else {
        material.iridescence = saturate(material.iridescence);
    }
    if(material.iridescence > 0.0f) {
        material.iridescenceFresnel = evalIridescence(1.0f, material.iridescenceIOR, dotNVi, material.iridescenceThickness, material.specularColor);
        material.iridescenceF0 = Schlick_to_F0(material.iridescenceFresnel, 1.0f, dotNVi);
    }
#endif
    IncidentLight directLight;
#if ( 0 > 0 ) && defined( RE_Direct )
    PointLight pointLight;
	#if defined( USE_SHADOWMAP ) && 0 > 0
    PointLightShadow pointLightShadow;
	#endif

#endif
#if ( 1 > 0 ) && defined( RE_Direct )
    SpotLight spotLight;
    vec4 spotColor;
    vec3 spotLightCoord;
    bool inSpotLightMap;
	#if defined( USE_SHADOWMAP ) && 1 > 0
    SpotLightShadow spotLightShadow;
	#endif

    spotLight = spotLights[0];
    getSpotLightInfo(spotLight, geometryPosition, directLight);
		#if ( 0 < 0 )
		#define SPOT_LIGHT_MAP_INDEX 0
		#elif ( 0 < 1 )
		#define SPOT_LIGHT_MAP_INDEX 0
		#else
		#define SPOT_LIGHT_MAP_INDEX ( 0 - 1 + 0 )
		#endif
		#if ( SPOT_LIGHT_MAP_INDEX < 0 )
    spotLightCoord = vSpotLightCoord[0].xyz / vSpotLightCoord[0].w;
    inSpotLightMap = all(lessThan(abs(spotLightCoord * 2.f - 1.f), vec3(1.0f)));
    spotColor = texture2D(spotLightMap[SPOT_LIGHT_MAP_INDEX], spotLightCoord.xy);
    directLight.color = inSpotLightMap ? directLight.color * spotColor.rgb : directLight.color;
		#endif
		#undef SPOT_LIGHT_MAP_INDEX
		#if defined( USE_SHADOWMAP ) && ( 0 < 1 )
    spotLightShadow = spotLightShadows[0];
    directLight.color *= (directLight.visible && receiveShadow) ? getShadow(spotShadowMap[0], spotLightShadow.shadowMapSize, spotLightShadow.shadowIntensity, spotLightShadow.shadowBias, spotLightShadow.shadowRadius, vSpotLightCoord[0]) : 1.0f;
		#endif
    RE_Direct(directLight, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight);

#endif
#if ( 0 > 0 ) && defined( RE_Direct )
    DirectionalLight directionalLight;
	#if defined( USE_SHADOWMAP ) && 0 > 0
    DirectionalLightShadow directionalLightShadow;
	#endif

#endif
#if ( 0 > 0 ) && defined( RE_Direct_RectArea )
    RectAreaLight rectAreaLight;

#endif
#if defined( RE_IndirectDiffuse )
    vec3 iblIrradiance = vec3(0.0f);
    vec3 irradiance = getAmbientLightIrradiance(ambientLightColor);
	#if defined( USE_LIGHT_PROBES )
    irradiance += getLightProbeIrradiance(lightProbe, geometryNormal);
	#endif
	#if ( 1 > 0 )

    irradiance += getHemisphereLightIrradiance(hemisphereLights[0], geometryNormal);

	#endif
#endif
#if defined( RE_IndirectSpecular )
    vec3 radiance = vec3(0.0f);
    vec3 clearcoatRadiance = vec3(0.0f);
#endif
#if defined( RE_IndirectDiffuse )
	#ifdef USE_LIGHTMAP
    vec4 lightMapTexel = texture2D(lightMap, vLightMapUv);
    vec3 lightMapIrradiance = lightMapTexel.rgb * lightMapIntensity;
    irradiance += lightMapIrradiance;
	#endif
	#if defined( USE_ENVMAP ) && defined( STANDARD ) && defined( ENVMAP_TYPE_CUBE_UV )
    iblIrradiance += getIBLIrradiance(geometryNormal);
	#endif
#endif
#if defined( USE_ENVMAP ) && defined( RE_IndirectSpecular )
	#ifdef USE_ANISOTROPY
    radiance += getIBLAnisotropyRadiance(geometryViewDir, geometryNormal, material.roughness, material.anisotropyB, material.anisotropy);
	#else
    radiance += getIBLRadiance(geometryViewDir, geometryNormal, material.roughness);
	#endif
	#ifdef USE_CLEARCOAT
    clearcoatRadiance += getIBLRadiance(geometryViewDir, geometryClearcoatNormal, material.clearcoatRoughness);
	#endif
#endif
#if defined( RE_IndirectDiffuse )
    RE_IndirectDiffuse(irradiance, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight);
#endif
#if defined( RE_IndirectSpecular )
    RE_IndirectSpecular(radiance, iblIrradiance, clearcoatRadiance, geometryPosition, geometryNormal, geometryViewDir, geometryClearcoatNormal, material, reflectedLight);
#endif
#ifdef USE_AOMAP
    float ambientOcclusion = (texture2D(aoMap, vAoMapUv).r - 1.0f) * aoMapIntensity + 1.0f;
    reflectedLight.indirectDiffuse *= ambientOcclusion;
	#if defined( USE_CLEARCOAT ) 
    clearcoatSpecularIndirect *= ambientOcclusion;
	#endif
	#if defined( USE_SHEEN ) 
    sheenSpecularIndirect *= ambientOcclusion;
	#endif
	#if defined( USE_ENVMAP ) && defined( STANDARD )
    float dotNV = saturate(dot(geometryNormal, geometryViewDir));
    reflectedLight.indirectSpecular *= computeSpecularOcclusion(dotNV, ambientOcclusion, material.roughness);
	#endif
#endif
    vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + reflectedLight.directSpecular + reflectedLight.indirectSpecular + totalEmissiveRadiance;
#ifdef USE_ENVMAP
	#ifdef ENV_WORLDPOS
    vec3 cameraToFrag;
    if(isOrthographic) {
        cameraToFrag = normalize(vec3(-viewMatrix[0][2], -viewMatrix[1][2], -viewMatrix[2][2]));
    } else {
        cameraToFrag = normalize(vWorldPosition - cameraPosition);
    }
    vec3 worldNormal = inverseTransformDirection(normal, viewMatrix);
		#ifdef ENVMAP_MODE_REFLECTION
    vec3 reflectVec = reflect(cameraToFrag, worldNormal);
		#else
    vec3 reflectVec = refract(cameraToFrag, worldNormal, refractionRatio);
		#endif
	#else
    vec3 reflectVec = vReflect;
	#endif
	#ifdef ENVMAP_TYPE_CUBE
    vec4 envColor = textureCube(envMap, envMapRotation * vec3(flipEnvMap * reflectVec.x, reflectVec.yz));
	#else
    vec4 envColor = vec4(0.0f);
	#endif
	#ifdef ENVMAP_BLENDING_MULTIPLY
    outgoingLight = mix(outgoingLight, outgoingLight * envColor.xyz, specularStrength * reflectivity);
	#elif defined( ENVMAP_BLENDING_MIX )
    outgoingLight = mix(outgoingLight, envColor.xyz, specularStrength * reflectivity);
	#elif defined( ENVMAP_BLENDING_ADD )
    outgoingLight += envColor.xyz * specularStrength * reflectivity;
	#endif
#endif
#ifdef OPAQUE
    diffuseColor.a = 1.0f;
#endif
#ifdef USE_TRANSMISSION
    diffuseColor.a *= material.transmissionAlpha;
#endif
    gl_FragColor = vec4(outgoingLight, diffuseColor.a);
#if defined( TONE_MAPPING )
    gl_FragColor.rgb = toneMapping(gl_FragColor.rgb);
#endif
    gl_FragColor = linearToOutputTexel(gl_FragColor);
#ifdef USE_FOG
	#ifdef FOG_EXP2
    float fogFactor = 1.0f - exp(-fogDensity * fogDensity * vFogDepth * vFogDepth);
	#else
    float fogFactor = smoothstep(fogNear, fogFar, vFogDepth);
	#endif
    gl_FragColor.rgb = mix(gl_FragColor.rgb, fogColor, fogFactor);
#endif
#ifdef PREMULTIPLIED_ALPHA
    gl_FragColor.rgb *= gl_FragColor.a;
#endif
#ifdef DITHERING
    gl_FragColor.rgb = dithering(gl_FragColor.rgb);
#endif
}