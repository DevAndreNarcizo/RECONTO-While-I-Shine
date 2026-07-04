extends Node
## MoonCycleManager — Inovação #1: a run é uma NOITE com 5 fases (Balance.MOON_PHASES).
## Deriva a fase da fração da run (stateless) e emite moon_phase_changed na virada.

var current_index := -1

func _process(_delta: float) -> void:
	if not GameState.run_active:
		return
	var frac := clampf(GameState.run_time / Balance.run_duration(), 0.0, 1.0)
	var idx := _index_for_frac(frac)
	if idx != current_index:
		current_index = idx
		EventBus.moon_phase_changed.emit(idx)

func _index_for_frac(frac: float) -> int:
	var idx := 0
	for i in Balance.MOON_PHASES.size():
		if frac >= float(Balance.MOON_PHASES[i]["from"]):
			idx = i
	return idx

func phase() -> Dictionary:
	return Balance.MOON_PHASES[maxi(current_index, 0)]

func is_full_moon() -> bool:
	return phase()["id"] == &"lua_cheia"

func spawn_mult() -> float:
	return float(phase()["spawn_mult"])

func enemy_hp_mult() -> float:
	return float(phase()["enemy_hp_mult"])

func enemy_damage_mult() -> float:
	return float(phase()["enemy_damage_mult"])

func regen_bonus() -> float:
	return float(phase()["regen_bonus"])

## Segundos até a próxima fase (na Alvorada, até o boss).
func time_to_next() -> float:
	var duration := Balance.run_duration()
	var i := maxi(current_index, 0)
	if i >= Balance.MOON_PHASES.size() - 1:
		return maxf(0.0, duration - GameState.run_time)
	return maxf(0.0, float(Balance.MOON_PHASES[i + 1]["from"]) * duration - GameState.run_time)
