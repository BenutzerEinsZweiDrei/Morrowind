// Generated by CoffeeScript 1.9.1
(function() {
  mw.Prop = (function() {
    function Prop(raw) {
      this.raw = raw;
      this.model = this.raw.model;
      this.x = this.raw.x;
      this.y = this.raw.y;
      this.z = this.raw.z;
      this.r = this.raw.r;
      this.mesh = mw.models[this.model].clone();
      this.mesh.position.set(this.x, this.y, this.z);
      this.mesh.rotation.z = this.r * Math.PI / 180;
      mw.scene.add(this.mesh);
    }

    return Prop;

  })();

}).call(this);
