// Generated by CoffeeScript 1.4.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  gm.Level = (function(_super) {

    __extends(Level, _super);

    function Level(game) {
      this.game = game;
    }

    Level.prototype.init = function(levelid) {
      var x, y;
      this.levelid = levelid;
      this.data = gm.data.levels[this.levelid];
      this.game.physics.startSystem(Phaser.Physics.ARCADE);
      this.game.physics.arcade.gravity.y = 2500;
      this.actionButton = this.game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR);
      this.nl = this.game.input.keyboard.addKey(Phaser.Keyboard.Z);
      this.pl = this.game.input.keyboard.addKey(Phaser.Keyboard.A);
      this.ww = this.data.width;
      this.hh = this.data.height;
      this.mode = gm.Mode.REAL;
      this.frozen = false;
      this.triggersById = {};
      return this.triggers = (function() {
        var _i, _ref, _results;
        _results = [];
        for (x = _i = 0, _ref = this.data.height; 0 <= _ref ? _i < _ref : _i > _ref; x = 0 <= _ref ? ++_i : --_i) {
          _results.push((function() {
            var _j, _ref1, _results1;
            _results1 = [];
            for (y = _j = 0, _ref1 = this.data.width; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; y = 0 <= _ref1 ? ++_j : --_j) {
              _results1.push([]);
            }
            return _results1;
          }).call(this));
        }
        return _results;
      }).call(this);
    };

    Level.prototype.create = function() {
      this.game.world.setBounds(0, 0, this.ww * gm.TILE_SIZE, this.hh * gm.TILE_SIZE);
      this.backgroundRe = this.game.add.tileSprite(0, 0, this.game.world.width, this.game.world.height, this.data.backgrounds[gm.Mode.RE]);
      this.backgroundIm = this.game.add.tileSprite(0, 0, this.game.world.width, this.game.world.height, this.data.backgrounds[gm.Mode.IM]);
      this.platforms = this.game.add.group();
      this.zerog = this.game.add.group();
      this.items = this.game.add.group();
      this.scenery = this.game.add.group();
      this.lights = this.game.add.group();
      this.cracks = this.game.add.group();
      this.addTriggers(this.data.triggers);
      this.addPlatforms(this.data.platforms, this.data.defaultPlatforms[gm.Mode.RE], this.data.defaultPlatforms[gm.Mode.IM]);
      this.addItems(this.data.items);
      this.addScenery(this.data.scenery);
      this.addCracks(this.data.cracks);
      this.player = new gm.Player(this.game, this.data.player[0], this.data.player[1]);
      this.game.camera.follow(this.player, Phaser.Camera.FOLLOW_PLATFORMER);
      this.setupHint();
      this.actionButton.onDown.add(this.onActionCallback, this);
      this.addLights(this.data.lights);
      this.overlay = this.game.add.tileSprite(0, 0, this.game.world.width, this.game.world.height, "overlay");
      this.overlay.alpha = 0;
      this.overlayRed = this.game.add.tileSprite(0, 0, this.game.world.width, this.game.world.height, "overlay_red");
      this.overlayRed.alpha = 0;
      return this.switchMode(gm.Mode.RE, true);
    };

    Level.prototype.freeze = function() {
      this.frozen = true;
      return this.player.freeze();
    };

    Level.prototype.unfreeze = function() {
      this.frozen = false;
      return this.player.unfreeze();
    };

    Level.prototype.switchMode = function(mode, instant) {
      var tween, tween3;
      if (instant) {
        this._switchMode(mode);
        return;
      }
      if (this.frozen) {
        return;
      }
      this.player.animations.play('back', 8, true);
      tween = this.game.add.tween(this.overlay).to({
        alpha: 0.2
      }, 300);
      tween3 = this.game.add.tween(this.player).to({
        alpha: 0
      }, 500);
      tween3.start();
      tween.onComplete.add(function() {
        var tween2, tween4;
        this.player.animations.play('front', 8, true);
        this._switchMode();
        tween2 = this.game.add.tween(this.overlay).to({
          alpha: 0
        }, 500);
        tween2.start();
        tween4 = this.game.add.tween(this.player).to({
          alpha: 1
        }, 200);
        tween4.start();
        return tween2.onComplete.add(function() {
          this.player.alpha = 1;
          return this.unfreeze();
        }, this);
      }, this);
      tween.start();
      return this.freeze();
    };

    Level.prototype._switchMode = function(mode) {
      var i, p, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _m, _ref, _ref1, _ref2, _ref3, _ref4;
      if (mode) {
        this.mode = mode;
      } else {
        this.mode = (this.mode === gm.Mode.RE ? gm.Mode.IM : gm.Mode.RE);
      }
      _ref = this.cracks.children;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        if (this.mode === gm.Mode.RE) {
          p.blendMode = PIXI.blendModes.NORMAL;
        } else if (this.mode === gm.Mode.IM) {
          p.blendMode = PIXI.blendModes.MULTIPLY;
        }
      }
      _ref1 = this.platforms.children;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        p = _ref1[_j];
        p.enable();
        if (p.mode && p.mode !== this.mode) {
          p.disable();
        }
      }
      _ref2 = this.items.children;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        i = _ref2[_k];
        i.enable();
        if (i.mode && i.mode !== this.mode) {
          i.disable();
        }
      }
      _ref3 = this.scenery.children;
      for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
        i = _ref3[_l];
        i.enable();
        if (i.mode && i.mode !== this.mode) {
          i.disable();
        }
      }
      _ref4 = this.zerog.children;
      for (_m = 0, _len4 = _ref4.length; _m < _len4; _m++) {
        i = _ref4[_m];
        i.enable();
        if (i.mode && i.mode !== this.mode) {
          i.disable();
        }
      }
      this.backgroundRe.alpha = this.mode === gm.Mode.RE;
      return this.backgroundIm.alpha = this.mode !== gm.Mode.RE;
    };

    Level.prototype.gameOver = function() {
      var tween;
      this.freeze();
      this.player.body.velocity.y = -800;
      this.player.body.velocity.x = 200;
      this.player.angle = -50;
      this.player.body.checkCollision.none = true;
      tween = this.game.add.tween(this.overlayRed).to({
        alpha: 0.8
      }, 700, Phaser.Easing.Quadratic.In);
      tween.onComplete.add(function() {
        return this.game.state.start('level', true, false, this.levelid);
      }, this);
      tween.start();
      this.freeze();
      return this.game.state.s;
    };

    Level.prototype.addItems = function(data) {
      var i, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        i = data[_i];
        _results.push(this.items.add(new gm.Item(this.game, i.id, i.x, i.y, i.mode)));
      }
      return _results;
    };

    Level.prototype.addTrap = function(data) {
      var i, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        i = data[_i];
        _results.push(this.traps.add(new gm.Spike(this.game, i.id, i.x, i.y, i.mode)));
      }
      return _results;
    };

    Level.prototype.addLights = function(data) {
      var i, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        i = data[_i];
        _results.push(this.lights.add(new gm.LightBeam(this.game, i.x, i.y)));
      }
      return _results;
    };

    Level.prototype.addScenery = function(data) {
      var i, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        i = data[_i];
        _results.push(this.scenery.add(gm.Scenery.make(this.game, i.x, i.y, i.id, i.properties)));
      }
      return _results;
    };

    Level.prototype.addCracks = function(data) {
      var i, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        i = data[_i];
        _results.push(this.cracks.add(new gm.Crack(this.game, i.x, i.y)));
      }
      return _results;
    };

    Level.prototype.movePlayerToSpawn = function() {
      this.player.x = this.data.player[0] * gm.TILE_SIZE;
      return this.player.y = (this.data.player[1] - 2) * gm.TILE_SIZE;
    };

    Level.prototype.addPlatforms = function(data, keyIm, keyRe) {
      var allTriggers, p, t, triggers, type, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _ref2, _ref3, _results;
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        p = data[_i];
        if (p.type === 'platform') {
          _results.push(this.platforms.add(new gm.Platform(this.game, p.x, p.y, p.w, p.h, keyIm, keyRe, p.properties)));
        } else if ((_ref = p.type) === 'liftableplatform' || _ref === 'counterweight' || _ref === 'spike') {
          allTriggers = [];
          if ('trigger' in p.properties && p.properties.trigger.length > 0) {
            if (p.properties.trigger.indexOf(",") === -1) {
              allTriggers.push(this.getTriggerById(+p.properties.trigger));
            } else {
              _ref1 = p.properties.trigger.split(',');
              for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
                t = _ref1[_j];
                allTriggers.push(this.getTriggerById(+t));
              }
            }
          }
          if (p.type === 'liftableplatform') {
            _results.push(this.platforms.add(new gm.LiftablePlatform(this.game, p.x, p.y, p.w, p.h, keyIm, keyRe, allTriggers, p.properties)));
          } else if (p.type === 'spike') {
            _results.push(this.platforms.add(new gm.Spike(this.game, p.x, p.y, allTriggers, p.properties)));
          } else if (p.type === 'counterweight') {
            _results.push(this.platforms.add(new gm.Counterweight(this.game, p.x, p.y, allTriggers, p.properties)));
          } else {
            throw 'lol';
          }
        } else if (p.type === 'zerog') {
          triggers = {
            enable: [],
            disable: []
          };
          _ref2 = ['enable', 'disable'];
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            type = _ref2[_k];
            if (type in p.properties && p.properties[type].length > 0) {
              if (p.properties[type].indexOf(",") === -1) {
                triggers[type].push(this.getTriggerById(p.properties[type]));
              } else {
                _ref3 = p.properties[type].split(',');
                for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
                  t = _ref3[_l];
                  trigges[type].push(this.getTriggerById(t));
                }
              }
            }
          }
          _results.push(this.zerog.add(new gm.ZeroG(this.game, p.x, p.y, p.w, p.h, 'default' in p.properties, triggers.enable, triggers.disable, p.properties)));
        } else {
          throw 'caca';
        }
      }
      return _results;
    };

    Level.prototype.getTriggerById = function(id) {
      return this.triggersById[+id];
    };

    Level.prototype.addTriggers = function(data) {
      var t, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        t = data[_i];
        _results.push(this.addTrigger(t));
      }
      return _results;
    };

    Level.prototype.addTrigger = function(t) {
      if (t.id in this.triggersById) {
        throw "a trigger with id " + t.id + " is already registered";
      }
      if (t.type === 'texttrigger') {
        t = new gm.TextTrigger(t.id, t.x, t.y, t.mode, t.text, t.properties);
      } else if (t.type === 'positiontrigger') {
        t = new gm.PositionTrigger(t.id, t.x, t.y, t.mode, t.automatic, t.properties);
      } else if (t.type === 'itemtrigger') {
        t = new gm.ItemTrigger(t.id, t.x, t.y, t.mode, t.automatic, +t.item_id, t.properties);
      } else {
        throw 'not implemented ' + t.type;
      }
      this.triggers[+t.y][+t.x].push(t);
      return this.triggersById[+t.id] = t;
    };

    Level.prototype.onActionCallback = function() {};

    Level.prototype.getTriggersAt = function(x, y) {
      if (x >= 0 && y >= 0 && x < this.ww && y < this.hh) {
        return this.triggers[+y][+x];
      }
      return [];
    };

    Level.prototype.nextLevel = function() {
      this.player.inventory.items = [];
      this.player.inventory.rerender();
      if ((this.levelid + 1) in gm.data.levels) {
        try {
          localStorage.setItem('level', this.levelid + 1);
        } catch (e) {
          console.warn('cant use localstorage');
        }
        return this.game.state.start('level', true, false, this.levelid + 1);
      } else {
        return this.game.state.start('win', true, false);
      }
    };

    Level.prototype.update = function() {
      /* TODO RM
      		if @pl.isDown && @pl.repeats is 1
      			@game.state.start('level', true, false, @levelid-1)
      		if @nl.isDown && @nl.repeats is 1
      			@game.state.start('level', true, false, @levelid+1)
      		## /TODO RM
      */

      var actionPressed, o, t, wereFired, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2,
        _this = this;
      if (this.player.yy >= this.hh) {
        return this.gameOver();
      }
      this.player.blockJump = false;
      actionPressed = this.actionButton.isDown && this.actionButton.repeats === 1;
      this.hint.x = this.player.x;
      this.hint.y = this.player.y;
      this.hint.scale.setTo((this.actionButton.isDown ? 1.2 : 0.8), (this.actionButton.isDown ? 1.2 : 0.8));
      this.setHint(false);
      if (!this.frozen) {
        if (this.player.xx === this.data.exit[0] && this.player.yy === this.data.exit[1] && this.mode === gm.Mode.RE) {
          this.setHint(true);
          _ref = this.scenery.children;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            o = _ref[_i];
            if (o instanceof gm.Scenery.BadassDoor) {
              o.animations.play('open', 10, true);
            }
          }
          if (actionPressed) {
            this.nextLevel();
          }
        }
        if (this.game.physics.arcade.overlap(this.player, this.cracks)) {
          this.setHint(true);
          if (actionPressed) {
            this.switchMode();
          }
        }
      }
      _ref1 = this.getTriggersAt(this.player.xx, this.player.yy);
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        t = _ref1[_j];
        wereFired = false;
        if (t && (!t.mode || t.mode === this.mode)) {
          if (!t.automatic && !t.fired) {
            this.setHint(true);
          }
          if (actionPressed || t.automatic) {
            if (t instanceof gm.TextTrigger && !t.fired) {
              this.player.say(t.text);
              t.fire();
              wereFired = true;
            } else if (t instanceof gm.PositionTrigger) {
              t.fire();
              wereFired = true;
            } else if (t instanceof gm.ItemTrigger) {
              if (this.player.inventory.hasItem(+t.item_id)) {
                this.player.inventory.removeItem(+t.item_id);
                t.fire();
                wereFired = true;
              } else {
                this.player.say("I need a " + gm.data.items[+t.item_id].name + " to trigger that");
              }
            }
            if (wereFired && t.data.cmsid && t.data.cmsmethod) {
              _ref2 = this.scenery.children;
              for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
                o = _ref2[_k];
                if (+o.extra.cmsid === +t.data.cmsid) {
                  o[t.data.cmsmethod]();
                }
              }
            }
          }
        }
      }
      this.game.physics.arcade.collide(this.player, this.items, function(player, item) {
        _this.items.remove(item, true);
        return _this.player.inventory.addItem(item.id);
      });
      this.game.physics.arcade.collide(this.player, this.platforms, function(player, p) {
        if (p instanceof gm.Spike && (!p.mode || p.mode === _this.mode) && p.allTriggersFired()) {
          return _this.gameOver();
        }
      });
      return this.game.physics.arcade.overlap(this.player, this.zerog, function(player, z) {
        _this.player.blockJump = true;
        if ((!z.mode || z.mode === _this.mode) && z.working) {
          if (_this.game.rnd.rnd() < 0.001) {
            _this.player.say("wwweeeeeeee!");
          }
          return z.applyForce(player);
        }
      });
    };

    Level.prototype.setupHint = function() {
      this.hint = this.game.add.sprite(0, 0, 'hint');
      this.hint.anchor.setTo(0.5, 0.5);
      this.hint.blendMode = PIXI.blendModes.ADD;
      this.hint.alpha = 0;
      return this.tween = this.game.add.tween(this.hint).to({
        angle: 360
      }, 3000, Phaser.Easing.Linear.None, true).loop(true);
    };

    Level.prototype.setHint = function(onoff) {
      return this.hint.alpha = +onoff * 0.8;
    };

    return Level;

  })(Phaser.State);

}).call(this);
