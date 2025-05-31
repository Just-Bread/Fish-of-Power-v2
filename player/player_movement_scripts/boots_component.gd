class_name BootsComponent
extends MovementComponent


var max_speed : float = -200.0
var wall_jump_strength : Vector2 = Vector2(500.0, -400.0)
var acceleration : float = 2000.0
var wall_climb_distance : float = 200.0 # pixels
var starting_height : float = 0.0
var sticky_time : float = 1.0 # seconds
var time_since_last_climb : float = 0.0 # seconds
var slide_time : float = 0.3 # seconds
var time_since_last_slide : float = 0.0 # seconds
var is_sliding : bool = false
var was_on_wall : bool = false
var is_stop_on_wall : bool = false


func _init() -> void:
	super()
	type = Type.WEARABLE


func action(player: CharacterBody2D, delta: float) -> void:
	climb_wall(player, delta)


func climb_wall(player: CharacterBody2D, delta: float) -> void:
	if player.is_on_wall() and player.is_on_floor():
		# move the player up so that the player
		# stops detecting the floor
		player.velocity.y = -1.0
	if is_climbing(player, delta) and not is_sliding:
		var direction = Input.get_axis("move_left","move_right")
		var wall_direction = snappedf(player.get_wall_normal().x, 1.0)
		# apply a constant force towards the wall
		# so that the player detects wall collision
		player.velocity.x += -1.0 * wall_direction
		# -wall_direction because is_on_wall() returns 1 if
		# on right wall and -1 if on left wall
		var not_reached_max_distance : bool = abs(player.global_position.y - starting_height) < wall_climb_distance
		if direction and not is_stop_on_wall:
			player.velocity.y = 0.0
		if direction == -wall_direction and not_reached_max_distance:
			is_stop_on_wall = true
			player.velocity.y = move_toward(player.velocity.y, max_speed, acceleration * delta)
		elif is_stop_on_wall:
			player.velocity.y = 0.0
			
		if player.velocity.y == 0.0:
			time_since_last_climb += delta
		if time_since_last_climb >= sticky_time:
			is_sliding = true
			time_since_last_climb = 0.0
			
		# wall jump
		if direction == wall_direction or Input.is_action_just_pressed("jump"):
			player.velocity = wall_jump_strength * Vector2(wall_direction, 1.0)
		# change starting height if the player slides down too far
		if player.global_position.y > starting_height:
			starting_height = player.global_position.y
	elif is_sliding:
		is_stop_on_wall = false
		time_since_last_slide += delta
		if time_since_last_slide >= slide_time:
			is_sliding = false
			time_since_last_slide = 0.0


func has_just_touched_wall(player: CharacterBody2D, delta: float) -> bool:
	if player.is_on_wall():
		if not was_on_wall:
			was_on_wall = true
			return true
	else:
		was_on_wall = false
	
	return false


func is_climbing(player: CharacterBody2D, delta: float) -> bool:
	if has_just_touched_wall(player, delta):
		player.velocity.y = 0.0
		starting_height = player.global_position.y
		return true
	if player.is_on_wall_only():
		return true
	return false
