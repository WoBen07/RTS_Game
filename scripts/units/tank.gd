extends CharacterBody2D

@export var speed := 100
var selected = false
var moving = false

@onready var agent = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var driving: AudioStreamPlayer2D = $driving
@onready var idle: AudioStreamPlayer2D = $idle


func _ready():
	agent.target_reached.connect(_on_target_reached)

func _process(delta):
	if moving:
		var next_pos = agent.get_next_path_position()
		var direction = next_pos - global_position
		velocity = direction.normalized() * speed
		move_and_slide()
		animated_sprite.flip_h = velocity.x < 0
	else:
		velocity = Vector2.ZERO

func set_target(pos: Vector2):
	agent.target_position = pos
	animated_sprite.play("moving")
	driving.play()
	moving = true

func _on_target_reached():
	moving = false
	animated_sprite.play("idle")
	driving.stop()

func set_selected(value: bool):
	selected = value
	if selected:
		idle.play()
	else:
		idle.stop()
	var mat = animated_sprite.material
	if mat is ShaderMaterial:
		mat.set_shader_parameter("show_outline", value)
