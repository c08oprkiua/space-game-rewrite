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

@export_category("General")
@export var ProfileName: String
@export var HighScore: int = 0
@export_range(0, 100) var SFX_Volume: int = 100
@export_range(0, 100) var MusicVolume: int = 100

#Export flags for which cheats should be accessible here
@export_category("Cheats")
@export var tripleShot: bool = false
@export var doubleShot: bool = false
@export var CanEditSpeed: bool = false
@export var lives: int = 4
@export var speed: int = 400

#Export flags for which extras should be accessible here
@export_category("Extras")
@export var NoEnemies: bool = false
@export var Kamikaze: bool = false
@export_enum("Original", "Inverted", "Galaga") var ShipType: int = 0
@export var RedBlueSwap: bool = false
@export_enum("None", "Wii U Gamepad", "Switch Tablet") var bordertype: int = 0
