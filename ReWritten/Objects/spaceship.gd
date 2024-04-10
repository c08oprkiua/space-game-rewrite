extends CharacterBody2D

@export var settings: PlayerSettings

#var buttonA = Input.is_action_pressed("accept")
#var buttonB = Input.is_action_pressed("cancel")
#var buttonUP    = Input.is_action_pressed("up")
#var buttonDOWN  = Input.is_action_pressed("down")
#var buttonRIGHT = Input.is_action_pressed("right")
#var buttonLEFT  = Input.is_action_pressed("left")
#var buttonPLUS = Input.is_action_pressed("pause")

#These values now also are interchangable with the d-pad inputs.
#However, the d-pad will still return binary values, so true 8 direction
#"d-pad movement" is still possible because of how these are used
var rstick_x: float
var lstick_x: float
var rstick_y: float
var lstick_y: float 

var shootspeed: float

#	- Joystick input (p1Move)
#	- Bullet firing (p1Shoot)
#	- Player look direction (p1look)

func _ready() -> void:
	set_scale(SpaceGlobals.SCALER)

func _process(_delta:float) -> void:
	rstick_x = Input.get_axis("shoot_left","shoot_right")
	lstick_x = Input.get_axis("left","right")
	rstick_y = Input.get_axis("shoot_up", "shoot_down")
	lstick_y = Input.get_axis("up","down")
	shootspeed = Input.get_action_strength("shoot")
	
	p1look()
	p1Shoot()

func _physics_process(delta:float) -> void:
	p1Move(delta)
	#oldP1Move()

func p1Shoot() -> void:
	if (SpaceGlobals.playerExplodeFrame > 1):
		return
	if shootspeed > 0:
		var theta:float = rotation_degrees - PI
		var bulletsShot:int = int(settings.doubleShot)
		SpaceGlobals.firstShotFired = true
		for bullet:Bullet in Bullet.bullets:
			if not bullet.visible:
				var offsetVector:Vector2 = Vector2()
				offsetVector.x = int(SpaceGlobals.bulletsShot == 1) * 9 * cos(-theta) - int(bulletsShot == 2) * 9 * cos(-theta)
				offsetVector.y = int(bulletsShot == 1) * 9 * sin(-theta) - int(bulletsShot == 2) * 9 * sin(-theta)
				bulletsShot += 1
				bullet.position = position + Vector2(18, 18) + offsetVector
				bullet.m = Vector2(9, 9) * Vector2(sin(theta), cos(theta)) # 9 is the desired bullet speed
				bullet.visible = true



#	var xdif = 0;
#	var ydif = 0;
	
#	xdif = SpaceGlobals.p1X - (SpaceGlobals.p1X + (rstick_x * 18));
#	ydif = SpaceGlobals.p1Y - (SpaceGlobals.p1Y + (rstick_y * 18));
	
	# if no joysticks were touched, but a touch is present
#	if (xdif == 0 && ydif == 0 && SpaceGlobals.touched):
#		xdif = (SpaceGlobals.p1X - SpaceGlobals.touchX + 18);
#		ydif = (SpaceGlobals.p1Y - SpaceGlobals.touchY + 18);
		
#	if (xdif != 0 && ydif != 0):
#		SpaceGlobals.angle = atan2(xdif, ydif);
		# shoot a bullet
		# find an inactive bullet
#		var theta = SpaceGlobals.angle - PI
#		var bulletsShot = int(SpaceGlobals.doubleShot)
#		for xx in range(SpaceGlobals.BULLET_COUNT):
#			if (SpaceGlobals.bullets[xx].active != 1):
#				var offsetX = int(SpaceGlobals.bulletsShot == 1) * 9 * cos(-theta) - int(bulletsShot == 2) * 9 * cos(-theta)
#				var offsetY = int(bulletsShot==1)*9*sin(-theta) - int(bulletsShot==2)*9*sin(-theta)
#				bulletsShot += 1
#				SpaceGlobals.bullets[xx].x = SpaceGlobals.p1X + 18 + offsetX;
#				SpaceGlobals.bullets[xx].y = SpaceGlobals.p1Y + 18 + offsetY;
#				SpaceGlobals.bullets[xx].m_x = 9 * sin(theta); # 9 is the desired bullet speed
#				SpaceGlobals.bullets[xx].m_y = 9 * cos(theta); # we have to solve for the hypotenuese
#				SpaceGlobals.bullets[xx].active = 1;
#				SpaceGlobals.firstShotFired = 1;
#				if (SpaceGlobals.score >= 1000):
#					SpaceGlobals.displayHowToPlay = 0;
#				if not SpaceGlobals.tripleShot or bulletsShot >= 3:
#					break;

## Updates player location
func p1Move(delta:float) -> void:
	#var playerMaxSpeed:float = 5 * SpaceGlobals.FPS_MULT * delta
	var playerMaxSpeed:float = 5 * SpaceGlobals.FPS_MULT * delta * Performance.get_monitor(Performance.TIME_FPS)
	var direction:Vector2 = Input.get_vector("left","right","up", "down")
	if direction:
		print(playerMaxSpeed)
	velocity = direction * playerMaxSpeed
	move_and_slide()

#Updates player1 location
func oldP1Move() -> void:
	# can't move while exploding
	if SpaceGlobals.playerExplodeFrame > 1:
		return
	
	var left_x:float = Input.get_axis("left", "right")
	#var left_y:float = Input.get_axis("down", "up")
	var left_y:float = Input.get_axis("up", "down")
	
	
	# get the differences
	var xdif:float = left_x
	var ydif:float = left_y
	
	# don't update angle if both are within -.1 < x < .1
	# (this is an expensive check... 128 bytes compared to just ==0)
	if ((xdif < 0.1) && (xdif > -0.1) && (ydif < 0.1) && (ydif > -0.1)): return;
	
	#This code may screw with analog movement/input
	xdif = clampi(xdif, -1, 1)
	ydif = clampi(ydif, -1, 1)
	
	# invalid view
	SpaceGlobals.invalid = 1;
	
	# accept x and y movement from either stick
	#var playerMaxSpeed = 5 * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
	var playerMaxSpeed:float = 5 * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
	#SpaceGlobals.p1X += xdif * playerMaxSpeed;
	#SpaceGlobals.p1Y += ydif * playerMaxSpeed;
	position.x += xdif * playerMaxSpeed
	position.y += ydif * playerMaxSpeed
	
	# calculate angle to face
	#SpaceGlobals.angle = atan2(-ydif, xdif) - PI / 2.0;
	set_rotation_degrees(atan2(-ydif, xdif) - PI / 2.0)
	
	# update score if on a frame divisible by 60 (gain ~10 points every second)
	if (SpaceGlobals.frame % 60 == 0):
		SpaceGlobals.increaseScore(10);
		
		# if the score is at least 50 and a shot hasn't been fired yet, display a message about shooting
		if (SpaceGlobals.score >= 50 && !SpaceGlobals.firstShotFired):
			SpaceGlobals.displayHowToPlay = 1;

func p1look() -> void:
	if Input.is_action_just_pressed("shoot_mouse"):
		shootspeed = 1
		look_at(get_global_mouse_position())
		return
	if rstick_x != 0 or rstick_y != 0:
		var lookrot:float = Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down").angle()
		set_rotation_degrees(rad_to_deg(lookrot))
		return
	if lstick_x != 0 or lstick_y != 0:
		var rotangl:float = Input.get_vector("left","right","up", "down").angle()
		set_rotation_degrees(rad_to_deg(rotangl))
		return
