extends Resource
class_name PlayerSettings


var buttonA = false
var buttonB = false
var buttonUP = false 
var buttonDOWN = false
var buttonLEFT = false
var buttonRIGHT = false 
var buttonPLUS = false 
var rstick_x: int = 0 
var lstick_x: int = 0 
var rstick_y: int = 0 
var lstick_y: int = 0 
var touched = false
var allowInput = true

@export var tripleShot: bool = false
@export var doubleShot: bool = false 
@export var lives: int = 4
@export var orig_ship: bool = true
@export var speed: int = 400
