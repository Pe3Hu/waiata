extends MarginContainer


@onready var song = $VBox/Song
@onready var staff = $VBox/Staff
@onready var health = $VBox/Health

var cradle = null
var index = null


func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	index = int(Global.num.index.poet)
	Global.num.index.poet += 1
	
	set_nodes()
	staff.use_tags()
	#staff.spaces_overlay()


func set_nodes() -> void:
	var input = {}
	input.poet = self
	input.limits = {}
	input.limits.vigor = 0.25
	input.limits.standard = 0.5
	input.limits.fatigue = 0.25
	input.total = 100
	health.set_attributes(input)
	
	staff.set_attributes(input)
	song.set_attributes(input)
