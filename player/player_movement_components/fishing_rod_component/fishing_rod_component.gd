class_name FishingRodComponent
extends MovementComponent


var old_distance : float


func _init() -> void:
	super()
	type = Type.HANDHELD


func _ready() -> void:
	$Rope.set_all_nodes(global_position)
	$Node/Hook.global_position = global_position


func action(player: CharacterBody2D, delta: float) -> void:
	$Node/Hook.player = player
	
	var distance : float = ($Node/Hook.global_position - player.global_position).length()
	if distance >= old_distance:
		$Rope.length = distance
	else:
		$Rope.length = move_toward($Rope.length, distance, delta * 1500)
	old_distance = distance
	if $Rope.length <= 10:
		$Rope.active = false
	else:
		$Rope.active = true
	
	$Rope.set_start_position(player.global_position)
	$Rope.set_end_position($Node/Hook.global_position)
