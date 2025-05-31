class_name WalkComponent
extends MovementComponent


const MAX_SPEED : float = 300.0 # px/s
const MAX_AIR_TIME : float = 0.6 # seconds
var acceleration : float = 2500.0 # px/s^2
var deceleration : float = 4000.0 # px/s^2
var air_resistance : float = 700.0 # px/s^2
var air_time : float = 0.0 # seconds
var was_on_floor : bool = false
var just_left_floor : bool = false
# i actually made up all the measurement units


func action(player: CharacterBody2D, delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	var _has_air_control := has_air_control(player, delta)
	if direction:
		if player.is_on_floor() or _has_air_control:
			if abs(player.velocity.x) < MAX_SPEED * final_speed_multiplier:
				player.velocity.x += direction * acceleration * delta
	
	# apply deceleration
	elif player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0.0, deceleration * delta)
	
	# air resistance
	player.velocity.x = move_toward(player.velocity.x, 0.0, air_resistance * delta)


func has_air_control(player: CharacterBody2D, delta: float) -> bool:
	if player.is_on_floor():
		was_on_floor = true
		just_left_floor = false
		air_time = 0.0
	elif was_on_floor:
		was_on_floor = false
		just_left_floor = true
	if just_left_floor:
		if air_time < MAX_AIR_TIME:
			air_time += delta
			return true
		return false
	else:
		return true
