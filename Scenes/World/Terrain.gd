extends Node

export (PackedScene) var packed_ground_scene
onready var ground_scene = packed_ground_scene.instance()

export (NodePath) var target_path
onready var target = get_node(target_path)

export (int) var ground_pool_size = 50
export (float) var ground_level = 16
export (int) var ground_block_width_px = 48
export (float) var max_block_render_distance = 1000

var next_block_index = 1

var ground_pool: Array = []

func _ready():
	for _i in range(ground_pool_size):
		ground_pool.append(packed_ground_scene.instance())

	generate_ground()

func _process(_delta):
	update_ground()

func generate_ground():
	for block in ground_pool:
		render_next_block(block)

func update_ground():
	var first_block = ground_pool.front()

	if get_target_distance_from_block(first_block) > max_block_render_distance:
		render_next_block(first_block)
		ground_pool.push_back(ground_pool.pop_front())

func render_next_block(block, add_to_parent: bool = true):
	var next_x_position = (next_block_index - 1) * ground_block_width_px
	var block_position = Vector2(next_x_position, ground_level)
	block.position = block_position

	next_block_index += 1
	if block.get_parent() == null:
		get_parent().call_deferred("add_child", block)

func get_target_distance_from_block(block):
	return (target.global_position - block.global_position).abs().x

func _on_GameManager_restart():
	next_block_index = 1
	generate_ground()
