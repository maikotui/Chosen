class_name StateMachine
extends Object
# Retains a given state and the previous one that was set. Also has a signal
# that is emitted when the state is changed. This signal provides a reference to
# the state machine that emitted the signal.

signal state_changed(state_machine)

var state:int setget set_state, get_state
var previous_state:int setget , get_previous_state


func set_state(value:int):
	if(state == null):
		state = value
		previous_state = value
	elif(state != value):
		previous_state = state
		state = value
		emit_signal("state_changed", self)


func get_state():
	return state


func get_previous_state():
	return previous_state
