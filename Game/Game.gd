extends Node

export (NodePath) var game_manager_path;
onready var gameManager = get_node(game_manager_path)

func _ready():
	print("Game ready!")
	connect_nodes()

func connect_nodes():
	for obstacle in get_tree().get_nodes_in_group("Obstacle"):
		obstacle.connect("obstacle_collision", gameManager, "_on_obstacle_collision")
