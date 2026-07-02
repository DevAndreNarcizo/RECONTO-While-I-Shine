class_name Player
extends CharacterBody2D
## Player — movimento top-down 8 direções com aceleração/desaceleração suave.
## Placeholder visual: círculo verde (Curupira) com indicador de facing âmbar.

# GDD §5 sugere 60 px/s; com câmera em zoom 2x o valor foi calibrado para cima.
# Ajuste de feel: mexa em move_speed primeiro, depois accel/decel (maior = mais responsivo).
@export var move_speed: float = 90.0
@export var accel: float = 900.0
@export var decel: float = 1200.0
@export var max_hp: float = 100.0

var hp: float
var facing: Vector2 = Vector2.RIGHT  # última direção de movimento (armas frontais usam)

func _ready() -> void:
	hp = max_hp

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target := input_dir * move_speed
	var rate := accel if input_dir != Vector2.ZERO else decel
	velocity = velocity.move_toward(target, rate * delta)
	move_and_slide()

	if input_dir != Vector2.ZERO and not facing.is_equal_approx(input_dir.normalized()):
		facing = input_dir.normalized()
		queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 14.0, Color("3fa34d"))
	var tip := facing * 22.0
	var side := facing.orthogonal() * 6.0
	draw_colored_polygon(
		PackedVector2Array([tip, facing * 10.0 + side, facing * 10.0 - side]),
		Color("ffd25e")
	)
