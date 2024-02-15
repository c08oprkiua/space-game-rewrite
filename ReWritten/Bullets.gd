extends Area2D

func _ready() -> void:
	set_scale(SpaceGlobals.SCALER)
	hide()
	Satellite.connect("laserinit", initBullets, 4)
	Satellite.connect("firelaser", firelaser)

var arrayvalue
var x: int
var y: int
var m_x: int
var m_y: int
var active: bool = false

#Self note: The bullet will store an integer. This is its number. 
#This number shall be present in the BULLET_COUNT array, so that the game can 
#Call the bullet to move if the item in the BULLET_COUNT matches the number

func initBullets(array) -> void:
	arrayvalue = array
	for bullets in range(SpaceGlobals.BULLET_COUNT):
		var bullet:Dictionary = {
			"x": 0,
			"y": 0,
			"m_x": 0,
			"m_y": 0,
			"active": 0
		}
		SpaceGlobals.bullets.append(bullet)

func firelaser(pos, rot):
	position = pos
	rotation = rot

func RenderBullets() -> void:
	pass
	# for all active bullets, advance them
	for bullet in range(SpaceGlobals.BULLET_COUNT):
		if (SpaceGlobals.bullets[bullet].active == 1):
			for z in range(4):
				for za in range(2):
					#draw.drawPixel(SpaceGlobals.graphics, SpaceGlobals.bullets[x].x + z, SpaceGlobals.bullets[x].y + za, 255, 0, 0);
					pass


# moveBullets should be replaced with the bullets becoming nodes with hitboxes and velocity
#	moveBullets(mySpaceGlobals);
func moveBullets() -> void:
	pass
	# for all active bullets, advance them
	for x in range(SpaceGlobals.BULLET_COUNT):
		if (SpaceGlobals.bullets[x].active == 1):
			SpaceGlobals.bullets[x].x += SpaceGlobals.bullets[x].m_x * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
			SpaceGlobals.bullets[x].y += SpaceGlobals.bullets[x].m_y * SpaceGlobals.FPS_MULT * SpaceGlobals.delta
			if (SpaceGlobals.bullets[x].x > SpaceGlobals.xMaxBoundry ||
				SpaceGlobals.bullets[x].x < SpaceGlobals.xMinBoundry ||
				SpaceGlobals.bullets[x].y > SpaceGlobals.yMaxBoundry ||
				SpaceGlobals.bullets[x].y < SpaceGlobals.yMinBoundry + 20):
				SpaceGlobals.bullets[x].active = 0;
			SpaceGlobals.invalid = 1;
	for x in range(SpaceGlobals.MAX_ENEMIES):
		if (SpaceGlobals.enemies[x].position.active == 1):
			SpaceGlobals.enemies[x].position.x += SpaceGlobals.enemies[x].position.m_x * SpaceGlobals.FPS_MULT * SpaceGlobals.delta;
			SpaceGlobals.enemies[x].position.y += SpaceGlobals.enemies[x].position.m_y * SpaceGlobals.FPS_MULT * SpaceGlobals.delta;
			if (SpaceGlobals.enemies[x].position.x > SpaceGlobals.xMaxBoundry ||
				SpaceGlobals.enemies[x].position.x < SpaceGlobals.xMinBoundry ||
				SpaceGlobals.enemies[x].position.y > SpaceGlobals.yMaxBoundry ||
				SpaceGlobals.enemies[x].position.y < SpaceGlobals.yMinBoundry + 20):
				SpaceGlobals.enemies[x].position.active = 0;
			# rotate the enemy slowly
			SpaceGlobals.enemies[x].angle += 0.02 * SpaceGlobals.FPS_MULT * SpaceGlobals.delta;
			if (SpaceGlobals.enemies[x].angle > 6.28318530):
				SpaceGlobals.enemies[x].angle = 0.0;
			# TODO: the below crashes... with angle instead of 0
#			makeRotationMatrix(mySpaceGlobals.enemies[x].angle, 23, mySpaceGlobals.enemy, mySpaceGlobals.enemies[x].rotated_sprite, 9);
#			mySpaceGlobals.invalid = 1;
