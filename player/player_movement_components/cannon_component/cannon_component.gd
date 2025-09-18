class_name CannonComponent
extends MovementComponent


const PRIMARY_STRENGTH : float = 700.0
const SECONDARY_STRENGTH : float = 1300.0
var cursor : Node2D
var fuel : float = 100.0 # percentage
var fuel_consumption_rate : float = 95.0 # percentage per second
var refuel_rate : float = 65.0 # percentage per second
var time_until_refuel_starts : float = 0.5 # seconds
var time_since_last_use : float = 0.0 # seconds


func _init() -> void:
	super()
	type = Type.BOTH


func _ready() -> void:
	cursor = Marker2D.new()
	add_child(cursor)


func action(player: CharacterBody2D, delta: float) -> void:
	cursor.global_position = get_global_mouse_position()
	$Display.text = "Fuel: " + str(snappedf(fuel,1.0)) + "%"
	
	if Input.is_action_pressed("left_click"):
		strong_mode(player, delta)
	elif Input.is_action_pressed("right_click"):
		weak_mode(player, delta)
	
	refuel(delta)


func strong_mode(player: CharacterBody2D, delta: float) -> void:
	if fuel == 100.0:
		var direction : Vector2 = player.global_position - get_global_mouse_position()
		direction = direction / direction.length()
		player.velocity = direction * PRIMARY_STRENGTH
		
		# set fuel to 0 and starts refueling right away
		fuel = 0.0
		time_since_last_use = time_until_refuel_starts
	
	
func weak_mode(player: CharacterBody2D, delta: float) -> void:
	if fuel > 0:
		var direction : Vector2 = player.global_position - get_global_mouse_position()
		direction = direction / direction.length()
		player.velocity += direction * SECONDARY_STRENGTH * delta
		
		fuel -= fuel_consumption_rate * delta
		fuel = clamp(fuel, 0.0, 100.0)
		
	time_since_last_use = 0.0


func refuel(delta: float) -> void:
	if time_since_last_use < time_until_refuel_starts:
		time_since_last_use += delta
	elif fuel < 100.0:
		fuel += refuel_rate * delta
		fuel = clamp(fuel, 0.0, 100.0)
		
