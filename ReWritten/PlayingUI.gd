extends Node

@onready var Level = $"Level"
@onready var Score = $"Score"
@onready var Lives = $"Lives"

var draw

func _ready():
	Satellite.connect("lives", updatelives)
	Satellite.connect("displayHowToPlay", nagtheplayer)
	Satellite.connect("firelaser", nevermind)

func renderTexts(mySpaceGlobals):
#	draw.fillRect(mySpaceGlobals.graphics, 0, 0, xMaxBoundry, 20, 0, 0, 0);
	var score
	if (mySpaceGlobals.dontKeepTrackOfScore == 1):
		score = "Score: N/A"
	else:
		score = "Score: %09d" % mySpaceGlobals.score
	draw.drawString(SpaceGlobals.graphics, 0, 0, score)
	var level = "   Lv %d" % (mySpaceGlobals.level+1)
	draw.drawString(SpaceGlobals.graphics, 27, 0, level)
	var lives = "   Lives: %d" % mySpaceGlobals.lives
	draw.drawString(SpaceGlobals.graphics, 52, 0, lives)

func nagtheplayer():
	var nag = "Rapid fire with right stick or touch!"
	draw.drawString(SpaceGlobals.graphics, 17, 17, nag)

func nevermind(_position, _rotation):
	Satellite.disconnect("displayHowToPlay", nagtheplayer)
	Satellite.disconnect("firelaser", nevermind)

func updatelives(count):
	Lives.text = ("Lives: "+ count)
	
func updatescore(count):
	Score.text = ("Score: "+ count)

func updatelevel(count):
	Level.text = ("Level: "+ count)