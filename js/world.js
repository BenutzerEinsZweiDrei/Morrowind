// Generated by CoffeeScript 1.10.0
(function() {
  mw.World = (function() {
    function World() {
      var j, len, p, ref;
      this.x = -2;
      this.y = -9;
      this.cells = [];
      this.doskybox();
      this.props = [];
      this.cached = 0;
      this.queue = 0;
      ref = mw.props;
      for (j = 0, len = ref.length; j < len; j++) {
        p = ref[j];
        if (typeof p === "object") {
          this.cache(p);
        }
      }
      this.waterStep = 0;
      this.waterMoment = 0;
      this.cellcheck();
    }

    World.prototype.doskybox = function() {
      var array, geometry, i, j, material, t;
      geometry = new THREE.CubeGeometry(8192 * 3, 8192 * 3, 8192);
      t = mw.textures['tx_sky_clear.dds'];
      t.repeat.set(1, 1);
      array = [];
      for (i = j = 0; j <= 5; i = ++j) {
        array.push(new THREE.MeshBasicMaterial({
          map: t,
          side: THREE.BackSide
        }));
      }
      material = new THREE.MeshFaceMaterial(array);
      this.skybox = new THREE.Mesh(geometry, material);
      this.skybox.position.set((this.x * 8192) + 4096, (this.y * 8192) + 4096, -255);
      mw.scene.add(this.skybox);
      return true;
    };

    World.prototype.cachcb = function() {
      this.cached++;
      console.log(this.cached + " >= " + this.queue);
      if (this.cached >= this.queue) {
        mw.world.ransack();
      }
      return true;
    };

    World.prototype.ransack = function() {
      var data, j, k, len, len1, ref, ref1;
      ref = mw.props;
      for (j = 0, len = ref.length; j < len; j++) {
        data = ref[j];
        if (typeof data === "object" && !data.hidden) {
          this.props.push(mw.factory(data));
        }
      }
      ref1 = mw.grasses;
      for (k = 0, len1 = ref1.length; k < len1; k++) {
        data = ref1[k];
        data.type = 'Grass';
        if (typeof data === "object" && !data.hidden) {
          this.props.push(mw.factory(data));
        }
      }

      /*mw.controls.movementSpeed = 200
      		mw.controls.lookSpeed = 0.15
      		mw.controls.lat = -26.743659000000005
      		mw.controls.lon = -137.39699074999993
      		mw.camera.position.set -10608, -71283, 1008
       */
      mw.watershed.call(mw);
      return true;
    };

    World.prototype.cache = function(p) {
      var cb, loader, model;
      model = p.model;
      if (mw.models[model]) {
        return;
      }
      mw.models[model] = -1;
      this.queue++;
      cb = function(dae) {
        var dad;
        dad = dae.scene;
        dad.mw = model;
        mw.models[model] = dae;
        dad.scale.x = dad.scale.y = dad.scale.z = 1;
        dad.updateMatrix();
        dad.traverse(function(child) {
          var animation, map;
          if (-1 === mw.noshadow.indexOf(model)) {
            child.castShadow = true;
            child.receiveShadow = true;
          }
          if (child instanceof THREE.SkinnedMesh) {
            animation = new THREE.Animation(child, child.geometry.animation);
            animation.play();
            console.log('Oh ye');
          }
          if (child instanceof THREE.Mesh) {
            child.material.vertexColors = THREE.VertexColors;
            child.material.alphaTest = 0.5;
            if (map = child.material.map) {
              map.repeat.y = -1;
              return map.anisotropy = mw.maxAnisotropy;
            }
          }
        });
        mw.world.cachcb();
      };
      loader = new THREE.ColladaLoader;
      loader.load("models/" + model + ".dae", cb);
      return true;
    };

    World.prototype.cellcheck = function() {
      var i, j;
      for (i = j = 0; j <= 8; i = ++j) {
        this.cells.push(new mw.Cell(this.x + mw.circle[i].x, this.y + mw.circle[i].y));
      }
      return 0;
    };

    World.prototype.step = function() {
      var j, len, p, ref, t;
      ref = this.props;
      for (j = 0, len = ref.length; j < len; j++) {
        p = ref[j];
        p.step();
      }
      if (mw.water) {
        this.waterMoment += mw.delta;
        if (this.waterMoment >= 0.08) {
          this.waterStep = this.waterStep < 30 ? this.waterStep + 1 : 0;
          t = mw.textures["water/water" + this.waterStep + ".dds"];
          t.repeat.set(64, 64);
          mw.waterNormals.map = t;
          this.waterMoment = 0;
        }
      }
      return true;
    };

    return World;

  })();

}).call(this);
