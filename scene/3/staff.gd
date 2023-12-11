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
	var tag = word_.get_syllabe_based_on_type("base").tag
	var type = Global.dict.tag.syllable[tag]
	var input = {}
	input.space = get(type+"s")
	input.type = type
	input.subtype = "standard"
	input.value = word_.length
	
	word_.token = Global.scene.token.instantiate()
	input.space.tokens.add_child(word_.token)
	word_.token.set_attributes(input)


func use_tags() -> void:
	for segment in poet.song.segments.get_children():
		for word in segment.words.get_children():
			var syllable = word.get_syllabe_based_on_type("base")
			var type = Global.dict.tag.syllable[syllable.tag]
			var space = get(type+"s")
			
			for tag in word.tags.get_children():
				match tag.type:
					"slur":
						word.token.stack.change_number(2)
					"rapture":
						word.token.stack.change_number(3)
					"current":
						word.token.stack.change_number(4)
					"next":
						var index = word.token.get_index() + 1
						
						if index < space.tokens.get_child_count():
							var next = space.tokens.get_child(index)
							next.stack.change_number(5)
					"first":
						var first = space.tokens.get_child(0)
						first.stack.change_number(9)
					"last":
						var last = space.tokens.get_child(space.tokens.get_child_count()-1)
						last.stack.change_number(11)


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
