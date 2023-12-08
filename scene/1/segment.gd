extends MarginContainer


@onready var words = $Words

var song = null
var title = null


func set_attributes(input_: Dictionary) -> void:
	song = input_.song
	title = input_.title
	
	init_words()


func init_words() -> void:
	var runes = Global.dict.segment.title[title].combinations[0]
	var index = Global.dict.combination.runes[runes][0]
	var description = Global.dict.combination.index[index]
	
	for length in description.length:
		for _i in description.length[length]:
			var input = {}
			input.segment = self
			input.length = length

			var word = Global.scene.word.instantiate()
			words.add_child(word)
			word.set_attributes(input)
