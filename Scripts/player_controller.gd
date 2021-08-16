class_name PlayerController
extends KinematicBody2D

enum MovementState {
	IDLE = 0, 
	WALKING,
	ATTACKING,
}

const StateMachine = preload("res://Scripts/Utilities/state_machine.gd")

onready var anim_tree: AnimationTree = get_node("AnimationTree")
onready var anim_state_machine: AnimationNodeStateMachinePlayback = anim_tree["parameters/playback"]

export var speed: int = 200

var direction: Vector2 = Vector2()
var velocity: Vector2 = Vector2()
var movement_state: StateMachine
var movement_multiplier: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	movement_state = StateMachine.new()
	movement_state.state = MovementState.IDLE
	var _err = movement_state.connect("state_changed", self, "_on_movement_state_change")
	
	# Initialize any abilities
	for child in self.get_children():
		if child.has_method("_ability_ready"):
			child._ability_ready()


# Used for processing animations / non-physics processes
func _process(delta):
	# Process any abilities
	for child in self.get_children():
		if child.has_method("_ability_process"):
			child._ability_process(delta)
	
	# Update any animation parameters
	anim_tree['parameters/idle/blend_position'] = direction
	anim_tree['parameters/walking/blend_position'] = direction


# Used to process physics
func _physics_process(delta):
	if movement_state.state != MovementState.IDLE:
		velocity = move_and_slide(velocity, Vector2.ZERO)
		velocity = velocity.linear_interpolate(Vector2.ZERO, delta * 10)


func _on_movement_state_change(sm: StateMachine):
	anim_state_machine.travel(MovementState.keys()[sm.state].to_lower())
