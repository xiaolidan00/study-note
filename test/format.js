//发光效果相关参数
const params = {
  threshold: 0,
  strength: 0.6,
  radius: 1,
  exposure: 1
};
const renderScene = new RenderPass(this.scene, this.camera);

const bloomPass = new UnrealBloomPass(
  new THREE.Vector2(this.container.offsetWidth, this.container.offsetHeight),
  params.strength,
  params.radius,
  params.threshold
);
const bloomComposer = new EffectComposer(this.renderer);
bloomComposer.renderToScreen = false;
bloomComposer.addPass(renderScene);
bloomComposer.addPass(bloomPass);
this.bloomComposer = bloomComposer;
this.bloomComposer.setSize(this.container.offsetWidth, this.container.offsetHeight);
