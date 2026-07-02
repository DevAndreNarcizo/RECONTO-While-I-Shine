extends CanvasLayer
## HUD da run: XP no topo, timer, nível, HP, kills e debug de performance.

var player: Player

@onready var xp_bar: ProgressBar = $XpBar
@onready var level_label: Label = $LevelLabel
@onready var time_label: Label = $TimeLabel
@onready var hp_bar: ProgressBar = $HpBar
@onready var kills_label: Label = $KillsLabel
@onready var debug_label: Label = $DebugLabel

func _ready() -> void:
	EventBus.xp_changed.connect(_on_xp_changed)

func _on_xp_changed(xp: float, xp_to_next: float, level: int) -> void:
	xp_bar.max_value = xp_to_next
	xp_bar.value = xp
	level_label.text = "Nv %d" % level

func _process(_delta: float) -> void:
	var t := int(GameState.run_time)
	time_label.text = "%02d:%02d" % [t / 60, t % 60]
	kills_label.text = "Derrotados: %d" % GameState.kills
	debug_label.text = "inimigos %d · fps %d" % [
		EnemySpawner.active_count(), Engine.get_frames_per_second()
	]
	if player:
		hp_bar.max_value = player.max_hp
		hp_bar.value = player.hp
