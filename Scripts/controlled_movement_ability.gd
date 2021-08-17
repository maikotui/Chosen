class_name ControlledMovementAbility
extends Node2D

const MovementState = PlayerController.MovementState

export var speed: int = 200
export var idle_threshold: float = 0.1
export(Array, PlayerController.MovementState) var blocking_states: Array = [MovementState.STUNNED]

var player_controller: PlayerController

var can_move: bool 


func _ability_ready(controller):
	var _err = $"/root/InputManager".connect("movement_input",self,"_on_movement_input")
	
	player_controller = controller
	_err = player_controller.movement_state.connect("state_changed", self, "_on_state_changed")
	can_move = not blocking_states.has(player_controller.movement_state.state)

func _ability_process(_delta):
	# Check if we can return to a non-walking state
	if player_controller.movement_state.state == MovementState.WALKING:
		if player_controller.velocity.length() / speed <= idle_threshold:
			player_controller.movement_state.state = MovementState.IDLE

func _on_movement_input(direction: Vector2):
	if can_move:
		if player_controller.movement_state.state != MovementState.ATTACKING:
			player_controller.direction = direction.normalized()
			player_controller.movement_state.state = MovementState.WALKING
		player_controller.velocity = (direction * speed)
		


func _on_state_changed(state_machine: StateMachine):
	can_move = not blocking_states.has(state_machine.state)
