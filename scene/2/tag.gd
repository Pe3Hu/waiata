extends MarginContainer


@onready var bg = $BG
@onready var title = $Title
@onready var stack = $Stack

var syllable = null
var type = null
var value = null


func set_attributes(input_: Dictionary) -> void:
	syllable = input_.syllable
	type = input_.type
	value = input_.value
	
	init_icons()


func init_icons() -> void:
	var input = {}
	input.type = "tag"
	input.subtype = type
	title.set_attributes(input)
	title.custom_minimum_size = Vector2(Global.vec.size.token)
	
	#input = {}
	#input.type = "number"
	#input.subtype = value
	#stack.set_attributes(input)
	custom_minimum_size = Vector2(Global.vec.size.token)
	#stack.custom_minimum_size = Vector2(Global.vec.size.sixteen)

	#title.set("theme_override_constants/margin_left", 4)
	#title.set("theme_override_constants/margin_top", 4)
	#custom_minimum_size = title.custom_minimum_size + stack.custom_minimum_size * 0.4

