extends MarginContainer


@onready var poets = $Poets

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_poets()


func init_poets() -> void:
	for _i in 1:
		var input = {}
		input.cradle = self
	
		var poet = Global.scene.poet.instantiate()
		poets.add_child(poet)
		poet.set_attributes(input)
