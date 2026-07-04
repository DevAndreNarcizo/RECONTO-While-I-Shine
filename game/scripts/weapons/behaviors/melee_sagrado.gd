class_name EncantoMeleeSagrado
extends EncantoMeleeFrontal
## Forma ancestral MELEE_SAGRADO — Cipó Sagrado: cura o player a cada
## inimigo atingido (Ritual: Cipó máx + Fita do Bonfim + Lua Cheia).

const HEAL_PER_HIT := 1.0

func _attack() -> void:
	super()
	if _last_hits > 0:
		player.heal(HEAL_PER_HIT * _last_hits)

func _hit_color() -> Color:
	return Color(0.95, 0.85, 0.4, 0.75)  # dourado sagrado
