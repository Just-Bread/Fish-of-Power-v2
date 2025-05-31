class_name UmbrellaComponent
extends MovementComponent


const MAX_AIR_SPEED : float = 300.0
var acceleration : float = 1000.0
var drag : float = 0.12
var is_opened : bool = false


func _init() -> void:
	super()
	type = Type.HANDHELD
	speed_multiplier = 1.0


func action(player: CharacterBody2D, delta: float) -> void:
	if Input.is_action_just_pressed("use_set"):
		is_opened = not is_opened
	
	air_movement(player, delta)
	
	if is_opened:
		if player.velocity.y >= 0:
			player.velocity.y -= drag * player.velocity.y * player.velocity.y * delta
		else:
			player.velocity.y += drag * player.velocity.y * player.velocity.y * delta


func air_movement(player: CharacterBody2D, delta: float) -> void:
	if not player.is_on_floor() and is_opened:
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			if abs(player.velocity.x) < MAX_AIR_SPEED:
				player.velocity.x += direction * acceleration * delta
