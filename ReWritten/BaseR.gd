extends Control

@onready var config = ConfigFile.new()

@onready var TitleScreen:Control = $"CenterContainer/SubViewportContainer/Gameview/TitleScreen"
@onready var MainGameplay:Node2D = $"CenterContainer/SubViewportContainer/Gameview/MainGameplay"
@onready var HUD:SpaceGameHUD = $"CenterContainer/SubViewportContainer/Gameview/UI"

@onready var Wiiuscreen:TextureRect = $"WiiUGamepad/Gameview"
@onready var Switchscreen:TextureRect = $"SwitchTablet/Gameview"
@onready var FullScreen:TextureRect = $"FullScreen"

func _ready() -> void:
	setBorder()
	Satellite.connect("state", changeState)
	Satellite.emit_signal("state", SpaceGlobals.GameState.TITLE_SCREEN)

#TODO: This uses the old settings design, need to update
func setBorder() -> void:
	config.load("user://settings.ini")
	if config.has_section_key("Settings", "Frame"):
		var screenchoice = config.get_value("Settings", "Frame")
		if screenchoice == "Switch":
			print(Switchscreen.get_size())
		#gameview.get_texture()

#TODO: This currently causes the title screen to be completely skipped, which is bad
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		match SpaceGlobals.state:
			SpaceGlobals.GameState.PAUSE_SCREEN:
				Satellite.emit_signal("state", SpaceGlobals.GameState.GAMEPLAY)
			SpaceGlobals.GameState.GAMEPLAY:
				Satellite.emit_signal("state", SpaceGlobals.GameState.PAUSE_SCREEN)
			SpaceGlobals.GameState.TITLE_SCREEN: #Debug thing
				Satellite.emit_signal("state", SpaceGlobals.GameState.GAMEPLAY)

#This function is the overarching controller of what is going on in Space Game
#It's kinda messy rn, definitely want to clean it up at some point
func changeState(state:SpaceGlobals.GameState) -> void:
	SpaceGlobals.state = state
	match state:
		SpaceGlobals.GameState.GAMEPLAY: #Gameplay
			TitleScreen.hide()
			HUD.menus.hide()
			HUD.show()
			MainGameplay.show()
			get_tree().paused = false
		SpaceGlobals.GameState.TITLE_SCREEN:
			#MainGameplay.process_mode = Node.PROCESS_MODE_DISABLED
			get_tree().paused = true
			HUD.hide()
			MainGameplay.hide() #TODO: Pause the gameplay when this happens
			TitleScreen.show()
		SpaceGlobals.GameState.PASSWORD_SCREEN:
			pass
		SpaceGlobals.GameState.PAUSE_SCREEN:
			get_tree().paused = true
			#MainGameplay.process_mode = Node.PROCESS_MODE_DISABLED
			HUD.displayPauseScreen()
			HUD.menus.show()
		SpaceGlobals.GameState.GAME_OVER_SCREEN:
			HUD.displayGameOver()
			HUD.menus.show()
		SpaceGlobals.GameState.PASSWORD_INPUT: 
			pass

const state:Dictionary = {
	0: "main gameplay",
	1: "title screen",
	2: "password screen",
	3: "pause screen",
	4: "game over screen",
	-27: "for password inputs",
}

# This class is a bit of a mess, but it basically does "everything else" in the game.
# The most vareresting function is rotating the bitmap (makeRotationMatrix).
#
# Other things it handles:
#	- Status bar drawd.drawing (renderTexts)
#	- Decompressing sprites (decompress_bitmap)
# It relies heavily on a SpaceGlobals struct defined in space.h. This is a carry over from the libwiiu
# pong example, but also I believe neccesary since global variables don't seem to be able to be set(?)

#var target = 

var orig_ship:Array = []
var rotated_ship:Array = []
var title:Array = []

#var compressed_boss = images.compressed_boss
#var boss_palette = images.boss_palette
#var compressed_boss2 = images.compressed_boss2
#var boss2_palette = images.boss2_palette

#Renamed "draw" to "drawd" because Godot was complaining about it
var drawd
var trigmath

# the original Space Game uses a few different speeds (bullet, player, enemies)
# but it didn't run at a reliable 60 fps (1/60 deltas)
# 30 fps "felt" too slow, so let's go with 40 fps
# as a baseline for how fast the game should expect to move
# this multiplier will modify all original game speeds to scale them back
# to one that feels more like how it ran on console
# it can be removed with password 60185
var FPS_MULT:int = 40



func blackout(g):
	g.labelController.makeAllInvisible()
	drawd.fillScreen(g, 0,0,0,1)

func makeRotationMatrix(angle, width:int, original, target, transIndex):
	for x in range(width):
		for y in range(width):
			target[x][y] = transIndex;
	var woffset = width/2.0;
	# go though every pixel in the target bitmap
	for ix in range(width):
		for iy in range(width):
			# rotate the pixel by the angle varo a new spot in the rotation matrix
			var oldx = int((ix - woffset) * cos(angle) + (iy - woffset) * sin(angle) + woffset);
			var oldy = int((ix - woffset) * sin(angle) - (iy - woffset) * cos(angle) + woffset);
			
			if (oldx > width): oldx = width-1;
			if (oldy > width): oldy = width-1;
			
#			if (original[oldx][oldy] == transIndex): continue;
			
			if (oldx < 0 || oldx >= width): continue;
			if (oldy < 0 || oldy >= width): continue;
			
			# TODO: crashes with this below line! When trying to assign to target, but only after doing the above math
			target[ix][iy] = original[oldx][oldy];

func render(mySpaceGlobals):
	if (mySpaceGlobals.invalid == 1):
		blackout(mySpaceGlobals.graphics);
		mySpaceGlobals.frame += 1;
#		if (mySpaceGlobals.renderResetFlag):
#			renderReset(mySpaceGlobals);
#		renderStars(mySpaceGlobals);
#		renderEnemies(mySpaceGlobals);
#		renderShip(mySpaceGlobals);
#		renderTexts(mySpaceGlobals);
		drawd.flipBuffers(mySpaceGlobals.graphics);
		mySpaceGlobals.invalid = 0;

# see the notes in images.c for more info on how this works
func decompress_sprite(arraysize:int, width:int, height:int, input, target, transIndex:int):
	var cx:int = 0
	var cy:int = 0;
	var posinrow:int = 0;
	# go through input array
	var x:int = 0
	while x < arraysize:
		var count = input[x];
		var value = input[x+1];
		if (count == -120): # full value rows of last index in palette
			for z in range(value):
				for za in range(width):
					target[cy+z][cx+za] = transIndex;
			cy += value;
			x += 2
			continue;
		if (count <= 0): # if it's negative, -count is value, and value is meaningless and advance by one
			value = -1*count;
			count = 1;
			x -= 1; # subtract one, so next time it goes up by 2, putting us at x+1
		for z in range(count):
			target[cy][cx] = value;
			cx += 1;
		posinrow += count
		if (posinrow >= width):
			posinrow = 0;
			cx = 0;
			cy+= 1;
		x += 2

func renderShip(mySpaceGlobals):
	var posx = int(mySpaceGlobals.p1X);
	var posy = int(mySpaceGlobals.p1Y);
	if (mySpaceGlobals.playerExplodeFrame < 2):
		makeRotationMatrix(mySpaceGlobals.angle, 36, orig_ship, rotated_ship, mySpaceGlobals.transIndex);
	drawd.drawBitmap(mySpaceGlobals.graphics, posx, posy, 36, 36, rotated_ship, mySpaceGlobals.curPalette);

func drawMenuCursor(mySpaceGlobals):
	# cover up any old cursors (used to be needed before changing to draw.draw everything mode)
	drawd.fillRect(mySpaceGlobals.graphics, 138, 164, 16, 30, 0, 0, 0);
	drawd.fillRect(mySpaceGlobals.graphics, 250, 164, 16, 30, 0, 0, 0);
	# display the cursor on the correct item
	var cursor:String = "[[            ]]"
	drawd.drawString(mySpaceGlobals.graphics, 21, 13 + mySpaceGlobals.menuChoice, cursor);

func displayPause(mySpaceGlobals):
	if (mySpaceGlobals.invalid == 1):
		blackout(mySpaceGlobals.graphics);
		# display the password here
		var resume:String = "Resume"
		var quit:String = " Quit"
		drawd.drawString(mySpaceGlobals.graphics, 27, 13, resume);
		drawd.drawString(mySpaceGlobals.graphics, 27, 14, quit);
		drawMenuCursor(mySpaceGlobals);
		drawd.flipBuffers(mySpaceGlobals.graphics);
		mySpaceGlobals.invalid = 0;
		
enum { A, B, X, Y, Z, UP, DOWN, LEFT, RIGHT }

func addNewEnemies(mySpaceGlobals):
	if (mySpaceGlobals.noEnemies || mySpaceGlobals.playerExplodeFrame > 1):
		return;
	# here we make a new enemy with a certain speed based on the level
	# get a random position from one of the sides with a random var 0-3
	var side = int(trigmath.prand()*4);
#	# randomly decide to set starting angle right for the player
#	var seekPlayer = trigmath.prand(mySpaceGlobals.seed)*2;
	var difficulty = mySpaceGlobals.level / 100.0;
	var randVal = trigmath.prand();
	# set the enemy count (max enemies on screen at once) based on level
	var enemyCount = 10 + difficulty * 90 * randVal;
	if (enemyCount > 100): enemyCount = 100;
	# set speed randomly within difficulty range
	var speed = 3 + (difficulty) * 12 * randVal;
	var startx
	var starty
	var theta = trigmath.prand()*PI;
	randVal = trigmath.prand();
	# horiz size
	if (side < 2):
#		startx = 0 if (side == 0) else xMaxBoundry;
#		starty = randVal*yMaxBoundry;
		if (startx != 0):
			theta -= PI;
	else:
#		starty = 20 if (side == 2) else yMaxBoundry;
#		startx = randVal*xMaxBoundry;
		if (starty == 20):
			theta -= PI / 2.0;
		else:
			theta += PI / 2.0;
	# seek directly to the player
	if (mySpaceGlobals.enemiesSeekPlayer == 1):
		var xdif = startx + 11 - (mySpaceGlobals.p1X + 18);
		var ydif = starty + 11 - (mySpaceGlobals.p1Y + 18);
		theta = atan2(xdif, ydif) - PI;
	for xx in range(enemyCount):
		if (mySpaceGlobals.enemies[xx].position.active == 0):
			mySpaceGlobals.enemies[xx].position.x = startx;
			mySpaceGlobals.enemies[xx].position.y = starty;
			mySpaceGlobals.enemies[xx].position.m_x = speed*sin(theta); # speed is the desired enemy speed
			mySpaceGlobals.enemies[xx].position.m_y = speed*cos(theta); # we have to solve for the hypotenuese
			mySpaceGlobals.enemies[xx].position.active = 1;
			break;

#func totallyRefreshState(mySpaceGlobals):
#	initGameState(mySpaceGlobals);
#	mySpaceGlobals["displayHowToPlay"] = 0;
#	mySpaceGlobals["firstShotFired"] = 0;
#	mySpaceGlobals["lives"] = 3;
#	mySpaceGlobals["playerExplodeFrame"] = 0;
#	mySpaceGlobals["score"] = 0;
#	mySpaceGlobals["level"] = 0;
#	mySpaceGlobals["dontKeepTrackOfScore"] = int(mySpaceGlobals.doubleShot or mySpaceGlobals.tripleShot)
#	mySpaceGlobals["noEnemies"] = 0;
#	mySpaceGlobals["enemiesSeekPlayer"] = 0;

func displayGameOver(mySpaceGlobals):
	if (mySpaceGlobals.invalid == 1):
		blackout(mySpaceGlobals.graphics);
		var gameover:String = "Game Over!"
		drawd.drawString(mySpaceGlobals.graphics, 25, 5, gameover);
		# only display score + pw if the player didn't use cheats
		if (mySpaceGlobals.dontKeepTrackOfScore != 1):
			var finalscore:String = "Score: %08d" % mySpaceGlobals.score
			var passw:String = "Lv %d Password: %05d" % [mySpaceGlobals.level+1, mySpaceGlobals.passwordList[mySpaceGlobals.level]]
			drawd.drawString(mySpaceGlobals.graphics, 23, 7, finalscore);
			drawd.drawString(mySpaceGlobals.graphics, 21, 8, passw);
		var resume:String = "Try Again"
		var quit:String = "   Quit"
		drawd.drawString(mySpaceGlobals.graphics, 25, 13, resume);
		drawd.drawString(mySpaceGlobals.graphics, 25, 14, quit);
		self.drawMenuCursor(mySpaceGlobals);
		drawd.flipBuffers(mySpaceGlobals.graphics);
		mySpaceGlobals.invalid = 0;
	# 100 passwords, one for each level
	for x in range(100):
		if (mySpaceGlobals.passwordEntered == mySpaceGlobals.passwordList[x]):
			mySpaceGlobals.level = x;
			break;
		if (x==99): # no password was right
			return;
	# switch to the game state
	mySpaceGlobals.state = 7;
	# They are generated

#func renderReset(mySpaceGlobals):
#	initGameState(mySpaceGlobals);
#	mySpaceGlobals.p1X = 200;
#	mySpaceGlobals.p1Y = 100;
#	mySpaceGlobals.renderResetFlag = 0;
#	mySpaceGlobals.invalid = 1;
