class_name LegendData
extends Resource
## Definição de uma Lenda jogável (docs/04 §1). Adicionar lendas novas =
## criar um .tres — a habilidade ativa é resolvida por active_id no player.

@export var id: StringName
@export var display_name := ""
@export_multiline var description := ""
@export var color := Color(0.25, 0.64, 0.3)  # cor do placeholder visual
@export var starting_encanto: EncantoData

@export_group("Modificadores de stat base")
@export var max_hp_bonus := 0.0
@export var move_speed_bonus := 0.0
@export var damage_mult_bonus := 0.0   # 0.1 = +10%
@export var luck_bonus := 0.0          # 0.1 = +10%
@export var regen_bonus := 0.0         # HP/s (passiva do Curupira)
@export var fire_immune := false       # Boitatá ignora queimadas (bioma reativo)

@export_group("Habilidade ativa")
@export var active_id: StringName      # vazio = sem ativa
@export var active_name := ""
@export_multiline var active_desc := ""
@export var active_cooldown := 12.0

@export_group("Desbloqueio")
@export var unlocked_by_default := false
@export var unlock_desc := ""  # ex: "1.000 Luar", "Vença o Cerrado"
@export var unlock_luar_cost := 0  # > 0 = comprável com Cristais de Luar
