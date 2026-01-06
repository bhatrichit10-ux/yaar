extends Node2D

@export var enemy_scene: PackedScene

func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.global_position = global_position
	get_parent().add_child(enemy)
