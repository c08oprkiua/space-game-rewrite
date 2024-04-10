extends TextureRect

#	- Star draw.drawing (renderStars)

const STAR_COUNT:int = 200

var stars:Array[NewStar] = []
var starimg:Image = Image.create(427,240, false, Image.FORMAT_RGB8)
var flipColors:bool = false
@export var animating:bool = true

func _init() -> void:
	initStars()

func _ready() -> void:
	renderStars()

#TODO: I want to make it so that every second, it moves a number of stars to a
# new position, creating a Galaga-like star "flickering" effect.

func _process(delta: float) -> void:
	if animating:
		var seconds:int = Time.get_ticks_msec()
		if seconds % 1000 == 0:
			renderStars()

func initStars() -> void:
	for x:int in range(STAR_COUNT):
		var star:NewStar = NewStar.new()
		print(star.position)
		stars.append(star)

func renderStars() -> void:
	# don't draw.draw stars if the player is on their last life and died
	#I'm going to change this so that this just pauses when the player dies
	if (SpaceGlobals.lives == 1 && SpaceGlobals.playerExplodeFrame > 1):
		animating = false
		return
	drawPixels()

func drawPixels() -> void:
	for a_star:NewStar in stars:
		putAPixel(Vector2i(a_star.position), a_star.color)
	texture = ImageTexture.create_from_image(starimg)

func putAPixel(pos:Vector2i, col:Color) -> void:
	if flipColors:
		var temp:int = col.r8
		col.r8 = col.b8
		col.b8 = temp
	
	if not SpaceGlobals.bounds.has_point(pos) or starimg == null:
		return
	starimg.set_pixelv(pos, col)
