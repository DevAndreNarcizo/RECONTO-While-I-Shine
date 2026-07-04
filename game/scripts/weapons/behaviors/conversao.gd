class_name EncantoConversao
extends EncantoBase
## CONVERSAO — Canto da Iara (inovação #2): o canto LEMBRA a criatura de quem
## ela era. Encanta o(s) inimigo(s) mais forte(s) por perto, que lutam ao seu
## lado até a Luz se esgotar. Duração escala com o stat Duração (amuletos).

const RANGE := 340.0
const BASE_DURATION := 6.0

func _attack() -> void:
	var reach := RANGE * area()
	var candidates: Array[Enemy] = []
	for e in EnemySpawner.active_enemies():
		if e.charmed_t <= 0.0 and e.hp > 0.0 \
				and player.global_position.distance_squared_to(e.global_position) < reach * reach:
			candidates.push_back(e)
	if candidates.is_empty():
		return
	candidates.sort_custom(func(a, b): return a.hp > b.hp)  # os mais fortes primeiro
	var converted := 0
	for e in candidates:
		if converted >= amount():
			break
		if EnemySpawner.charm_enemy(e, BASE_DURATION * player.stats.duration_mult):
			EventBus.ability_cast.emit(e.global_position, 30.0)  # anel no convertido
			converted += 1
