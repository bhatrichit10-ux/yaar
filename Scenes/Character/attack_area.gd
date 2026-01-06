extends Area2D

func _on_body_entered(body):
	var player = get_parent().get_parent()
	if not player.is_attacking:
		return
	if body.is_in_group("enemy"):
		body.take_damage(1)
