extends AnimatedSprite

const ANIMATION_RUN = "Run"

func _on_HitboxArea2D_body_entered(body):
	if body.is_in_group("Ground"):
		play(ANIMATION_RUN)

func _on_HitboxArea2D_body_exited(body):
	if body.is_in_group("Ground"):
		stop()
