class_name Enemy
extends Area2D
## Inimigo genérico dirigido por EnemyData. Sem _process próprio:
## o movimento é feito em LOTE pelo EnemySpawner (performance para centenas).
## Visual: sprite direcional do PixelLab (8 rotações) com fallback geométrico.

const KNOCKBACK_FORCE := 55.0
const KNOCKBACK_MAX := 140.0
const SPRITE_SIZE_FACTOR := 2.4  # diâmetro visual ≈ raio da colisão × fator

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
var _textures: Array = []
var _octant := SpriteSet.SOUTH

@onready var _sprite: Sprite2D = get_node_or_null("Sprite")

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
	_setup_sprite()
	show()
	set_deferred("monitorable", true)
	queue_redraw()

func _setup_sprite() -> void:
	_textures = SpriteSet.load_set(data.sprite_dir)
	if _sprite == null:
		return
	if _textures.is_empty():
		_sprite.visible = false
		return
	_octant = SpriteSet.SOUTH
	_sprite.texture = _textures[_octant]
	var tex_size: float = _sprite.texture.get_width()
	_sprite.scale = Vector2.ONE * (data.radius * SPRITE_SIZE_FACTOR / tex_size)
	_sprite.self_modulate = Color.WHITE
	_sprite.visible = true

## Chamado pelo spawner/bosses com a direção do movimento — vira o sprite.
func set_move_dir(dir: Vector2) -> void:
	if _textures.is_empty() or _sprite == null or dir == Vector2.ZERO:
		return
	var o := SpriteSet.octant(dir)
	if o != _octant:
		_octant = o
		_sprite.texture = _textures[o]

func confuse(duration: float) -> void:
	if charmed_t > 0.0:
		return  # aliado não se confunde
	confusion_t = duration
	confusion_dir = Vector2.from_angle(randf() * TAU)
	refresh_visual()

## ENCANTADO: muda de time — layer "allies" o tira do alcance das armas do
## player e do dano de contato (hurtbox/armas filtram pela layer "enemies").
func charm(duration: float) -> void:
	charmed_t = duration
	confusion_t = 0.0
	charm_hit_cd = 0.0
	set_deferred("collision_layer", 16)
	refresh_visual()

func uncharm() -> void:
	charmed_t = 0.0
	set_deferred("collision_layer", 2)
	refresh_visual()

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
	refresh_visual()
	# false = timer respeita pausa do jogo
	get_tree().create_timer(0.08, false).timeout.connect(_end_flash, CONNECT_ONE_SHOT)
	if hp <= 0.0:
		die()

func die() -> void:
	EventBus.enemy_killed.emit(self)
	EnemySpawner.despawn(self)

func _end_flash() -> void:
	_flash = false
	refresh_visual()

## Atualiza tint do sprite + redesenha os anéis de estado.
func refresh_visual() -> void:
	if _sprite and _sprite.visible:
		if _flash:
			_sprite.self_modulate = Color(6, 6, 6)      # clarão de dano
		elif charmed_t > 0.0:
			_sprite.self_modulate = Color(0.6, 0.95, 1.5)  # encantado = azulado
		elif confusion_t > 0.0:
			_sprite.self_modulate = Color(1.5, 1.3, 0.5)   # confuso = amarelado
		else:
			_sprite.self_modulate = Color.WHITE
	queue_redraw()

func _draw() -> void:
	var radius := data.radius if data else 9.0
	if _textures.is_empty():
		# fallback geométrico (sem sprite)
		var color := Color.WHITE if _flash else (data.color if data else Color(0.8, 0.2, 0.2))
		if charmed_t > 0.0 and not _flash:
			color = color.lerp(Color(0.5, 0.8, 1.0), 0.45)
		elif confusion_t > 0.0 and not _flash:
			color = color.lerp(Color(1.0, 0.9, 0.3), 0.55)
		draw_circle(Vector2.ZERO, radius, color)
		if data and data.behavior == EnemyData.Behavior.SHOOTER:
			draw_circle(Vector2.ZERO, radius * 0.4, Color(0.15, 0.3, 0.1))
	# anéis de estado (com ou sem sprite)
	if charmed_t > 0.0:
		draw_arc(Vector2.ZERO, radius + 4.0, 0, TAU, 20, Color(0.55, 0.85, 1.0, 0.9), 2.0)
	elif confusion_t > 0.0:
		draw_arc(Vector2(0, -radius - 8.0), 5.0, 0, TAU * 0.75, 10, Color(1.0, 0.95, 0.4), 2.0)
	if data and data.behavior == EnemyData.Behavior.ELITE:
		draw_arc(Vector2.ZERO, radius + 4.0, 0, TAU, 20, Color(0.75, 0.3, 1.0, 0.8), 2.0)
