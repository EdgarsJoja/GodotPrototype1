extends Area2D

func _on_ObstacleArea2D_area_entered(area):
	print("Collision with: " + area.name)
