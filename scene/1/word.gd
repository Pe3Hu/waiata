extends MarginContainer


@onready var runes = $Runes

var segment = null
var length = null


func set_attributes(input_: Dictionary) -> void:
	segment = input_.segment
	length = input_.length
	
	init_runes()


func init_runes() -> void:
	var options = Global.dict.rune.title.keys()
	
	for _i in length:
		var input = {}
		input.word = self
		input.title = options[Global.num.index.rune % 8]
		Global.num.index.rune += 1

		var rune = Global.scene.rune.instantiate()
		runes.add_child(rune)
		rune.set_attributes(input)

