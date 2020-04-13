extends Node

signal restart

func _process(delta):
	get_input()

func _on_obstacle_collision():
	print("Obstacle collision")
	get_tree().paused = true

func get_input():
	var restart = Input.is_action_just_pressed("Restart")

	if restart:
		print("Restart")
		emit_signal("restart")
		get_tree().paused = false
