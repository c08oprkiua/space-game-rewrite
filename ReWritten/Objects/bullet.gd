extends Area2D

class_name Bullet

static var bullets:Array[Bullet] = []

static func _static_init() -> void:
	initBulletPool()

## Initializes the bullet pool.
static func initBulletPool() -> void:
	for x in range(SpaceGlobals.BULLET_COUNT):
		var bullet:Bullet = Bullet.new()
		bullets.append(bullet)

static func renderBullets() -> void:
	for bullet in bullets:
		if bullet.active:
			bullet.newMoveBullet()


var m:Vector2i = Vector2i(0, 0)

func _ready() -> void:
	set_scale(SpaceGlobals.SCALER)
	hide()

func newMoveBullet() -> void:
	if visible:
		position.x += m.x * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
		position.y += m.y * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
		if not SpaceGlobals.bounds.has_point(position):
			visible = false
		#SpaceGlobals.invalid = 1
