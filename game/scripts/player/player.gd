class_name Player
extends CharacterBody2D
## Player — movimento top-down 8 direções com aceleração/desaceleração suave.
## Stats vêm do agregador PlayerStats (base + amuletos + futura meta).
## Placeholder visual: círculo verde (Curupira) com indicador de facing âmbar.

# Ajuste de feel: velocidade base fica em PlayerStats.BASE_MOVE_SPEED;
# accel/decel aqui (maior = mais responsivo).
@export var accel: float = 900.0
@export var decel: float = 1200.0
@export var contact_iframes: float = 0.5  # invencibilidade após levar dano de contato

var stats := PlayerStats.new()
var hp: float
var facing: Vector2 = Vector2.RIGHT  # última direção de movimento (armas frontais usam)

var _invuln := 0.0
var _bonus_move_speed := 0.0  # bônus de cartas na run (placeholder até a fase 2.3)

@onready var _hurtbox: Area2D = $Hurtbox
@onready var _magnet: Area2D = $MagnetArea
@onready var amulets: AmuletoManager = $AmuletoManager
@onready var encantos: EncantoManager = $EncantoManager

func _ready() -> void:
	amulets.changed.connect(rebuild_stats)
	rebuild_stats()
	hp = stats.max_hp
	_magnet.area_entered.connect(_on_magnet_area_entered)

## Recalcula TODOS os stats do zero (nunca acumular por cima).
func rebuild_stats() -> void:
	var old_max := stats.max_hp
	stats.reset()
	stats.move_speed += _bonus_move_speed
	amulets.apply_to(stats)
	SaveManager.apply_tree_bonuses(stats)  # bônus permanentes da Árvore Sagrada
	if stats.max_hp > old_max:
		hp += stats.max_hp - old_max  # ganhar vida máx concede a diferença
	hp = minf(hp, stats.max_hp)
	($MagnetArea/CollisionShape2D.shape as CircleShape2D).radius = stats.magnetism

func add_move_speed_bonus(amount: float) -> void:
	_bonus_move_speed += amount
	rebuild_stats()

func heal(amount: float) -> void:
	hp = minf(stats.max_hp, hp + amount)

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target := input_dir * stats.move_speed
	var rate := accel if input_dir != Vector2.ZERO else decel
	velocity = velocity.move_toward(target, rate * delta)
	move_and_slide()

	if input_dir != Vector2.ZERO and not facing.is_equal_approx(input_dir.normalized()):
		facing = input_dir.normalized()
		queue_redraw()

	if stats.recovery > 0.0 and hp < stats.max_hp:
		hp = minf(stats.max_hp, hp + stats.recovery * delta)

	_invuln = maxf(0.0, _invuln - delta)
	if _invuln <= 0.0:
		_check_contact_damage()

func _on_magnet_area_entered(area: Area2D) -> void:
	# Sementes de Luz e Fragmentos de Luar implementam magnetize()
	if area.has_method("magnetize"):
		area.magnetize(self)

func _check_contact_damage() -> void:
	var strongest := 0.0
	for area in _hurtbox.get_overlapping_areas():
		var enemy := area as Enemy
		if enemy and enemy.hp > 0.0:
			strongest = maxf(strongest, enemy.data.contact_damage)
	if strongest > 0.0:
		take_damage(strongest)

func take_damage(amount: float) -> void:
	amount = maxf(1.0, amount - stats.armor)  # armadura reduz, nunca zera
	hp = maxf(0.0, hp - amount)
	_invuln = contact_iframes
	EventBus.player_damaged.emit(hp, stats.max_hp)
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
