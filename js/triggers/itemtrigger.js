// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  gm.ItemTrigger = (function(_super) {

    __extends(ItemTrigger, _super);

    function ItemTrigger(id, x, y, mode, automatic, item_id, data) {
      this.item_id = item_id;
      ItemTrigger.__super__.constructor.call(this, id, x, y, mode, automatic, data);
    }

    return ItemTrigger;

  })(gm.Trigger);

}).call(this);