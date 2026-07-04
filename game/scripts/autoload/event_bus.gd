extends Node
## EventBus — barramento global de sinais (baixo acoplamento entre sistemas).
## Regra: sistemas EMITEM e ESCUTAM sinais daqui; nunca chamam uns aos outros direto.

# --- Inimigos / combate ---
signal enemy_killed(enemy: Node2D)
signal damage_dealt(position: Vector2, amount: float)

# --- Juice / feedback ---
signal seed_collected(position: Vector2)
signal screen_shake(strength: float)
signal ability_cast(position: Vector2, radius: float)

# --- Bioma reativo (inovação #4) ---
signal fire_started(position: Vector2)

# --- Player ---
signal player_damaged(hp: float, max_hp: float)
signal player_died

# --- Progressão (Sementes de Luz / XP) ---
signal xp_changed(xp: float, xp_to_next: float, level: int)
signal level_up_ready(level: int)
signal encanto_evolved(data: EncantoData)

# --- Ciclo da Lua (inovação #1) ---
signal moon_phase_changed(phase_index: int)

# --- Bosses ---
signal miniboss_time
signal boss_time
signal boss_spawned(boss: Node2D)
signal boss_defeated

# --- Run ---
signal run_ended(victory: bool)

# TODO(fase 4): sinais do Ciclo da Lua (phase_changed) virão com o MoonCycleManager.
