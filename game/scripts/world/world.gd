extends Node2D
## World — orquestra a run: aplica a lenda escolhida, reseta estado e inicia
## o spawner. Fim de run é tratado por GameState + EndScreen via EventBus.

const DEFAULT_LEGEND := preload("res://resources/legends/curupira.tres")
const MINIBOSS_SCENE := preload("res://scenes/enemies/MiniBossPreguica.tscn")
const BOSS_SCENE := preload("res://scenes/enemies/BossOnca.tscn")

@onready var player: Player = $Player

func _ready() -> void:
	GameState.reset_run()
	var legend: LegendData = GameState.selected_legend if GameState.selected_legend else DEFAULT_LEGEND
	player.set_legend(legend)
	player.encantos.add_encanto(legend.starting_encanto)
	EnemySpawner.start(player, $Enemies)
	$HUD.player = player
	$LevelUpScreen.player = player
	EventBus.miniboss_time.connect(_spawn_boss_scene.bind(MINIBOSS_SCENE))
	EventBus.boss_time.connect(_spawn_boss_scene.bind(BOSS_SCENE))
	EventBus.moon_phase_changed.connect(_on_moon_phase_changed)

func _on_moon_phase_changed(_index: int) -> void:
	# transição suave de iluminação (o HUD fica fora — é CanvasLayer)
	var tint: Color = MoonCycleManager.phase()["tint"]
	create_tween().tween_property($DayNight, "color", tint, 2.0)
	player.rebuild_stats()  # fases podem alterar stats (ex: regen da Alvorada)

func _spawn_boss_scene(scene: PackedScene) -> void:
	var boss := scene.instantiate()
	boss.player = player
	boss.global_position = player.global_position + Vector2.from_angle(randf() * TAU) * 500.0
	$Enemies.add_child(boss)
	EventBus.boss_spawned.emit(boss)
