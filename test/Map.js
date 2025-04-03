const earthRadius = 6378137;

function Point(x, y) {
  this.x = x;
  this.y = y;
  return this;
}
function LatLng(lat, lng) {
  this.lng = lng;
  this.lat = lat;
  return this;
}
function Bounds(x, y, x1, y1) {
  this.min = {x: Math.min(x, x1), y: Math.min(y, y1)};
  this.max = {x: Math.max(x, x1), y: Math.max(y, y1)};
  return this;
}
const SphericalMercator = {
  R: earthRadius,
  MAX_LATITUDE: 85.0511287798,

  project(latlng) {
    const d = Math.PI / 180,
      max = this.MAX_LATITUDE,
      lat = Math.max(Math.min(max, latlng.lat), -max),
      sin = Math.sin(lat * d);

    return new Point(this.R * latlng.lng * d, (this.R * Math.log((1 + sin) / (1 - sin))) / 2);
  },

  unproject(point) {
    const d = 180 / Math.PI;

    return new LatLng((2 * Math.atan(Math.exp(point.y / this.R)) - Math.PI / 2) * d, (point.x * d) / this.R);
  },

  bounds: (function () {
    const d = earthRadius * Math.PI;
    return new Bounds([-d, -d], [d, d]);
  })(),
  scale(zoom) {
    return 256 * Math.pow(2, zoom);
  },
  zoom(scale) {
    return Math.log(scale / 256) / Math.LN2;
  },
  latlng2px(latlng, zoom) {
    const scale = 0.5 / (Math.PI * SphericalMercator.R);
    const s = this.scale(zoom);
    const p = this.project(latlng);

    return new Point(scale * p.x * s, -scale * p.y * s);
  },
  px2latlng(px, zoom) {
    const scale = 0.5 / (Math.PI * SphericalMercator.R);
    const s = this.scale(zoom);
    const p = this.unproject(px);
    return new LatLng(-p.y / scale / s, p.x / scale / s);
  }
};

function travelGeo(geojson, cb) {
  geojson.features.forEach((a) => {
    if (a.geometry.type == 'MultiPolygon') {
      a.geometry.coordinates.forEach((b) => {
        b.forEach((c) => {
          cb(c);
        });
      });
    } else {
      a.geometry.coordinates.forEach((c) => {
        cb(c);
      });
    }
  });
}
