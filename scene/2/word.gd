extends MarginContainer


@onready var syllables = $VBox/Syllables
@onready var tags = $VBox/Tags

var segment = null
var length = null
var token = null


func set_attributes(input_: Dictionary) -> void:
	segment = input_.segment
	length = input_.length
	
	init_syllables()


func init_syllables() -> void:
	syllables.set("theme_override_constants/separation", Global.num.gap.syllable)
	var options = Global.dict.syllable.types[length]
	var option = options.pick_random()
	
	for type in option:
		var input = {}
		input.word = self
		input.type = type

		var syllable = Global.scene.syllable.instantiate()
		syllables.add_child(syllable)
		syllable.set_attributes(input)
		finality_check()


func finality_check() -> void:
	var l = 0
	
	for syllable in syllables.get_children():
		l += syllable.runes.get_child_count()
	
	if l == length:
		segment.song.poet.staff.write_word(self)


func get_syllabe_based_on_type(type_: String) -> Variant:
	for syllable in syllables.get_children():
		if syllable.type == type_:
			return syllable
	
	return null

