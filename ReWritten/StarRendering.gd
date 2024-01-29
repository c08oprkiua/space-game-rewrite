extends TextureRect

#	- Star draw.drawing (renderStars)

var xMinBoundry: int = 0
var xMaxBoundry: int = 427
var yMinBoundry: int = 0
var yMaxBoundry: int = 240

var stars: Array = []
var starimg = Image.create(427,240, false, Image.FORMAT_ETC)

var starthread = Thread.new()

func _ready():
	print("Google")
	initStars()

func initStars():
	# create the stars randomly
	print("Wants")
	for x in range(200):
		var star = {
			"x": 0,
			"y": 0,
			"r": 0,
			"g": 0,
			"b": 0
		}
		prand()
		stars.append(star)
		stars[x].x = int(prand() * SpaceGlobals.xMaxBoundry);
		stars[x].y = int(prand() * SpaceGlobals.yMaxBoundry);
		var randomNum = int(trigmath.prand()*4);
		# half of the time make them white, 1/4 yellow, 1/4 blue
		stars[x].r = 255 if (randomNum <= 2) else 0;
		stars[x].g = 255 if (randomNum <= 2) else 0;
		stars[x].b = 255 if (randomNum != 2) else 0;
		print(stars[x])
	renderStars()

func renderStars():
	# don't draw.draw stars if the player is on their last life and died
	#I'm going to change this so that this just pauses when the player dies
	if (SpaceGlobals.lives == 1 && SpaceGlobals.playerExplodeFrame > 1):
		return;
	drawPixels(SpaceGlobals.graphics)

#I want to make it so that every half a second, it moves a number of stars to a
# new position, creating a Galaga-like star "flickering" effect.

func drawPixels(g):
	for rx in range(200):
		var x = stars[rx].x;
		var y = stars[rx].y;
		#if SpaceGlobals.state == 7 and y <= 20:
			# if we're in game, and the star would've been in the upper region of the screen
			# don't draw it. This is to simulate the black rectangle in the original game
			# this space globals check is totally cheating btw!
		#	continue
		putAPixel(g, x, y, stars[rx].r, stars[rx].g, stars[rx].b);

# This is the main function that does the grunt work of drawing to both screens. It takes in the
# Services structure that is constructed in program.c, which contains the pointer to the function
# that is responsible for putting a pixel on the screen. By doing it this way, the OSScreenPutPixelEx function pointer is only
# looked up once, at the program initialization, which makes successive calls to this pixel caller quicker.
func putAPixel(gr, x, y, r, g, b):
	if (gr.flipColor):
		var temp = r;
		r = b;
		b = temp;
	if x < 0 or x >= 427 or y < 0 or y >= 240 or gr.editableScreen == null:
		return
	gr.editableScreen.set_pixel(x, y, Color(r/255.0, g/255.0, b/255.0))

# This is from here: http://stackoverflow.com/a/1026370/1871287
# it is initially seeded with the time
var xseed

func _init(initialSeed):
	xseed = initialSeed

func prand():
	var next = xseed
	var result
	next *= 1103515245
	next += 12345
	result = int(next / 65536) % 2048
	result = ~result

	next *= 1103515245;
	next += 12345;
	result <<= 10;
	result ^= int(next / 65536) % 1024;
	result = ~result

	next *= 1103515245;
	next += 12345;
	result <<= 10;
	result ^= int(next / 65536) % 1024;
	result = ~result

	xseed = next;

	return abs(result / 2147483647.0);
