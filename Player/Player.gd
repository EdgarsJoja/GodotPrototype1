extends KinematicBody2D

export (NodePath) var spawn_path
onready var spawn = get_node(spawn_path)

export (NodePath) var animated_sprite_path
onready var animated_sprite = get_node(animated_sprite_path)

export (int) var jump_speed = -500
export (int) var run_speed = 300
export (int) var gravity = 1800

var velocity = Vector2()
var jumping = false

func get_input():
	var jump = Input.is_action_just_pressed("Jump")

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed

func _physics_process(delta):
	get_input()

	velocity.y += gravity * delta
	velocity.x = run_speed

	if is_on_floor():
		animated_sprite.play("Run")

		if jumping:
			jumping = false
	else:
		animated_sprite.stop()

	velocity = move_and_slide(velocity, Vector2(0, -1))

func _on_GameManager_restart():
	velocity = Vector2()
	spawn.respawn()
