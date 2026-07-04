class_name Evolutions
## Ritual de Sincretismo (Inovação #3) — lógica pura sobre Balance.EVOLUTIONS.
## Tríade: encanto no nível máx + amuleto correspondente + condição (ex: Lua Cheia).

static func eligible(player: Player) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for recipe in Balance.EVOLUTIONS:
		var weapon := player.encantos.get_weapon(recipe["base"])
		if weapon == null or not weapon.is_max_level():
			continue
		if not player.amulets.has_amuleto(recipe["amulet"]):
			continue
		if not _condition_met(recipe["condition"]):
			continue
		result.push_back(recipe)
	return result

static func _condition_met(condition: StringName) -> bool:
	match condition:
		&"":
			return true
		&"lua_cheia":
			return MoonCycleManager.is_full_moon()
	push_warning("Condição de evolução desconhecida: %s" % condition)
	return false

static func apply(recipe: Dictionary, player: Player) -> void:
	var new_data: EncantoData = load(recipe["result"])
	player.encantos.evolve(recipe["base"], new_data)
	EventBus.encanto_evolved.emit(new_data)
