extends StaticBody2D

signal obstacle_collision

func _on_ObstacleArea2D_area_entered(_area):
	emit_signal("obstacle_collision")
