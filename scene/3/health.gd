extends MarginContainer


@onready var vigor = $HBox/States/Vigor
@onready var standard = $HBox/States/Standard
@onready var fatigue = $HBox/States/Fatigue
@onready var marker = $HBox/Marker

var poet = null
var value = {}
var limits = {}
var state = null


func set_attributes(input_: Dictionary) -> void:
	poet = input_.poet
	limits = input_.limits
	
	value.total = int(input_.total)
	value.current = int(input_.total)
	init_states()
	
	var input = {}
	input.proprietor = self
	input.type = "poet"
	input.subtype = str(poet.index)
	input.value = poet.index
	marker.set_attributes(input)


func init_states() -> void:
	for type in Global.arr.state:
		var indicator = get(type)
		
		var input = {}
		input.health = self
		input.type = type
		input.max = limits[type] * value.total
		indicator.set_attributes(input)
	
	update_state()
	get_damage(0)


func update_state() -> void:
	for _state in Global.arr.state:
		var indicator = get(_state)
		
		if indicator.bar.value > 0:
			state = _state
			break


func get_damage(damage_: int) -> void:
	var indicator = get(state) 
	indicator.update_value("current", -damage_)
	update_state()


func reset() -> void:
	for _state in  Global.arr.state:
		var state = get(_state)
		state.reset()
