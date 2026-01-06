extends CharacterBody2D

@export var speed := 200
@export var jump_velocity := -250
@export var djump_velocity := -150

@export var attack_time := 0.4
@export var max_health := 100

var attack_timer := 0.0
var is_attacking := false
var has_djumped := false
var health: int = 100

@onready var anim := $AnimatedSprite2D
@onready var health_bar := $"../CanvasLayer/HealthBar"

func _ready():
	add_to_group("player")
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health

func start_attack():
	is_attacking = true
	attack_timer = attack_time
	anim.play("attack")

func take_damage(amount: int):
	health -= amount
	health = max(health, 0)
	health_bar.value = health
	print("Player took damage:", amount)

	if health <= 0:
		die()

func die():
	get_tree().change_scene_to_file("res://Scenes/control.tscn")

func _physics_process(delta):
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		has_djumped = false

	# jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		elif not has_djumped:
			velocity.y = djump_velocity
			has_djumped = true

	# attack input
	if Input.is_action_just_pressed("attack") and not is_attacking:
		start_attack()

	# attack timer
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
		velocity.x = 0
	else:
		var dir: float = Input.get_axis("left", "right")
		if dir != 0:
			anim.flip_h = dir < 0
			anim.play("walk")
			velocity.x = dir * speed
		else:
			anim.play("idle")
			velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

# SIGNAL: AttackArea.body_entered → Player
func _on_attack_area_body_entered(body):
	if not is_attacking:
		return
	if body.is_in_group("enemy"):
		body.take_damage(1)
