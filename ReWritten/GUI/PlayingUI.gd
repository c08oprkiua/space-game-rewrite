extends Control

class_name SpaceGameHUD

@onready var Level:Label = $"HUD/Level"
@onready var Score:Label = $"HUD/Score"
@onready var Lives:Label = $"HUD/Lives"

@onready var menus:CenterContainer = $"Menus"
@onready var pauseScreen:VBoxContainer = $"Menus/Pause"
@onready var gameOverScreen:VBoxContainer = $"Menus/GameOver"


func _ready() -> void:
	Satellite.connect("lives", updatelives)
	Satellite.connect("displayHowToPlay", nagThePlayer)

func displayPauseScreen() -> void:
	gameOverScreen.hide()
	pauseScreen.show()
	$"Menus/Pause/Resume".grab_focus()

func displayGameOver() -> void:
	pauseScreen.hide()
	gameOverScreen.show()
	$"Menus/Pause/Retry".grab_focus()

func nagThePlayer() -> void:
	var nag: String = "Rapid fire with RT or left on mouse!"
	#dRaw.drawString(SpaceGlobals.graphics, 17, 17, nag)

func updatelives(count:int) -> void:
	Lives.text = ("Lives: "+ String.num(count))

func updatescore(count:int) -> void:
	if (SpaceGlobals.dontKeepTrackOfScore == 1):
		Score.text = "Score: N/A"
	else:
		Score.text = ("Score: "+ String.num(count))

func updatelevel(count:int) -> void:
	Level.text = ("Lv: "+ String.num(count))

func _on_quit_pressed() -> void:
	Satellite.emit_signal("state", SpaceGlobals.GameState.TITLE_SCREEN)

func _on_resume_pressed() -> void:
	Satellite.emit_signal("state", SpaceGlobals.GameState.GAMEPLAY)

func _on_retry_pressed() -> void:
	#*mumble mumble* reset flag
	Satellite.emit_signal("state", SpaceGlobals.GameState.GAMEPLAY)
