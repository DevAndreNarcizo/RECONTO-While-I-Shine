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
@onready var boss_bar: ProgressBar = $BossBar
@onready var boss_name: Label = $BossName
@onready var moon_label: Label = $MoonLabel

var _boss: Enemy

func _ready() -> void:
	EventBus.xp_changed.connect(_on_xp_changed)
	EventBus.boss_spawned.connect(_on_boss_spawned)

func _on_boss_spawned(boss: Node2D) -> void:
	_boss = boss as Enemy
	boss_bar.visible = true
	boss_name.visible = true
	boss_name.text = _boss.data.display_name

func _on_xp_changed(xp: float, xp_to_next: float, level: int) -> void:
	xp_bar.max_value = xp_to_next
	xp_bar.value = xp
	level_label.text = tr("HUD_LEVEL") % level

func _process(_delta: float) -> void:
	var t := int(GameState.run_time)
	time_label.text = "%02d:%02d" % [t / 60, t % 60]
	kills_label.text = tr("HUD_KILLS") % GameState.kills
	debug_label.text = "inimigos %d · fps %d" % [
		EnemySpawner.active_count(), Engine.get_frames_per_second()
	]
	luar_label.text = tr("HUD_LUAR") % GameState.run_luar
	var next := int(MoonCycleManager.time_to_next())
	var phase: Dictionary = MoonCycleManager.phase()
	moon_label.text = "%s %s · %d:%02d" % [
		phase["icon"], tr("MOON_" + String(phase["id"]).to_upper()), next / 60, next % 60
	]
	if _boss != null:
		if is_instance_valid(_boss) and _boss.hp > 0.0:
			boss_bar.max_value = _boss.data.max_hp
			boss_bar.value = _boss.hp
		else:
			_boss = null
			boss_bar.visible = false
			boss_name.visible = false
	if player:
		hp_bar.max_value = player.stats.max_hp
		hp_bar.value = player.hp
		build_label.text = _build_summary()
		ability_label.text = _ability_text()

func _ability_text() -> String:
	var lines := "" if SaveManager.setting_on("auto_attack") else tr("HUD_ATTACK_HINT")
	if player.legend == null or player.legend.active_id == &"":
		return lines
	var sep := "\n" if lines != "" else ""
	if player.ability_cd_left <= 0.0:
		return lines + sep + tr("HUD_ABILITY_READY") % player.legend.active_name
	return lines + sep + "%s: %.1fs" % [player.legend.active_name, player.ability_cd_left]

## Ícones da build em texto (placeholder até termos ícones de verdade na fase 5).
func _build_summary() -> String:
	var parts: PackedStringArray = []
	for w in player.encantos.owned():
		var weapon := w as EncantoBase
		parts.push_back("%s %d" % [weapon.data.display_name, weapon.level])
	for entry in player.amulets.owned():
		parts.push_back("◈%s %d" % [(entry["data"] as AmuletoData).display_name, entry["level"]])
	return " · ".join(parts)
