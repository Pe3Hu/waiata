extends MarginContainer


@onready var song = $Song

var cradle = null


func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	init_song()


func init_song() -> void:
	var input = {}
	input.poet = self
	song.set_attributes(input)
