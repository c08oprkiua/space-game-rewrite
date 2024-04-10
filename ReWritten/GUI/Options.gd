extends VBoxContainer

var sfxvol: int
var musicvol: int

#User-specific information here
var profile: PlayerSettings #"CurrentProfile"
#General game settings in the setting.ini file

func _ready():
	DefaultSettings()

#Determine which tabs to show based on what's written to the settings file, 
#so that the user does not see what they don't have activated

func DefaultSettings():
	profile.loadSettings("settings")
	profile.saveSettings()

func _on_sfx_vol_drag_ended(value_changed:bool) -> void:
	if value_changed:
		profile.sfxVolume = sfxvol

func _on_sfx_vol_value_changed(value:float) -> void:
	sfxvol = int(value)

func _on_music_vol_drag_ended(value_changed:bool) -> void:
	if value_changed:
		profile.musicVolume = musicvol

func _on_music_vol_value_changed(value:float) -> void:
	musicvol = int(value)

func _on_load_pressed() -> void:
	pass # Replace with function body.

func _on_save_pressed() -> void:
	profile.saveSettings()
