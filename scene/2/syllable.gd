extends MarginContainer


@onready var runes = $Runes

var word = null
var type = null
var couple = null
var tag = null


func set_attributes(input_: Dictionary) -> void:
	word = input_.word
	type = input_.type
	
	init_runes()


func init_runes() -> void:
	runes.set("theme_override_constants/separation", Global.num.gap.rune)
	
	couple = Global.dict.syllable.couples.pick_random()
	var index = Global.dict.syllable.couples.find(couple)
	var tags = Global.dict.syllable.index[index].tags
	
	match type:
		"base":
			tag = tags.front()
		"prefix":
			for _tag in Global.arr.extreme:
				if tags.has(_tag):
					tag = _tag
					break
		"suffix":
			for _tag in Global.arr.phase:
				if tags.has(_tag):
					tag = _tag
					break
	
	if tag != null:
		var input = {}
		input.syllable = self
		input.type = Global.dict.tag.syllable[tag]
		input.value = 1
		
		var _tag = Global.scene.tag.instantiate()
		word.tags.add_child(_tag)
		_tag.set_attributes(input)
	
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

