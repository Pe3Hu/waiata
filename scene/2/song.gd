extends MarginContainer


@onready var segments = $VBox/Segments
@onready var arrangement = $VBox/Arrangement

var poet = null


func set_attributes(input_: Dictionary) -> void:
	poet = input_.poet
	
	var input = {}
	input.song = self
	arrangement.set_attributes(input)
	init_segments()


func init_segments() -> void:
	segments.set("theme_override_constants/separation", Global.num.gap.segment)
	
	for callsign in arrangement.segments:
		var input = {}
		input.song = self
		input.callsign = callsign

		var segment = Global.scene.segment.instantiate()
		segments.add_child(segment)
		segment.set_attributes(input)
