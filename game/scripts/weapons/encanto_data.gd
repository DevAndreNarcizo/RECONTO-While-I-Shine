class_name EncantoData
extends Resource
## Definição de um Encanto (arma) — SÓ DADOS, por nível. A lógica fica nos
## scripts de behavior (scripts/weapons/behaviors/). Criar variações como .tres.

enum Behavior {
	MELEE_FRONTAL,   # Cipó Chicoteante
	PROJETIL_MIRA,   # Peixeira Voadora (futuro)
	ORBITAL,         # Vaga-lumes Guardiões
	AREA_PLAYER,     # Roda do Boitatá (futuro)
	SALTITANTE,      # Pedra do Saci
	RAIO,            # Relâmpago do Trovão
	CONVERSAO,       # Canto da Iara (inovação #2)
	INVOCACAO,       # Vela do Pastoreio (futuro)
	RAIZES,          # Cipó da Mãe-da-Mata (forma ancestral)
	MELEE_SAGRADO,   # Cipó Sagrado (forma ancestral que cura)
}

const MAX_LEVEL := 8

@export var id: StringName
@export var display_name := ""
@export_multiline var description := ""
@export var behavior: Behavior = Behavior.MELEE_FRONTAL
@export var icon: Texture2D

## Tabelas por nível — índice 0 = nível 1. Preencher as 8 posições no .tres.
@export var damage_by_level: Array[float] = []
@export var cooldown_by_level: Array[float] = []
@export var area_by_level: Array[float] = []   # multiplicador de tamanho
@export var amount_by_level: Array[int] = []   # projéteis/orbes/raios

func damage(level: int) -> float:
	return _at_f(damage_by_level, level, 10.0)

func cooldown(level: int) -> float:
	return _at_f(cooldown_by_level, level, 1.2)

func area(level: int) -> float:
	return _at_f(area_by_level, level, 1.0)

func amount(level: int) -> int:
	if amount_by_level.is_empty():
		return 1
	return amount_by_level[clampi(level, 1, amount_by_level.size()) - 1]

func _at_f(table: Array[float], level: int, fallback: float) -> float:
	if table.is_empty():
		return fallback
	return table[clampi(level, 1, table.size()) - 1]
