class_name Rope
extends Node


@export var number_of_nodes : int = 10:
	set = set_number_of_nodes
@export var length : float = 200.0:
	set = set_length
@export var iterations : int = 5
@export var renderer : RopeRenderer
@export var active : bool = true
@export var straight : bool = false:
	set = set_straight
var nodes : Array[RopeNode]
var start : RopeNode
var end : RopeNode

var updated_start_position : bool = false
var updated_end_position : bool = false
var new_start_position : Vector2
var new_end_position : Vector2


func _init() -> void:
	for i in number_of_nodes + 2: # needs at least 2 nodes as the start and end of the rope
		var rope_node := RopeNode.new()
		nodes.append(rope_node)
		add_child(rope_node)
	
	set_length(length)
	
	start = nodes[0]
	end = nodes[-1]
	
	if not renderer:
		renderer = RopeRenderer.new()
		add_child(renderer)
	renderer.update_rope(nodes)


func _process(delta: float) -> void:
	for node in nodes:
		node.update_position(delta)
	
	if updated_start_position:
		updated_start_position = false
		start.global_position = new_start_position
	if updated_end_position:
		updated_end_position = false
		end.global_position = new_end_position
	
	if not active:
		renderer.clear_points()
	else:
		if not straight:
			renderer.draw_rope(nodes)
		else:
			renderer.draw_rope([start, end])
	
	for i in iterations:
		for node in nodes:
			node.constraint()


func set_length(_length : float) -> void:
	length = _length
	for i in number_of_nodes + 1:
		nodes[i].next_node = nodes[i + 1]
		nodes[i].max_distance = length / (number_of_nodes + 2)


func set_number_of_nodes(number : int) -> void:
	if number < 0:
		number = 0
	var difference := number - number_of_nodes
	number_of_nodes = number
	if difference == 0:
		return
	elif difference < 0:
		for i in range(abs(difference)):
			nodes.pop_back().queue_free()
	elif difference > 0:
		for i in range(difference):
			var rope_node := RopeNode.new()
			rope_node.starting_position = start.global_position
			nodes.append(rope_node)
			add_child(rope_node)

	set_length(length)
	end = nodes[-1]
	renderer.update_rope(nodes)


func set_straight(value) -> void:
	if value:
		renderer.update_rope([start,end])
	else:
		renderer.update_rope(nodes)
	straight = value


func _on_hook_is_pulled() -> void:
	straight = true
	await get_tree().create_timer(0.07).timeout
	straight = false


func set_start_position(position : Vector2) -> void:
	new_start_position = position
	updated_start_position = true


func set_end_position(position : Vector2) -> void:
	new_end_position = position
	updated_end_position = true


func set_all_nodes(position : Vector2) -> void:
	for node in nodes:
		node.set_new_position(position)
