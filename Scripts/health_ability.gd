class_name HealthAbility
extends Node2D

const MovementState = PlayerController.MovementState
const PlayerState = PlayerController.PlayerState

export var health: int = 4
export var stun_speed: float = 100
export var stun_duration: float = 0.5
export var invicibility_duration: float = 1.0

var player_controller: PlayerController
var hitbox: Area2D

var _is_processing_hit: bool = false
var _time_since_hit: float = 0.0
var _knockback_direction: Vector2 = Vector2.ZERO


func _ability_ready(controller):
	player_controller = controller
	hitbox = get_parent().get_node("Hitbox")
	hitbox.connect("area_entered", self, "_on_hitbox_entered")


func _ability_process(delta):
	if _is_processing_hit:
		_time_since_hit += delta

		if player_controller.movement_state.state == MovementState.STUNNED:
			player_controller.velocity = _knockback_direction * stun_speed
			if _time_since_hit >= stun_duration:
				player_controller.movement_state.state = player_controller.movement_state.previous_state
				print("Returned")

		if player_controller.player_state.state == PlayerState.INVINCIBLE:
			if _time_since_hit >= invicibility_duration:
				player_controller.player_state.state = player_controller.player_state.previous_state
		
		if _time_since_hit > stun_duration and _time_since_hit > invicibility_duration:
			_is_processing_hit = false


func _on_hitbox_entered(other: Area2D):
	health -= 1
	if health <= 0:
		print("Player death")
	else:
		print("Stun")
		_is_processing_hit = true
		_time_since_hit = 0.0
		_knockback_direction = (global_position - other.global_position).normalized()

		player_controller.direction = _knockback_direction
		player_controller.velocity = _knockback_direction * stun_speed
		player_controller.movement_state.state = MovementState.STUNNED
		player_controller.player_state.state = PlayerState.INVINCIBLE
