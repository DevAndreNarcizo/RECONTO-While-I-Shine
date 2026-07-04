class_name EncantoBase
extends Node2D
## Base de todo Encanto (arma). Ataque AUTOMÁTICO por cooldown — sem botão.
## Os números vêm do EncantoData por nível; a lógica, das subclasses de behavior.

var data: EncantoData
var level := 1
var player: Player

var _cd := 0.0

func setup(p_data: EncantoData, p_player: Player) -> void:
	data = p_data
	player = p_player
	_on_setup()

## Stats efetivos = tabela do nível × stats globais do player (amuletos etc.).
func damage() -> float:
	return data.damage(level) * player.stats.damage_mult

func cooldown() -> float:
	return data.cooldown(level) / maxf(0.1, player.stats.attack_speed_mult)

func area() -> float:
	return data.area(level) * player.stats.area_mult

func amount() -> int:
	var bonus := player.stats.amount_bonus if _uses_amount_bonus() else 0
	return data.amount(level) + bonus

## Virtual: encantos sem projéteis/instâncias (ex: melee) ignoram +Quantidade.
func _uses_amount_bonus() -> bool:
	return true

func is_max_level() -> bool:
	return level >= EncantoData.MAX_LEVEL

func level_up() -> void:
	if is_max_level():
		return
	level += 1
	_on_level_up()

func _physics_process(delta: float) -> void:
	if player == null or data == null:
		return
	_cd -= delta
	if _cd > 0.0:
		return
	# Ataque MANUAL (decisão de playtest, jul/2026): encantos disparam segurando
	# o clique direito/RT, no ritmo do próprio cooldown. Encantos passivos
	# (orbitais/auras) continuam automáticos.
	if _is_passive() or Input.is_action_pressed("attack"):
		_cd = cooldown()
		_attack()

## Virtual: encantos passivos ignoram o gatilho manual (ex: orbital).
func _is_passive() -> bool:
	return false

## Virtual: executa um ataque.
func _attack() -> void:
	pass

## Virtual: chamado uma vez após setup().
func _on_setup() -> void:
	pass

## Virtual: reagir a subida de nível (reconstruir orbes etc.).
func _on_level_up() -> void:
	pass

## Helper compartilhado: dano em área circular na layer de inimigos.
func damage_circle(center: Vector2, radius: float, dmg: float) -> void:
	var shape := CircleShape2D.new()
	shape.radius = radius
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0.0, center)
	query.collision_mask = 2  # physics layer "enemies"
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var space := get_world_2d().direct_space_state
	for result in space.intersect_shape(query, 128):
		var enemy := result.collider as Enemy
		if enemy:
			enemy.take_damage(dmg, center)
