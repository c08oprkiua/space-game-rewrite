extends CharacterBody2D

class_name Enemy

static var enemies:Array[Enemy] = []
static var palette:Array = Images.enemy_palette
static var sprite:Array

static func _static_init() -> void:
	initEnemyPool()
	#sprite = SpaceGlobals.decompress_sprite(206, 23, 23, Images.compressed_enemy, 9);


## Initializes the bullet pool.
static func initEnemyPool() -> void:
	for x in range(SpaceGlobals.MAX_ENEMIES):
		var enemy:Enemy = Enemy.new()
		enemies.append(enemy)

static func moveEnemies() -> void:
	for enemy in enemies:
		if enemy.active:
			enemy.moveEnemy()



var m:Vector2i
var angle:float

func _ready() -> void:
	set_scale(SpaceGlobals.SCALER)
	hide()

func moveEnemy() -> void:
	if visible:
		position.x += m.x * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
		position.y += m.y * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
		if not SpaceGlobals.bounds.has_point(position):
			visible = false
	#Note: the following may be broken due to Godot natively using radians?
		angle += 0.02 * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
		if (angle > 6.28318530):
			angle = 0.0
		# TODO: the below crashes... with angle instead of 0
#		makeRotationMatrix(mySpaceGlobals.enemies[x].angle, 23, mySpaceGlobals.enemy, mySpaceGlobals.enemies[x].rotated_sprite, 9);
#		mySpaceGlobals.invalid = 1;
