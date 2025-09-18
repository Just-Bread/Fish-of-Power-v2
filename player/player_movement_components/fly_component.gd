class_name FlyComponent
extends MovementComponent


func _init() -> void:
	super()
	jump_height_multiplier = 1.5


func action(player: CharacterBody2D, delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		player.velocity.y = -300.0
