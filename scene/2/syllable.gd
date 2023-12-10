extends MarginContainer


@onready var runes = $Runes

var word = null
var type = null
var couple = null


func set_attributes(input_: Dictionary) -> void:
	word = input_.word
	type = input_.type
	
	init_runes()


func init_runes() -> void:
	runes.set("theme_override_constants/separation", Global.num.gap.rune)
	var length = 2
	
	match type:
		#"base":
			#length = 3
		"prefix":
			length = 2
		"suffix":
			length = 2
	
	couple = Global.dict.syllable.couples.pick_random()
	
	var titles = []
	titles.append_array(couple)
	
	if type == "base":
		titles.append(couple.front())
	
	for title in titles:
		var input = {}
		input.word = self
		input.title = title

		var rune = Global.scene.rune.instantiate()
		runes.add_child(rune)
		rune.set_attributes(input)
	
