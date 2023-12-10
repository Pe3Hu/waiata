extends MarginContainer


@onready var tokens = $Tokens

var staff = null


func set_attributes(input_: Dictionary) -> void:
	staff = input_.staff
