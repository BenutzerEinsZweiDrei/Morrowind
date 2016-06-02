// Generated by CoffeeScript 1.10.0
(function() {
  var onDocumentMouseMove, onWindowResize, render, windowHalfX, windowHalfY;

  mw.mouseX = 0;

  mw.mouseY = 0;

  windowHalfX = window.innerWidth / 2;

  windowHalfY = window.innerHeight / 2;

  mw.boot = function() {
    var camera, container, controls, renderer, scene, stats, sun, wisp;
    container = document.createElement('div');
    document.body.appendChild(container);
    camera = this.camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 20, 50000);
    mw.camera.position.set(-8503.72820894099, -73706.23796587897, 408.92018992170136);
    camera.up = new THREE.Vector3(0, 0, 1);

    /*
    	camera.rotation.y = 1
    	camera.rotation.x = 1.1063848995163013
    	camera.rotation.z = 0.40295405886168556
     */
    controls = this.controls = new THREE.FirstPersonControls(camera);
    controls.movementSpeed = 1000;
    controls.lookSpeed = .25;
    controls.lat = -18;
    controls.lon = -36;
    scene = this.scene = new THREE.Scene;
    scene.fog = new THREE.Fog(mw.Fog, 2250, 9000);
    scene.add(new THREE.AmbientLight(mw.Ambient));
    sun = this.sun = new THREE.DirectionalLight(mw.Sun, 1);
    sun.name = 'Sun ^^';
    sun.position.set(-9736 - 1000, -71181 + 1200, 1385);
    sun.target.position.set(-11224 - 1000, -70869 + 1200, 300);
    sun.castShadow = true;
    sun.shadow.darkness = 5;
    sun.shadow.camera.near = 5;
    sun.shadow.camera.far = 3000;
    sun.shadow.camera.right = 1000;
    sun.shadow.camera.left = -800;
    sun.shadow.camera.top = 500;
    sun.shadow.camera.bottom = -1500;
    sun.shadow.mapSize.width = 2048;
    sun.shadow.mapSize.height = 2048;
    scene.add(sun);
    scene.add(sun.target);
    wisp = new THREE.PointLight(0xf58c28, 1.3, 150);
    wisp.position.set(-11738.976, -70195.289, 385.415);
    scene.add(wisp);
    THREE.Loader.Handlers.add(/\.dds$/i, new THREE.DDSLoader);
    renderer = this.renderer = new THREE.WebGLRenderer({
      antialias: true
    });
    this.maxAnisotropy = renderer.getMaxAnisotropy();
    renderer.setPixelRatio(window.devicePixelRatio);
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.shadowMap.enabled = true;
    renderer.shadowMap.type = THREE.PCFShadowMap;
    stats = this.stats = new Stats();
    stats.domElement.style.position = 'absolute';
    stats.domElement.style.top = '0px';
    container.appendChild(stats.domElement);
    container.appendChild(renderer.domElement);
    document.addEventListener('mousemove', onDocumentMouseMove, false);
    window.addEventListener('resize', onWindowResize, false);
    this.clock = new THREE.Clock();
    return true;
  };

  ({
    audios: function() {
      var loader;
      return loader = new THREE.SEA3D({
        autoPlay: true,
        container: scene
      });
    }
  });

  onWindowResize = function() {
    windowHalfX = window.innerWidth / 2;
    windowHalfY = window.innerHeight / 2;
    mw.camera.aspect = window.innerWidth / window.innerHeight;
    mw.camera.updateProjectionMatrix();
    mw.renderer.setSize(window.innerWidth, window.innerHeight);
  };

  onDocumentMouseMove = function(event) {
    mw.mouseX = (event.clientX - windowHalfX) * 2;
    mw.mouseY = (event.clientY - windowHalfY) * 2;
  };

  mw.animate = function() {
    var i, j, k, len, ref;
    requestAnimationFrame(mw.animate);
    mw.delta = mw.clock.getDelta();
    mw.timestep = mw.delta / mw.base;
    if (mw.timestep > 10) {
      mw.timestep = 1;
    }
    if (!mw.freeze) {
      mw.controls.update(mw.delta);
    }
    if (mw.keys[77] === 1) {
      mw.freeze = !mw.freeze;
    }
    if (mw.keys[78] === 1) {
      mw.shadowing = !mw.shadowing;
      if (!mw.shadowing) {
        mw.sun.position.set(-9736 - 1000, -71181 + 1200, 1385);
        mw.sun.target.position.set(-11224 - 1000, -70869 + 1200, 300);
      }
    }
    if (mw.keys[20] === 1) {
      mw.slow = !mw.slow;
      if (mw.slow) {
        mw.controls.movementSpeed = 200;
        mw.controls.lookSpeed = 0.15;
      } else {
        mw.controls.movementSpeed = 1000;
        mw.controls.lookSpeed = 0.25;
      }
    }
    if (mw.keys[72] === 1) {

    }
    if (mw.world != null) {
      mw.world.step();
    }
    if (mw.water) {
      mw.water.material.uniforms.time.value += 1.0 / 60.0;
    }
    render.call(mw);
    mw.stats.update();
    ref = mw.keys;
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      k = ref[i];
      if (k) {
        mw.keys[i] = 2;
      }
    }
  };

  render = function() {
    var x, y, z;
    if (mw.shadowing) {
      x = -11576 - -9736;
      y = -70815 - -71181;
      z = 381 - 1385;
      mw.sun.position.set(mw.camera.position.x - x, mw.camera.position.y - y, mw.camera.position.z - z);
      x = -11224 - -9736;
      y = -70869 - -71181;
      z = 300 - 1385;
      mw.sun.target.position.set(mw.sun.position.x + x, mw.sun.position.y + y, mw.sun.position.z + z);
    }
    if (mw.water) {
      mw.water.render();
    }
    THREE.AnimationHandler.update(mw.delta);
    this.renderer.render(this.scene, this.camera);
  };

}).call(this);
