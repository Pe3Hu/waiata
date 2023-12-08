extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.word = [3, 5, 7]
	arr.arrangement = ["AAA", "ABA", "AABA", "ABABCB"]


func init_num() -> void:
	num.index = {}
	num.index.rune = 0


func init_dict() -> void:
	init_neighbor()
	init_rune()
	init_combination()
	init_segment()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_rune() -> void:
	dict.rune = {}
	dict.rune.title = {}
	color.rune = {}
	var h = 360.0
	
	var path = "res://asset/json/waiata_rune.json"
	var array = load_data(path)
	
	for rune in array:
		var data = {}
		
		for key in rune:
			if key != "title":
				if key == "hue":
					color.rune[rune.title] = Color.from_hsv(rune.hue / h, 0.9, 0.6)
				else:
					data[key] = rune[key]
		
		dict.rune.title[rune.title] = data


func init_combination() -> void:
	dict.combination = {}
	dict.combination.index = {}
	dict.combination.runes = {}
	dict.combination.words = {}
	color.combination = {}
	var h = 360.0
	
	var path = "res://asset/json/waiata_combination.json"
	var array = load_data(path)
	
	for combination in array:
		var data = {}
		data.length = {}
		
		for key in combination:
			if key != "index":
				var words = key.split(" ")
				
				if words.has("length"):
					data[words[0]][int(words[1])] = combination[key]
				else:
					data[key] = combination[key]
		
		if !dict.combination.runes.has(combination.runes):
			dict.combination.runes[combination.runes] = []
		
		if !dict.combination.words.has(combination.words):
			dict.combination.words[combination.words] = []
			
		dict.combination.index[combination.index] = data
		dict.combination.runes[combination.runes].append(combination.index) 
		dict.combination.words[combination.words].append(combination.index) 


func init_segment() -> void:
	dict.segment = {}
	dict.segment.title = {}
	dict.segment.types = {}
	color.segment = {}
	var h = 360.0
	
	var path = "res://asset/json/waiata_segment.json"
	var array = load_data(path)
	
	for segment in array:
		var data = {}
		
		for key in segment:
			if key != "title":
				var words = key.split(" ")
				
				if words.size() > 1:
					words[0] = words[0]+"s"
					
					if !data.has(words[0]):
						data[words[0]] = []
						
					data[words[0]].append(segment[key])
				else:
					data[key] = segment[key]
		
		dict.segment.title[segment.title] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.poet = load("res://scene/1/poet.tscn")
	scene.song = load("res://scene/1/song.tscn")
	scene.segment = load("res://scene/1/segment.tscn")
	scene.word = load("res://scene/1/word.tscn")
	scene.rune = load("res://scene/1/rune.tscn")
	pass


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(48, 48)
	vec.size.number = Vector2(5, 32)
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.aspect = Vector2(32, 32)
	vec.size.box = Vector2(100, 100)
	vec.size.bar = Vector2(120, 12)
	
	vec.size.rune = Vector2(40, 40)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	#color.rune.a = Color.from_hsv(0 / h, 0.9, 0.6)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
