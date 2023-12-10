extends MarginContainer


@onready var syllables = $Syllables

var segment = null
var length = null


func set_attributes(input_: Dictionary) -> void:
	segment = input_.segment
	length = input_.length
	
	init_syllables()


func init_syllables() -> void:
	var options = Global.dict.syllable.types[length]
	var option = options.front()
	
	for type in option:
		var input = {}
		input.word = self
		input.type = type

		var syllable = Global.scene.syllable.instantiate()
		syllables.add_child(syllable)
		syllable.set_attributes(input)

