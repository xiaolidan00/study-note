let geoFun;
  function initGeoFun(size) {
  //放大倍数
  geoFun = d3geo.geoMercator().scale(size || 100);
}

  const latlng2px = (pos) => {
  if (pos[0] >= -180 && pos[0] <= 180 && pos[1] >= -90 && pos[1] <= 90) {
    return geoFun(pos);
  }
  return pos;
};


function drawRegion(ctx, c ) {
    ctx.beginPath();
    c.forEach((item, i) => {
      let pos = latlng2px(item);
      if (i == 0) {
        ctx.moveTo(pos[0], pos[1]);
      } else {
        ctx.lineTo(pos[0], pos[1]);
      }
    });
    ctx.closePath();
    ctx.fill();
    ctx.stroke();
  }
  function drawChina(){
return new Promise(resolve=>{


 
  var that = {
    bg: '#000080',
    borderColor: '#1E90FF',
    blurColor: '#1E90FF',
    borderWidth: 1,
    blurWidth: 5,
    fillColor: 'rgb(30 ,144 ,255,0.3)'
  };
  let canvas = document.createElement('canvas');

  canvas.width = 3600;
  canvas.height = 1800;

  let ctx = canvas.getContext('2d');
  //背景颜色
  ctx.fillStyle = that.bg;
  ctx.rect(0, 0, canvas.width, canvas.height);
  ctx.fill();
  //设置地图样式
  ctx.strokeStyle = that.borderColor;
  ctx.lineWidth = that.borderWidth;

  ctx.fillStyle = that.fillColor;
  if (that.blurWidth) {
    ctx.shadowBlur = that.blurWidth;
    ctx.shadowColor = that.blurColor;
  }
  fetch('https://geo.datav.aliyun.com/areas_v3/bound/100000_full.json')
    .then((res) => res.json())
    .then((geojson) => {
      console.log(geojson);
      geojson.features.forEach((a) => {
        if (a.geometry.type == 'MultiPolygon') {
          a.geometry.coordinates.forEach((b) => {
            b.forEach((c) => {
              drawRegion(ctx, c);
            });
          });
        } else {
          a.geometry.coordinates.forEach((c) => {
            drawRegion(ctx, c);
          });
        }
      });
      resolve(canvas)
    });
})
}

var map = new BMapGL.Map('container');
 
map.centerAndZoom(new BMapGL.Point(114.02040712756965, 22.537191581274687), 17);
 
map.enableKeyboard();
map.enableScrollWheelZoom();


// 自定义canvas
async function getTextureCanvas() {
    var textureCanvas =await drawChina();
  
     
    return textureCanvas;
}

// 添加canvas叠加层
var canvasSource = getTextureCanvas();
var pStart = new BMapGL.Point(-180,-90);
var pEnd = new BMapGL.Point(180,90);
var bounds = new BMapGL.Bounds(new BMapGL.Point(pStart.lng, pEnd.lat), new BMapGL.Point(pEnd.lng, pStart.lat));
var canvasOverlay = new BMapGL.GroundOverlay(bounds, {
    type: 'canvas',
    url: canvasSource,
    opacity: 0.9
});
map.addOverlay(canvasOverlay);

// 添加文本标注
var opts = {
    position: new BMapGL.Point(116.4503, 39.9213),
    offset: new BMapGL.Size(-28, -20)
};
var label = new BMapGL.Label('日坛公园', opts);
label.setStyle({
    color: '#fff',
    borderRadius: '5px',
    borderColor: '#fff',
    backgroundColor: '#79a913',
    fontSize: '16px',
    height: '30px',
    lineHeight: '30px'
});
map.addOverlay(label);