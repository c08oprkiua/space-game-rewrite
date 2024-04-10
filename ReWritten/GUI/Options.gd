extends VBoxContainer

@onready var General = $"Scroller/General"
@onready var Cheats = $"Scroller/Cheats"
@onready var Extras = $"Scroller/Extras"

const settingsfile: String = "user://settings.ini"

var sfxvol: int
var musicvol: int

#User-specific information here
var CurPro: PlayerSettings #"CurrentProfile"
#General game settings in the setting.ini file
var conf = ConfigFile.new()

func _ready():
	conf.load(settingsfile)
	var savefile:String = conf.get_value("General", "Last_used", "Player1.tres") #Should be Resource
	CurPro = ResourceLoader.load(savefile) as PlayerSettings

#Determine which tabs to show based on what's written to the settings file, 
#so that the user does not see what they don't have activated

func DefaultSettings():
	#Will set default values
	pass

func WriteGeneral(name: String, value: Variant):
	conf.set_value("General", name, value)

func _on_sfx_vol_drag_ended(value_changed):
	if value_changed:
		WriteGeneral("SFXVol", sfxvol)

func _on_sfx_vol_value_changed(value):
	sfxvol = int(value)

func _on_music_vol_drag_ended(value_changed):
	if value_changed:
		WriteGeneral("MusicVol", musicvol)

func _on_music_vol_value_changed(value):
	musicvol = int(value)


func _on_load_pressed():
	pass # Replace with function body.


func _on_save_pressed():
	pass # Replace with function body.
