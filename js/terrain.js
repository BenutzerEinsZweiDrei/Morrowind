// Generated by CoffeeScript 1.9.1
(function() {
  mw.Terrain = (function() {
    function Terrain() {
      var that;
      this.bmp = new Image(64, 64);
      this.bmp.src = 'cells/-2,-9.bmp';
      that = this;
      this.bmp.onload = function() {
        return that.got();
      };
    }

    Terrain.prototype.got = function() {
      var b, g, h, i, j, map, mx, my, p, px, py, r, ref, x, y;
      this.data = this.heights();
      this.geometry = new THREE.PlaneGeometry(4096 * 2, 4096 * 2, 64, 64);
      map = THREE.ImageUtils.loadTexture('cells/-2,-9.bmp');
      map.magFilter = THREE.NearestFilter;
      map.minFilter = THREE.LinearMipMapLinearFilter;
      this.material = new THREE.MeshBasicMaterial({
        map: map,
        wireframe: true
      });
      this.mesh = new THREE.Mesh(this.geometry, this.material);
      this.mx = mx = (-2 * 8192) + 4096 - 128;
      this.my = my = (-9 * 8192) + 4096 + 128;
      console.log("mx " + mx + ", my " + my);
      this.mesh.position.set(mx, my, 0);
      for (i = j = 0, ref = this.geometry.vertices.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
        x = this.geometry.vertices[i].x;
        y = this.geometry.vertices[i].y;
        px = (4096 + x) / 64;
        px /= 2;
        py = (4096 + y) / 64;
        py /= 2;
        px = Math.floor(px);
        py = Math.floor(py);
        p = ((py * 64) + px) * 4;
        r = this.data[p];
        g = this.data[p + 1];
        b = this.data[p + 2];
        if (r === 255) {
          this.geometry.vertices[i].z = h;
          h = -(255 - b);
        } else if (g) {
          h = 255 + b;
        } else {
          h = b;
        }
        this.geometry.vertices[i].z = h;
      }
      mw.scene.add(this.mesh);
      this.mkground();
      this.water();
      return true;
    };

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
      var canvas, context, img, imgd;
      console.log('heights');
      img = this.bmp;
      canvas = document.createElement('canvas');
      document.body.appendChild(canvas);
      $('canvas').css('position', 'absolute');
      canvas.width = 64;
      canvas.height = 64;
      context = canvas.getContext('2d');
      context.translate(0, 64);
      context.scale(1, -1);
      context.drawImage(img, 0, 0);
      imgd = context.getImageData(0, 0, 64, 64);
      console.log(imgd);
      return imgd.data;
    };

    Terrain.prototype.water = function() {
      var loader, that;
      that = this;
      loader = new THREE.TGALoader;
      loader.load('models/water00.tga', function(asd) {
        var geometry, material, mesh;
        asd.wrapS = asd.wrapT = THREE.RepeatWrapping;
        asd.repeat.set(32, 32);
        geometry = new THREE.PlaneGeometry(8192 * 2, 8192 * 2, 64, 64);
        material = new THREE.MeshBasicMaterial({
          map: asd
        });
        mesh = new THREE.Mesh(geometry, material);
        mesh.position.set(that.mx, that.my, 0);
        console.log(mesh);
        return mw.scene.add(mesh);
      });
      return true;
    };

    return Terrain;

  })();

}).call(this);
