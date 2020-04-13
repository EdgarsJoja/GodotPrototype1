extends Node

export (NodePath) var spawn_position_path
onready var spawnPosition = get_node(spawn_position_path)

func respawn():
	get_parent().position = spawnPosition.position
