
console.log "splash.coffee"

window.START_SPLASH = ->
	console.log "start splash"
	console.log sctx
	console.log maxW
	console.log maxH
	initAnimation()
	startAnimation()


BOUND_STRENGTH_VERTICAL = 0.47
BOUND_STRENGTH_HRIZONAL = 0.8


class Ball
	constructor: (x, y, vx, vy) ->
		@r = 20
		@x = x
		@y = y
		@vx = vx
		@vy = vy
		@g = 9.8
		@t = 0
		@e = 0.8

		console.log this.x + ", " + this.y

		@color = HSVtoRGB (Math.random()), 0.7, 1

		@move_gravity = ->

			this.vy += this.g * this.t

			#縦バウンド
			if this.vy >= 0
				if this.y >= maxH - this.r
					this.vy *= (-BOUND_STRENGTH_VERTICAL)
					this.t = 0
			else
				if this.y <= 0
					this.vy *= (-BOUND_STRENGTH_VERTICAL)
					this.t = 0


			#横バウンド
			if this.vx >= 0
				this.vx *= (-BOUND_STRENGTH_HRIZONAL)  if this.x >= maxW - this.r
			else
				this.vx *= (-BOUND_STRENGTH_HRIZONAL)  if this.x <= 0 + this.r

			this.t += 1 / 1000

			this.x += this.vx
			this.y += this.vy

			return




balls = []
FPS = 1

initAnimation = ->
	balls.push new Ball 10, 200, 30, 40
	balls.push new Ball 300, 30, -20, 10
	balls.push new Ball 300, 30, 2, 110
	balls.push new Ball 300, 30, -120, 2
	balls.push new Ball 300, 30, 30, 20
	balls.push new Ball 300, 30, -50, 10
startAnimation = ->
	onEnterFrame()



drawBalls = ->
	#全消し
	sctx.fillStyle = "#FFF"
	sctx.fillRect 0, 0, maxW, maxH

	for ball in balls
		sctx.beginPath()
		sctx.fillStyle = "rgba(" + ball.color.r + "," + ball.color.g + "," + ball.color.b + ",1)"
		sctx.arc ball.x, ball.y, ball.r, 0, Math.PI * 2
		sctx.closePath()
		sctx.fill()




onEnterFrame = ->
	setTimeout onEnterFrame, FPS
	ball.move_gravity() for ball in balls
	drawBalls()









HSVtoRGB = (h, s, v) ->
	r = undefined
	g = undefined
	b = undefined
	i = undefined
	f = undefined
	p = undefined
	q = undefined
	t = undefined
	if h and s is `undefined` and v is `undefined`
		s = h.s
		v = h.v
		h = h.h
	i = Math.floor(h * 6)
	f = h * 6 - i
	p = v * (1 - s)
	q = v * (1 - f * s)
	t = v * (1 - (1 - f) * s)
	switch i % 6
		when 0
			r = v
			g = t
			b = p
		when 1
			r = q
			g = v
			b = p
		when 2
			r = p
			g = v
			b = t
		when 3
			r = p
			g = q
			b = v
		when 4
			r = t
			g = p
			b = v
		when 5
			r = v
			g = p
			b = q

	return {
		r: Math.floor(r * 255)
		g: Math.floor(g * 255)
		b: Math.floor(b * 255)
	}

