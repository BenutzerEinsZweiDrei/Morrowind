// Generated by CoffeeScript 1.10.0
(function() {
  var mw, root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  mw = root.mw = {
    freeze: false,
    gots: 0,
    gets: 3,
    slow: false,
    shadowing: false,
    keys: [],
    models: {},
    world: null,
    ply: null,
    circle: [
      {
        x: 1,
        y: -1
      }, {
        x: 0,
        y: -1
      }, {
        x: -1,
        y: -1
      }, {
        x: 1,
        y: 0
      }, {
        x: 0,
        y: 0
      }, {
        x: -1,
        y: 0
      }, {
        x: 1,
        y: 1
      }, {
        x: 0,
        y: 1
      }, {
        x: -1,
        y: 1
      }
    ],
    pretex: ['cat.dds', 'tx_sky_clear.dds', 'tx_bc_mud.dds', 'tx_bc_dirt.dds', 'tx_bc_moss.dds'],
    blues: {
      '230': 'tx_bc_moss.dds',
      '214': 'tx_bc_dirt.dds',
      '247': 'tx_bc_mud.dds'
    },
    noshadow: ['vurt_neentree', 'light_com_lantern_02', 'furn_com_lantern_hook'],
    nolight: ['light_com_lantern_02', 'furn_com_lantern_hook'],
    textures: [],
    wireframe: new THREE.MeshBasicMaterial({
      wireframe: true,
      transparent: true,
      opacity: .5
    }),
    weather: {
      clear: {
        SkySunrise: new THREE.Color('rgb(117,141,164)'),
        SkyDay: new THREE.Color('rgb(95,135,203)'),
        SkySunset: new THREE.Color('rgb(55,89,127)'),
        SkyNight: new THREE.Color('rgb(5,5,5)'),
        FogSunrise: new THREE.Color('rgb(255,188,155)'),
        FogDay: new THREE.Color('rgb(206,227,255)'),
        FogSunset: new THREE.Color('rgb(255,188,155)'),
        FogNight: new THREE.Color('rgb(5,5,5)'),
        AmbientSunrise: new THREE.Color('rgb(36,50,72)'),
        AmbientDay: new THREE.Color('rgb(137,140,160)'),
        AmbientSunset: new THREE.Color('rgb(55,61,77)'),
        AmbientNight: new THREE.Color('rgb(10,11,12)'),
        SunSunrise: new THREE.Color('rgb(242,159,119)'),
        SunDay: new THREE.Color('rgb(255,252,238)'),
        SunSunset: new THREE.Color('rgb(255,114,79)'),
        SunNight: new THREE.Color('rgb(45,73,131)'),
        SunDiscSunset: new THREE.Color('rgb(255,189,157)')
      },
      cloudy: {
        SkySunrise: new THREE.Color('rgb(125,158,173)'),
        SkyDay: new THREE.Color('rgb(117,160,215)'),
        SkySunset: new THREE.Color('rgb(109,114,159)'),
        SkyNight: new THREE.Color('rgb(5,5,5)'),
        FogSunrise: new THREE.Color('rgb(255,203,147)'),
        FogDay: new THREE.Color('rgb(245,235,224)'),
        FogSunset: new THREE.Color('rgb(255,154,105)'),
        FogNight: new THREE.Color('rgb(5,5,5)'),
        AmbientSunrise: new THREE.Color('rgb(50,56,64)'),
        AmbientDay: new THREE.Color('rgb(137,145,160)'),
        AmbientSunset: new THREE.Color('rgb(55,62,71)'),
        AmbientNight: new THREE.Color('rgb(10,12,16)'),
        SunSunrise: new THREE.Color('rgb(241,177,99)'),
        SunDay: new THREE.Color('rgb(255,236,221)'),
        SunSunset: new THREE.Color('rgb(255,89,0)'),
        SunNight: new THREE.Color('rgb(39,46,61)'),
        SunDiscSunset: new THREE.Color('rgb(255,202,179)')
      }
    }
  };

  mw.Ambient = mw.weather.clear.AmbientDay.getHex();

  mw.Sun = mw.weather.clear.SunDay.getHex();

  mw.Fog = mw.weather.clear.FogDay.getHex();

  $(document).ready(function() {
    $.ajaxSetup({
      'async': false
    });
    mw.boot.call(mw);
    $.getJSON('my trade.json', function(data) {
      return mw.mytrade = data;
    });
    mw.produceterrain.call(mw);
    mw.resources.call(mw);
    return true;
  });

  document.onkeydown = document.onkeyup = function(event) {
    var k;
    k = event.keyCode;
    if (event.type === 'keydown' && mw.keys[k] !== 2) {
      mw.keys[k] = 1;
    } else if (event.type === 'keyup') {
      mw.keys[k] = 0;
    }
    if (!mw.keys[k]) {
      delete mw.keys[k];
    }
    if (k === 114) {
      event.preventDefault();
    }
    if (mw.lightbox) {
      mw.lightbox.key();
    }
    return true;
  };

  mw.resources = function() {
    var f, go, i, j, l, len, n, ref;
    this.vvardenfell = new Image(2688, 2816);
    this.vvardenfell.src = 'textures/vvardenfell.bmp';
    this.vclr = new Image(2688, 2816);
    this.vclr.src = 'textures/vvardenfell-vclr.bmp';
    this.vtex = new Image(672, 704);
    this.vtex.src = 'textures/vvardenfell-vtex3.bmp';
    for (n = j = 0; j <= 31; n = ++j) {
      this.pretex.push("water/water" + n + ".dds");
    }
    this.gets += this.pretex.length;
    ref = this.pretex;
    for (i = l = 0, len = ref.length; l < len; i = ++l) {
      f = ref[i];
      go = function() {
        var a, loader;
        a = f;
        loader = new THREE.DDSLoader;
        return loader.load("textures/" + f, function(asd) {
          asd.wrapS = asd.wrapT = THREE.RepeatWrapping;
          asd.anisotropy = mw.maxAnisotropy;
          asd.repeat.set(64, 64);
          mw.textures[a] = asd;
          mw.got.call(mw);
        });
      };
      go();
    }
    this.vvardenfell.onload = this.vclr.onload = this.vtex.onload = function() {
      return mw.got.call(mw);
    };
    return true;
  };

  mw.got = function() {
    if (++this.gots === this.gets) {
      console.log('got all preloads');
      this.after();
    }
    return true;
  };

  mw.after = function() {
    $.getJSON("seydaneen.json", function(data) {
      return mw.world = new mw.World(data);
    });
    mw.animate();
    return true;
  };

  mw.texture = function(file) {
    var go, loader, p;
    p = file;
    loader = new THREE.TextureLoader();
    loader.load(p);
    loader = null;
    if (mw.textures[p]) {
      return mw.textures[p];
    } else {
      go = function() {
        var i;
        loader = new THREE.TGALoader;
        console.log(loader);
        i = p;
        return loader.load(p, function(asd) {
          mw.textures[i] = asd;
        });
      };
      go();
    }
    return true;
  };

}).call(this);
