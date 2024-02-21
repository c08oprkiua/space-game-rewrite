extends Node
class_name SpacGlob

var seed:float = 4.20

var player

var a:int = 0;

var screenImage
var screenTexture
var editableScreen

var SCALER:Vector2i = Vector2i(1,1)
var windowSize
var gamepad

var initialized:bool = false

var labelController

var gamepadTexture
var tabletTexture

var startedMusic = false

var playerChoice: int = 0
var playerChoiceDict = {
	
	
}
var playerExplodeFrame: int = 0

var enemy = null
var enemies
var noEnemies:bool = false

var xMinBoundry:int = 0
var xMaxBoundry:int = 427
var yMinBoundry:int = 0
var yMaxBoundry:int = 240

var rstick_x
var rstick_y

var MAX_ENEMIES:int = 100
var BULLET_COUNT:int = 20
var bullets:Array = []

var spedUpMusic
var flipColor: int = 0

# Flag for restarting the entire game.
var restart:int = 1

# initial state is title screen
#The state variable has become a signal, and is compared to state the constant (dictionary)
const state = {
	1: "title screen",
	2: "password screen",
	3: "pause screen",
	4: "game over screen",
	-27: "for password inputs",
}
#Anything not in that dictionary is gameplay
var titleScreenRefresh:int = 1

# Flags for render states
var renderResetFlag:int = 0
var menuChoice:int = 0
const menuChoiceDict:Dictionary = {
	0: "play",
	1: "password",
}

var lives: int = 4

var p1X: int = 0
var p1Y: int = 0
var angle: int = 0
var frame: int = 0

#The folowing have been moved: 
	#These have been changed to per-player, for the sake of futureproofing and the fact that having 
	# them configurable per-player just makes sense imho
var tripleShot:bool = false
var doubleShot:bool = false
var orig_ship

	#Moved to the password manager script, which entirely manages all passwords in the game for the 
	#sake of that code not bloating up a different script
var passwordList:Array = []
var title 
	#All input variables are entirely gone, because that can be natively handled in Godot through
	#the various Input singletons

#var curPalette = images.ship_palette
var transIndex:int = 14
var passwordEntered:int = 0
var quit:int = 0
#  initialize starfield for this game
var invalid:int = 1

var touched
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

var images:Images = Images.new()

var rotated_ship:Array = []

var enemy_palette:Array = images.enemy_palette
var title_palette:Array = images.title_palette
var compressed_ship:Array = images.compressed_ship
var compressed_ship2:Array = images.compressed_ship2
var ship_palette:Array = images.ship_palette
var ship2_palette:Array = images.ship2_palette
var compressed_boss:Array = images.compressed_boss
var boss_palette:Array = images.boss_palette
var compressed_boss2:Array = images.compressed_boss2
var boss2_palette:Array = images.boss2_palette

var trigmath

func _init():
	print("Bababooey")

# the original Space Game uses a few different speeds (bullet, player, enemies)
# but it didn't run at a reliable 60 fps (1/60 deltas)
# 30 fps "felt" too slow, so let's go with 40 fps
# as a baseline for how fast the game should expect to move
# this multiplier will modify all original game speeds to scale them back
# to one that feels more like how it ran on console
# it can be removed with password 60185
var FPS_MULT:int = 40

#Some new global variables
var playingOptions: bool
var config:ConfigFile = ConfigFile.new()#.load("user://settings.ini")


#Reset the game
func reset() -> void:
	button = 0
	#Set flag to render reset screen;
	renderResetFlag = 1

#This might not be needed, the game now renders to a 427x240 subviewport that the
#engine then scales up to the window size if it's larger than 240p
func size_changed() -> void:
	#windowSize = get_viewport_rect().size
	var width:int = 427
	var height:int = 240
	SCALER = max(min(int(windowSize.x / width), int(windowSize.y / height)), 1)

func initGameState() -> void:
	pass
#	# init enemies
	for x in range(MAX_ENEMIES):
		enemies[x].position.active = 0;
		enemies[x].angle = 3.14;
		#makeRotationMatrix(0, 23, enemy, enemies[x].rotated_sprite, 9);

func initBullets() -> void:
	for x in range(BULLET_COUNT):
		var bullet:Dictionary = {
			"x": 0,
			"y": 0,
			"m_x": 0,
			"m_y": 0,
			"active": 0
		}
		bullets.append(bullet)

func increaseScore(inc) -> void:
#	# count the number of 5000s that fit into the score before adding
	var fiveThousandsBefore = score / 5000
#	# increase the score
	score += inc
#	# count them again
	var fiveThousandsAfter = score / 5000
#	# if it increased, levelup
	if (fiveThousandsAfter > fiveThousandsBefore):
		level += 1



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
