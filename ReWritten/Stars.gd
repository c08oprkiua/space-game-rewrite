extends Control

var xMinBoundry: int = 0
var xMaxBoundry: int = 427
var yMinBoundry: int = 0
var yMaxBoundry: int = 240

@export var imgbg: Color = Color(0,0,0,255)
var stars: Array = []
@export var starimg: Image = Image.create(427,240, false, Image.FORMAT_RGB8)
var RNG:RandomNumberGenerator = RandomNumberGenerator.new()
var initialloop: bool = true

var starthread:Thread = Thread.new()

signal newstarimg

func _ready() -> void:
	#connect("SetBG", SetBG)
	starimg.fill(imgbg)
	initStars()


#I think this is broken, it doesn't appear that blue colors get used
func initStars() -> void:
	# create the stars randomly
	for x in range(200):
		var star: Dictionary = {
			"x": 0,
			"y": 0,
			"r": 0,
			"g": 0,
			"b": 0,
		}
		var newstar: Dictionary = {
			"pos": Vector2i(0,0),
			"color": Color8(0,0,0,255)
		}
		stars.append(star)
		stars[x].x = RNG.randi_range(xMinBoundry, xMaxBoundry-1)
		stars[x].y = RNG.randi_range(yMinBoundry, yMaxBoundry-1)
		var randomNum:int = RNG.randi_range(0, 5)
		# half of the time make them white, 1/4 yellow, 1/4 blue
#		stars[x].r = 255 if (randomNum <= 2) else 0
#		stars[x].g = 255 if (randomNum <= 2) else 0
#		stars[x].b = 255 if (randomNum != 2) else 0
		if randomNum <= 2:
			stars[x].r = 255
			stars[x].g = 255
		elif randomNum != 2:
			stars[x].b = 255
	for rx in range(200):
		putAPixel(rx);
	initialloop = false
	emit_signal("newstarimg")

func drawPixels() -> void:
	for rx in range(200):
		putAPixel(rx);
	emit_signal("newstarimg")

func putAPixel(rx: int) -> void:
	if not initialloop:
		pass #code that blacks out a star so we don't have more than 200 onscreen
	if SpaceGlobals.graphics.flipColor:
		var temp:int = stars[rx].r
		stars[rx].r = stars[rx].b;
		stars[rx].b = temp;
	var starTint:Color = Color(stars[rx].r, stars[rx].g, stars[rx].b)
	starimg.set_pixel(stars[rx].x, stars[rx].y, starTint)

func putAPixelRand() -> void:
	var randint: int = randi_range(0, 200)
	putAPixel(randint)

func SetBG() -> void:
	var img:ImageTexture = ImageTexture.create_from_image(starimg)
	$"Stars".texture = img
