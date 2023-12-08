extends MarginContainer


@onready var segments = $Segments

var poet = null


func set_attributes(input_: Dictionary) -> void:
	poet = input_.poet
	
	init_segments()


func init_segments() -> void:
	var input = {}
	input.song = self
	input.title = "intro"

	var segment = Global.scene.segment.instantiate()
	segments.add_child(segment)
	segment.set_attributes(input)

	segment = Global.scene.segment.instantiate()
	segments.add_child(segment)
	segment.set_attributes(input)
