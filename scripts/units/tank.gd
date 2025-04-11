extends CharacterBody2D

@export var speed := 100
var selected = false
var moving = false

@onready var agent = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	agent.target_reached.connect(_on_target_reached)

func _process(delta):
	if moving:
		var next_pos = agent.get_next_path_position()
		var direction = next_pos - global_position
		velocity = direction.normalized() * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO

func set_target(pos: Vector2):
	agent.target_position = pos
	moving = true

func _on_target_reached():
	moving = false

func set_selected(value: bool):
	selected = value
	var mat = animated_sprite.material
	if mat is ShaderMaterial:
		mat.set_shader_parameter("show_outline", value)
