extends ItemList


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_activated(index: int) -> void:
	var movement_component
	var movement_component_instance
	match index:
		0:
			movement_component = load("uid://dnr6eko5lg4mk")
		1:
			movement_component = load("uid://cvy3tkp85hlxd")
		2:
			movement_component = load("uid://b2bnfn218lqap")
		3:
			SignalBus.player_movement_component_removed.emit(MovementComponent.Type.BOTH)
			self.deselect_all()
			return
		4:
			movement_component = load("uid://ctote75yxxfha")
	movement_component_instance = movement_component.instantiate()
	SignalBus.player_movement_component_added.emit(movement_component_instance)
	self.deselect_all()
