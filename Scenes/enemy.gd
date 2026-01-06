extends CharacterBody2D

@export var speed := 80
@export var gravity := 900
@export var damage := 10

@onready var anim := $AnimatedSprite2D
@onready var attack_timer := $AttackTimer

var player: CharacterBody2D = null
var player_in_contact := false

func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D

func _physics_process(delta):
	# add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	if player:
		var dx: float = player.global_position.x - global_position.x
		if abs(dx) > 10:
			var dir: int = sign(dx)
			velocity.x = dir * speed
			anim.flip_h = dir > 0
			anim.play("walk")
		else:
			velocity.x = 0
			anim.play("idle")
	move_and_slide()
	player_in_contact = false
	for i in range(get_slide_collision_count()):
		var col = get_slide_collision(i)
		if col.get_collider().is_in_group("player"):
			player_in_contact = true
			break

	if player_in_contact and attack_timer.is_stopped():
		attack_timer.start()
		player.take_damage(damage)
func _on_AttackTimer_timeout():
	if player_in_contact:
		player.take_damage(damage)
	else:
		attack_timer.stop()
func take_damage(amount: int):
	add_score()
	queue_free()
func add_score():
	var score_label = get_tree().get_first_node_in_group("score")
	if score_label:
		score_label.add_score(1)
