// Generated by CoffeeScript 1.10.0
(function() {
  mw.Prop = (function() {
    function Prop(data) {
      this.data = data;
      this.model = this.data.model;
      this.x = this.data.x;
      this.y = this.data.y;
      this.z = this.data.z;
      this.r = Math.abs(this.data.r - 360);
      this.scale = this.data.scale || 0;
      this.transparent = this.data.transparent || false;
      if (mw.models[this.model] == null) {
        return;
      }
      if (mw.models[this.model] === -1) {
        return;
      }
      this.mesh = mw.models[this.model].scene.clone();
      if (this.scale) {
        this.mesh.scale.set(this.scale, this.scale, this.scale);
      }
      this.pose();
      if (this.model === 'ex_common_house_tall_02') {
        mw.target = this;
      }
      mw.scene.add(this.mesh);
    }

    Prop.prototype.pose = function() {
      this.mesh.position.set(this.x, this.y, this.z);
      this.mesh.rotation.z = this.r * Math.PI / 180;
    };

    Prop.prototype.step = function() {
      return true;
    };

    return Prop;

  })();

}).call(this);
