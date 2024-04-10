extends Control

@onready var Level:Label = $"MarginContainer/Level"
@onready var Score:Label = $"MarginContainer/Score"
@onready var Lives:Label = $"MarginContainer/Lives"

var dRaw

func _ready() -> void:
	Satellite.connect("lives", updatelives)
	Satellite.connect("displayHowToPlay", nagtheplayer)
	Satellite.connect("firelaser", nevermind)

func renderTexts():
#	draw.fillRect(SpaceGlobals.graphics, 0, 0, xMaxBoundry, 20, 0, 0, 0);
	var score: String
	if (SpaceGlobals.dontKeepTrackOfScore == 1):
		score = "Score: N/A"
	else:
		score = "Score: %09d" % SpaceGlobals.score
	dRaw.drawString(SpaceGlobals.graphics, 0, 0, score)
	var level:String = "   Lv %d" % (SpaceGlobals.level+1)
	dRaw.drawString(SpaceGlobals.graphics, 27, 0, level)
	var lives:String = "   Lives: %d" % SpaceGlobals.lives
	dRaw.drawString(SpaceGlobals.graphics, 52, 0, lives)

func nagtheplayer() -> void:
	var nag: String = "Rapid fire with right stick or touch!"
	dRaw.drawString(SpaceGlobals.graphics, 17, 17, nag)

func nevermind(_position, _rotation) -> void:
	Satellite.disconnect("displayHowToPlay", nagtheplayer)
	Satellite.disconnect("firelaser", nevermind)

func updatelives(count) -> void:
	Lives.text = ("Lives: "+ count)
	
func updatescore(count) -> void:
	Score.text = ("Score: "+ count)

func updatelevel(count) -> void:
	Level.text = ("Level: "+ count)
