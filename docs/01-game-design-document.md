# Game Design Document — RECONTO

**Versão:** 0.1 (conceito) · **Gênero:** Ação / Roguelite / Bullet Heaven (Survivors-like)
**Engine:** Godot 4.x · **Visão:** Top-down 2D pixel art · **Sessão de jogo:** ~30 min por run

---

## 1. Pitch de uma linha

> Você é uma lenda do folclore brasileiro. A **Corrupção** está devorando a mata. Sobreviva às hordas por
> 30 minutos, evolua seus encantos e expulse a praga de cada bioma do Brasil.

## 2. Pilares de design (as decisões que NÃO se quebram)

1. **Game feel acima de tudo.** Movimento fluido e responsivo + feedback de impacto satisfatório. Se o
   movimento e o "matar" não forem gostosos, nada mais importa. (Foco do protótipo.)
2. **Identidade folclórica em cada sistema.** Nenhuma mecânica é genérica: tudo tem nome, cor e sentido
   dentro do mundo (ver `02-lore.md`).
3. **O run está vivo.** A partida tem arco dramático (Ciclo da Lua), não é só "ficar 30 min apertando nada".
4. **Build expression.** O jogador deve sentir que *as escolhas dele* criaram a build — sinergias profundas.
5. **Respeito cultural como qualidade.** Homenagem, nunca caricatura.

## 3. O Core Loop (o coração do jogo)

### 3.1 Loop de segundos (gameplay momento-a-momento)
```
Mover (única entrada) → desviar de inimigos → encostar em inimigos = tomar dano
       ↑                                                                    │
       │                                                                    ▼
Coletar Sementes de Luz  ←  inimigos morrem (ataque AUTOMÁTICO das armas)  ←  armas disparam sozinhas
```
- **Entrada do jogador:** apenas movimento (WASD / setas / analógico). Sem botão de ataque.
- **Ataque:** automático, em intervalos por arma. Cada arma tem padrão próprio (frente, área, mira no
  inimigo mais próximo, orbital, etc.).
- **Dano ao jogador:** por contato/colisão com inimigos (e projéteis de inimigos avançados).

### 3.2 Loop de minutos (progressão dentro do run)
```
Matar inimigos → dropam Sementes de Luz → encher barra de XP → SOBE DE NÍVEL
       → o tempo congela → escolher 1 de 3-4 cartas (arma nova OU melhorar arma OU amuleto)
       → voltar mais forte → inimigos ficam mais densos/fortes → repetir
```
- A cada **subida de nível**: 3 a 4 opções. Tipos de carta:
  - **Novo Encanto** (arma) — até 6 slots de arma.
  - **Melhorar Encanto** (sobe nível de uma arma que já tem).
  - **Amuleto** (passiva: +dano, +velocidade, +área, +vida, +sorte, etc.) — até 6 slots.
  - **Reroll / Banir / Pular** (desbloqueáveis na meta).

### 3.3 Loop de partida (a run de 30 min)
| Tempo | Fase do Ciclo da Lua | O que acontece |
|------:|----------------------|----------------|
| 0–6 min   | 🌆 Crepúsculo  | Inimigos fracos e esparsos. Montar base da build. |
| 6–14 min  | 🌙 Noite       | Densidade sobe. Primeiros mini-bosses. Primeiras evoluções. |
| 14–20 min | 🌕 Lua Cheia   | PICO: inimigos lunares (Lobisomem/Mula) explodem de força. Tela cheia. |
| 20–26 min | 🌌 Madrugada   | Inimigos do rio/água (Boto). Hordas em corredores. |
| 26–30 min | 🌅 Alvorada    | Build no auge. Onda final massiva. |
| 30:00     | ☀️ **BOSS / Ceifador** | Boss do bioma OU o "Tempo Esgotado" vira inimigo (Ceifador da Corrupção). Vencer = limpar o bioma. |

### 3.4 Loop de meta (entre runs — o que traz o jogador de volta)
```
Morrer/Vencer → ganhar Cristais de Luar (moeda permanente, baseada em desempenho)
   → gastar na ÁRVORE SAGRADA (upgrades permanentes) + desbloquear lendas/biomas/amuletos
   → escolher nova lenda + bioma → run mais forte → repetir
```
- **Cristais de Luar** = moeda permanente (≈ ouro do VS).
- **Árvore Sagrada** = menu de meta-progressão (mais vida base, +sorte, slots de reroll, etc.).
- Desbloqueios por **conquistas** (matar X, sobreviver Y, evoluir tal encanto).

## 4. Sistemas principais (resumo — detalhe em `03-mecanicas-detalhadas.md`)

| Sistema | Função |
|---|---|
| **Encantos** (armas) | Atacam sozinhos. Sobem de nível 1→8. No nível máx, podem evoluir. |
| **Amuletos** (passivas) | Bônus de stats. Também necessários para evoluir encantos. |
| **Ritual de Sincretismo** | Evolução: Encanto nível máx + Amuleto correspondente + condição (ex: Lua Cheia) → forma suprema. |
| **Ciclo da Lua** | Fases temporais que buffam/nerfam lendas e inimigos. (Inovação #1) |
| **Encantar a horda** | Algumas habilidades convertem inimigos em aliados temporários. (Inovação #2) |
| **Bioma Reativo** | Hazards dinâmicos: fogo se espalha, rio transborda, fendas abrem. (Inovação #4) |
| **Simpatias** (Arcanas) | Cartas que mudam regras da partida inteira. |
| **Meta-progressão** | Cristais de Luar + Árvore Sagrada + desbloqueios. |

## 5. Stats do personagem (base — para balancear)

| Stat | Descrição | Valor inicial sugerido |
|---|---|---|
| Vida (HP) | Pontos de vida | 100 |
| Recuperação | HP/segundo | 0 |
| Armadura | Reduz dano por hit | 0 |
| Velocidade Mov. | Pixels/seg | 60 |
| Dano (%) | Multiplicador global | 100% |
| Velocidade de Ataque (%) | Reduz cooldown | 100% |
| Área (%) | Tamanho dos ataques | 100% |
| Duração (%) | Tempo dos efeitos | 100% |
| Quantidade | Projéteis extras | +0 |
| Velocidade Projétil (%) | | 100% |
| Sorte | Chance de drops/evoluções/rerolls | 100% |
| Magnetismo | Raio de coleta de Sementes | 50 px |
| Ganho de XP (%) | | 100% |
| Ganho de Luar (%) | | 100% |

> **Regra de balanceamento:** stats globais (%) afetam TODOS os encantos. Por isso amuletos de "+Área"
> são fortes — eles escalam tudo. Cuidar para não trivializar.

## 6. Condições de vitória e derrota

- **Vitória do run:** sobreviver aos 30 min e derrotar o boss do bioma (ou sobreviver à onda final).
- **Derrota:** HP chega a 0. Run encerra, calcula Cristais de Luar ganhos.
- **Progressão de mundo:** vencer um bioma desbloqueia o próximo + avança a narrativa (`02-lore.md`).

## 7. Controles

| Ação | Teclado | Gamepad |
|---|---|---|
| Mover | WASD / Setas | Analógico esquerdo |
| Pausar | ESC | Start |
| Confirmar (level up) | Enter / Clique | A |
| (Opcional) Habilidade ativa da lenda | Espaço | A / RT |

> **Nota:** o VS clássico é 100% movimento. Vamos permitir **1 habilidade ativa por lenda** (cooldown),
> que dá identidade sem quebrar a simplicidade. (Ex: dash do Saci.) Opcional — pode ficar pra v2.

## 8. Escopo da v1.0 (Steam) vs protótipo

- **Protótipo jogável (semana 1-2):** 1 lenda, 1 bioma, 3 encantos, XP+level up, spawn, 1 boss. Provar o feel.
- **Vertical slice (mês 1-2):** 1 bioma 100% polido + Ciclo da Lua + 1 inovação + meta básica.
- **v1.0 (Steam):** 7 biomas, 8-10 lendas, ~20 encantos, árvore de evolução, todas as 4 inovações.

Ver `05-roadmap.md` para a ordem exata de construção.
