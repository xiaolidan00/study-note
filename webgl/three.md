# WebGLRenderer

## render(scene, camera)

```js
this.render = function (scene, camera) {
  if (camera !== undefined && camera.isCamera !== true) {
    console.error('THREE.WebGLRenderer.render: camera is not an instance of THREE.Camera.');
    return;
  }

  if (_isContextLost === true) return;

  //更新场景形状

  if (scene.matrixWorldAutoUpdate === true) scene.updateMatrixWorld();

  //更新相机矩阵和视锥

  if (camera.parent === null && camera.matrixWorldAutoUpdate === true) camera.updateMatrixWorld();

  if (xr.enabled === true && xr.isPresenting === true) {
    if (xr.cameraAutoUpdate === true) xr.updateCamera(camera);

    camera = xr.getCamera(); // use XR camera for rendering
  }

  //场景渲染前处理
  if (scene.isScene === true) scene.onBeforeRender(_this, scene, camera, _currentRenderTarget);
  //WebGLRenderStates
  currentRenderState = renderStates.get(scene, renderStateStack.length);
  //WebGLRenderState
  currentRenderState.init(camera);

  renderStateStack.push(currentRenderState);
  //投影矩阵，设置视锥矩阵
  _projScreenMatrix.multiplyMatrices(camera.projectionMatrix, camera.matrixWorldInverse);
  _frustum.setFromProjectionMatrix(_projScreenMatrix);

  _localClippingEnabled = this.localClippingEnabled;
  _clippingEnabled = clipping.init(this.clippingPlanes, _localClippingEnabled);
  //WebGLRenderLists
  currentRenderList = renderLists.get(scene, renderListStack.length);
  //WebGLRenderList
  currentRenderList.init();

  renderListStack.push(currentRenderList);

  if (xr.enabled === true && xr.isPresenting === true) {
    const depthSensingMesh = _this.xr.getDepthSensingMesh();

    if (depthSensingMesh !== null) {
      projectObject(depthSensingMesh, camera, -Infinity, _this.sortObjects);
    }
  }

  projectObject(scene, camera, 0, _this.sortObjects);

  //结束加入渲染列表
  currentRenderList.finish();

  if (_this.sortObjects === true) {
    //根据透明度排序
    currentRenderList.sort(_opaqueSort, _transparentSort);
  }

  _renderBackground =
    xr.enabled === false || xr.isPresenting === false || xr.hasDepthSensing() === false;
  //背景
  if (_renderBackground) {
    background.addToRenderList(currentRenderList, scene);
  }

  //

  this.info.render.frame++;
  //阴影裁剪
  if (_clippingEnabled === true) clipping.beginShadows();

  //WebGLShadowMap
  const shadowsArray = currentRenderState.state.shadowsArray;

  shadowMap.render(shadowsArray, scene, camera);

  if (_clippingEnabled === true) clipping.endShadows();

  //

  if (this.info.autoReset === true) this.info.reset();

  // 渲染场景

  const opaqueObjects = currentRenderList.opaque;
  const transmissiveObjects = currentRenderList.transmissive;
  //设置光照
  currentRenderState.setupLights();

  if (camera.isArrayCamera) {
    const cameras = camera.cameras;

    if (transmissiveObjects.length > 0) {
      for (let i = 0, l = cameras.length; i < l; i++) {
        const camera2 = cameras[i];

        renderTransmissionPass(opaqueObjects, transmissiveObjects, scene, camera2);
      }
    }

    if (_renderBackground) background.render(scene);

    for (let i = 0, l = cameras.length; i < l; i++) {
      const camera2 = cameras[i];

      renderScene(currentRenderList, scene, camera2, camera2.viewport);
    }
  } else {
    if (transmissiveObjects.length > 0)
      renderTransmissionPass(opaqueObjects, transmissiveObjects, scene, camera);

    //渲染背景 WebGLBackground
    if (_renderBackground) background.render(scene);

    renderScene(currentRenderList, scene, camera);
  }

  //

  if (_currentRenderTarget !== null) {
    // resolve multisample renderbuffers to a single-sample texture if necessary

    textures.updateMultisampleRenderTarget(_currentRenderTarget);

    // Generate mipmap if we're using any kind of mipmap filtering

    textures.updateRenderTargetMipmap(_currentRenderTarget);
  }

  //场景渲染后处理
  if (scene.isScene === true) scene.onAfterRender(_this, scene, camera);

  // _gl.finish();

  bindingStates.resetDefaultState();
  _currentMaterialId = -1;
  _currentCamera = null;

  renderStateStack.pop();

  if (renderStateStack.length > 0) {
    currentRenderState = renderStateStack[renderStateStack.length - 1];

    if (_clippingEnabled === true)
      clipping.setGlobalState(_this.clippingPlanes, currentRenderState.state.camera);
  } else {
    currentRenderState = null;
  }

  renderListStack.pop();

  if (renderListStack.length > 0) {
    currentRenderList = renderListStack[renderListStack.length - 1];
  } else {
    currentRenderList = null;
  }
};
```

## projectObject

```js
//分类对象
function projectObject(object, camera, groupOrder, sortObjects) {
  //判断对象是否可视
  if (object.visible === false) return;

  const visible = object.layers.test(camera.layers);

  if (visible) {
    //排序
    if (object.isGroup) {
      groupOrder = object.renderOrder;
    } else if (object.isLOD) {
      //LOD分层级

      if (object.autoUpdate === true) object.update(camera);
    } else if (object.isLight) {
      //接受光照

      currentRenderState.pushLight(object);

      if (object.castShadow) {
        //产生阴影

        currentRenderState.pushShadow(object);
      }
    } else if (object.isSprite) {
      //精灵贴图

      if (!object.frustumCulled || _frustum.intersectsSprite(object)) {
        //在视线范围内

        if (sortObjects) {
          _vector4.setFromMatrixPosition(object.matrixWorld).applyMatrix4(_projScreenMatrix);
        }

        const geometry = objects.update(object);
        const material = object.material;

        if (material.visible) {
          currentRenderList.push(object, geometry, material, groupOrder, _vector4.z, null);
        }
      }
    } else if (object.isMesh || object.isLine || object.isPoints) {
      //3D对象

      if (!object.frustumCulled || _frustum.intersectsObject(object)) {
        //在视线范围内
        const geometry = objects.update(object);
        const material = object.material;

        if (sortObjects) {
          //根据3D对象前后位置排序
          if (object.boundingSphere !== undefined) {
            if (object.boundingSphere === null) object.computeBoundingSphere();
            _vector4.copy(object.boundingSphere.center);
          } else {
            if (geometry.boundingSphere === null) geometry.computeBoundingSphere();
            _vector4.copy(geometry.boundingSphere.center);
          }

          _vector4.applyMatrix4(object.matrixWorld).applyMatrix4(_projScreenMatrix);
        }
        //材质
        if (Array.isArray(material)) {
          const groups = geometry.groups;

          for (let i = 0, l = groups.length; i < l; i++) {
            const group = groups[i];
            const groupMaterial = material[group.materialIndex];

            if (groupMaterial && groupMaterial.visible) {
              currentRenderList.push(
                object,
                geometry,
                groupMaterial,
                groupOrder,
                _vector4.z,
                group
              );
            }
          }
        } else if (material.visible) {
          currentRenderList.push(object, geometry, material, groupOrder, _vector4.z, null);
        }
      }
    }
  }

  const children = object.children;
  //遍历子对象
  for (let i = 0, l = children.length; i < l; i++) {
    projectObject(children[i], camera, groupOrder, sortObjects);
  }
}
```

## renderScene

```js
function renderScene(currentRenderList, scene, camera, viewport) {
  const opaqueObjects = currentRenderList.opaque;
  const transmissiveObjects = currentRenderList.transmissive;
  const transparentObjects = currentRenderList.transparent;
  //WebGLLights
  currentRenderState.setupLightsView(camera);

  if (_clippingEnabled === true) clipping.setGlobalState(_this.clippingPlanes, camera);

  if (viewport) state.viewport(_currentViewport.copy(viewport));

  if (opaqueObjects.length > 0) renderObjects(opaqueObjects, scene, camera);
  if (transmissiveObjects.length > 0) renderObjects(transmissiveObjects, scene, camera);
  if (transparentObjects.length > 0) renderObjects(transparentObjects, scene, camera);

  // Ensure depth buffer writing is enabled so it can be cleared on next render

  //深度测试
  state.buffers.depth.setTest(true);
  //深度缓冲
  state.buffers.depth.setMask(true);
  //颜色缓冲
  state.buffers.color.setMask(true);
  //设置用于计算深度值的比例和单位
  state.setPolygonOffset(false);
}
```

## renderObjects

```js
//渲染对象
function renderObjects(renderList, scene, camera) {
  const overrideMaterial = scene.isScene === true ? scene.overrideMaterial : null;

  for (let i = 0, l = renderList.length; i < l; i++) {
    const renderItem = renderList[i];

    const object = renderItem.object;
    const geometry = renderItem.geometry;
    const material = overrideMaterial === null ? renderItem.material : overrideMaterial;
    const group = renderItem.group;

    if (object.layers.test(camera.layers)) {
      renderObject(object, scene, camera, geometry, material, group);
    }
  }
}
```

## renderObject

```js
function renderObject(object, scene, camera, geometry, material, group) {
  object.onBeforeRender(_this, scene, camera, geometry, material, group);

  object.modelViewMatrix.multiplyMatrices(camera.matrixWorldInverse, object.matrixWorld);
  object.normalMatrix.getNormalMatrix(object.modelViewMatrix);

  material.onBeforeRender(_this, scene, camera, geometry, object, group);

  //双面可见
  if (
    material.transparent === true &&
    material.side === DoubleSide &&
    material.forceSinglePass === false
  ) {
    material.side = BackSide;
    material.needsUpdate = true;
    //渲染对象
    _this.renderBufferDirect(camera, scene, geometry, material, object, group);

    material.side = FrontSide;
    material.needsUpdate = true;
    //渲染对象
    _this.renderBufferDirect(camera, scene, geometry, material, object, group);

    material.side = DoubleSide;
  } else {
    //渲染对象
    _this.renderBufferDirect(camera, scene, geometry, material, object, group);
  }

  object.onAfterRender(_this, scene, camera, geometry, material, group);
}
```

## renderBufferDirect

```js
this.renderBufferDirect = function (camera, scene, geometry, material, object, group) {
  if (scene === null) scene = _emptyScene; // renderBufferDirect second parameter used to be fog (could be null)

  const frontFaceCW = object.isMesh && object.matrixWorld.determinant() < 0;

  const program = setProgram(camera, scene, geometry, material, object);
  //WebGLState
  state.setMaterial(material, frontFaceCW);

  //

  let index = geometry.index;
  let rangeFactor = 1;
  //线框
  if (material.wireframe === true) {
    index = geometries.getWireframeAttribute(geometry);

    if (index === undefined) return;

    rangeFactor = 2;
  }

  //

  const drawRange = geometry.drawRange;
  const position = geometry.attributes.position;

  let drawStart = drawRange.start * rangeFactor;
  let drawEnd = (drawRange.start + drawRange.count) * rangeFactor;

  if (group !== null) {
    drawStart = Math.max(drawStart, group.start * rangeFactor);
    drawEnd = Math.min(drawEnd, (group.start + group.count) * rangeFactor);
  }

  if (index !== null) {
    drawStart = Math.max(drawStart, 0);
    drawEnd = Math.min(drawEnd, index.count);
  } else if (position !== undefined && position !== null) {
    drawStart = Math.max(drawStart, 0);
    drawEnd = Math.min(drawEnd, position.count);
  }

  const drawCount = drawEnd - drawStart;

  if (drawCount < 0 || drawCount === Infinity) return;

  //

  bindingStates.setup(object, material, program, geometry, index);

  let attribute;
  let renderer = bufferRenderer;

  if (index !== null) {
    attribute = attributes.get(index);

    renderer = indexedBufferRenderer;
    renderer.setIndex(attribute);
  }

  //
  if (object.isMesh) {
    //线框
    if (material.wireframe === true) {
      state.setLineWidth(material.wireframeLinewidth * getTargetPixelRatio());
      renderer.setMode(_gl.LINES);
    } else {
      //三角面
      renderer.setMode(_gl.TRIANGLES);
    }
  } else if (object.isLine) {
    //线段
    let lineWidth = material.linewidth;

    if (lineWidth === undefined) lineWidth = 1; // Not using Line*Material

    state.setLineWidth(lineWidth * getTargetPixelRatio());

    if (object.isLineSegments) {
      renderer.setMode(_gl.LINES);
    } else if (object.isLineLoop) {
      renderer.setMode(_gl.LINE_LOOP);
    } else {
      renderer.setMode(_gl.LINE_STRIP);
    }
  } else if (object.isPoints) {
    //点
    renderer.setMode(_gl.POINTS);
  } else if (object.isSprite) {
    //精灵
    renderer.setMode(_gl.TRIANGLES);
  }

  if (object.isBatchedMesh) {
    if (object._multiDrawInstances !== null) {
      renderer.renderMultiDrawInstances(
        object._multiDrawStarts,
        object._multiDrawCounts,
        object._multiDrawCount,
        object._multiDrawInstances
      );
    } else {
      if (!extensions.get('WEBGL_multi_draw')) {
        const starts = object._multiDrawStarts;
        const counts = object._multiDrawCounts;
        const drawCount = object._multiDrawCount;
        const bytesPerElement = index ? attributes.get(index).bytesPerElement : 1;
        const uniforms = properties.get(material).currentProgram.getUniforms();
        for (let i = 0; i < drawCount; i++) {
          uniforms.setValue(_gl, '_gl_DrawID', i);
          renderer.render(starts[i] / bytesPerElement, counts[i]);
        }
      } else {
        renderer.renderMultiDraw(
          object._multiDrawStarts,
          object._multiDrawCounts,
          object._multiDrawCount
        );
      }
    }
  } else if (object.isInstancedMesh) {
    //实例网格
    renderer.renderInstances(drawStart, drawCount, object.count);
  } else if (geometry.isInstancedBufferGeometry) {
    const maxInstanceCount =
      geometry._maxInstanceCount !== undefined ? geometry._maxInstanceCount : Infinity;
    const instanceCount = Math.min(geometry.instanceCount, maxInstanceCount);

    renderer.renderInstances(drawStart, drawCount, instanceCount);
  } else {
    //绘制对象范围
    renderer.render(drawStart, drawCount);
  }
};
```

## setProgram

```js
function setProgram(camera, scene, geometry, material, object) {
  if (scene.isScene !== true) scene = _emptyScene; // scene could be a Mesh, Line, Points, ...

  textures.resetTextureUnits();

  const fog = scene.fog;
  const environment = material.isMeshStandardMaterial ? scene.environment : null;
  const colorSpace =
    _currentRenderTarget === null
      ? _this.outputColorSpace
      : _currentRenderTarget.isXRRenderTarget === true
      ? _currentRenderTarget.texture.colorSpace
      : LinearSRGBColorSpace;
  const envMap = (material.isMeshStandardMaterial ? cubeuvmaps : cubemaps).get(
    material.envMap || environment
  );
  const vertexAlphas =
    material.vertexColors === true &&
    !!geometry.attributes.color &&
    geometry.attributes.color.itemSize === 4;
  const vertexTangents =
    !!geometry.attributes.tangent && (!!material.normalMap || material.anisotropy > 0);
  const morphTargets = !!geometry.morphAttributes.position;
  const morphNormals = !!geometry.morphAttributes.normal;
  const morphColors = !!geometry.morphAttributes.color;

  let toneMapping = NoToneMapping;

  if (material.toneMapped) {
    if (_currentRenderTarget === null || _currentRenderTarget.isXRRenderTarget === true) {
      toneMapping = _this.toneMapping;
    }
  }

  const morphAttribute =
    geometry.morphAttributes.position ||
    geometry.morphAttributes.normal ||
    geometry.morphAttributes.color;
  const morphTargetsCount = morphAttribute !== undefined ? morphAttribute.length : 0;

  const materialProperties = properties.get(material);
  const lights = currentRenderState.state.lights;

  if (_clippingEnabled === true) {
    if (_localClippingEnabled === true || camera !== _currentCamera) {
      const useCache = camera === _currentCamera && material.id === _currentMaterialId;

      // we might want to call this function with some ClippingGroup
      // object instead of the material, once it becomes feasible
      // (#8465, #8379)
      clipping.setState(material, camera, useCache);
    }
  }

  //

  let needsProgramChange = false;

  if (material.version === materialProperties.__version) {
    if (
      materialProperties.needsLights &&
      materialProperties.lightsStateVersion !== lights.state.version
    ) {
      needsProgramChange = true;
    } else if (materialProperties.outputColorSpace !== colorSpace) {
      needsProgramChange = true;
    } else if (object.isBatchedMesh && materialProperties.batching === false) {
      needsProgramChange = true;
    } else if (!object.isBatchedMesh && materialProperties.batching === true) {
      needsProgramChange = true;
    } else if (
      object.isBatchedMesh &&
      materialProperties.batchingColor === true &&
      object.colorTexture === null
    ) {
      needsProgramChange = true;
    } else if (
      object.isBatchedMesh &&
      materialProperties.batchingColor === false &&
      object.colorTexture !== null
    ) {
      needsProgramChange = true;
    } else if (object.isInstancedMesh && materialProperties.instancing === false) {
      needsProgramChange = true;
    } else if (!object.isInstancedMesh && materialProperties.instancing === true) {
      needsProgramChange = true;
    } else if (object.isSkinnedMesh && materialProperties.skinning === false) {
      needsProgramChange = true;
    } else if (!object.isSkinnedMesh && materialProperties.skinning === true) {
      needsProgramChange = true;
    } else if (
      object.isInstancedMesh &&
      materialProperties.instancingColor === true &&
      object.instanceColor === null
    ) {
      needsProgramChange = true;
    } else if (
      object.isInstancedMesh &&
      materialProperties.instancingColor === false &&
      object.instanceColor !== null
    ) {
      needsProgramChange = true;
    } else if (
      object.isInstancedMesh &&
      materialProperties.instancingMorph === true &&
      object.morphTexture === null
    ) {
      needsProgramChange = true;
    } else if (
      object.isInstancedMesh &&
      materialProperties.instancingMorph === false &&
      object.morphTexture !== null
    ) {
      needsProgramChange = true;
    } else if (materialProperties.envMap !== envMap) {
      needsProgramChange = true;
    } else if (material.fog === true && materialProperties.fog !== fog) {
      needsProgramChange = true;
    } else if (
      materialProperties.numClippingPlanes !== undefined &&
      (materialProperties.numClippingPlanes !== clipping.numPlanes ||
        materialProperties.numIntersection !== clipping.numIntersection)
    ) {
      needsProgramChange = true;
    } else if (materialProperties.vertexAlphas !== vertexAlphas) {
      needsProgramChange = true;
    } else if (materialProperties.vertexTangents !== vertexTangents) {
      needsProgramChange = true;
    } else if (materialProperties.morphTargets !== morphTargets) {
      needsProgramChange = true;
    } else if (materialProperties.morphNormals !== morphNormals) {
      needsProgramChange = true;
    } else if (materialProperties.morphColors !== morphColors) {
      needsProgramChange = true;
    } else if (materialProperties.toneMapping !== toneMapping) {
      needsProgramChange = true;
    } else if (materialProperties.morphTargetsCount !== morphTargetsCount) {
      needsProgramChange = true;
    }
  } else {
    needsProgramChange = true;
    materialProperties.__version = material.version;
  }

  //

  let program = materialProperties.currentProgram;

  if (needsProgramChange === true) {
    program = getProgram(material, scene, object);
  }

  let refreshProgram = false;
  let refreshMaterial = false;
  let refreshLights = false;
  //WebGLUniforms
  const p_uniforms = program.getUniforms(),
    m_uniforms = materialProperties.uniforms;

  if (state.useProgram(program.program)) {
    refreshProgram = true;
    refreshMaterial = true;
    refreshLights = true;
  }

  if (material.id !== _currentMaterialId) {
    _currentMaterialId = material.id;

    refreshMaterial = true;
  }

  if (refreshProgram || _currentCamera !== camera) {
    // common camera uniforms

    //相机矩阵
    if (capabilities.reverseDepthBuffer) {
      _currentProjectionMatrix.copy(camera.projectionMatrix);

      toNormalizedProjectionMatrix(_currentProjectionMatrix);
      toReversedProjectionMatrix(_currentProjectionMatrix);

      p_uniforms.setValue(_gl, 'projectionMatrix', _currentProjectionMatrix);
    } else {
      p_uniforms.setValue(_gl, 'projectionMatrix', camera.projectionMatrix);
    }
    //世界矩阵
    p_uniforms.setValue(_gl, 'viewMatrix', camera.matrixWorldInverse);

    const uCamPos = p_uniforms.map.cameraPosition;

    if (uCamPos !== undefined) {
      uCamPos.setValue(_gl, _vector3.setFromMatrixPosition(camera.matrixWorld));
    }
    //是否逻辑深度渲染，根据相交距离，避免深度冲突
    if (capabilities.logarithmicDepthBuffer) {
      p_uniforms.setValue(_gl, 'logDepthBufFC', 2.0 / (Math.log(camera.far + 1.0) / Math.LN2));
    }

    // consider moving isOrthographic to UniformLib and WebGLMaterials, see https://github.com/mrdoob/three.js/pull/26467#issuecomment-1645185067

    if (
      material.isMeshPhongMaterial ||
      material.isMeshToonMaterial ||
      material.isMeshLambertMaterial ||
      material.isMeshBasicMaterial ||
      material.isMeshStandardMaterial ||
      material.isShaderMaterial
    ) {
      //是否正交投影
      p_uniforms.setValue(_gl, 'isOrthographic', camera.isOrthographicCamera === true);
    }

    if (_currentCamera !== camera) {
      _currentCamera = camera;

      // lighting uniforms depend on the camera so enforce an update
      // now, in case this material supports lights - or later, when
      // the next material that does gets activated:

      refreshMaterial = true; // set to true on material change
      refreshLights = true; // remains set until update done
    }
  }

  // skinning and morph target uniforms must be set even if material didn't change
  // auto-setting of texture unit for bone and morph texture must go before other textures
  // otherwise textures used for skinning and morphing can take over texture units reserved for other material textures
  //骨骼
  if (object.isSkinnedMesh) {
    p_uniforms.setOptional(_gl, object, 'bindMatrix');
    p_uniforms.setOptional(_gl, object, 'bindMatrixInverse');

    const skeleton = object.skeleton;

    if (skeleton) {
      if (skeleton.boneTexture === null) skeleton.computeBoneTexture();

      p_uniforms.setValue(_gl, 'boneTexture', skeleton.boneTexture, textures);
    }
  }

  if (object.isBatchedMesh) {
    p_uniforms.setOptional(_gl, object, 'batchingTexture');
    p_uniforms.setValue(_gl, 'batchingTexture', object._matricesTexture, textures);

    p_uniforms.setOptional(_gl, object, 'batchingIdTexture');
    p_uniforms.setValue(_gl, 'batchingIdTexture', object._indirectTexture, textures);

    p_uniforms.setOptional(_gl, object, 'batchingColorTexture');
    if (object._colorsTexture !== null) {
      p_uniforms.setValue(_gl, 'batchingColorTexture', object._colorsTexture, textures);
    }
  }

  const morphAttributes = geometry.morphAttributes;
  //动画属性
  if (
    morphAttributes.position !== undefined ||
    morphAttributes.normal !== undefined ||
    morphAttributes.color !== undefined
  ) {
    morphtargets.update(object, geometry, program);
  }
  //阴影
  if (refreshMaterial || materialProperties.receiveShadow !== object.receiveShadow) {
    materialProperties.receiveShadow = object.receiveShadow;
    p_uniforms.setValue(_gl, 'receiveShadow', object.receiveShadow);
  }

  // https://github.com/mrdoob/three.js/pull/24467#issuecomment-1209031512

  if (material.isMeshGouraudMaterial && material.envMap !== null) {
    m_uniforms.envMap.value = envMap;

    m_uniforms.flipEnvMap.value =
      envMap.isCubeTexture && envMap.isRenderTargetTexture === false ? -1 : 1;
  }

  if (material.isMeshStandardMaterial && material.envMap === null && scene.environment !== null) {
    m_uniforms.envMapIntensity.value = scene.environmentIntensity;
  }

  if (refreshMaterial) {
    p_uniforms.setValue(_gl, 'toneMappingExposure', _this.toneMappingExposure);
    //
    if (materialProperties.needsLights) {
      // the current material requires lighting info

      // note: all lighting uniforms are always set correctly
      // they simply reference the renderer's state for their
      // values
      //
      // use the current material's .needsUpdate flags to set
      // the GL state when required

      markUniformsLightsNeedsUpdate(m_uniforms, refreshLights);
    }

    // refresh uniforms common to several materials

    if (fog && material.fog === true) {
      materials.refreshFogUniforms(m_uniforms, fog);
    }
    //WebGLMaterials
    materials.refreshMaterialUniforms(
      m_uniforms,
      material,
      _pixelRatio,
      _height,
      currentRenderState.state.transmissionRenderTarget[camera.id]
    );

    WebGLUniforms.upload(_gl, getUniformList(materialProperties), m_uniforms, textures);
  }

  if (material.isShaderMaterial && material.uniformsNeedUpdate === true) {
    WebGLUniforms.upload(_gl, getUniformList(materialProperties), m_uniforms, textures);
    material.uniformsNeedUpdate = false;
  }

  if (material.isSpriteMaterial) {
    p_uniforms.setValue(_gl, 'center', object.center);
  }

  // 通用矩阵

  p_uniforms.setValue(_gl, 'modelViewMatrix', object.modelViewMatrix);
  p_uniforms.setValue(_gl, 'normalMatrix', object.normalMatrix);
  p_uniforms.setValue(_gl, 'modelMatrix', object.matrixWorld);

  // UBOs

  if (material.isShaderMaterial || material.isRawShaderMaterial) {
    const groups = material.uniformsGroups;

    for (let i = 0, l = groups.length; i < l; i++) {
      const group = groups[i];

      uniformsGroups.update(group, program);
      uniformsGroups.bind(group, program);
    }
  }

  return program;
}
```

## getProgram

```js
//WebGLProgram
function getProgram(material, scene, object) {
  if (scene.isScene !== true) scene = _emptyScene; // scene could be a Mesh, Line, Points, ...

  const materialProperties = properties.get(material);

  const lights = currentRenderState.state.lights;
  const shadowsArray = currentRenderState.state.shadowsArray;

  const lightsStateVersion = lights.state.version;

  const parameters = programCache.getParameters(
    material,
    lights.state,
    shadowsArray,
    scene,
    object
  );
  //缓存program
  const programCacheKey = programCache.getProgramCacheKey(parameters);

  let programs = materialProperties.programs;

  // always update environment and fog - changing these trigger an getProgram call, but it's possible that the program doesn't change

  materialProperties.environment = material.isMeshStandardMaterial ? scene.environment : null;
  materialProperties.fog = scene.fog;
  materialProperties.envMap = (material.isMeshStandardMaterial ? cubeuvmaps : cubemaps).get(
    material.envMap || materialProperties.environment
  );
  materialProperties.envMapRotation =
    materialProperties.environment !== null && material.envMap === null
      ? scene.environmentRotation
      : material.envMapRotation;

  if (programs === undefined) {
    // new material

    material.addEventListener('dispose', onMaterialDispose);

    programs = new Map();
    materialProperties.programs = programs;
  }

  let program = programs.get(programCacheKey);

  if (program !== undefined) {
    // early out if program and light state is identical

    if (
      materialProperties.currentProgram === program &&
      materialProperties.lightsStateVersion === lightsStateVersion
    ) {
      updateCommonMaterialProperties(material, parameters);

      return program;
    }
  } else {
    parameters.uniforms = programCache.getUniforms(material);

    material.onBeforeCompile(parameters, _this);

    program = programCache.acquireProgram(parameters, programCacheKey);
    programs.set(programCacheKey, program);

    materialProperties.uniforms = parameters.uniforms;
  }

  const uniforms = materialProperties.uniforms;

  if ((!material.isShaderMaterial && !material.isRawShaderMaterial) || material.clipping === true) {
    uniforms.clippingPlanes = clipping.uniform;
  }

  updateCommonMaterialProperties(material, parameters);

  // store the light setup it was created for

  materialProperties.needsLights = materialNeedsLights(material);
  materialProperties.lightsStateVersion = lightsStateVersion;

  if (materialProperties.needsLights) {
    // wire up the material to this renderer's lighting state

    uniforms.ambientLightColor.value = lights.state.ambient;
    uniforms.lightProbe.value = lights.state.probe;
    uniforms.directionalLights.value = lights.state.directional;
    uniforms.directionalLightShadows.value = lights.state.directionalShadow;
    uniforms.spotLights.value = lights.state.spot;
    uniforms.spotLightShadows.value = lights.state.spotShadow;
    uniforms.rectAreaLights.value = lights.state.rectArea;
    uniforms.ltc_1.value = lights.state.rectAreaLTC1;
    uniforms.ltc_2.value = lights.state.rectAreaLTC2;
    uniforms.pointLights.value = lights.state.point;
    uniforms.pointLightShadows.value = lights.state.pointShadow;
    uniforms.hemisphereLights.value = lights.state.hemi;

    uniforms.directionalShadowMap.value = lights.state.directionalShadowMap;
    uniforms.directionalShadowMatrix.value = lights.state.directionalShadowMatrix;
    uniforms.spotShadowMap.value = lights.state.spotShadowMap;
    uniforms.spotLightMatrix.value = lights.state.spotLightMatrix;
    uniforms.spotLightMap.value = lights.state.spotLightMap;
    uniforms.pointShadowMap.value = lights.state.pointShadowMap;
    uniforms.pointShadowMatrix.value = lights.state.pointShadowMatrix;
    // TODO (abelnation): add area lights shadow info to uniforms
  }

  materialProperties.currentProgram = program;
  materialProperties.uniformsList = null;

  return program;
}
```

## getParameters

```js
function getParameters(material, lights, shadows, scene, object) {
  const fog = scene.fog;
  const geometry = object.geometry;
  const environment = material.isMeshStandardMaterial ? scene.environment : null;

  const envMap = (material.isMeshStandardMaterial ? cubeuvmaps : cubemaps).get(
    material.envMap || environment
  );
  const envMapCubeUVHeight =
    !!envMap && envMap.mapping === CubeUVReflectionMapping ? envMap.image.height : null;

  //根据material类型获取shader
  const shaderID = shaderIDs[material.type];

  // heuristics to create shader parameters according to lights in the scene
  // (not to blow over maxLights budget)

  if (material.precision !== null) {
    precision = capabilities.getMaxPrecision(material.precision);

    if (precision !== material.precision) {
      console.warn(
        'THREE.WebGLProgram.getParameters:',
        material.precision,
        'not supported, using',
        precision,
        'instead.'
      );
    }
  }

  //

  const morphAttribute =
    geometry.morphAttributes.position ||
    geometry.morphAttributes.normal ||
    geometry.morphAttributes.color;
  const morphTargetsCount = morphAttribute !== undefined ? morphAttribute.length : 0;

  let morphTextureStride = 0;

  if (geometry.morphAttributes.position !== undefined) morphTextureStride = 1;
  if (geometry.morphAttributes.normal !== undefined) morphTextureStride = 2;
  if (geometry.morphAttributes.color !== undefined) morphTextureStride = 3;

  //

  let vertexShader, fragmentShader;
  let customVertexShaderID, customFragmentShaderID;

  if (shaderID) {
    //shader库
    const shader = ShaderLib[shaderID];

    vertexShader = shader.vertexShader;
    fragmentShader = shader.fragmentShader;
  } else {
    vertexShader = material.vertexShader;
    fragmentShader = material.fragmentShader;

    _customShaders.update(material);

    customVertexShaderID = _customShaders.getVertexShaderID(material);
    customFragmentShaderID = _customShaders.getFragmentShaderID(material);
  }

  const currentRenderTarget = renderer.getRenderTarget();
  //一些IF变量对shader的影响
  const IS_INSTANCEDMESH = object.isInstancedMesh === true;
  const IS_BATCHEDMESH = object.isBatchedMesh === true;

  const HAS_MAP = !!material.map;
  const HAS_MATCAP = !!material.matcap;
  const HAS_ENVMAP = !!envMap;
  const HAS_AOMAP = !!material.aoMap;
  const HAS_LIGHTMAP = !!material.lightMap;
  const HAS_BUMPMAP = !!material.bumpMap;
  const HAS_NORMALMAP = !!material.normalMap;
  const HAS_DISPLACEMENTMAP = !!material.displacementMap;
  const HAS_EMISSIVEMAP = !!material.emissiveMap;

  const HAS_METALNESSMAP = !!material.metalnessMap;
  const HAS_ROUGHNESSMAP = !!material.roughnessMap;

  const HAS_ANISOTROPY = material.anisotropy > 0;
  const HAS_CLEARCOAT = material.clearcoat > 0;
  const HAS_DISPERSION = material.dispersion > 0;
  const HAS_IRIDESCENCE = material.iridescence > 0;
  const HAS_SHEEN = material.sheen > 0;
  const HAS_TRANSMISSION = material.transmission > 0;

  const HAS_ANISOTROPYMAP = HAS_ANISOTROPY && !!material.anisotropyMap;

  const HAS_CLEARCOATMAP = HAS_CLEARCOAT && !!material.clearcoatMap;
  const HAS_CLEARCOAT_NORMALMAP = HAS_CLEARCOAT && !!material.clearcoatNormalMap;
  const HAS_CLEARCOAT_ROUGHNESSMAP = HAS_CLEARCOAT && !!material.clearcoatRoughnessMap;

  const HAS_IRIDESCENCEMAP = HAS_IRIDESCENCE && !!material.iridescenceMap;
  const HAS_IRIDESCENCE_THICKNESSMAP = HAS_IRIDESCENCE && !!material.iridescenceThicknessMap;

  const HAS_SHEEN_COLORMAP = HAS_SHEEN && !!material.sheenColorMap;
  const HAS_SHEEN_ROUGHNESSMAP = HAS_SHEEN && !!material.sheenRoughnessMap;

  const HAS_SPECULARMAP = !!material.specularMap;
  const HAS_SPECULAR_COLORMAP = !!material.specularColorMap;
  const HAS_SPECULAR_INTENSITYMAP = !!material.specularIntensityMap;

  const HAS_TRANSMISSIONMAP = HAS_TRANSMISSION && !!material.transmissionMap;
  const HAS_THICKNESSMAP = HAS_TRANSMISSION && !!material.thicknessMap;

  const HAS_GRADIENTMAP = !!material.gradientMap;

  const HAS_ALPHAMAP = !!material.alphaMap;

  const HAS_ALPHATEST = material.alphaTest > 0;

  const HAS_ALPHAHASH = !!material.alphaHash;

  const HAS_EXTENSIONS = !!material.extensions;

  let toneMapping = NoToneMapping;

  if (material.toneMapped) {
    if (currentRenderTarget === null || currentRenderTarget.isXRRenderTarget === true) {
      toneMapping = renderer.toneMapping;
    }
  }
  //配置参数
  const parameters = {
    shaderID: shaderID,
    shaderType: material.type,
    shaderName: material.name,

    vertexShader: vertexShader,
    fragmentShader: fragmentShader,
    defines: material.defines,

    customVertexShaderID: customVertexShaderID,
    customFragmentShaderID: customFragmentShaderID,

    isRawShaderMaterial: material.isRawShaderMaterial === true,
    glslVersion: material.glslVersion,

    precision: precision,

    batching: IS_BATCHEDMESH,
    batchingColor: IS_BATCHEDMESH && object._colorsTexture !== null,
    instancing: IS_INSTANCEDMESH,
    instancingColor: IS_INSTANCEDMESH && object.instanceColor !== null,
    instancingMorph: IS_INSTANCEDMESH && object.morphTexture !== null,

    supportsVertexTextures: SUPPORTS_VERTEX_TEXTURES,
    outputColorSpace:
      currentRenderTarget === null
        ? renderer.outputColorSpace
        : currentRenderTarget.isXRRenderTarget === true
        ? currentRenderTarget.texture.colorSpace
        : LinearSRGBColorSpace,
    alphaToCoverage: !!material.alphaToCoverage,

    map: HAS_MAP,
    matcap: HAS_MATCAP,
    envMap: HAS_ENVMAP,
    envMapMode: HAS_ENVMAP && envMap.mapping,
    envMapCubeUVHeight: envMapCubeUVHeight,
    aoMap: HAS_AOMAP,
    lightMap: HAS_LIGHTMAP,
    bumpMap: HAS_BUMPMAP,
    normalMap: HAS_NORMALMAP,
    displacementMap: SUPPORTS_VERTEX_TEXTURES && HAS_DISPLACEMENTMAP,
    emissiveMap: HAS_EMISSIVEMAP,

    normalMapObjectSpace: HAS_NORMALMAP && material.normalMapType === ObjectSpaceNormalMap,
    normalMapTangentSpace: HAS_NORMALMAP && material.normalMapType === TangentSpaceNormalMap,

    metalnessMap: HAS_METALNESSMAP,
    roughnessMap: HAS_ROUGHNESSMAP,

    anisotropy: HAS_ANISOTROPY,
    anisotropyMap: HAS_ANISOTROPYMAP,

    clearcoat: HAS_CLEARCOAT,
    clearcoatMap: HAS_CLEARCOATMAP,
    clearcoatNormalMap: HAS_CLEARCOAT_NORMALMAP,
    clearcoatRoughnessMap: HAS_CLEARCOAT_ROUGHNESSMAP,

    dispersion: HAS_DISPERSION,

    iridescence: HAS_IRIDESCENCE,
    iridescenceMap: HAS_IRIDESCENCEMAP,
    iridescenceThicknessMap: HAS_IRIDESCENCE_THICKNESSMAP,

    sheen: HAS_SHEEN,
    sheenColorMap: HAS_SHEEN_COLORMAP,
    sheenRoughnessMap: HAS_SHEEN_ROUGHNESSMAP,

    specularMap: HAS_SPECULARMAP,
    specularColorMap: HAS_SPECULAR_COLORMAP,
    specularIntensityMap: HAS_SPECULAR_INTENSITYMAP,

    transmission: HAS_TRANSMISSION,
    transmissionMap: HAS_TRANSMISSIONMAP,
    thicknessMap: HAS_THICKNESSMAP,

    gradientMap: HAS_GRADIENTMAP,

    opaque:
      material.transparent === false &&
      material.blending === NormalBlending &&
      material.alphaToCoverage === false,

    alphaMap: HAS_ALPHAMAP,
    alphaTest: HAS_ALPHATEST,
    alphaHash: HAS_ALPHAHASH,

    combine: material.combine,

    //

    mapUv: HAS_MAP && getChannel(material.map.channel),
    aoMapUv: HAS_AOMAP && getChannel(material.aoMap.channel),
    lightMapUv: HAS_LIGHTMAP && getChannel(material.lightMap.channel),
    bumpMapUv: HAS_BUMPMAP && getChannel(material.bumpMap.channel),
    normalMapUv: HAS_NORMALMAP && getChannel(material.normalMap.channel),
    displacementMapUv: HAS_DISPLACEMENTMAP && getChannel(material.displacementMap.channel),
    emissiveMapUv: HAS_EMISSIVEMAP && getChannel(material.emissiveMap.channel),

    metalnessMapUv: HAS_METALNESSMAP && getChannel(material.metalnessMap.channel),
    roughnessMapUv: HAS_ROUGHNESSMAP && getChannel(material.roughnessMap.channel),

    anisotropyMapUv: HAS_ANISOTROPYMAP && getChannel(material.anisotropyMap.channel),

    clearcoatMapUv: HAS_CLEARCOATMAP && getChannel(material.clearcoatMap.channel),
    clearcoatNormalMapUv:
      HAS_CLEARCOAT_NORMALMAP && getChannel(material.clearcoatNormalMap.channel),
    clearcoatRoughnessMapUv:
      HAS_CLEARCOAT_ROUGHNESSMAP && getChannel(material.clearcoatRoughnessMap.channel),

    iridescenceMapUv: HAS_IRIDESCENCEMAP && getChannel(material.iridescenceMap.channel),
    iridescenceThicknessMapUv:
      HAS_IRIDESCENCE_THICKNESSMAP && getChannel(material.iridescenceThicknessMap.channel),

    sheenColorMapUv: HAS_SHEEN_COLORMAP && getChannel(material.sheenColorMap.channel),
    sheenRoughnessMapUv: HAS_SHEEN_ROUGHNESSMAP && getChannel(material.sheenRoughnessMap.channel),

    specularMapUv: HAS_SPECULARMAP && getChannel(material.specularMap.channel),
    specularColorMapUv: HAS_SPECULAR_COLORMAP && getChannel(material.specularColorMap.channel),
    specularIntensityMapUv:
      HAS_SPECULAR_INTENSITYMAP && getChannel(material.specularIntensityMap.channel),

    transmissionMapUv: HAS_TRANSMISSIONMAP && getChannel(material.transmissionMap.channel),
    thicknessMapUv: HAS_THICKNESSMAP && getChannel(material.thicknessMap.channel),

    alphaMapUv: HAS_ALPHAMAP && getChannel(material.alphaMap.channel),

    //

    vertexTangents: !!geometry.attributes.tangent && (HAS_NORMALMAP || HAS_ANISOTROPY),
    vertexColors: material.vertexColors,
    vertexAlphas:
      material.vertexColors === true &&
      !!geometry.attributes.color &&
      geometry.attributes.color.itemSize === 4,

    pointsUvs: object.isPoints === true && !!geometry.attributes.uv && (HAS_MAP || HAS_ALPHAMAP),

    fog: !!fog,
    useFog: material.fog === true,
    fogExp2: !!fog && fog.isFogExp2,

    flatShading: material.flatShading === true,

    sizeAttenuation: material.sizeAttenuation === true,
    logarithmicDepthBuffer: logarithmicDepthBuffer,
    reverseDepthBuffer: reverseDepthBuffer,

    skinning: object.isSkinnedMesh === true,

    morphTargets: geometry.morphAttributes.position !== undefined,
    morphNormals: geometry.morphAttributes.normal !== undefined,
    morphColors: geometry.morphAttributes.color !== undefined,
    morphTargetsCount: morphTargetsCount,
    morphTextureStride: morphTextureStride,

    numDirLights: lights.directional.length,
    numPointLights: lights.point.length,
    numSpotLights: lights.spot.length,
    numSpotLightMaps: lights.spotLightMap.length,
    numRectAreaLights: lights.rectArea.length,
    numHemiLights: lights.hemi.length,

    numDirLightShadows: lights.directionalShadowMap.length,
    numPointLightShadows: lights.pointShadowMap.length,
    numSpotLightShadows: lights.spotShadowMap.length,
    numSpotLightShadowsWithMaps: lights.numSpotLightShadowsWithMaps,

    numLightProbes: lights.numLightProbes,

    numClippingPlanes: clipping.numPlanes,
    numClipIntersection: clipping.numIntersection,

    dithering: material.dithering,

    shadowMapEnabled: renderer.shadowMap.enabled && shadows.length > 0,
    shadowMapType: renderer.shadowMap.type,

    toneMapping: toneMapping,

    decodeVideoTexture:
      HAS_MAP &&
      material.map.isVideoTexture === true &&
      ColorManagement.getTransfer(material.map.colorSpace) === SRGBTransfer,

    premultipliedAlpha: material.premultipliedAlpha,

    doubleSided: material.side === DoubleSide,
    flipSided: material.side === BackSide,

    useDepthPacking: material.depthPacking >= 0,
    depthPacking: material.depthPacking || 0,

    index0AttributeName: material.index0AttributeName,

    extensionClipCullDistance:
      HAS_EXTENSIONS &&
      material.extensions.clipCullDistance === true &&
      extensions.has('WEBGL_clip_cull_distance'),
    extensionMultiDraw:
      ((HAS_EXTENSIONS && material.extensions.multiDraw === true) || IS_BATCHEDMESH) &&
      extensions.has('WEBGL_multi_draw'),

    rendererExtensionParallelShaderCompile: extensions.has('KHR_parallel_shader_compile'),

    customProgramCacheKey: material.customProgramCacheKey()
  };

  // the usage of getChannel() determines the active texture channels for this shader

  parameters.vertexUv1s = _activeChannels.has(1);
  parameters.vertexUv2s = _activeChannels.has(2);
  parameters.vertexUv3s = _activeChannels.has(3);

  _activeChannels.clear();

  return parameters;
}
```

## setMaterial

```js
function setMaterial(material, frontFaceCW) {
  material.side === DoubleSide ? disable(gl.CULL_FACE) : enable(gl.CULL_FACE);

  let flipSided = material.side === BackSide;
  if (frontFaceCW) flipSided = !flipSided;

  setFlipSided(flipSided);

  material.blending === NormalBlending && material.transparent === false
    ? setBlending(NoBlending)
    : setBlending(
        material.blending,
        material.blendEquation,
        material.blendSrc,
        material.blendDst,
        material.blendEquationAlpha,
        material.blendSrcAlpha,
        material.blendDstAlpha,
        material.blendColor,
        material.blendAlpha,
        material.premultipliedAlpha
      );

  depthBuffer.setFunc(material.depthFunc);
  depthBuffer.setTest(material.depthTest);
  depthBuffer.setMask(material.depthWrite);
  colorBuffer.setMask(material.colorWrite);

  const stencilWrite = material.stencilWrite;
  stencilBuffer.setTest(stencilWrite);
  if (stencilWrite) {
    stencilBuffer.setMask(material.stencilWriteMask);
    stencilBuffer.setFunc(material.stencilFunc, material.stencilRef, material.stencilFuncMask);
    stencilBuffer.setOp(material.stencilFail, material.stencilZFail, material.stencilZPass);
  }

  setPolygonOffset(
    material.polygonOffset,
    material.polygonOffsetFactor,
    material.polygonOffsetUnits
  );

  material.alphaToCoverage === true
    ? enable(gl.SAMPLE_ALPHA_TO_COVERAGE)
    : disable(gl.SAMPLE_ALPHA_TO_COVERAGE);
}
```

## acquireProgram

```js
function acquireProgram(parameters, cacheKey) {
  let program;

  // Check if code has been already compiled
  for (let p = 0, pl = programs.length; p < pl; p++) {
    const preexistingProgram = programs[p];

    if (preexistingProgram.cacheKey === cacheKey) {
      program = preexistingProgram;
      ++program.usedTimes;

      break;
    }
  }

  if (program === undefined) {
    program = new WebGLProgram(renderer, cacheKey, parameters, bindingStates);
    programs.push(program);
  }

  return program;
}
```

## WebGLProgram

```js
//处理生成webgl program,替换#include,#define,兼容webgl2,shader编译绑定到program，缓存
function WebGLProgram(renderer, cacheKey, parameters, bindingStates) {
  //替换shader include
  vertexShader = resolveIncludes(vertexShader);
  //替换light参数
  vertexShader = replaceLightNums(vertexShader, parameters);
  vertexShader = replaceClippingPlaneNums(vertexShader, parameters);

  fragmentShader = resolveIncludes(fragmentShader);
  fragmentShader = replaceLightNums(fragmentShader, parameters);
  fragmentShader = replaceClippingPlaneNums(fragmentShader, parameters);
  //避免死循环
  vertexShader = unrollLoops(vertexShader);
  fragmentShader = unrollLoops(fragmentShader);

  const vertexGlsl = versionString + prefixVertex + vertexShader;
  const fragmentGlsl = versionString + prefixFragment + fragmentShader;

  // console.log( '*VERTEX*', vertexGlsl );
  // console.log( '*FRAGMENT*', fragmentGlsl );

  const glVertexShader = WebGLShader(gl, gl.VERTEX_SHADER, vertexGlsl);
  const glFragmentShader = WebGLShader(gl, gl.FRAGMENT_SHADER, fragmentGlsl);

  gl.attachShader(program, glVertexShader);
  gl.attachShader(program, glFragmentShader);
}
```

## include

```js
const includePattern = /^[ \t]*#include +<([\w\d./]+)>/gm;

function resolveIncludes(string) {
  return string.replace(includePattern, includeReplacer);
}

const shaderChunkMap = new Map();

function includeReplacer(match, include) {
  //shader片段
  let string = ShaderChunk[include];

  if (string === undefined) {
    const newInclude = shaderChunkMap.get(include);

    if (newInclude !== undefined) {
      string = ShaderChunk[newInclude];
      console.warn(
        'THREE.WebGLRenderer: Shader chunk "%s" has been deprecated. Use "%s" instead.',
        include,
        newInclude
      );
    } else {
      throw new Error('Can not resolve #include <' + include + '>');
    }
  }

  return resolveIncludes(string);
}
```

## refreshUniformsCommon

```js
function refreshUniformsCommon(uniforms, material) {
  uniforms.opacity.value = material.opacity;

  if (material.color) {
    //颜色
    uniforms.diffuse.value.copy(material.color);
  }

  if (material.emissive) {
    uniforms.emissive.value.copy(material.emissive).multiplyScalar(material.emissiveIntensity);
  }

  if (material.map) {
    uniforms.map.value = material.map;

    refreshTransformUniform(material.map, uniforms.mapTransform);
  }

  if (material.alphaMap) {
    uniforms.alphaMap.value = material.alphaMap;

    refreshTransformUniform(material.alphaMap, uniforms.alphaMapTransform);
  }

  if (material.bumpMap) {
    uniforms.bumpMap.value = material.bumpMap;

    refreshTransformUniform(material.bumpMap, uniforms.bumpMapTransform);

    uniforms.bumpScale.value = material.bumpScale;

    if (material.side === BackSide) {
      uniforms.bumpScale.value *= -1;
    }
  }

  if (material.normalMap) {
    uniforms.normalMap.value = material.normalMap;

    refreshTransformUniform(material.normalMap, uniforms.normalMapTransform);

    uniforms.normalScale.value.copy(material.normalScale);

    if (material.side === BackSide) {
      uniforms.normalScale.value.negate();
    }
  }

  if (material.displacementMap) {
    uniforms.displacementMap.value = material.displacementMap;

    refreshTransformUniform(material.displacementMap, uniforms.displacementMapTransform);

    uniforms.displacementScale.value = material.displacementScale;
    uniforms.displacementBias.value = material.displacementBias;
  }

  if (material.emissiveMap) {
    uniforms.emissiveMap.value = material.emissiveMap;

    refreshTransformUniform(material.emissiveMap, uniforms.emissiveMapTransform);
  }

  if (material.specularMap) {
    uniforms.specularMap.value = material.specularMap;

    refreshTransformUniform(material.specularMap, uniforms.specularMapTransform);
  }

  if (material.alphaTest > 0) {
    uniforms.alphaTest.value = material.alphaTest;
  }

  const materialProperties = properties.get(material);

  const envMap = materialProperties.envMap;
  const envMapRotation = materialProperties.envMapRotation;

  if (envMap) {
    uniforms.envMap.value = envMap;

    _e1.copy(envMapRotation);

    // accommodate left-handed frame
    _e1.x *= -1;
    _e1.y *= -1;
    _e1.z *= -1;

    if (envMap.isCubeTexture && envMap.isRenderTargetTexture === false) {
      // environment maps which are not cube render targets or PMREMs follow a different convention
      _e1.y *= -1;
      _e1.z *= -1;
    }

    uniforms.envMapRotation.value.setFromMatrix4(_m1.makeRotationFromEuler(_e1));

    uniforms.flipEnvMap.value =
      envMap.isCubeTexture && envMap.isRenderTargetTexture === false ? -1 : 1;

    uniforms.reflectivity.value = material.reflectivity;
    uniforms.ior.value = material.ior;
    uniforms.refractionRatio.value = material.refractionRatio;
  }

  if (material.lightMap) {
    uniforms.lightMap.value = material.lightMap;
    uniforms.lightMapIntensity.value = material.lightMapIntensity;

    refreshTransformUniform(material.lightMap, uniforms.lightMapTransform);
  }

  if (material.aoMap) {
    uniforms.aoMap.value = material.aoMap;
    uniforms.aoMapIntensity.value = material.aoMapIntensity;

    refreshTransformUniform(material.aoMap, uniforms.aoMapTransform);
  }
}
```
