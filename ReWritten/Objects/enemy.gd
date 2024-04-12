extends CharacterBody2D

## An enemy type in Space Game. 
class_name GByte

static var pool:Array[GByte] = []

static var palette:Array #= Images.enemy_palette
static var sprite:ImageTexture

static func _static_init() -> void:
	initEnemyPool()
	sprite = ImageTexture.create_from_image(SpaceGlobals.decompressSpriteToImage(Vector2i(23, 23), Images.compressed_enemy, Images.enemy_palette))

## Initializes the bullet pool.
static func initEnemyPool() -> void:
	for x in range(SpaceGlobals.MAX_ENEMIES):
		var enemy:GByte = GByte.new()
		pool.append(enemy)

var m:Vector2i
@onready var texture:Sprite2D = $"Sprite2D"

func _ready() -> void:
	set_scale(SpaceGlobals.SCALER)
	hide()
	texture.texture = sprite

func _process(_delta: float) -> void:
	moveEnemy()

func moveEnemy() -> void:
	if visible:
		position.x += m.x * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
		position.y += m.y * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
		if not SpaceGlobals.bounds.has_point(position):
			visible = false
	#Note: the following may be broken due to Godot natively using radians?
		rotation += 0.02 * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
		if (rotation > 6.28318530):
			rotation = 0.0
		# TODO: the below crashes... with angle instead of 0
#		makeRotationMatrix(mySpaceGlobals.enemies[x].angle, 23, mySpaceGlobals.enemy, mySpaceGlobals.enemies[x].rotated_sprite, 9);
#		mySpaceGlobals.invalid = 1;
