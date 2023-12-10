extends MarginContainer


@onready var bg = $BG

var word = null
var title = null


func set_attributes(input_: Dictionary) -> void:
	word = input_.word
	title = input_.title
	
	custom_minimum_size = Vector2(Global.vec.size.rune)
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	style.bg_color = Global.color.rune[title]
