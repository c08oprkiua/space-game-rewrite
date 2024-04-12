extends Node
class_name SpacGlob

const bounds:Rect2i = Rect2i(0, 0, 427, 240)

const MAX_ENEMIES:int = 100
const BULLET_COUNT:int = 20

# initial state is title screen
#The state variable has become a signal, which triggers changeState in BaseR.gd
enum GameState {
	GAMEPLAY = 0,
	TITLE_SCREEN = 1,
	PASSWORD_SCREEN = 2,
	PAUSE_SCREEN = 3,
	GAME_OVER_SCREEN = 4,
	PASSWORD_INPUT = -27,
}

var state:GameState

var seed:float = 4.20

var settings:PlayerSettings = PlayerSettings.new()

var player

var a:int = 0;

var SCALER:Vector2i = Vector2i(1,1)
var windowSize

var startedMusic = false

var playerExplodeFrame: int = 0

var noEnemies:bool = false

var spedUpMusic
var flipColor: int = 0

# Flag for restarting the entire game.
var restart:int = 1

# Flags for render states
var renderResetFlag:int = 0
var menuChoice:int = 0

const menuChoiceDict:Dictionary = {
	0: "play",
	1: "password",
}

var lives: int = 4

var ship_positions:Array[Vector2i] = []
#var p1X: int = 0
#var p1Y: int = 0

var angle: int = 0
var frame: int = 0

#The folowing have been moved: 
	#These have been changed to per-player, for the sake of futureproofing and the fact that having 
	# them configurable per-player just makes sense imho
var tripleShot:bool = false
var doubleShot:bool = false



	#Moved to the password manager script, which entirely manages all passwords in the game for the 
	#sake of that code not bloating up a different script
var passwordList:Array = []

	#All input variables are entirely gone, because that can be natively handled in Godot through
	#the various Input singletons



var curPalette:Array[Color] = Images.ship_palette
var transIndex:int = 14
var passwordEntered:int = 0
var quit:int = 0
#  initialize starfield for this game
var invalid:int = 1

#Touch vars are still here because I say so
var touched:bool 
var touchX
var touchY

var level:int = 0
var enemiesSeekPlayer:int = 0
var dontKeepTrackOfScore:int = 0
var score:int = 0
var displayHowToPlay:bool = false
var firstShotFired

var button

var graphics:Dictionary = {
#	classicMain: self,
	"nxFont": false,
#	"spaceGlobals" = mySpaceGlobals
#	"labelController": labelController
#	"editableScreen": editableScreen
#	"screenTexture": screenTexture
	"flipColor": true,
}

var rotated_ship:Array = []

var trigmath
var delta:float

func _init() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(the_delta: float) -> void:
	delta = the_delta

# the original Space Game uses a few different speeds (bullet, player, enemies)
# but it didn't run at a reliable 60 fps (1/60 deltas)
# 30 fps "felt" too slow, so let's go with 40 fps
# as a baseline for how fast the game should expect to move
# this multiplier will modify all original game speeds to scale them back
# to one that feels more like how it ran on console
# it can be removed with password 60185
var FPS_MULT:int = 40

#Some new global variables
var config:ConfigFile = ConfigFile.new()#.load("user://settings.ini")


#Reset the game
func reset() -> void:
	button = 0
	#Set flag to render reset screen;
	renderResetFlag = 1

#This is needed to properly scale the game w
func size_changed() -> void:
	#windowSize = get_viewport_rect().size
	var width:int = 427
	var height:int = 240
	SCALER = max(min(int(windowSize.x / width), int(windowSize.y / height)), 1)

func increaseScore(inc:int) -> void:
#	# count the number of 5000s that fit into the score before adding
	var fiveThousandsBefore:int = score / 5000 #float precision not needed for this math
#	# increase the score
	score += inc
#	# count them again
	var fiveThousandsAfter:int = score / 5000 #float precision not needed for this math
#	# if it increased, levelup
	if (fiveThousandsAfter > fiveThousandsBefore):
		level += 1

## This function takes a compressed sprite, its size, and the palette to use for it, and returns a full Image for it.
func decompressSpriteToImage(size:Vector2i, input:Array, palette:Array[Color]) -> Image:
	var target:Array[PackedByteArray] = []
	var out_img:Image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	var posinrow:int = 0;
	# go through input array
	var x:int = 0
	var c:Vector2i = Vector2i(0, 0)
	while x < input.size():
		var count:int = input[x]
		var value:int = input[x + 1]
		if (count == -120): # full value rows of last index in palette
			for z in range(value):
				for za in range(size.x):
					out_img.set_pixel(c.x + za, c.y + z, palette[palette.size() - 1])
			c.y += value;
			x += 2
			continue;
		if (count <= 0): # if it's negative, -count is value, and value is meaningless and advance by one
			value = -1 * count;
			count = 1;
			x -= 1; # subtract one, so next time it goes up by 2, putting us at x+1
		for z in range(count):
			out_img.set_pixelv(c, palette[value])
			c.x += 1;
		posinrow += count
		if (posinrow >= size.x):
			posinrow = 0;
			c.x = 0;
			c.y += 1;
		x += 2
	
	#out_img.save_png("res://{0}.png".format({"0": input.size()})) #For debugging purposes
	return out_img

#	graphics["classicMain"] = self
#	graphics["nxFont"] = false
#	graphics["spaceGlobals"] = mySpaceGlobals
#	graphics["labelController"] = labelController
	
#	graphics["editableScreen"] = editableScreen
#	graphics["screenTexture"] = screenTexture

#	mySpaceGlobals["graphics"] = graphics;
#	print("Space globals initialized\n");

	# Flag for restarting the entire game.
#	mySpaceGlobals["restart"] = 1;

	# initial state is title screen
#	mySpaceGlobals["state"] = 1;
#	mySpaceGlobals["titleScreenRefresh"] = 1;

	# Flags for render states
#	mySpaceGlobals["renderResetFlag"] = 0;
#	mySpaceGlobals["menuChoice"] = 0; #  0 is play, 1 is password
	
#	mySpaceGlobals["passwordList"] = []
#	mySpaceGlobals["title"] = null

#	mySpaceGlobals["enemy"] = null

#	mySpaceGlobals["p1X"] = 0
#	mySpaceGlobals["p1Y"] = 0
#	mySpaceGlobals["angle"] = 0
#	mySpaceGlobals["frame"] = 0

func SettingsCheck(directory: String) -> PlayerSettings:
	if FileAccess.file_exists(directory):
		return ResourceLoader.load(directory)
	else:
		var prof: PlayerSettings = PlayerSettings.new()
		return prof
