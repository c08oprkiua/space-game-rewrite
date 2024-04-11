extends RigidBody2D

## A bullet in Space Game. 
## A bullet being active is determined by its visibility.
class_name Bullet

## The pool of bullets used in Space Game
static var pool:Array[Bullet] = []
const scene:PackedScene = preload("res://Scenes/bullet.tscn")

static func _static_init() -> void:
	initBulletPool()

## Initializes the bullet pool.
static func initBulletPool() -> void:
	for x in range(SpaceGlobals.BULLET_COUNT):
		var bullet:Bullet = scene.instantiate()
		pool.append(bullet)

var m:Vector2i = Vector2i(0, 0)

func _ready() -> void:
	set_scale(SpaceGlobals.SCALER)
	hide()

func _process(delta: float) -> void:
	#newMoveBullet(delta)
	moveBullet(delta)

## Applies movement to a bullet
## Also will automatically hide the bullet if it is out of bounds
func moveBullet(delta:float) -> void:
	if visible:
		var motion:Vector2 = m * SpaceGlobals.FPS_MULT * delta * Performance.get_monitor(Performance.TIME_FPS)
		move_and_collide(m)
		if not SpaceGlobals.bounds.has_point(position):
			visible = false
