extends Node2D

signal movement_input(direction)


func _process(_delta):
	check_for_movement_input()


func check_for_movement_input():
	var movement_input := Vector2()
	if Input.is_action_pressed("move_left"):
		movement_input.x -= Input.get_action_strength("move_left")
	if Input.is_action_pressed("move_right"):
		movement_input.x += Input.get_action_strength("move_right")
	if Input.is_action_pressed("move_down"):
		movement_input.y += Input.get_action_strength("move_down")
	if Input.is_action_pressed("move_up"):
		movement_input.y -= Input.get_action_strength("move_up")
	
	if movement_input != Vector2.ZERO:
		emit_signal("movement_input", movement_input.normalized())
