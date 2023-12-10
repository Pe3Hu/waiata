extends MarginContainer


@onready var raptures = $Spaces/Raptures
@onready var slurs = $Spaces/Slurs

var poet = null


func set_attributes(input_: Dictionary) -> void:
	poet = input_.poet
	
	init_spaces()


func init_spaces() -> void:
	var input = {}
	input.staff = self
	
	for token in Global.arr.token:
		var space = get(token+"s")
		space.set_attributes(input)


func write_word(word_: MarginContainer) -> void:
	var tokens = {}
	
	for token in Global.arr.token:
		tokens[token] = 0
	
	
	for syllable in word_.syllables.get_children():
		for rune in syllable.runes.get_children():
			var parity = Global.dict.rune.title[rune.title].parity
			var token = Global.dict.rune.token[parity]
			tokens[token] += 1
	
	for type in tokens:
		var input = {}
		input.space = get(type+"s")
		input.type = type
		input.subtype = "standard"
		input.value = tokens[type]
		
		var token = Global.scene.token.instantiate()
		input.space.tokens.add_child(token)
		token.set_attributes(input)


func spaces_overlay() -> void:
	while slurs.tokens.get_child_count() > 0:
		var slur = slurs.tokens.get_child(0)
		slurs.tokens.remove_child(slur)
		var rapture = null
		var value = slur.value
		
		if raptures.tokens.get_child_count() > 0:
			rapture = raptures.tokens.get_child(0)
			raptures.tokens.remove_child(rapture)
			value -= rapture.value
		
		if value > 0:
			poet.health.get_damage(value)
