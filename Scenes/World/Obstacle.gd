extends StaticBody2D

signal obstacle_collision

func _on_ObstacleArea2D_area_entered(area):
	emit_signal("obstacle_collision")
