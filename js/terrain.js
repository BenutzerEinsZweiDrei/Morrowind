// Generated by CoffeeScript 1.9.1
(function() {
  mw.Terrain = (function() {
    function Terrain(x1, y1) {
      var b, g, h, i, j, map, mx, my, p, px, py, r, ref, x, y;
      this.x = x1;
      this.y = y1;
      this.data = this.heights();
      this.geometry = new THREE.PlaneGeometry(4096 * 2, 4096 * 2, 64, 64);
      map = new THREE.Texture(this.canvas);
      console.log(map);
      map.needsUpdate = true;
      map.magFilter = THREE.NearestFilter;
      map.minFilter = THREE.LinearMipMapLinearFilter;
      this.material = new THREE.MeshBasicMaterial({
        map: map,
        wireframe: true
      });
      this.mesh = new THREE.Mesh(this.geometry, this.material);
      this.mx = mx = (this.x * 8192) + 4096 - 128;
      this.my = my = (this.y * 8192) + 4096 + 128;
      this.mesh.position.set(mx, my, 0);
      for (i = j = 0, ref = this.geometry.vertices.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
        x = this.geometry.vertices[i].x;
        y = this.geometry.vertices[i].y;
        px = (4096 + x) / 64;
        px /= 2;
        py = (4096 + y) / 64;
        py /= 2;
        p = ((py * 64) + px) * 4;
        r = this.data[p];
        g = this.data[p + 1];
        b = this.data[p + 2];
        if (r === 255) {
          this.geometry.vertices[i].z = h;
          h = -(255 - b);
        } else if (g) {
          h = (255 * (g / 8)) + b;
        } else {
          h = b;
        }
        this.geometry.vertices[i].z = h;
      }
      mw.scene.add(this.mesh);
      this.mkground();
      true;
    }

    Terrain.prototype.mkground = function() {
      var loader, that;
      that = this;
      loader = new THREE.TGALoader;
      return loader.load('models/tx_ai_clover_02.tga', function(asd) {
        var geometry;
        asd.wrapS = asd.wrapT = THREE.RepeatWrapping;
        asd.repeat.set(32, 32);
        geometry = new THREE.PlaneGeometry(8192 * 2, 8192 * 2, 64, 64);
        that.ground = that.mesh.clone();
        that.ground.material = new THREE.MeshBasicMaterial({
          map: asd
        });
        return mw.scene.add(that.ground);
      });
    };

    Terrain.prototype.heights = function() {
      var canvas, context, img, imgd, x, y;
      img = mw.vvardenfell;
      canvas = document.createElement('canvas');
      document.body.appendChild(canvas);
      if (this.x === -2 && this.y === -9) {
        console.log('there');
        $('canvas').css('position', 'absolute');
      }
      canvas.width = 64;
      canvas.height = 64;
      context = canvas.getContext('2d');
      context.save();
      context.translate(0, 64);
      context.scale(1, -1);
      x = -(18 + this.x) * 64;
      y = -(27 - this.y) * 64;
      context.drawImage(img, x, y);
      imgd = context.getImageData(0, 0, 64, 64);
      context.restore();
      context.drawImage(img, x, y);
      this.canvas = canvas;
      return imgd.data;
    };

    return Terrain;

  })();

}).call(this);
