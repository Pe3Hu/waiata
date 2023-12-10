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
	words.set("theme_override_constants/separation", Global.num.gap.word)
	var _words = callsign.split(" ")
	title = _words[0]
	index = 0
	
	if _words.size() > 1:
		index = int(_words[1])
	
	var runes = int(Global.dict.segment.title[title].combinations[0])
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
