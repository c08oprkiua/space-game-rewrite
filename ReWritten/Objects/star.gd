extends Node2D

class_name NewStar

const bounds:Rect2i = Rect2i(0, 0, 427, 240)

var color:Color = Color8(0, 0, 0, 255)

var RNG:RandomNumberGenerator = RandomNumberGenerator.new()

func _init() -> void:
	hide()
	update()

func update() -> void:
	update_position()
	update_color()

func update_position() -> void:
	#position.x = int(trigmath.prand() * bounds.size.x)
	#position.y = int(trigmath.prand() * bounds.size.y)
	position.x = RNG.randi_range(0, bounds.size.x)
	position.y = RNG.randi_range(0, bounds.size.y)

func update_color() -> void:
	var randomNum:int = RNG.randi_range(0, 5)
	# half of the time make them white, 1/4 yellow, 1/4 blue
	if randomNum <= 2:
		color.r8 = 255
		color.g8 = 255
	else:
		color.r8 = 0
		color.g8 = 0
	if randomNum != 2:
		color.b8 = 255
	else:
		color.b8 = 0
