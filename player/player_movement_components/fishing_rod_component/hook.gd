extends RigidBody2D


signal is_pulled

@export var strength := 800
@export var max_distance := 600
var player : CharacterBody2D
#@export var camera : Camera2D
var loaded : bool = true
var can_throw : bool = true
var has_air_movement : bool = false
var _delta : float
var is_frozen : bool = false


func _process(delta: float) -> void:
	$Label.text = "time left: " + str(snappedf($ReloadTimer.time_left, 0.01))
	
	if has_air_movement:
		var direction := Input.get_axis("move_left", "move_right")
		if direction:
			if abs(player.velocity.x) < WalkComponent.MAX_SPEED:
				player.velocity.x += direction * WalkComponent.ACCELERATION * delta


func _physics_process(delta: float) -> void:
	_delta = delta
	
	if can_throw:
		if Input.is_action_just_pressed("left_click"):
			set_collision_mask_value(2, true)
			#camera.target = self
			freeze = false
			can_throw = false
			loaded = false
			var direction := (get_global_mouse_position() - global_position).normalized()
			apply_central_impulse(strength * direction)


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if freeze:
		set_collision_mask_value(2, false)
		#camera.target = player
		state.transform = Transform2D.IDENTITY.translated(global_position.move_toward(player.global_position, 2000 * _delta))
		state.linear_velocity = Vector2.ZERO
		if (global_position - (player.global_position)).length() <= 60 and not loaded:
			loaded = true
			$ReloadTimer.start()
	elif state.get_contact_count() > 0:
			has_air_movement = true
			$AirTimeTimer.start()
			#camera.target = player
		#if state.get_contact_local_normal(0) == Vector2.UP:
			var direction := (global_position - player.global_position).normalized()
			player.velocity += 700 * direction
			freeze = true
			is_pulled.emit()
		#else:
		#	freeze_body(true)
	elif Input.is_action_just_pressed("left_click") or reached_max_distance():
		#camera.target = player
		freeze = true
		is_pulled.emit()


func reached_max_distance() -> bool:
	var distance := (global_position - player.global_position).length()
	
	if distance >= max_distance:
		freeze = true
		return true
	else:
		return false


func _on_air_time_timer_timeout() -> void:
	has_air_movement = false


func _on_reload_timer_timeout() -> void:
	can_throw = true
