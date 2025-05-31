class_name MovementComponent
extends Node2D


enum Type {NONE, HANDHELD, WEARABLE, BOTH}
@export var type := Type.NONE
@export_group("Multiplier")
@export var speed_multiplier : float = 1.0
@export var jump_height_multiplier : float = 1.0
var final_speed_multiplier : float = 1.0
var final_jump_height_multiplier : float = 1.0


func _init() -> void:
	self.tree_exited.connect(remove)


func get_speed_multiplier() -> float:
	return speed_multiplier


func get_jump_height_multiplier() -> float:
	return jump_height_multiplier


func set_final_speed_multiplier(multiplier: float) -> void:
	final_speed_multiplier = multiplier


func set_final_jump_height_multiplier(multiplier: float) -> void:
	final_jump_height_multiplier = multiplier


func action(player: CharacterBody2D, delta: float) -> void:
	pass


# Probably deprecared
func remove() -> void:
	#SignalBus.player_movement_component_added.emit()
	pass
