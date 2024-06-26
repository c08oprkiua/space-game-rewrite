extends Node2D

func _ready() -> void:
	for bullet:Bullet in Bullet.pool:
		add_child(bullet)

func _process(delta: float) -> void:
	newAddEnemies()

func newAddEnemies() -> void:
	if (SpaceGlobals.noEnemies || SpaceGlobals.playerExplodeFrame > 1):
		return;
	# here we make a new enemy with a certain speed based on the level
	# get a random position from one of the sides with a random var 0-3
	var RNG:RandomNumberGenerator = RandomNumberGenerator.new()
	var side:int = RNG.randi_range(0, 3)
#	# randomly decide to set starting angle right for the player
#	var seekPlayer = trigmath.prand(mySpaceGlobals.seed)*2;
	var difficulty = SpaceGlobals.level / 100.0;
	var randVal:int = randi_range(0, 3)
	# set the enemy count (max enemies on screen at once) based on level
	var enemyCount:int = 10 + difficulty * 90 * randVal;
	 #Cap enemy amount to 100
	enemyCount = mini(enemyCount, 100)
	# set speed randomly within difficulty range
	var speed = 3 + (difficulty) * 12 * randVal;
	var start:Vector2i 
	
	var theta = trigmath.prand()*PI;
	randVal = trigmath.prand();
	# horiz size
	if (side < 2):
		start.x = 0 if (side == 0) else SpaceGlobals.bounds.size.x;
		start.y = randVal * SpaceGlobals.bounds.size.y;
		if (start.x != 0):
			theta -= PI;
	else:
		start.y = 20 if (side == 2) else SpaceGlobals.bounds.size.y;
		start.x = randVal * SpaceGlobals.bounds.size.x;
		if (start.y == 20):
			theta -= PI / 2.0;
		else:
			theta += PI / 2.0;
	# seek directly to the player
	if (SpaceGlobals.enemiesSeekPlayer == 1):
		var dif:Vector2i = start + Vector2i(11, 11) - (Vector2i(200, 100) + Vector2i(18, 18))
		theta = atan2(dif.x, dif.y) - PI;
	
	for xx in range(enemyCount):
		var enemy:GByte = GByte.pool[xx]
		if not (enemy.process_mode == Node.PROCESS_MODE_PAUSABLE):
			enemy.position = start
			# speed is the desired enemy speed
			# we have to solve for the hypotenuese
			enemy.m = speed * Vector2(sin(theta), cos(theta))
			enemy.enable()
			break;


func addNewEnemies() -> void:
	if (SpaceGlobals.noEnemies || SpaceGlobals.playerExplodeFrame > 1):
		return;
	# here we make a new enemy with a certain speed based on the level
	# get a random position from one of the sides with a random var 0-3
	var side = int(trigmath.prand()*4);
#	# randomly decide to set starting angle right for the player
#	var seekPlayer = trigmath.prand(mySpaceGlobals.seed)*2;
	var difficulty = SpaceGlobals.level / 100.0;
	var randVal = trigmath.prand();
	# set the enemy count (max enemies on screen at once) based on level
	var enemyCount = 10 + difficulty * 90 * randVal;
	if (enemyCount > 100): enemyCount = 100;
	# set speed randomly within difficulty range
	var speed = 3 + (difficulty) * 12 * randVal;
	var startx
	var starty
	var theta = trigmath.prand()*PI;
	randVal = trigmath.prand();
	# horiz size
	if (side < 2):
		startx = 0 if (side == 0) else SpaceGlobals.bounds.size.x;
		starty = randVal * SpaceGlobals.bounds.size.y;
		if (startx != 0):
			theta -= PI;
	else:
		starty = 20 if (side == 2) else SpaceGlobals.bounds.size.y;
		startx = randVal * SpaceGlobals.bounds.size.x;
		if (starty == 20):
			theta -= PI / 2.0;
		else:
			theta += PI / 2.0;
	# seek directly to the player
	if (SpaceGlobals.enemiesSeekPlayer == 1):
		var xdif = startx + 11 - (SpaceGlobals.p1X + 18);
		var ydif = starty + 11 - (SpaceGlobals.p1Y + 18);
		theta = atan2(xdif, ydif) - PI;
	
	for xx in range(enemyCount):
		var enemy:GByte = GByte.pool[xx]
		if not (enemy.process_mode == Node.PROCESS_MODE_PAUSABLE):
			enemy.position.x = startx;
			enemy.position.y = starty;
			enemy.m.x = speed * sin(theta); # speed is the desired enemy speed
			enemy.m.y = speed * cos(theta); # we have to solve for the hypotenuese
			enemy.enable()
			break;
