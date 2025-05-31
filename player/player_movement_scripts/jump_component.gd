class_name JumpComponent
extends MovementComponent


const JUMP_VELOCITY : float = -500.0
const JUMP_DEACCELERATION : float = -400.0
const JUMP_BUFFER_TIME : float = 0.15
const COYOTE_TIME : float = 0.15
const POUNCE_STRENGTH : Vector2 = Vector2(850.0,-270.0)
# jump buffer
var is_jump_buffered : bool = false
var time_since_jump_buffered : float = 0.0
# coyote time
var is_coyote_timed : bool = false
var time_since_leaving_ground : float = 0.0
var was_on_floor : bool = false
var just_left_floor : bool = false
# pounce
var has_jumped : bool = false
var is_jumping : bool = false
var charge_rate : float = 100.0 # percentage per second
var charge_amount : float = 0.0 # percentage


func action(player: CharacterBody2D, delta: float) -> void:
	# Handle jump.
	jump(player, delta)
	jump_charge(player, delta)


func jump(player: CharacterBody2D, delta: float) -> void:
	if jump_buffer(player, delta) or coyote_time(player, delta):
		is_jumping = true
		has_jumped = true
		player.velocity.y = JUMP_VELOCITY * final_jump_height_multiplier
	if player.velocity.y >= 0.0 or player.is_on_ceiling():
		is_jumping = false
	if not Input.is_action_pressed("jump") and is_jumping:
		is_jumping = false
		player.velocity.y *= 0.5


func jump_buffer(player: CharacterBody2D, delta: float) -> bool:
	if Input.is_action_just_pressed("jump"):
		is_jump_buffered = true
		time_since_jump_buffered = 0.0
	if is_jump_buffered:
		time_since_jump_buffered += delta
		if time_since_jump_buffered >= JUMP_BUFFER_TIME:
			is_jump_buffered = false
		elif player.is_on_floor():
			return true
	return false


func coyote_time(player: CharacterBody2D, delta: float) -> bool:
	if player.is_on_floor():
		has_jumped = false
		was_on_floor = true
		just_left_floor = false
	# does not activate coyote time if the
	# thing that caused the player to leave
	# the floor was a jump
	elif was_on_floor and not has_jumped:
		was_on_floor = false
		just_left_floor = true
	else:
		just_left_floor = false
	if just_left_floor:
		is_coyote_timed = true
		time_since_leaving_ground = 0.0
	if is_coyote_timed:
		time_since_leaving_ground += delta
		if time_since_leaving_ground >= COYOTE_TIME:
			is_coyote_timed = false
		elif Input.is_action_just_pressed("jump"):
			return true
	return false


func jump_charge(player: CharacterBody2D, delta: float) -> void:
	$Display.text = "Jump charge: " + str(snappedf(charge_amount, 1.0)) + "%"
	if Input.is_action_pressed("charge_jump") and player.is_on_floor():
		if charge_amount < 100.0:
			charge_amount += charge_rate * delta
			charge_amount = clamp(charge_amount, 0.0, 100.0)
	else:
		charge_amount = 0.0
	
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if charge_amount > 20.0:
			player.velocity = POUNCE_STRENGTH * Vector2(direction, 1.0) * (charge_amount / 100.0)
			has_jumped = true
			charge_amount = 0.0
		else:
			charge_amount = 0.0
