extends Resource
class_name PlayerSettings

#All these will be scrapped
var buttonA:bool = false
var buttonB:bool = false
var buttonUP:bool = false 
var buttonDOWN:bool = false
var buttonLEFT:bool = false
var buttonRIGHT:bool = false 
var buttonPLUS:bool = false 
var rstick_x: int = 0 
var lstick_x: int = 0 
var rstick_y: int = 0 
var lstick_y: int = 0 
var touched:bool = false
var allowInput:bool = true

var conf:ConfigFile = ConfigFile.new()
var path:String = "user://{}.ini"

var cheatsActive:bool = false

@export_category("General")
@export var profileName: String:
	set(value):
		profileName = value.validate_filename()
		setGeneral("profileName")
@export var highScore: int = 0:
	set(value):
		highScore = maxf(value, 0) #Negavtive scores will not be accepted
		setGeneral("highScore")
@export_range(0, 100) var sfxVolume: int = 100:
	set(value):
		sfxVolume = clampi(value, 0, 100)
		setGeneral("sfxVolume")
@export_range(0, 100) var musicVolume: int = 100:
	set(value):
		musicVolume = clampi(value, 0, 100)
		setGeneral("musicVolume")

#Export flags for which cheats should be accessible here
@export_category("Cheats")
@export var tripleShot: bool = false:
	set(value):
		tripleShot = value
		if value:
			cheatsActive = true
		setCheat("tripleShot")
@export var doubleShot: bool = false:
	set(value):
		doubleShot = value
		if value:
			cheatsActive = true
		setCheat("doubleShot")
@export var canEditSpeed: bool = false:
	set(value):
		canEditSpeed = value
		if value:
			cheatsActive = true
		setCheat("canEditSpeed")
@export var lives: int = 4
@export var speed: int = 400

#Export flags for which extras should be accessible here
@export_category("Extras")
@export var NoEnemies: bool = false
@export var Kamikaze: bool = false
@export_enum("Original", "Inverted", "Galaga") var ShipType: int = 0
@export var RedBlueSwap: bool = false
@export_enum("None", "Wii U Gamepad", "Switch Tablet") var bordertype: int = 0

func setGeneral(value:StringName) -> void:
	conf.set_value("General", value, self.get(value))

func setCheat(value:StringName) -> void:
	conf.set_value("Cheats", value, self.get(value))

func setExtra(value:StringName) -> void:
	conf.set_value("Extras", value, self.get(value))

func loadSettings(name:StringName) -> void:
	if FileAccess.file_exists(path.format(name)):
		conf.load(path.format(name))
	else:
		profileName = name
		saveSettings()

func saveSettings() -> void:
	conf.save(path.format(profileName))
