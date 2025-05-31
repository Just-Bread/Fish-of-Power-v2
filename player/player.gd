extends CharacterBody2D


var equipped_handheld : MovementComponent
var equipped_wearable : MovementComponent
var final_speed_multiplier : float = 1.0
var final_jump_height_multiplier : float = 1.0


func _ready() -> void:
	update_multiplier()
	SignalBus.player_movement_component_added.connect(add_movement_components)
	SignalBus.player_movement_component_removed.connect(remove_movement_components)


func _physics_process(delta: float) -> void:
	for i: MovementComponent in $MovementComponents.get_children():
		i.action(self, delta)
	move_and_slide()


func update_movement_components() -> void:
	update_multiplier()
	update_debug()


func update_multiplier() -> void:
	print("Multiplier Updated")
	final_speed_multiplier = 1.0
	final_jump_height_multiplier = 1.0
	for i : MovementComponent in $MovementComponents.get_children():
		final_speed_multiplier *= i.get_speed_multiplier()
		final_jump_height_multiplier *= i.get_jump_height_multiplier()
	print("speed multiplier: ", final_speed_multiplier)
	print("jump multiplier: ", final_jump_height_multiplier)
	for i : MovementComponent in $MovementComponents.get_children():
		i.set_final_speed_multiplier(final_speed_multiplier)
		i.set_final_jump_height_multiplier(final_jump_height_multiplier)


func add_movement_components(movement_component : MovementComponent) -> void:
	match movement_component.type:
		MovementComponent.Type.HANDHELD:
			remove_movement_components(MovementComponent.Type.HANDHELD)
			equipped_handheld = movement_component
		MovementComponent.Type.WEARABLE:
			remove_movement_components(MovementComponent.Type.WEARABLE)
			equipped_wearable = movement_component
		MovementComponent.Type.BOTH:
			remove_movement_components(MovementComponent.Type.BOTH)
			equipped_handheld = movement_component
			equipped_wearable = movement_component
	$MovementComponents.add_child(movement_component)
	update_movement_components()


func remove_movement_components(type: MovementComponent.Type) -> void:
	match type:
		MovementComponent.Type.HANDHELD:
			if equipped_handheld != null:
				$MovementComponents.remove_child(equipped_handheld)
				if equipped_wearable == equipped_handheld:
					equipped_wearable = null
			equipped_handheld = null
		MovementComponent.Type.WEARABLE:
			if equipped_wearable != null:
				$MovementComponents.remove_child(equipped_wearable)
				if equipped_handheld == equipped_wearable:
					equipped_handheld = null
			equipped_wearable = null
		MovementComponent.Type.BOTH:
			if equipped_handheld != null:
				$MovementComponents.remove_child(equipped_handheld)
			if equipped_wearable != null:
				if equipped_handheld != equipped_wearable:
					$MovementComponents.remove_child(equipped_wearable)
			equipped_handheld = null
			equipped_wearable = null
	update_movement_components()


func update_debug() -> void:
	$CanvasLayer/Label.text = "Equipped:\nHandheld: " + str(equipped_handheld) + "\nWearable: " + str(equipped_wearable)
