class_name GravityComponent
extends MovementComponent


const TERMINAL_VELOCITY: float = 500.0


func action(player: CharacterBody2D, delta: float) -> void:
	if not player.is_on_floor() and player.velocity.y <= TERMINAL_VELOCITY:
		player.velocity += player.get_gravity() * delta
