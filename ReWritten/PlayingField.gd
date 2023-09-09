extends Node2D

var laser = preload("res://Scenes/laser.tscn")

func _ready():
	Satellite.connect("firelaser", firelaser)
	InitBullets()


var arrayvalue
var x
var y
var m_x
var m_y
var active: bool = false

func firelaser(pos, rot):
	var newlaser = laser.instantiate()
	
	pass


func InitBullets():
	# init bullets
	for bullets in SpaceGlobals.BULLET_COUNT:
		add_child(laser.instantiate())
		Satellite.emit_signal("laserinit", bullets)

func initBullets(array):
	arrayvalue = array
	for x in range(SpaceGlobals.BULLET_COUNT):
		var bullet = {
			"x": 0,
			"y": 0,
			"m_x": 0,
			"m_y": 0,
			"active": 0
		}
		SpaceGlobals.bullets.append(bullet)

func RenderBullets():
	pass
	# for all active bullets, advance them
	for x in range(SpaceGlobals.BULLET_COUNT):
		if (SpaceGlobals.bullets[x].active == 1):
			for z in range(4):
				for za in range(2):
					#draw.drawPixel(SpaceGlobals.graphics, SpaceGlobals.bullets[x].x + z, SpaceGlobals.bullets[x].y + za, 255, 0, 0);
					pass