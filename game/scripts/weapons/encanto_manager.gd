class_name EncantoManager
extends Node2D
## Gerencia os até 6 slots de Encanto do player: adiciona, sobe nível, consulta.

const MAX_SLOTS := 6

const BEHAVIOR_SCRIPTS := {
	EncantoData.Behavior.MELEE_FRONTAL: preload("res://scripts/weapons/behaviors/melee_frontal.gd"),
	EncantoData.Behavior.ORBITAL: preload("res://scripts/weapons/behaviors/orbital.gd"),
	EncantoData.Behavior.SALTITANTE: preload("res://scripts/weapons/behaviors/saltitante.gd"),
	EncantoData.Behavior.RAIO: preload("res://scripts/weapons/behaviors/raio.gd"),
	EncantoData.Behavior.RAIZES: preload("res://scripts/weapons/behaviors/raizes.gd"),
	EncantoData.Behavior.MELEE_SAGRADO: preload("res://scripts/weapons/behaviors/melee_sagrado.gd"),
	EncantoData.Behavior.CONVERSAO: preload("res://scripts/weapons/behaviors/conversao.gd"),
	EncantoData.Behavior.PROJETIL_MIRA: preload("res://scripts/weapons/behaviors/projetil_mira.gd"),
	EncantoData.Behavior.AREA_PLAYER: preload("res://scripts/weapons/behaviors/area_player.gd"),
}

var evolved_bases: Array[StringName] = []  # encantos que já viraram forma ancestral

var _weapons: Dictionary = {}  # id (StringName) → EncantoBase

@onready var player: Player = owner as Player

func add_encanto(data: EncantoData) -> bool:
	if _weapons.size() >= MAX_SLOTS or _weapons.has(data.id):
		return false
	if not BEHAVIOR_SCRIPTS.has(data.behavior):
		push_warning("Behavior sem script implementado: %s" % data.display_name)
		return false
	var weapon: EncantoBase = (BEHAVIOR_SCRIPTS[data.behavior] as GDScript).new()
	weapon.name = String(data.id)
	add_child(weapon)
	weapon.setup(data, player)
	_weapons[data.id] = weapon
	return true

func upgrade(id: StringName) -> void:
	if _weapons.has(id):
		(_weapons[id] as EncantoBase).level_up()

func get_weapon(id: StringName) -> EncantoBase:
	return _weapons.get(id)

func owned() -> Array:
	return _weapons.values()

func has_encanto(id: StringName) -> bool:
	return _weapons.has(id)

func has_free_slot() -> bool:
	return _weapons.size() < MAX_SLOTS

func was_evolved(id: StringName) -> bool:
	return evolved_bases.has(id)

## Ritual de Sincretismo: troca o encanto base pela FORMA ANCESTRAL (mesmo slot).
func evolve(base_id: StringName, new_data: EncantoData) -> void:
	if not _weapons.has(base_id):
		return
	(_weapons[base_id] as EncantoBase).queue_free()
	_weapons.erase(base_id)
	evolved_bases.push_back(base_id)
	var weapon: EncantoBase = (BEHAVIOR_SCRIPTS[new_data.behavior] as GDScript).new()
	weapon.name = String(new_data.id)
	add_child(weapon)
	weapon.setup(new_data, player)
	_weapons[new_data.id] = weapon
