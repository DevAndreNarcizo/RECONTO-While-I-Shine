class_name Balance
## Tabelas de balanceamento — só dados/fórmulas, sem estado.
## Regra do GDD §5: ajustar aqui, não espalhar números pelo código.

const XP_BASE := 5.0
const XP_GROWTH := 1.2  # cada nível exige ~20% mais

# Duração da run (GDD §3.3). DEV_MODE encurta para testar rápido.
const DEV_MODE := true
const RUN_DURATION := 30.0 * 60.0
const DEV_RUN_DURATION := 5.0 * 60.0

# --- Cristais de Luar (meta) ---
const LUAR_DROP_CHANCE := 0.05  # chance de inimigo dropar 1 fragmento

# --- Ritual de Sincretismo (Inovação #3 — docs/03 §1) ---
# Receitas: encanto no nível MÁX + amuleto (qualquer nível) + condição opcional.
# Receitas com condição vêm PRIMEIRO (têm prioridade quando várias são elegíveis).
const EVOLUTIONS := [
	{"base": &"cipo_chicoteante", "amulet": &"fita_do_bonfim", "condition": &"lua_cheia",
		"result": "res://resources/encantos/cipo_sagrado.tres"},
	{"base": &"cipo_chicoteante", "amulet": &"figa", "condition": &"",
		"result": "res://resources/encantos/cipo_mae_da_mata.tres"},
]

# --- Curva de spawn da Mata Atlântica (docs/03 §4) ---
# "from" é FRAÇÃO da run (0..1) — funciona igual em run de 5 min (dev) e 30 min.
# "rate" = inimigos/segundo. "weights" = sorteio ponderado dos tipos ativos.
const MATA_SPAWN_TABLE := [
	{"from": 0.00, "rate": 1.5, "weights": {&"firefly": 6.0, &"cutia": 3.0}},
	{"from": 0.20, "rate": 3.5, "weights": {&"firefly": 5.0, &"cutia": 3.0, &"macaco": 2.5, &"sapo": 1.0}},
	{"from": 0.45, "rate": 6.0, "weights": {&"firefly": 4.0, &"cutia": 3.0, &"macaco": 3.0, &"sapo": 2.0, &"tamandua": 1.0, &"elite": 0.2}},
	{"from": 0.65, "rate": 9.0, "weights": {&"firefly": 3.0, &"cutia": 3.0, &"macaco": 3.5, &"sapo": 2.5, &"tamandua": 1.5, &"elite": 0.4}},
	{"from": 0.85, "rate": 13.0, "weights": {&"firefly": 3.0, &"cutia": 3.0, &"macaco": 4.0, &"sapo": 3.0, &"tamandua": 2.0, &"elite": 0.6}},
]

# Ondas temáticas: a cada fração da run, um grupo do mesmo tipo cerca o player.
const WAVE_INTERVAL_FRAC := 0.12
const WAVE_COUNT := 14

# Bosses: mini-boss na fração da run (0.35 ≈ min 10.5 de 30); boss no fim.
const MINIBOSS_FRAC := 0.35

# Encantar a horda (Inovação #2): máximo de aliados encantados simultâneos.
const CHARM_LIMIT := 10

# --- Ciclo da Lua (Inovação #1 — docs/01 §3.3 e docs/03 §1) ---
# "from" em FRAÇÃO da run (janelas do GDD: 0-6, 6-14, 14-20, 20-26, 26-30 min).
# Multiplicadores globais por fase; o tint vai num CanvasModulate (não afeta o HUD).
const MOON_PHASES := [
	{"id": &"crepusculo", "name": "Crepúsculo", "icon": "🌆", "from": 0.0,
		"tint": Color(1.0, 0.87, 0.78), "spawn_mult": 0.8, "enemy_hp_mult": 1.0,
		"enemy_damage_mult": 1.0, "regen_bonus": 0.0},
	{"id": &"noite", "name": "Noite", "icon": "🌙", "from": 0.2,
		"tint": Color(0.72, 0.78, 1.0), "spawn_mult": 1.0, "enemy_hp_mult": 1.0,
		"enemy_damage_mult": 1.0, "regen_bonus": 0.0},
	{"id": &"lua_cheia", "name": "Lua Cheia", "icon": "🌕", "from": 0.4667,
		"tint": Color(0.92, 0.95, 1.0), "spawn_mult": 1.3, "enemy_hp_mult": 1.25,
		"enemy_damage_mult": 1.25, "regen_bonus": 0.0},
	{"id": &"madrugada", "name": "Madrugada", "icon": "🌌", "from": 0.6667,
		"tint": Color(0.55, 0.6, 0.85), "spawn_mult": 1.1, "enemy_hp_mult": 1.1,
		"enemy_damage_mult": 1.1, "regen_bonus": 0.0},
	{"id": &"alvorada", "name": "Alvorada", "icon": "🌅", "from": 0.8667,
		"tint": Color(1.0, 0.88, 0.72), "spawn_mult": 0.9, "enemy_hp_mult": 0.75,
		"enemy_damage_mult": 0.75, "regen_bonus": 0.5},
]

## Upgrades permanentes da Árvore Sagrada. Os valores aplicados por nível
## estão em SaveManager.apply_tree_bonuses() — manter os textos em sincronia.
const TREE_UPGRADES := {
	&"vida": {"name": "Raiz Funda", "desc": "+10 de Vida Máxima por nível", "max_level": 5, "base_cost": 10},
	&"dano": {"name": "Seiva Brava", "desc": "+5% de Dano por nível", "max_level": 5, "base_cost": 15},
	&"velocidade": {"name": "Vento nas Folhas", "desc": "+3 de Velocidade por nível", "max_level": 5, "base_cost": 12},
	&"sorte": {"name": "Trevo da Copa", "desc": "+5% de Sorte por nível", "max_level": 5, "base_cost": 15},
	&"magnetismo": {"name": "Chamado da Luz", "desc": "+15 de Magnetismo por nível", "max_level": 5, "base_cost": 8},
	&"armadura": {"name": "Casca Grossa", "desc": "+1 de Armadura por nível", "max_level": 3, "base_cost": 25},
	&"luar": {"name": "Luar Fértil", "desc": "+10% de ganho de Luar por nível", "max_level": 5, "base_cost": 20},
}

static func xp_for_level(level: int) -> float:
	return ceilf(XP_BASE * pow(XP_GROWTH, level - 1))

static func run_duration() -> float:
	return DEV_RUN_DURATION if DEV_MODE else RUN_DURATION

## Luar ganho ao fim da run: fragmentos coletados + desempenho (kills, nível).
static func luar_for_run(run_luar: int, kills: int, level: int, luar_mult: float) -> int:
	return int(roundf((run_luar + kills / 20.0 + level) * luar_mult))
