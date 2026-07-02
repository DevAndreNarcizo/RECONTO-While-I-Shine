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
@export var contact_iframes: float = 0.5  # invencibilidade após levar dano de contato

var hp: float
var facing: Vector2 = Vector2.RIGHT  # última direção de movimento (armas frontais usam)

var _invuln := 0.0

@onready var _hurtbox: Area2D = $Hurtbox

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

	_invuln = maxf(0.0, _invuln - delta)
	if _invuln <= 0.0:
		_check_contact_damage()

func _check_contact_damage() -> void:
	var strongest := 0.0
	for area in _hurtbox.get_overlapping_areas():
		var enemy := area as Enemy
		if enemy and enemy.hp > 0.0:
			strongest = maxf(strongest, enemy.data.contact_damage)
	if strongest > 0.0:
		take_damage(strongest)

func take_damage(amount: float) -> void:
	hp = maxf(0.0, hp - amount)
	_invuln = contact_iframes
	EventBus.player_damaged.emit(hp, max_hp)
	_flash_damage()
	if hp <= 0.0:
		EventBus.player_died.emit()

func _flash_damage() -> void:
	modulate = Color(1.0, 0.45, 0.45)
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.25)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 14.0, Color("3fa34d"))
	var tip := facing * 22.0
	var side := facing.orthogonal() * 6.0
	draw_colored_polygon(
		PackedVector2Array([tip, facing * 10.0 + side, facing * 10.0 - side]),
		Color("ffd25e")
	)
