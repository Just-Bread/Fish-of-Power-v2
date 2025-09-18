class_name RopeRenderer
extends Line2D


var curve : Curve2D


func _init() -> void:
	curve = Curve2D.new()


func update_rope(nodes : Array[RopeNode]) -> void:
	curve.clear_points()
	for node in nodes:
		curve.add_point(node.global_position)


func draw_rope(nodes : Array[RopeNode]) -> void:
	for i in nodes.size():
		curve.set_point_position(i,nodes[i].global_position)
	
	for i in range(1, curve.point_count - 1):
		var direction : Vector2 = (curve.get_point_position(i + 1) - curve.get_point_position(i - 1)).normalized()
		var distance_to_previous : float = (curve.get_point_position(i - 1) - curve.get_point_position(i)).length()
		var distance_to_next : float = (curve.get_point_position(i + 1) - curve.get_point_position(i)).length()
		var control_distance1 = distance_to_previous * 0.4
		var control_distance2 = distance_to_next * 0.4
		
		curve.set_point_in(i, -direction * control_distance1)
		curve.set_point_out(i, direction * control_distance2)
	
	points = curve.tessellate()
