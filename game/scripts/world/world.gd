extends Node2D
## World — orquestra a run: aplica lenda E BIOMA escolhidos, reseta estado e
## inicia o spawner. Fim de run é tratado por GameState + EndScreen via EventBus.

const DEFAULT_LEGEND := preload("res://resources/legends/curupira.tres")

var biome: Dictionary

@onready var player: Player = $Player

func _ready() -> void:
	GameState.reset_run()
	biome = Balance.BIOMES.get(GameState.selected_biome_id, Balance.BIOMES[&"mata_atlantica"])

	var legend: LegendData = GameState.selected_legend if GameState.selected_legend else DEFAULT_LEGEND
	player.set_legend(legend)
	player.encantos.add_encanto(legend.starting_encanto)

	# visual e regras do bioma
	$Ground.color_a = biome["ground_a"]
	$Ground.color_b = biome["ground_b"]
	$Rain.visible = biome["rain"]
	$Rain.set_process(biome["rain"])
	$Rain.target = player
	GameState.projectile_env_mult = Balance.RAIN_PROJECTILE_MULT if biome["rain"] else 1.0
	var flood: bool = biome.get("flood", false)
	$Flood.set_physics_process(flood)
	$Flood.visible = flood
	$Flood.player = player

	EnemySpawner.start(player, $Enemies, biome["spawn_table"])
	$HUD.player = player
	$LevelUpScreen.player = player
	$BiomeHazard.player = player
	EventBus.miniboss_time.connect(_spawn_boss_scene.bind(String(biome["miniboss"])))
	EventBus.boss_time.connect(_spawn_boss_scene.bind(String(biome["boss"])))
	EventBus.moon_phase_changed.connect(_on_moon_phase_changed)

func _on_moon_phase_changed(_index: int) -> void:
	# transição suave de iluminação (o HUD fica fora — é CanvasLayer)
	var tint: Color = MoonCycleManager.phase()["tint"]
	create_tween().tween_property($DayNight, "color", tint, 2.0)
	player.rebuild_stats()  # fases podem alterar stats (ex: regen da Alvorada)

func _spawn_boss_scene(scene_path: String) -> void:
	var boss: Node2D = (load(scene_path) as PackedScene).instantiate()
	boss.player = player
	boss.global_position = player.global_position + Vector2.from_angle(randf() * TAU) * 500.0
	$Enemies.add_child(boss)
	EventBus.boss_spawned.emit(boss)
