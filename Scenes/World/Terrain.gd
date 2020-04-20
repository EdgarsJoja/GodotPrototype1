extends Node

export (PackedScene) var ground_scene
export (PackedScene) var obstacle_scene

# Node to which obstacles will be added as a children
export (NodePath) var obstacles_container_path
onready var obstacles_container = get_node(obstacles_container_path)

# Object, to which ground should be relative to (player)
export (NodePath) var target_path
onready var target = get_node(target_path)

# Object, which will handle obstacle collision logic
export (NodePath) var obstacle_collision_handler_path
onready var obstacle_collision_handler = get_node(
	obstacle_collision_handler_path
)

# How many ground blocks will be allocated
export (int) var ground_pool_size = 50
# Y position for ground blocks
export (float) var ground_level = 16
# Single block width in pixels @todo: Calculate this automatically
export (int) var ground_block_width_px = 48
# Maximum distance between player and ground block if it's visible
export (float) var max_block_render_distance = 1000
# How many obstacles will be allocated
export (int) var obstacles_pool_size = 10
# Maximum distance player can run without encountering obstacle
export (float) var max_obstacles_distance = 500
# Maximum distance between 2 obstacles
export (float) var min_obstacles_distance = 100
# How high should obstacles be placed above ground level
export (float) var obstacle_ground_level = 24
# Maximum distance between player and obstacle if it's visible
export (float) var max_obstacle_render_distance = 1000

# Total count of blocks that have been generated
var next_block_index = 1
# Position of last placed obstacle
var last_obstacle_position = Vector2()

# Pools for objects
var ground_pool: Array = []
var obstacles_pool: Array = []

var random = RandomNumberGenerator.new()

# Called once initially
func _ready():
	# Fill pools with object instances, so they can be quickly accessed
	for _i in range(ground_pool_size):
		ground_pool.append(ground_scene.instance())

	for _i in range(obstacles_pool_size):
		var obstacle = obstacle_scene.instance()
		obstacle.connect(
			"obstacle_collision",
			obstacle_collision_handler,
			"handle_obstacle_collision"
		)

		obstacles_pool.append(obstacle)

	reset_terrain()

# Reset terrain data (ground, obstacles)
func reset_terrain():
	next_block_index = 1
	last_obstacle_position = target.global_position

	# Generate initial ground blocks
	generate_ground()
	# Generate initial obstacles
	generate_obstacles()

# Called every frame
func _process(_delta):
	update_ground()
	update_obstacles()

# Generates and positions all ground pool blocks
func generate_ground():
	for block in ground_pool:
		render_next_block(block)

# Check if player has moved forward,
# and if so take blocks from back and position in front
func update_ground():
	var first_block = ground_pool.front()

	if get_target_distance_from_object(first_block) > max_block_render_distance:
		render_next_block(first_block)
		ground_pool.push_back(ground_pool.pop_front())

# Calculates and renders block for next available position in front of player
func render_next_block(block):
	var next_x_position = (next_block_index - 1) * ground_block_width_px
	var block_position = Vector2(next_x_position, ground_level)
	block.position = block_position

	next_block_index += 1
	if block.get_parent() == null:
		get_parent().call_deferred("add_child", block)

# Calculates absolute distance between specific block and player
func get_target_distance_from_object(object):
	return (target.global_position - object.global_position).abs().x

# Generates and positions all initial obstacles
func generate_obstacles():
	for obstacle in obstacles_pool:
		render_next_obstacle(obstacle)

# Check if obstacles can be generated in front of player and do so if can
func update_obstacles():
	var first_obstacle = obstacles_pool.front()

	if (get_target_distance_from_object(first_obstacle) > max_obstacle_render_distance &&
		first_obstacle.position.x < target.position.x):
		render_next_obstacle(first_obstacle)
		obstacles_pool.push_back(obstacles_pool.pop_front())

# Renders next obstacle
func render_next_obstacle(obstacle):
	var min_distance = last_obstacle_position.x + min_obstacles_distance
	var max_distance = last_obstacle_position.x + max_obstacles_distance

	random.randomize()
	var distance = random.randf_range(min_distance, max_distance)
	obstacle.position = Vector2(distance, -obstacle_ground_level)

	if obstacle.get_parent() == null:
		get_parent().call_deferred("add_child", obstacle)

	last_obstacle_position = obstacle.position

# When game is restarted
func _on_GameManager_restart():
	reset_terrain()
