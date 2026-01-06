extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_parent().on_player_detected(body)

func _on_body_exited(body):
	if body.is_in_group("player"):
		get_parent().on_player_lost(body)
