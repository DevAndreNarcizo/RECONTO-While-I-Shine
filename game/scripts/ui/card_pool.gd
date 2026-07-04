class_name CardPool
## Sorteio das cartas de level up — LÓGICA PURA, sem UI (fácil de testar/balancear).
## Carta = Dictionary {type, data, title, desc}.

const ENCANTOS: Array = [
	preload("res://resources/encantos/cipo_chicoteante.tres"),
	preload("res://resources/encantos/vagalumes_guardioes.tres"),
	preload("res://resources/encantos/pedra_do_saci.tres"),
	preload("res://resources/encantos/relampago_do_trovao.tres"),
	preload("res://resources/encantos/canto_da_iara.tres"),
	preload("res://resources/encantos/peixeira_voadora.tres"),
	preload("res://resources/encantos/roda_do_boitata.tres"),
]

const AMULETOS: Array = [
	preload("res://resources/amuletos/figa.tres"),
	preload("res://resources/amuletos/pena_de_tucano.tres"),
	preload("res://resources/amuletos/galho_de_arruda.tres"),
	preload("res://resources/amuletos/sal_grosso.tres"),
	preload("res://resources/amuletos/chocalho.tres"),
	preload("res://resources/amuletos/fita_do_bonfim.tres"),
	preload("res://resources/amuletos/po_de_estrela.tres"),
	preload("res://resources/amuletos/espelho_dagua.tres"),
	preload("res://resources/amuletos/olho_de_boi.tres"),
	preload("res://resources/amuletos/couro_de_anta.tres"),
	preload("res://resources/amuletos/mel_de_jatai.tres"),
]

# Pesos do sorteio (balancear aqui)
const W_NEW_ENCANTO := 10.0
const W_UPGRADE_ENCANTO := 12.0
const W_NEW_AMULETO := 9.0
const W_UPGRADE_AMULETO := 10.0
const W_HEAL := 2.5
const W_XP := 2.0

static func roll(player: Player, rng: RandomNumberGenerator) -> Array[Dictionary]:
	var options := build_options(player)
	var count := 3
	# Sorte acima de 100% = chance proporcional de uma 4ª carta
	if rng.randf() < (player.stats.luck - 1.0):
		count = 4
	var cards: Array[Dictionary] = []
	while cards.size() < count and not options.is_empty():
		var total := 0.0
		for o in options:
			total += o["weight"]
		var pick := rng.randf() * total
		for i in options.size():
			pick -= options[i]["weight"]
			if pick <= 0.0:
				cards.push_back(options[i])
				options.remove_at(i)
				break
	return cards

## Monta o pool VÁLIDO: nunca oferece melhorar o que não se tem, nem novo sem slot.
static func build_options(player: Player) -> Array[Dictionary]:
	var opts: Array[Dictionary] = []

	for data in ENCANTOS:
		var e := data as EncantoData
		if player.encantos.was_evolved(e.id):
			continue  # já virou forma ancestral — não oferecer de novo
		if player.encantos.has_encanto(e.id):
			var weapon := player.encantos.get_weapon(e.id)
			if not weapon.is_max_level():
				opts.push_back({
					"type": "upgrade_encanto", "data": e, "weight": W_UPGRADE_ENCANTO,
					"title": "⬆ %s" % e.display_name,
					"desc": "Nível %d → %d" % [weapon.level, weapon.level + 1],
				})
		elif player.encantos.has_free_slot():
			opts.push_back({
				"type": "new_encanto", "data": e, "weight": W_NEW_ENCANTO,
				"title": "✦ %s" % e.display_name,
				"desc": e.description,
			})

	for data in AMULETOS:
		var a := data as AmuletoData
		var lv := player.amulets.level_of(a.id)
		if lv > 0:
			if lv < AmuletoData.MAX_LEVEL:
				opts.push_back({
					"type": "upgrade_amuleto", "data": a, "weight": W_UPGRADE_AMULETO,
					"title": "⬆ %s" % a.display_name,
					"desc": "Nível %d → %d" % [lv, lv + 1],
				})
		elif player.amulets.has_free_slot():
			opts.push_back({
				"type": "new_amuleto", "data": a, "weight": W_NEW_AMULETO,
				"title": "◈ %s" % a.display_name,
				"desc": a.description,
			})

	if player.hp < player.stats.max_hp:
		opts.push_back(_heal_card())
	opts.push_back({
		"type": "xp", "data": null, "weight": W_XP,
		"title": "Punhado de Sementes", "desc": "+10 Sementes de Luz na hora.",
	})
	return opts

static func apply(card: Dictionary, player: Player) -> void:
	match card["type"]:
		"new_encanto":
			player.encantos.add_encanto(card["data"])
		"upgrade_encanto":
			player.encantos.upgrade((card["data"] as EncantoData).id)
		"new_amuleto":
			player.amulets.add(card["data"])
		"upgrade_amuleto":
			player.amulets.upgrade((card["data"] as AmuletoData).id)
		"heal":
			player.heal(player.stats.max_hp * 0.3)
		"xp":
			GameState.add_xp(10.0)

## Fallback quando tudo está no máximo: sempre há o que escolher.
static func _heal_card() -> Dictionary:
	return {
		"type": "heal", "data": null, "weight": W_HEAL,
		"title": "Fruta da Mata", "desc": "Recupera 30% da vida.",
	}

static func fallback_card() -> Dictionary:
	return _heal_card()
