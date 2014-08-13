(function() {
  var BOUND_STRENGTH_HRIZONAL, BOUND_STRENGTH_VERTICAL, Ball, FPS, HSVtoRGB, balls, drawBalls, initAnimation, onEnterFrame, startAnimation;

  console.log("splash.coffee");

  window.START_SPLASH = function() {
    console.log("start splash");
    console.log(sctx);
    console.log(maxW);
    console.log(maxH);
    initAnimation();
    return startAnimation();
  };

  BOUND_STRENGTH_VERTICAL = 0.47;

  BOUND_STRENGTH_HRIZONAL = 0.8;

  Ball = (function() {
    function Ball(x, y, vx, vy) {
      this.r = 20;
      this.x = x;
      this.y = y;
      this.vx = vx;
      this.vy = vy;
      this.g = 9.8;
      this.t = 0;
      this.e = 0.8;
      console.log(this.x + ", " + this.y);
      this.color = HSVtoRGB(Math.random(), 0.7, 1);
      this.move_gravity = function() {
        this.vy += this.g * this.t;
        if (this.vy >= 0) {
          if (this.y >= maxH - this.r) {
            this.vy *= -BOUND_STRENGTH_VERTICAL;
            this.t = 0;
          }
        } else {
          if (this.y <= 0) {
            this.vy *= -BOUND_STRENGTH_VERTICAL;
            this.t = 0;
          }
        }
        if (this.vx >= 0) {
          if (this.x >= maxW - this.r) {
            this.vx *= -BOUND_STRENGTH_HRIZONAL;
          }
        } else {
          if (this.x <= 0 + this.r) {
            this.vx *= -BOUND_STRENGTH_HRIZONAL;
          }
        }
        this.t += 1 / 1000;
        this.x += this.vx;
        this.y += this.vy;
      };
    }

    return Ball;

  })();

  balls = [];

  FPS = 1;

  initAnimation = function() {
    balls.push(new Ball(10, 200, 30, 40));
    balls.push(new Ball(300, 30, -20, 10));
    balls.push(new Ball(300, 30, 2, 110));
    balls.push(new Ball(300, 30, -120, 2));
    balls.push(new Ball(300, 30, 30, 20));
    return balls.push(new Ball(300, 30, -50, 10));
  };

  startAnimation = function() {
    return onEnterFrame();
  };

  drawBalls = function() {
    var ball, _i, _len, _results;
    sctx.fillStyle = "#FFF";
    sctx.fillRect(0, 0, maxW, maxH);
    _results = [];
    for (_i = 0, _len = balls.length; _i < _len; _i++) {
      ball = balls[_i];
      sctx.beginPath();
      sctx.fillStyle = "rgba(" + ball.color.r + "," + ball.color.g + "," + ball.color.b + ",1)";
      sctx.arc(ball.x, ball.y, ball.r, 0, Math.PI * 2);
      sctx.closePath();
      _results.push(sctx.fill());
    }
    return _results;
  };

  onEnterFrame = function() {
    var ball, _i, _len;
    setTimeout(onEnterFrame, FPS);
    for (_i = 0, _len = balls.length; _i < _len; _i++) {
      ball = balls[_i];
      ball.move_gravity();
    }
    return drawBalls();
  };

  HSVtoRGB = function(h, s, v) {
    var b, f, g, i, p, q, r, t;
    r = void 0;
    g = void 0;
    b = void 0;
    i = void 0;
    f = void 0;
    p = void 0;
    q = void 0;
    t = void 0;
    if (h && s === undefined && v === undefined) {
      s = h.s;
      v = h.v;
      h = h.h;
    }
    i = Math.floor(h * 6);
    f = h * 6 - i;
    p = v * (1 - s);
    q = v * (1 - f * s);
    t = v * (1 - (1 - f) * s);
    switch (i % 6) {
      case 0:
        r = v;
        g = t;
        b = p;
        break;
      case 1:
        r = q;
        g = v;
        b = p;
        break;
      case 2:
        r = p;
        g = v;
        b = t;
        break;
      case 3:
        r = p;
        g = q;
        b = v;
        break;
      case 4:
        r = t;
        g = p;
        b = v;
        break;
      case 5:
        r = v;
        g = p;
        b = q;
    }
    return {
      r: Math.floor(r * 255),
      g: Math.floor(g * 255),
      b: Math.floor(b * 255)
    };
  };

}).call(this);
