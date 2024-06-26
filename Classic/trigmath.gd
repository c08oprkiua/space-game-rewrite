extends Node
class_name PRandom

# This is from here: http://stackoverflow.com/a/1026370/1871287
# it is initially seeded with the time
var xseed:float

func _init(initialSeed:float = 0) -> void:
	xseed = initialSeed
	print("Initial seed is "+ String.num(initialSeed))

func prand() -> float:
	var next:float = xseed
	var result:int
	next *= 1103515245
	next += 12345
	result = int(next / 65536) % 2048
	result = ~result
	
	next *= 1103515245;
	next += 12345;
	result <<= 10;
	result ^= int(next / 65536) % 1024;
	result = ~result

	next *= 1103515245;
	next += 12345;
	result <<= 10;
	result ^= int(next / 65536) % 1024;
	result = ~result

	xseed = next;

	return abs(result / 2147483647.0);
