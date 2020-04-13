extends Node

func _on_obstacle_collision():
	print("Obstacle collision")
	get_tree().paused = true
