extends MarginContainer


@onready var words = $Words

var song = null
var callsign = null
var index = null
var title = null


func set_attributes(input_: Dictionary) -> void:
	song = input_.song
	callsign = input_.callsign
	
	init_words()


func init_words() -> void:
	var words = callsign.split(" ")
	title = words[0]
	index = 0
	
	if words.size() > 1:
		title = int(words[1])
	
	var e = Global.dict.segment.title[title]
	var runes = Global.dict.segment.title[title].combinations[0]
	var a = Global.dict.segment.title[title].combinations
	var b = Global.dict.combination.runes.keys()
	var c = typeof(runes) == TYPE_FLOAT
	var d = Global.dict.combination.runes.keys().has(runes)
	var _index = Global.dict.combination.runes[runes][0]
	var description = Global.dict.combination.index[_index]
	
	for length in description.length:
		for _i in description.length[length]:
			var input = {}
			input.segment = self
			input.length = length

			var word = Global.scene.word.instantiate()
			words.add_child(word)
			word.set_attributes(input)
