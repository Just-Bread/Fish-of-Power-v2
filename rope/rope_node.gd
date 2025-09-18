class_name RopeNode
extends Node2D


var max_distance : float = 100
var next_node : RopeNode
var old_position : Vector2
var position_copy : Vector2
var acceleration := Vector2(0, 980)
var starting_position := Vector2(0,0)


func _ready() -> void:
	global_position = starting_position
	old_position = starting_position
	
	#var sprite = Sprite2D.new()
	#sprite.texture = load("res://assets/ball.png")
	#sprite.scale = Vector2(0.5, 0.5)
	#add_child(sprite)


func update_position(delta: float) -> void:
	position_copy = global_position
	global_position = 2 * global_position - old_position + delta * delta * (acceleration)
	old_position = position_copy


func constraint() -> void:
	if next_node == null:
		return
	var distance := next_node.global_position - global_position
	var direction := distance.normalized()
	if distance.length() > max_distance:
		global_position += direction * ((distance.length() - max_distance) / 2)
		next_node.global_position -= direction * ((distance.length() - max_distance) / 2)


# changes position without touching physics
func set_new_position(new_position : Vector2) -> void:
	global_position = new_position
	old_position = new_position
