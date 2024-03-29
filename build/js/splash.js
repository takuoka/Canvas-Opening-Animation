(function() {
  var BALL_FONT, BALL_NUM, BALL_R, BOUND_STRENGTH_HRIZONAL, BOUND_STRENGTH_VERTICAL, Ball, FONT_SIZE, FPS, GRAVITY_NUM, HSVtoRGB, IS_END, ball_move_type, balls, drawBalls, easeInCubic, fallBalls, gatherBalls, initAnimation, onEnterFrame, setEND, splashBalls, startAnimation;

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

  GRAVITY_NUM = 9;

  BALL_NUM = 8;

  BALL_R = null;

  FONT_SIZE = null;

  BALL_FONT = null;

  Ball = (function() {
    var ballCount;

    ballCount = 0;

    function Ball(x, y, r, bottom, char) {
      var gather_duration, x_beforGather, x_change_for_gather, y_beforGather, y_change_for_gather;
      this.r = r;
      this.x = x;
      this.y = y;
      this.vx = 0;
      this.vy = 0;
      this.g = GRAVITY_NUM;
      if (window.isMobile) {
        this.g = GRAVITY_NUM * 300;
      }
      this.t = 0;
      this.bottom = bottom;
      this.color = HSVtoRGB(1 / BALL_NUM * ++ballCount, 0.3, 1);
      this.boundStrength = BOUND_STRENGTH_VERTICAL;
      this.char = char;
      this.boundReduction = 0.986;
      if (window.isMobile) {
        this.boundReduction = 0.96;
      }
      this.rotate = 0;
      this.move_gravity = function() {
        this.vy += this.g * this.t;
        if (this.vy >= 0) {
          if (this.y >= this.bottom - this.r) {
            this.vy *= -this.boundStrength;
            this.t = 0;
          }
        } else {
          if (this.y <= 0) {
            this.vy *= -this.boundStrength;
            this.t = 0;
          }
        }
        if (this.vx >= 0) {
          if (this.x >= maxW - this.r) {
            this.vx *= -this.boundStrength;
          }
        } else {
          if (this.x <= 0 + this.r) {
            this.vx *= -this.boundStrength;
          }
        }
        this.t += 1 / 1000;
        this.x += this.vx;
        this.y += this.vy;
        this.rotate += this.vx;
        this.boundStrength *= this.boundReduction;
      };
      x_beforGather = null;
      y_beforGather = null;
      x_change_for_gather = null;
      y_change_for_gather = null;
      gather_duration = null;
      this.initGather = function(duration) {
        this.t = 0;
        x_beforGather = this.x;
        y_beforGather = this.y;
        x_change_for_gather = maxW / 2 - this.x;
        y_change_for_gather = maxH / 2 - this.y;
        return gather_duration = duration;
      };
      this.gather = function() {
        this.t += 1;
        if (this.x !== maxW / 2 || this.y !== maxH / 2) {
          this.x = easeInCubic(this.t, x_beforGather, x_change_for_gather, gather_duration);
          this.y = easeInCubic(this.t, y_beforGather, y_change_for_gather, gather_duration);
          return this.rotate = easeInCubic(this.t, 0, 360, gather_duration);
        }
      };
    }

    return Ball;

  })();

  easeInCubic = function(t, b, c, d) {
    t /= d;
    return c * t * t * t + b;
  };

  balls = [];

  FPS = 1;

  FPS = 1 === window.isMobile;

  initAnimation = function() {
    var addBallDelay, addCount, addInterval, cell_horizontal, cell_size, char, gatherDelay, ghaterDuration, margin_horizontal, r, splashDelay, startY, x, y;
    addCount = 0;
    margin_horizontal = maxW / 10;
    cell_horizontal = 5;
    cell_size = (maxW - margin_horizontal * 2) / cell_horizontal;
    x = function(n) {
      var pos;
      if (n <= 2) {
        pos = n;
      }
      if (n === 3) {
        pos = n - 1.5;
      }
      if (n >= 4) {
        pos = n - 3;
      }
      return margin_horizontal + (cell_size * pos) + (cell_size / 2);
    };
    y = function(n) {
      var gap;
      if (n <= 2) {
        gap = r * -3;
      }
      if (n === 3) {
        gap = 0;
      }
      if (n >= 4) {
        gap = r * 3;
      }
      return maxH / 2 + gap;
    };
    r = cell_size / 2 * 0.7;
    startY = -100;
    char = ['A', 'r', 't', '&', 'H', 'a', 'c', 'k'];
    addBallDelay = 50;
    if (window.isMobile) {
      addBallDelay = 100;
    }
    addInterval = setInterval((function() {
      balls.push(new Ball(x(addCount), startY, r, y(addCount), char[addCount]));
      if (++addCount === BALL_NUM) {
        return clearInterval(addInterval);
      }
    }), addBallDelay);
    BALL_R = r;
    FONT_SIZE = BALL_R * 2 * 1.2 + "px";
    BALL_FONT = FONT_SIZE + " HelveticaNeue-UltraLight,Quicksand";
    gatherDelay = 1500;
    ghaterDuration = 70;
    splashDelay = 420;
    if (window.isMobile) {
      gatherDelay = 2500;
      ghaterDuration = 20;
      splashDelay = 500;
    }
    return setTimeout((function() {
      var x_ball;
      x_ball = balls[3];
      balls[3] = balls[7];
      balls[7] = x_ball;
      gatherBalls(ghaterDuration);
      return setTimeout((function() {
        return splashBalls(true);
      }), splashDelay);
    }), gatherDelay);
  };

  startAnimation = function() {
    return onEnterFrame();
  };

  drawBalls = function() {
    var ball, _i, _len, _results;
    sctx.restore();
    sctx.fillStyle = "#000";
    sctx.fillRect(0, 0, maxW, maxH);
    sctx.font = BALL_FONT;
    sctx.fillStyle = "white";
    sctx.textAlign = "center";
    sctx.textBaseline = "middle";
    _results = [];
    for (_i = 0, _len = balls.length; _i < _len; _i++) {
      ball = balls[_i];
      sctx.restore();
      sctx.beginPath();
      sctx.fillStyle = "rgba(" + ball.color.r + "," + ball.color.g + "," + ball.color.b + ",1)";
      sctx.arc(ball.x, ball.y, ball.r, 0, Math.PI * 2);
      sctx.closePath();
      sctx.fill();
      sctx.fillStyle = "black";
      sctx.save();
      sctx.translate(ball.x, ball.y);
      sctx.rotate(ball.rotate * Math.PI / 180);
      _results.push(sctx.fillText(ball.char, 0, 0));
    }
    return _results;
  };

  IS_END = false;

  ball_move_type = "move";

  onEnterFrame = function() {
    var ball, _i, _len;
    if (!IS_END) {
      setTimeout(onEnterFrame, FPS);
    }
    for (_i = 0, _len = balls.length; _i < _len; _i++) {
      ball = balls[_i];
      if (ball_move_type === "move") {
        ball.move_gravity();
      }
      if (ball_move_type === "gather") {
        ball.gather();
      }
    }
    return drawBalls();
  };

  gatherBalls = function(duration) {
    var ball, _i, _len;
    for (_i = 0, _len = balls.length; _i < _len; _i++) {
      ball = balls[_i];
      ball.initGather(duration);
    }
    return ball_move_type = "gather";
  };

  fallBalls = function() {
    var ball, _i, _len, _results;
    ball_move_type = "move";
    _results = [];
    for (_i = 0, _len = balls.length; _i < _len; _i++) {
      ball = balls[_i];
      ball.bottom = maxH - ball.r;
      ball.boundStrength = BOUND_STRENGTH_VERTICAL;
      _results.push(ball.boundReduction = 0.99);
    }
    return _results;
  };

  splashBalls = function(isFall) {
    var ball, deg, i, one_deg, rand_rag, splashVelocity, v, velocityRange, _i, _len;
    console.log("splashBalls");
    splashVelocity = function(deg) {
      var v;
      v = {};
      v.x = Math.cos(deg);
      v.y = Math.sin(deg);
      return v;
    };
    velocityRange = 30;
    if (isFall) {
      velocityRange = 10;
      if (window.isMobile) {
        velocityRange = 50;
      }
    }
    one_deg = 360 / balls.length;
    if (isFall) {
      one_deg = 360 / (balls.length * 2);
    }
    rand_rag = 1;
    for (i = _i = 0, _len = balls.length; _i < _len; i = ++_i) {
      ball = balls[i];
      ball.t = 0;
      if (!isFall) {
        ball.bottom = maxH - ball.r;
      }
      if (isFall) {
        ball.bottom = maxH * 99;
      }
      if (isFall) {
        ball.g = 1;
        if (window.isMobile) {
          ball.g = GRAVITY_NUM * 1;
        }
      }
      ball.boundStrength = BOUND_STRENGTH_VERTICAL;
      ball.boundReduction = 0.999;
      deg = one_deg * i * -1 + 180 * ((Math.random() * rand_rag) - rand_rag / 2);
      if (isFall) {
        deg = one_deg * i * -1 + 180;
      }
      v = splashVelocity(deg);
      ball.vx = v.x * velocityRange;
      ball.vy = v.y * velocityRange;
    }
    ball_move_type = "move";
    if (isFall) {
      return setTimeout((function() {
        return setEND();
      }), 1500);
    }
  };

  setEND = function() {
    IS_END = true;
    return hide_loading();
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
