class_name AmuletoData
extends Resource
## Definição de um Amuleto (passiva) — bônus POR NÍVEL (efeito = valor × nível).

const MAX_LEVEL := 5

@export var id: StringName
@export var display_name := ""
@export_multiline var description := ""
@export var icon: Texture2D

@export_group("Bônus por nível")
@export var max_hp_per_level := 0.0
@export var recovery_per_level := 0.0        # HP/s
@export var armor_per_level := 0.0
@export var move_speed_per_level := 0.0      # px/s
@export var damage_pct_per_level := 0.0      # 8.0 = +8%
@export var attack_speed_pct_per_level := 0.0
@export var area_pct_per_level := 0.0
@export var duration_pct_per_level := 0.0
@export var projectile_speed_pct_per_level := 0.0
@export var luck_pct_per_level := 0.0
@export var magnetism_per_level := 0.0       # px
@export var xp_pct_per_level := 0.0
## Níveis do amuleto que concedem +1 Quantidade (ex: [3, 5]).
@export var amount_at_levels: Array[int] = []

# TODO(balanceamento): Sal Grosso reflete 5% do dano de contato — implementar
# junto com o passe de defesa (doc 06 §4).
