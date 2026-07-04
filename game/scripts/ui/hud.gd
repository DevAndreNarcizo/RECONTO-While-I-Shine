extends CanvasLayer
## HUD da run: XP no topo, timer, nível, HP, kills e debug de performance.

var player: Player

@onready var xp_bar: ProgressBar = $XpBar
@onready var level_label: Label = $LevelLabel
@onready var time_label: Label = $TimeLabel
@onready var hp_bar: ProgressBar = $HpBar
@onready var kills_label: Label = $KillsLabel
@onready var luar_label: Label = $LuarLabel
@onready var build_label: Label = $BuildLabel
@onready var ability_label: Label = $AbilityLabel
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
	luar_label.text = "❖ Luar: %d" % GameState.run_luar
	if player:
		hp_bar.max_value = player.stats.max_hp
		hp_bar.value = player.hp
		build_label.text = _build_summary()
		ability_label.text = _ability_text()

func _ability_text() -> String:
	if player.legend == null or player.legend.active_id == &"":
		return ""
	if player.ability_cd_left <= 0.0:
		return "ESPAÇO — %s: PRONTO" % player.legend.active_name
	return "%s: %.1fs" % [player.legend.active_name, player.ability_cd_left]

## Ícones da build em texto (placeholder até termos ícones de verdade na fase 5).
func _build_summary() -> String:
	var parts: PackedStringArray = []
	for w in player.encantos.owned():
		var weapon := w as EncantoBase
		parts.push_back("%s %d" % [weapon.data.display_name, weapon.level])
	for entry in player.amulets.owned():
		parts.push_back("◈%s %d" % [(entry["data"] as AmuletoData).display_name, entry["level"]])
	return " · ".join(parts)
