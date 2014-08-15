
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
		@g = GRAVITY_NUM * 8 if window.isMobile
		@t = 0
		@bottom = bottom
		@color = HSVtoRGB (1 / BALL_NUM * ++ballCount), 0.3, 1# 色相　彩度　明るさ
		@boundStrength = BOUND_STRENGTH_VERTICAL
		@char = char
		@boundReduction = 0.986
		@rotate = 0

		@move_gravity = ->

			@vy += @g * @t

			#縦バウンド
			if @vy >= 0
				if @y >= @bottom - @r
					@vy *= (-@boundStrength)
					@t = 0
			else
				if @y <= 0
					@vy *= (-@boundStrength)
					@t = 0

			# 横バウンド
			if @vx >= 0
				@vx *= (-@boundStrength) if @x >= maxW - @r
			else
				@vx *= (-@boundStrength) if @x <= 0 + @r

			@t += 1 / 1000

			@x += @vx
			@y += @vy

			@rotate += @vx

			@boundStrength *= @boundReduction

			return




		x_beforGather = null
		y_beforGather = null
		x_change_for_gather = null
		y_change_for_gather = null
		gather_duration = null
		@initGather = (duration) ->
			@t = 0
			x_beforGather = @x
			y_beforGather = @y
			x_change_for_gather = maxW / 2 - @x
			y_change_for_gather = maxH / 2 - @y
			gather_duration = duration


		@gather = ()->
			@t += 1
			if @x isnt maxW / 2 or @y isnt maxH / 2
				@x = easeInCubic @t, x_beforGather, x_change_for_gather, gather_duration
				@y = easeInCubic @t, y_beforGather, y_change_for_gather, gather_duration
				@rotate = easeInCubic @t, 0, 360, gather_duration



easeInCubic = (t, b, c, d) ->
   t /= d
   return c * t * t * t + b













#------------------------------------
# アニメ−ションのイニシャライズ
#------------------------------------

balls = []
FPS = 1
FPS = 30 is window.isMobile

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
	char = ['A','r','t','&','H','a','c','k']

	addBallDelay = 50
	addBallDelay = 25 if window.isMobile

	addInterval = setInterval (->
		balls.push new Ball x(addCount), startY, r, y(addCount), char[addCount]
		clearInterval addInterval if ++addCount is BALL_NUM
	), addBallDelay


	BALL_R = r
	FONT_SIZE = BALL_R * 2 * 1.2 + "px"
	BALL_FONT = FONT_SIZE + " HelveticaNeue-UltraLight,Quicksand"


	gatherDelay = 1500
	ghaterDuration = 70
	splashDelay = 420

	if window.isMobile
		gatherDelay = 3000 
		ghaterDuration = 50
		splashDelay = 700

	setTimeout (->

		x_ball = balls[3];
		balls[3] = balls[7];
		balls[7] = x_ball;

		gatherBalls ghaterDuration
		setTimeout (->
			splashBalls true
		), splashDelay
	), gatherDelay

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

		sctx.fillStyle = "black"
		sctx.save()
		sctx.translate ball.x, ball.y
		sctx.rotate ball.rotate * Math.PI / 180
		sctx.fillText ball.char, 0, 0

IS_END = false

ball_move_type = "move"
onEnterFrame = ->
	setTimeout onEnterFrame, FPS unless IS_END
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





splashBalls = (isFall) ->
	console.log "splashBalls"

	splashVelocity = (deg) ->
		v = {}
		v.x = Math.cos(deg)
		v.y = Math.sin(deg)
		return v

	velocityRange = 30
	if isFall
		velocityRange = 10
		velocityRange = 20 if window.isMobile
	one_deg = 360 / balls.length
	one_deg = 360 / balls.length /2 if isFall
	rand_rag = 10

	for ball,i in balls
		ball.t = 0
		ball.bottom = maxH - ball.r unless isFall
		ball.bottom = maxH * 99 if isFall
		if isFall
			ball.g = 1
			ball.g = 40 if window.isMobile
		ball.boundStrength = BOUND_STRENGTH_VERTICAL
		ball.boundReduction = 0.999
		deg = one_deg * i * -1 + 180 * ((Math.random() * rand_rag) - rand_rag / 2)
		v = splashVelocity deg
		ball.vx = v.x * velocityRange
		ball.vy = v.y * velocityRange

	ball_move_type = "move"

	if isFall
		setTimeout (->
			IS_END = true
		), 1500





























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

