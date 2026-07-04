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
var legend: LegendData
var ability_cd_left := 0.0
var external_push := Vector2.ZERO  # forças externas (puxão de boss); zera a cada frame

const DASH_TIME := 0.22
const DASH_SPEED := 430.0

var _invuln := 0.0
var _dash_t := 0.0  # Dash de Vento do Saci
var _bonus_move_speed := 0.0  # bônus de cartas na run (placeholder até a fase 2.3)

# Sprite direcional (PixelLab, 8 rotações). TODO(fase 6): vem da LegendData.
const SPRITE_DIR := "res://assets/sprites/small_forest_guardian_boy_wild/small_forest_guardian_boy_wild/rotations"
const SPRITE_SIZE_FACTOR := 2.4

var _textures: Array = []
var _octant := SpriteSet.SOUTH

@onready var _sprite: Sprite2D = $Sprite
@onready var _hurtbox: Area2D = $Hurtbox
@onready var _magnet: Area2D = $MagnetArea
@onready var amulets: AmuletoManager = $AmuletoManager
@onready var encantos: EncantoManager = $EncantoManager

func _ready() -> void:
	_setup_sprite()
	amulets.changed.connect(rebuild_stats)
	rebuild_stats()
	hp = stats.max_hp
	_magnet.area_entered.connect(_on_magnet_area_entered)

## Define a lenda jogável (chamar ANTES do primeiro frame da run).
func set_legend(p_legend: LegendData) -> void:
	legend = p_legend
	_setup_sprite()
	rebuild_stats()
	hp = stats.max_hp
	queue_redraw()

func _setup_sprite() -> void:
	var dir := SPRITE_DIR
	if legend and not legend.sprite_dir.is_empty():
		dir = legend.sprite_dir
	_textures = SpriteSet.load_set(dir)
	if _textures.is_empty():
		_sprite.visible = false
		return
	_octant = SpriteSet.SOUTH
	_sprite.texture = _textures[_octant]
	_sprite.scale = Vector2.ONE * (14.0 * SPRITE_SIZE_FACTOR / _sprite.texture.get_width())
	_sprite.visible = true

## Recalcula TODOS os stats do zero (nunca acumular por cima).
func rebuild_stats() -> void:
	var old_max := stats.max_hp
	stats.reset()
	if legend:
		stats.max_hp += legend.max_hp_bonus
		stats.move_speed += legend.move_speed_bonus
		stats.damage_mult += legend.damage_mult_bonus
		stats.luck += legend.luck_bonus
		stats.recovery += legend.regen_bonus
	stats.move_speed += _bonus_move_speed
	amulets.apply_to(stats)
	SaveManager.apply_tree_bonuses(stats)  # bônus permanentes da Árvore Sagrada
	stats.recovery += MoonCycleManager.regen_bonus()  # a Alvorada cura os Encantados
	if stats.max_hp > old_max:
		hp += stats.max_hp - old_max  # ganhar vida máx concede a diferença
	hp = minf(hp, stats.max_hp)
	($MagnetArea/CollisionShape2D.shape as CircleShape2D).radius = stats.magnetism

func add_move_speed_bonus(amount: float) -> void:
	_bonus_move_speed += amount
	rebuild_stats()

func heal(amount: float) -> void:
	hp = minf(stats.max_hp, hp + amount)

# Movimento por mouse: segurar o botão esquerdo anda em direção ao cursor.
# Deadzone evita tremedeira quando o cursor está em cima do personagem.
const MOUSE_DEADZONE := 10.0

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir == Vector2.ZERO and Input.is_action_pressed("move_click"):
		var to_mouse := get_global_mouse_position() - global_position
		if to_mouse.length() > MOUSE_DEADZONE:
			input_dir = to_mouse.normalized()
	if _dash_t > 0.0:
		_dash_t -= delta
		velocity = facing * DASH_SPEED  # dash ignora aceleração e puxões
	else:
		var target := input_dir * stats.move_speed
		var rate := accel if input_dir != Vector2.ZERO else decel
		velocity = velocity.move_toward(target, rate * delta) + external_push
	external_push = Vector2.ZERO
	move_and_slide()

	if input_dir != Vector2.ZERO and not facing.is_equal_approx(input_dir.normalized()):
		facing = input_dir.normalized()
		if not _textures.is_empty():
			var o := SpriteSet.octant(facing)
			if o != _octant:
				_octant = o
				_sprite.texture = _textures[o]
		queue_redraw()

	if stats.recovery > 0.0 and hp < stats.max_hp:
		hp = minf(stats.max_hp, hp + stats.recovery * delta)

	_invuln = maxf(0.0, _invuln - delta)
	if _invuln <= 0.0:
		_check_contact_damage()

	ability_cd_left = maxf(0.0, ability_cd_left - delta)
	if legend and legend.active_id != &"" and ability_cd_left <= 0.0 \
			and Input.is_action_just_pressed("ability"):
		_use_ability()

func _use_ability() -> void:
	ability_cd_left = legend.active_cooldown
	match legend.active_id:
		&"pes_invertidos":
			# Curupira: pegadas ao contrário — inimigos próximos andam errado
			const RADIUS := 260.0
			for e in EnemySpawner.active_enemies():
				if global_position.distance_squared_to(e.global_position) < RADIUS * RADIUS:
					e.confuse(3.0)
			EventBus.ability_cast.emit(global_position, RADIUS)
			EventBus.screen_shake.emit(3.0)
		&"dash_vento":
			# Saci: dash curto com invencibilidade — o redemoinho o carrega
			_dash_t = DASH_TIME
			_invuln = maxf(_invuln, DASH_TIME + 0.15)
			EventBus.ability_cast.emit(global_position, 44.0)

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
			continue
		var proj := area as EnemyProjectile
		if proj:
			strongest = maxf(strongest, proj.damage)
			proj.expire()  # projétil é consumido no impacto
	if strongest > 0.0:
		take_damage(strongest * MoonCycleManager.enemy_damage_mult())

func take_damage(amount: float) -> void:
	if legend and legend.dodge_chance > 0.0 and randf() < legend.dodge_chance:
		EventBus.ability_cast.emit(global_position, 22.0)  # anel: esquivou!
		return
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
	if not _textures.is_empty():
		return  # o sprite do Curupira assume o visual
	var body_color := legend.color if legend else Color("3fa34d")
	draw_circle(Vector2.ZERO, 14.0, body_color)
	var tip := facing * 22.0
	var side := facing.orthogonal() * 6.0
	draw_colored_polygon(
		PackedVector2Array([tip, facing * 10.0 + side, facing * 10.0 - side]),
		Color("ffd25e")
	)
