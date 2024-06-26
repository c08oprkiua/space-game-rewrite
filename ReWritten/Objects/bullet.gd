extends RigidBody2D

## A bullet in Space Game. 
## A bullet being active is determined by its visibility.
class_name Bullet

## The pool of bullets used in Space Game
static var pool:Array[Bullet] = []
#If this is a preloaded const, it causes a corruption error. 
static var scene:PackedScene = load("res://Scenes/bullet.tscn")

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
	disable()

func _process(delta: float) -> void:
	moveBullet(delta)

func enable() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	set_process(true)
	show()

func disable() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	set_process(false)

## Applies movement to a bullet
## Also will automatically hide the bullet if it is out of bounds
func moveBullet(delta:float) -> void:
	var motion:Vector2 = m * SpaceGlobals.FPS_MULT * delta * Performance.get_monitor(Performance.TIME_FPS)
	move_and_collide(m)
	if not SpaceGlobals.bounds.has_point(position):
		disable()
