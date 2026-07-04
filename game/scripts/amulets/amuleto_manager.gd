class_name AmuletoManager
extends Node
## Gerencia os até 6 slots de Amuleto e aplica seus bônus ao PlayerStats.

signal changed

const MAX_SLOTS := 6

var _amulets: Dictionary = {}  # id (StringName) → {"data": AmuletoData, "level": int}

func add(data: AmuletoData) -> bool:
	if _amulets.size() >= MAX_SLOTS or _amulets.has(data.id):
		return false
	_amulets[data.id] = {"data": data, "level": 1}
	changed.emit()
	return true

func upgrade(id: StringName) -> void:
	if not _amulets.has(id):
		return
	var entry: Dictionary = _amulets[id]
	if entry["level"] < AmuletoData.MAX_LEVEL:
		entry["level"] += 1
		changed.emit()

func has_amuleto(id: StringName) -> bool:
	return _amulets.has(id)

func level_of(id: StringName) -> int:
	return _amulets[id]["level"] if _amulets.has(id) else 0

func owned() -> Array:
	return _amulets.values()

func has_free_slot() -> bool:
	return _amulets.size() < MAX_SLOTS

## Soma os bônus de todos os amuletos no agregador de stats.
func apply_to(stats: PlayerStats) -> void:
	for entry in _amulets.values():
		var d: AmuletoData = entry["data"]
		var lv: int = entry["level"]
		stats.max_hp += d.max_hp_per_level * lv
		stats.recovery += d.recovery_per_level * lv
		stats.armor += d.armor_per_level * lv
		stats.move_speed += d.move_speed_per_level * lv
		stats.damage_mult += d.damage_pct_per_level * lv / 100.0
		stats.attack_speed_mult += d.attack_speed_pct_per_level * lv / 100.0
		stats.area_mult += d.area_pct_per_level * lv / 100.0
		stats.duration_mult += d.duration_pct_per_level * lv / 100.0
		stats.projectile_speed_mult += d.projectile_speed_pct_per_level * lv / 100.0
		stats.luck += d.luck_pct_per_level * lv / 100.0
		stats.magnetism += d.magnetism_per_level * lv
		stats.xp_mult += d.xp_pct_per_level * lv / 100.0
		stats.luar_mult += d.luar_pct_per_level * lv / 100.0
		for threshold in d.amount_at_levels:
			if lv >= threshold:
				stats.amount_bonus += 1
