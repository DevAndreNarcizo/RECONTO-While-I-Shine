class_name EncantoManager
extends Node2D
## Gerencia os até 6 slots de Encanto do player: adiciona, sobe nível, consulta.

const MAX_SLOTS := 6

const BEHAVIOR_SCRIPTS := {
	EncantoData.Behavior.MELEE_FRONTAL: preload("res://scripts/weapons/behaviors/melee_frontal.gd"),
	EncantoData.Behavior.ORBITAL: preload("res://scripts/weapons/behaviors/orbital.gd"),
	EncantoData.Behavior.SALTITANTE: preload("res://scripts/weapons/behaviors/saltitante.gd"),
	EncantoData.Behavior.RAIO: preload("res://scripts/weapons/behaviors/raio.gd"),
}

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
