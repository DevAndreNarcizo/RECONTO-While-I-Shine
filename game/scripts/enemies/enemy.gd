class_name Enemy
extends Area2D
## Inimigo genérico dirigido por EnemyData. Sem _process próprio:
## o movimento é feito em LOTE pelo EnemySpawner (performance para centenas).

const KNOCKBACK_FORCE := 55.0
const KNOCKBACK_MAX := 140.0

var data: EnemyData
var hp: float = 0.0
var speed: float = 0.0
var knockback := Vector2.ZERO  # decaído em lote pelo EnemySpawner
var confusion_t := 0.0         # >0 = anda na direção errada (Pés Invertidos)
var confusion_dir := Vector2.ZERO
var charmed_t := 0.0           # >0 = ENCANTADO: luta ao lado do player (inovação #2)
var charm_hit_cd := 0.0
var shoot_cd := 0.0            # atiradores
var zig_phase := 0.0           # fase da onda do zigue-zague

var _flash := false

func setup(p_data: EnemyData, pos: Vector2) -> void:
	data = p_data
	hp = data.max_hp * MoonCycleManager.enemy_hp_mult()  # a lua fortalece a Corrupção
	if GameState.has_simpatia(&"mata_generosa"):
		hp *= 1.25  # o preço da fartura
	speed = data.move_speed
	global_position = pos
	knockback = Vector2.ZERO
	confusion_t = 0.0
	charmed_t = 0.0
	set_deferred("collision_layer", 2)  # volta ao time hostil (pooling)
	shoot_cd = data.shoot_interval * randf()  # dessincroniza os atiradores
	zig_phase = randf() * TAU
	_flash = false
	show()
	set_deferred("monitorable", true)
	queue_redraw()

func confuse(duration: float) -> void:
	if charmed_t > 0.0:
		return  # aliado não se confunde
	confusion_t = duration
	confusion_dir = Vector2.from_angle(randf() * TAU)

## ENCANTADO: muda de time — layer "allies" o tira do alcance das armas do
## player e do dano de contato (hurtbox/armas filtram pela layer "enemies").
func charm(duration: float) -> void:
	charmed_t = duration
	confusion_t = 0.0
	charm_hit_cd = 0.0
	set_deferred("collision_layer", 16)
	queue_redraw()

func uncharm() -> void:
	charmed_t = 0.0
	set_deferred("collision_layer", 2)
	queue_redraw()

func is_charmed() -> bool:
	return charmed_t > 0.0

## `from` = origem do golpe (para knockback); omitir = sem empurrão.
func take_damage(amount: float, from := Vector2.INF) -> void:
	if hp <= 0.0:
		return
	hp -= amount
	EventBus.damage_dealt.emit(global_position, amount)
	if from.x != INF:
		var force := KNOCKBACK_FORCE * data.knockback_scale
		knockback = (knockback + (global_position - from).normalized() * force).limit_length(KNOCKBACK_MAX)
	_flash = true
	queue_redraw()
	# false = timer respeita pausa do jogo
	get_tree().create_timer(0.08, false).timeout.connect(_end_flash, CONNECT_ONE_SHOT)
	if hp <= 0.0:
		die()

func die() -> void:
	EventBus.enemy_killed.emit(self)
	EnemySpawner.despawn(self)

func _end_flash() -> void:
	_flash = false
	queue_redraw()

func _draw() -> void:
	var radius := data.radius if data else 9.0
	var color := Color.WHITE if _flash else (data.color if data else Color(0.8, 0.2, 0.2))
	if charmed_t > 0.0 and not _flash:
		color = color.lerp(Color(0.5, 0.8, 1.0), 0.45)  # encantado = azulado
	elif confusion_t > 0.0 and not _flash:
		color = color.lerp(Color(1.0, 0.9, 0.3), 0.55)  # confuso = amarelado
	draw_circle(Vector2.ZERO, radius, color)
	if charmed_t > 0.0:
		# anel de aliado — a Luz voltou a esta criatura
		draw_arc(Vector2.ZERO, radius + 4.0, 0, TAU, 20, Color(0.55, 0.85, 1.0, 0.9), 2.0)
	elif confusion_t > 0.0:
		# redemoinho sobre a cabeça — feedback dos Pés Invertidos
		draw_arc(Vector2(0, -radius - 8.0), 5.0, 0, TAU * 0.75, 10, Color(1.0, 0.95, 0.4), 2.0)
	if data and data.behavior == EnemyData.Behavior.ELITE:
		draw_arc(Vector2.ZERO, radius + 4.0, 0, TAU, 20, Color(0.75, 0.3, 1.0, 0.8), 2.0)
	elif data and data.behavior == EnemyData.Behavior.SHOOTER:
		draw_circle(Vector2.ZERO, radius * 0.4, Color(0.15, 0.3, 0.1))
