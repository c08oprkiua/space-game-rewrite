extends TextureRect

#	- Star draw.drawing (renderStars)

const bounds:Rect2i = Rect2i(0, 0, 427, 240)
const STAR_COUNT:int = 200

var stars:Array[NewStar] = []
var starimg:Image = Image.create(427,240, false, Image.FORMAT_RGB8)
var flipColors:bool = false
var animating:bool = false

func _init() -> void:
	initStars()

func _ready() -> void:
	renderStars()

#TODO: I want to make it so that every half a second, it moves a number of stars to a
# new position, creating a Galaga-like star "flickering" effect.

func initStars() -> void:
	for x:int in range(STAR_COUNT):
		var star:NewStar = NewStar.new()
		print(star.position)
		stars.append(star)

func renderStars() -> void:
	# don't draw.draw stars if the player is on their last life and died
	#I'm going to change this so that this just pauses when the player dies
#	if (SpaceGlobals.lives == 1 && SpaceGlobals.playerExplodeFrame > 1):
#		return
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
	
	#if pos.x < 0 or pos.x >= 427 or pos.y < 0 or pos.y >= 240 or starimg == null:
	if not bounds.has_point(pos) or starimg == null:
		return
	starimg.set_pixelv(pos, col)
