extends CharacterBody2D

#	- Joystick input (p1Move)
#	- Bullet firing (p1Shoot)
#	- Player look direction (p1look)

static var sprite:ImageTexture
static var sprite2:ImageTexture

static func _static_init() -> void:
	sprite = ImageTexture.create_from_image(SpaceGlobals.decompressSpriteToImage(Vector2i(36,36), Images.compressed_ship, Images.ship_palette))
	sprite2 = ImageTexture.create_from_image(SpaceGlobals.decompressSpriteToImage(Vector2i(36,36), Images.compressed_ship2, Images.ship2_palette))


@export var settings: PlayerSettings

@onready var spr_texture:Sprite2D = $"Sprite2D"

var look_vector:Vector2 #Aim/look vector, replaces rstick_x and rstick_y
var move_vector:Vector2 #Movement vector, replaces lstick_x and lstick_y

var shootspeed: float #Future plans: Use this as an analog fire rate thing
var mouse_aim:bool # shootspeed = 1

func _ready() -> void:
	set_scale(SpaceGlobals.SCALER)
	match settings.ShipType:
		0:
			spr_texture.texture = sprite
		1:
			var img:ImageTexture = ImageTexture.create_from_image(SpaceGlobals.decompressSpriteToImage(Vector2i(36, 36), Images.compressed_ship, Images.swapRedBlue(Images.ship_palette)))
			spr_texture.texture = img
		2:
			spr_texture.texture = sprite

func _process(delta:float) -> void:
	move_vector = Vector2()
	look_vector = Vector2()
	move_vector = Input.get_vector("left","right","up", "down")
	look_vector = Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down")
	
	shootspeed = Input.get_action_strength("shoot")
	mouse_aim = Input.is_action_pressed("shoot_mouse")
	if mouse_aim:
		shootspeed = 1
	
	p1Move(delta)
	p1look()
	p1Shoot()

func p1Shoot() -> void:
	if (SpaceGlobals.playerExplodeFrame > 1):
		return
	if shootspeed > 0:
		var difVect:Vector2
		difVect = position - (position + (look_vector * 18))
		if difVect.is_zero_approx() && mouse_aim:
			difVect = (position - get_global_mouse_position())
		
		if difVect.is_zero_approx():
			return
		
		var theta:float = atan2(difVect.x, difVect.y) - PI
		
		var bulletsShot:int = int(settings.doubleShot)
		SpaceGlobals.firstShotFired = true
		for bullet:Bullet in Bullet.pool:
			if not bullet.visible:
				var offsetVector:Vector2 = Vector2()
				offsetVector.x = int(bulletsShot == 1) * 9 * cos(-theta) - int(bulletsShot == 2) * 9 * cos(-theta)
				offsetVector.y = int(bulletsShot == 1) * 9 * sin(-theta) - int(bulletsShot == 2) * 9 * sin(-theta)
				
				bullet.rotation = rotation
				
				bulletsShot += 1
				bullet.position = position + offsetVector
				
				bullet.m = 9.0 * Vector2(sin(theta), cos(theta)) # 9 is the desired bullet speed
				bullet.visible = true
				
				
				SpaceGlobals.firstShotFired = 1;
				if (SpaceGlobals.score >= 1000):
					SpaceGlobals.displayHowToPlay = 0;
				if not settings.tripleShot or bulletsShot >= 3:
					break

## Updates player location
func p1Move(delta:float) -> void:
	#Note: This should be changed in the future; tying this to FPS is *very* bad in a futureproofing sense
	var playerMaxSpeed:float = 5 * SpaceGlobals.FPS_MULT * delta * Performance.get_monitor(Performance.TIME_FPS)
	velocity = move_vector * playerMaxSpeed
	move_and_slide()
	# update score if on a frame divisible by 60 (gain ~10 points every second)
	if (SpaceGlobals.frame % 60 == 0):
		SpaceGlobals.increaseScore(10);
		
		# if the score is at least 50 and a shot hasn't been fired yet, display a message about shooting
		if (SpaceGlobals.score >= 50 && !SpaceGlobals.firstShotFired):
			SpaceGlobals.displayHowToPlay = 1;


## Updates player location
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
	if mouse_aim:
		shootspeed = 1
		look_at(get_global_mouse_position())
		return
	elif not look_vector.is_zero_approx():
		rotation = look_vector.angle()
		return
	elif not move_vector.is_zero_approx():
		rotation = move_vector.angle()
		return
