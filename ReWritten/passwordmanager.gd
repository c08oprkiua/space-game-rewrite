extends LineEdit

#Change this to save changes to a userprofile file, which then can be read back by
#both options and the game at runtime

var config:ConfigFile = ConfigFile.new()
const userfile: String = "user://settings.ini"
# Dear Github Viewer,
#		Well, here's where you see the passwords I guess!
#		With the exception of a few hardcoded ones, the
#		level passwords are generated and checked against
#		a seeded random list from program.c
# Enjoy!

const EasterPasswords = {
	"00001": "https://t-tb.bandcamp.com/track/cruise",
	"00002": "https://t-tb.bandcamp.com/track/scream-pictures",
	"00003": "https://t-tb.bandcamp.com/track/slimers",
	"00004": "https://t-tb.bandcamp.com/track/frog-song",
	"00005": "https://www.youtube.com/watch?v=Tb02CNlhkPA",
	"00006": "https://www.youtube.com/watch?v=a6oWk-BJ8bI",
	"00007": "https://www.youtube.com/watch?v=wcMLFMsIVis",
	"41666": "https://wiiu.hacks.guide"
}

const ExtrasPassword = {
	"82571": "noEnemies",
	"30236": "Kamikaze",
	"00000": "DefaultShip",
	"22222": "NoAudio", #Depreciate? Replace?
	"12345": "Galaga",
	"77777": "RedBlueFlip",
}

const CheatPassword = {
	"55225": "Invincibility",
	"24177": "DoubleShot",
	"37124": "TripleShot",
	"60185": "SpeedHack",
	"99499": "99lives",
}

func _ready() -> void:
	config.load(userfile)

func tryPassword(password:String) -> void:
	if EasterPasswords.has(password):
		OS.shell_open(EasterPasswords.get(password))
	elif ExtrasPassword.has(password):
		config.set_value("Extras", ExtrasPassword.get(password), true)
	elif CheatPassword.has(password):
		config.set_value("Cheats", CheatPassword.get(password), true)
	config.save(userfile)

#The following will instead be checked through the configfile at runtime

	# Play as galaga ship
#	if (SpaceGlobals.passwordEntered == 12345):
#		SpaceGlobals.playerChoice = 3;
#		decompress_sprite(452, 36, 36, compressed_ship2, orig_ship, 5);
#		SpaceGlobals.curPalette = ship2_palette;
#		SpaceGlobals.transIndex = 5;
#		SpaceGlobals.state = 7;

	# double shot (previously turn player into boss1)
#	if (mySpaceGlobals.passwordEntered == 24177):
#		mySpaceGlobals.tripleShot = true
#		mySpaceGlobals.doubleShot = true
#		BULLET_COUNT = 60
#		initBullets(mySpaceGlobals)
#		mySpaceGlobals.dontKeepTrackOfScore = 1;
#		mySpaceGlobals.playerChoice = 1;
#		decompress_sprite(662, 36, 36, compressed_boss2, orig_ship, 39);
#		mySpaceGlobals.curPalette = boss2_palette;
#		mySpaceGlobals.transIndex = 39;
#		mySpaceGlobals.state = 7;
#
#	# triple shot (previously turn player into boss2)
#	if (mySpaceGlobals.passwordEntered == 37124):
#		mySpaceGlobals.tripleShot = true
#		mySpaceGlobals.doubleShot = false
#		BULLET_COUNT = 100
#		initBullets(mySpaceGlobals)
#		mySpaceGlobals.dontKeepTrackOfScore = 1;
#		# rest in peace Etika
#		OS.shell_open("https://www.youtube.com/watch?v=1qX75J4_-e8")
##		mySpaceGlobals.playerChoice = 2;
##		decompress_sprite(740, 36, 36, compressed_boss, orig_ship, 39);
#		mySpaceGlobals.curPalette = boss_palette;
#		mySpaceGlobals.transIndex = 39;
#		mySpaceGlobals.state = 7;

	# Enemies come right for you (kamikaze mode)
	#if (SpaceGlobals.passwordEntered == 30236):
		#SpaceGlobals.enemiesSeekPlayer = 1;
		#SpaceGlobals.dontKeepTrackOfScore = 1;
		#SpaceGlobals.state = 7;

	# toggle the space nx bitmap font
#	if SpaceGlobals.passwordEntered == 11111:
#		SpaceGlobals.graphics.nxFont = not mySpaceGlobals.graphics.nxFont
#		SpaceGlobals.graphics.classicMain.size_changed()

	# play whole game at faster speed, and switch audio
#	if SpaceGlobals.passwordEntered == 60185:
#		if FPS_MULT == 60:
#			FPS_MULT = 80 # go even further beyond
#		else:
#			FPS_MULT = 60
#		var player = SpaceGlobals.graphics.classicMain.player
#		var isPlaying = player.playing
#		player.stream = spedUpMusic
#		player.playing = isPlaying
#		mySpaceGlobals.state = 27;

#	# 100 passwords, one for each level
#	for x in range(100):
	
#		if (mySpaceGlobals.passwordEntered == mySpaceGlobals.passwordList[x]):
#			mySpaceGlobals.level = x;
#			break;

#		if (x==99): # no password was right
#			return;

#Program it so that B on the settings box rehides it and unhides everything else

func doPasswordMenuAction(mySpaceGlobals):
	# if we've seen up, down, left, right, and a buttons not being pressed
	if (!(mySpaceGlobals.buttonA   ||
		mySpaceGlobals.buttonUP    ||
		mySpaceGlobals.buttonDOWN  ||
		mySpaceGlobals.buttonLEFT  ||
		mySpaceGlobals.buttonRIGHT   )):
		mySpaceGlobals.allowInput = 1;
	if (mySpaceGlobals.allowInput):
		if (mySpaceGlobals.buttonB):
			# go back to title screen
			mySpaceGlobals.state = 1;
			# update the menu choice
			mySpaceGlobals.menuChoice = 0;
			# disable menu input after selecting to prevent double selects
			mySpaceGlobals.allowInput = 0;
			# mark view invalid to redraw.draw
			mySpaceGlobals.invalid = 1;
		if (mySpaceGlobals.buttonA):
			# try the password
			tryPassword(mySpaceGlobals);
			# disable menu input after selecting to prevent double selects
			mySpaceGlobals.allowInput = 0;
			# update the menu choice
			mySpaceGlobals.menuChoice = 0;
			# mark view invalid to redraw.draw
			mySpaceGlobals.invalid = 1;
		var stickY = mySpaceGlobals.lstick_y + mySpaceGlobals.rstick_y;
		var stickX = mySpaceGlobals.lstick_x + mySpaceGlobals.rstick_x;
		var down   = (mySpaceGlobals.buttonDOWN  || stickY < -0.3);
		var up     = (mySpaceGlobals.buttonUP    || stickY >  0.3);
		var left   = (mySpaceGlobals.buttonLEFT  || stickX < -0.3);
		var right  = (mySpaceGlobals.buttonRIGHT || stickX >  0.3);
		if (up || down):
			var offset: int = 1
			# keep going up in the 10s place to match current choice
			for x in range(4 - mySpaceGlobals.menuChoice):
				offset *= 10;
			if (up):
				mySpaceGlobals.passwordEntered += offset;
			if (down):
				mySpaceGlobals.passwordEntered -= offset;
			mySpaceGlobals.invalid = 1;
			mySpaceGlobals.allowInput = 0;
		if (left || right):
			if (right):
				mySpaceGlobals.menuChoice += 1;
			if (left):
				mySpaceGlobals.menuChoice -= 1;
			# bound the menu choices
			if (mySpaceGlobals.menuChoice < 0):
				mySpaceGlobals.menuChoice = 0;
			if (mySpaceGlobals.menuChoice > 4):
				mySpaceGlobals.menuChoice = 4;
			mySpaceGlobals.invalid = 1;
			mySpaceGlobals.allowInput = 0;
		# bound the password
		if (mySpaceGlobals.passwordEntered < 0):
			mySpaceGlobals.passwordEntered = 0;
		if (mySpaceGlobals.passwordEntered > 99999):
			mySpaceGlobals.passwordEntered = 99999;
