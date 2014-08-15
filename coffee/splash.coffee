
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
GRAVITY_NUM = 9#9.8
BALL_NUM = 8

BALL_R = null
FONT_SIZE = null
BALL_FONT = null

class Ball
	ballCount = 0

	constructor: (x, y, r, bottom, char) ->
		@r = r
		@x = x
		@y = y
		@vx = 0
		@vy = 0
		@g = GRAVITY_NUM
		@t = 0
		@bottom = bottom
		@color = HSVtoRGB (1 / BALL_NUM * ++ballCount), 0.7, 1
		@boundStrength = BOUND_STRENGTH_VERTICAL
		@char = char
		@boundReduction = 0.986
		@rotate = 0

		@move_gravity = ->

			this.vy += this.g * this.t

			#縦バウンド
			if this.vy >= 0
				if this.y >= this.bottom - this.r
					this.vy *= (-this.boundStrength)
					this.t = 0
			# else
			# 	if this.y <= 0
			# 		this.vy *= (-this.boundStrength)
			# 		this.t = 0

			# 横バウンド
			if this.vx >= 0
				this.vx *= (-this.boundStrength) if this.x >= maxW - this.r
			else
				this.vx *= (-this.boundStrength) if this.x <= 0 + this.r

			this.t += 1 / 1000

			this.x += this.vx
			this.y += this.vy

			this.rotate += this.vx

			this.boundStrength *= this.boundReduction

			return




		x_beforGather = null
		y_beforGather = null
		x_change_for_gather = null
		y_change_for_gather = null
		gather_duration = null
		@initGather = (duration) ->
			this.t = 0
			x_beforGather = this.x
			y_beforGather = this.y
			x_change_for_gather = maxW / 2 - this.x
			y_change_for_gather = maxH / 2 - this.y

			gather_duration = duration

			console.log "init gather"
			console.log x_beforGather
			console.log x_change_for_gather


		@gather = ()->
			console.log "ghater"
			this.t += 1
			if this.x isnt maxW / 2 or this.y isnt maxH / 2
				this.x = easeInCubic this.t, x_beforGather, x_change_for_gather, gather_duration
				this.y = easeInCubic this.t, y_beforGather, y_change_for_gather, gather_duration
				this.rotate = easeInCubic this.t, 0, 360, gather_duration



easeInCubic = (t, b, c, d) ->
   t /= d
   return c * t * t * t + b













#------------------------------------
# アニメ−ションのイニシャライズ
#------------------------------------

balls = []
FPS = 1

initAnimation = ->

	addCount = 0

	margin_horizontal = 30
	cell_horizontal = 5
	cell_size = ((maxW - margin_horizontal * 2) / cell_horizontal) 

	x = (n) ->
		if n <= 2 then pos = n
		if n is 3 then pos = n - 1.5
		if n >= 4 then pos = n - 3
		margin_horizontal + (cell_size * pos) + (cell_size / 2)
	y = (n) ->
		if n <= 2 then gap = r * -2.5
		if n is 3 then gap = 0
		if n >= 4 then gap = r * 2.5
		return maxH / 2 + gap
	r = cell_size / 2 * 0.7
	startY = -100
	char = ['A','r','t','☓','H','a','c','k']

	addInterval = setInterval (->
		balls.push new Ball x(addCount), startY, r, y(addCount), char[addCount]
		clearInterval addInterval if ++addCount is BALL_NUM
	), 50


	BALL_R = r
	FONT_SIZE = BALL_R * 2 * 0.6 + "px"
	BALL_FONT = FONT_SIZE + " 'Helvetica Neue UltraLight'"

	ghaterDuration = 100
	setTimeout (->
		gatherBalls ghaterDuration
		setTimeout splashBalls, 700
	), 1000

startAnimation = ->
	onEnterFrame()








#------------------------------------
# 描画
#------------------------------------


drawBalls = ->
	#全消し
	sctx.restore()
	sctx.fillStyle = "#000"
	sctx.fillRect 0, 0, maxW, maxH

	sctx.font = BALL_FONT
	sctx.fillStyle = "white"
	sctx.textAlign = "center"
	sctx.textBaseline = "middle"

	for ball in balls
		sctx.restore()
		sctx.beginPath()
		sctx.fillStyle = "rgba(" + ball.color.r + "," + ball.color.g + "," + ball.color.b + ",1)"
		sctx.arc ball.x, ball.y, ball.r, 0, Math.PI * 2
		sctx.closePath()
		sctx.fill()

		sctx.fillStyle = "white"
		sctx.save()
		sctx.translate ball.x, ball.y
		sctx.rotate ball.rotate * Math.PI / 180
		sctx.fillText ball.char, 0, 0


ball_move_type = "move"
onEnterFrame = ->
	setTimeout onEnterFrame, FPS
	for ball in balls
		if ball_move_type is "move" then ball.move_gravity()
		if ball_move_type is "gather" then ball.gather()
	drawBalls()



gatherBalls = (duration)->
	for ball in balls
		ball.initGather(duration)
	ball_move_type = "gather"







fallBalls = ->
	ball_move_type = "move"
	for ball in balls
		ball.bottom = maxH - ball.r 
		ball.boundStrength = BOUND_STRENGTH_VERTICAL
		ball.boundReduction = 0.99





splashBalls = ->
	console.log "splashBalls"

	splashVelocity = (deg) ->
		v = {}
		v.x = Math.cos(deg)
		v.y = Math.sin(deg)
		return v

	velocityRange = 50
	one_deg = 360 / balls.length

	for ball,i in balls
		ball.t = 0
		ball.bottom = maxH - ball.r 
		ball.boundStrength = BOUND_STRENGTH_VERTICAL
		ball.boundReduction = 0.999
		deg = one_deg * i * -1 + 180
		v = splashVelocity deg
		ball.vx = v.x * velocityRange
		ball.vy = v.y * velocityRange

	ball_move_type = "move"





























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

