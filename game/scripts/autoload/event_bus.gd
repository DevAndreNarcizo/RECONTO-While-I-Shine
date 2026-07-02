extends Node
## EventBus — barramento global de sinais (baixo acoplamento entre sistemas).
## Regra: sistemas EMITEM e ESCUTAM sinais daqui; nunca chamam uns aos outros direto.

# --- Inimigos / combate ---
signal enemy_killed(enemy: Node2D)

# --- Player ---
signal player_damaged(hp: float, max_hp: float)
signal player_died

# --- Progressão (Sementes de Luz / XP) ---
signal xp_changed(xp: float, xp_to_next: float, level: int)
signal level_up_ready(level: int)

# --- Run ---
signal run_ended(victory: bool)

# TODO(fase 4): sinais do Ciclo da Lua (phase_changed) virão com o MoonCycleManager.
