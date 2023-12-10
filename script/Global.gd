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
	arr.token = ["slur", "rapture"]
	arr.state = ["vigor", "standard", "fatigue"]


func init_num() -> void:
	num.index = {}
	num.index.poet = 0
	num.index.rune = 0
	
	num.gap = {}
	num.gap.segment = 10
	num.gap.word = 0
	num.gap.syllable = 5
	num.gap.rune = 0


func init_dict() -> void:
	init_neighbor()
	init_rune()
	init_combination()
	init_segment()
	init_syllable()


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
	
	dict.rune.token = {}
	dict.rune.token["vowel"] = "rapture"
	dict.rune.token["consonant"] = "slur"
	
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
		
		for key in data:
			if !dict.rune.has(key):
				dict.rune[key] = {}
			
			if !dict.rune[key].has(data[key]):
				dict.rune[key][data[key]] = []
			
			dict.rune[key][data[key]].append(rune.title)


func init_combination() -> void:
	dict.combination = {}
	dict.combination.index = {}
	dict.combination.runes = {}
	dict.combination.words = {}
	color.combination = {}
	
	var path = "res://asset/json/waiata_combination.json"
	var array = load_data(path)
	
	for combination in array:
		combination.index = int(combination.index)
		combination.runes = int(combination.runes)
		combination.words = int(combination.words)
		var data = {}
		data.length = {}
		
		for key in combination:
			if key != "index":
				var words = key.split(" ")
				
				if words.has("length"):
					if combination[key] > 0:
						data[words[0]][int(words[1])] = int(combination[key])
				else:
					data[key] = int(combination[key])
		
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
					
					if words.has("combination"):
						segment[key] = int(segment[key])
					
					data[words[0]].append(segment[key])
				else:
					data[key] = segment[key]
		
		dict.segment.title[segment.title] = data
		
		for type in data.types:
			if !dict.segment.types.has(type):
				dict.segment.types[type] = []
			
			dict.segment.types[type].append(segment.title)


func init_syllable() -> void:
	dict.syllable = {}
	dict.syllable.types = {}
	dict.syllable.types[3] = [["base"]]
	dict.syllable.types[5] = [["prefix", "base"], ["base", "suffix"]]
	dict.syllable.types[7] = [["prefix", "base", "suffix"]]
	
	dict.syllable.couples = []
	
	for _i in dict.rune.parity.keys().size():
		var _j = (_i + 1) % dict.rune.parity.keys().size()
		var firsts = dict.rune.parity[dict.rune.parity.keys()[_j]]
		var seconds = dict.rune.parity[dict.rune.parity.keys()[_i]]
		
		for second in seconds:
			for first in firsts:
				var couple = [first, second]
				dict.syllable.couples.append(couple)
	
	dict.syllable.index = {}
	dict.syllable.parities = {}
	dict.syllable.extremes = {}
	dict.syllable.phases = {}
	
	
	var path = "res://asset/json/waiata_syllable.json"
	var array = load_data(path)
	
	for syllable in array:
		var data = {}
		data.runes = []
		data.tags = []
		
		for key in syllable:
			syllable.index = int(syllable.index)
			
			if key != "index":
				var words = key.split(" ")
				
				if words.size() > 1:
					data.runes.append(syllable[key])
				else:
					data.tags.append(syllable[key])
		
		if !dict.syllable.parities.has(syllable.parity):
			dict.syllable.parities[syllable.parity] = []
		
		if syllable.has("syllable"):
			if !dict.syllable.extremes.has(syllable.extreme):
				dict.syllable.extremes[syllable.extreme] = []
				dict.syllable.extremes[syllable.extreme].append(syllable.index)
		
		if syllable.has("syllable"):
			if !dict.syllable.phases.has(syllable.phase):
				dict.syllable.phases[syllable.phase] = []
				dict.syllable.phases[syllable.phase].append(syllable.index)
		
		dict.syllable.index[syllable.index] = data
		dict.syllable.parities[syllable.parity].append(syllable.index)


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.poet = load("res://scene/1/poet.tscn")
	
	scene.song = load("res://scene/2/song.tscn")
	scene.arrangement = load("res://scene/2/arrangement.tscn")
	scene.segment = load("res://scene/2/segment.tscn")
	scene.word = load("res://scene/2/word.tscn")
	scene.syllable = load("res://scene/2/syllable.tscn")
	scene.rune = load("res://scene/2/rune.tscn")
	
	scene.lectern = load("res://scene/3/lectern.tscn")
	scene.token = load("res://scene/3/token.tscn")


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(48, 48)
	vec.size.number = Vector2(5, 32)
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.aspect = Vector2(32, 32)
	vec.size.box = Vector2(100, 100)
	vec.size.bar = Vector2(120, 12)
	
	vec.size.rune = Vector2(16, 16)
	vec.size.token = Vector2(16, 16)
	vec.size.state = Vector2(128, 16)
	#vec.size.token = Vector2(8, 8)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.token = {}
	color.token.slur = Color.from_hsv(0 / h, 0.9, 0.6)
	color.token.rapture = Color.from_hsv(210 / h, 0.9, 0.6)
	
	color.state = {}
	color.state.vigor = {}
	color.state.vigor.fill = Color.from_hsv(120 / h, 1, 0.9)
	color.state.vigor.background = Color.from_hsv(120 / h, 0.25, 0.9)
	color.state.standard = {}
	color.state.standard.fill = Color.from_hsv(30 / h, 1, 0.9)
	color.state.standard.background = Color.from_hsv(30 / h, 0.25, 0.9)
	color.state.fatigue = {}
	color.state.fatigue.fill = Color.from_hsv(0, 1, 0.9)
	color.state.fatigue.background = Color.from_hsv(0, 0.25, 0.9)


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
