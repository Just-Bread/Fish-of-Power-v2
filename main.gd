extends Node


var cat = preload("res://player/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# TODO: centralized way to change scenes
# A node could request a changing of scene via
# a signal, for example
# The main class would handle the change without
# the node needing to know how to
# Also, make a general "Level" class to handle player
# loading and position
func change_scene(new_scene: Node2D) -> void:
	pass
