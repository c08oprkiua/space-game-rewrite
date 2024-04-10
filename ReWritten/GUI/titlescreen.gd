extends VBoxContainer

@onready var logo:TextureButton = $"SpaceGame"
@onready var credits:Label = $"Credits"
@onready var startgame:Button = $"StartGame"
@onready var password:Button = $"Password"
@onready var passwordenter:LineEdit = $"PassEnt" 
@onready var options:Button = $"Options"
@onready var anims:AnimationPlayer = $"AnimationPlayer"
#	- Handling the menu at the title screen (doMenuAction)

func _ready() -> void:
	#Have some stuff in here about opening a thread and loading up the main scene in the background
	if SpaceGlobals.settings != null:
		options.show()
	anims.play("startup")
	await anims.animation_finished
	startgame.grab_focus()

func _on_start_game_pressed() -> void:
	Satellite.emit_signal("state", 0)
	print("Start game")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_password_toggled(button_pressed:bool) -> void:
	if button_pressed:
		anims.play("fade-title")
		await anims.animation_finished
		if SpaceGlobals.settings != null:
			options.hide()
		logo.hide()
		credits.hide()
		startgame.hide()
		passwordenter.show()
	else:
		passwordenter.hide()
		if SpaceGlobals.settings != null:
			options.show()
		logo.show()
		credits.show()
		startgame.show()
		anims.play_backwards("fade-title")
		await anims.animation_finished

func _on_space_game_pressed() -> void:
	print("Original Godot 3 version by vgmoose. Godot 4 port and rewrite by c08oprkiua.")

#the following is just reference code from the OG SpaceGame

#func displayTitle(mySpaceGlobals):
#	if (mySpaceGlobals.invalid == 1):
#		print("Blacking out\n");
#		blackout(mySpaceGlobals.graphics);
#		print("draw.drawing stars\n");
		# draw.draw some stars
#		renderStars(mySpaceGlobals);
#		print("draw.drawing \"text\"\n");
		# display the bitmap in upper center screen
#		draw.drawBitmap(mySpaceGlobals.graphics, 107, 30, 200, 100, title, title_palette);
#		var credits = "  by vgmoose";
#		var musiccredits = "~*cruise*~ by (T-T)b"
#		var license = "MIT License"
#		var play = "Start Game"
#		var password = " Password"
		#display the menu under it
#		draw.drawString(mySpaceGlobals.graphics, 35, 10, credits);
#		draw.drawString(mySpaceGlobals.graphics, 25, 13, play);
#		draw.drawString(mySpaceGlobals.graphics, 25, 14, password);
#		draw.drawString(mySpaceGlobals.graphics, 40, 17, musiccredits);
#		draw.drawString(mySpaceGlobals.graphics, 0, 17, license);
#		drawMenuCursor(mySpaceGlobals);
#		draw.flipBuffers(mySpaceGlobals.graphics);
#		mySpaceGlobals.invalid = 0;


func doMenuAction(mySpaceGlobals):
	# if we've seen the A button and B button not being pressed
	if (!(mySpaceGlobals.buttonA) && !(mySpaceGlobals.buttonB)):
		mySpaceGlobals.allowInput = 1;
	# title screen and B was pressed, exit fully
	if (mySpaceGlobals.state == 1 && mySpaceGlobals.buttonB && mySpaceGlobals.allowInput):
		mySpaceGlobals.quit = 1;
	if (mySpaceGlobals.buttonA && mySpaceGlobals.allowInput):
		# if we're on the title menu
		if (mySpaceGlobals.state == 1):
			if (mySpaceGlobals.menuChoice == 0):
#				totallyRefreshState(mySpaceGlobals);
				# start game chosen
				mySpaceGlobals.state = 7; # switch to game state
				mySpaceGlobals.renderResetFlag = 1; # redraw.draw screen
			elif (mySpaceGlobals.menuChoice == 1):
				# password screen chosen
				mySpaceGlobals.state = 2;
		# password screen
#		elif (mySpaceGlobals.state == 2):
#		{
#			# this is handled by the password menu action function
#		}
		# pause screen
		elif (mySpaceGlobals.state == 3):
			if (mySpaceGlobals.menuChoice == 0):
				# resume chosen
				mySpaceGlobals.state = 7; # switch to game state
			elif (mySpaceGlobals.menuChoice == 1):
				# quit chosen
#				totallyRefreshState(mySpaceGlobals);
				mySpaceGlobals.state = 1;
		# game over screen
		elif (mySpaceGlobals.state == 4):
#			totallyRefreshState(mySpaceGlobals);
			if (mySpaceGlobals.menuChoice == 0):
				# try again chosen
				#player stays on the same level
				mySpaceGlobals.state = 7; # switch to game state
			elif (mySpaceGlobals.menuChoice == 1):
				# quit chosen
				mySpaceGlobals.state = 1;
		# reset the choice
		mySpaceGlobals.menuChoice = 0;
		# disable menu input after selecting to prevent double selects
		mySpaceGlobals.allowInput = 0;
		# mark view invalid to redraw.draw
		mySpaceGlobals.invalid = 1;
	var stickY = mySpaceGlobals.lstick_y + mySpaceGlobals.rstick_y;
	if (mySpaceGlobals.buttonDOWN || stickY > 0.3):
		mySpaceGlobals.menuChoice = 1;
		mySpaceGlobals.invalid = 1;
	if (mySpaceGlobals.buttonUP || stickY < -0.3):
		mySpaceGlobals.menuChoice = 0;
		mySpaceGlobals.invalid = 1;


