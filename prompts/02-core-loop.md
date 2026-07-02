# 02 — Core Loop / Game Feel ⭐ (A PARTE MAIS IMPORTANTE)

> Aqui nasce a alma do jogo. Se "andar e matar" não for gostoso, nada mais importa.
> Construa cada prompt, TESTE de verdade jogando 1-2 min, ajuste, só então avance.

---

## PROMPT 2.1 — Player com movimento fluido + câmera

```
Implemente o Player do Encantados (placeholder por enquanto: um círculo/quadrado colorido com um pequeno
indicador de direção).

Requisitos:
- CharacterBody2D chamado Player, em scenes/player/Player.tscn + scripts/player/player.gd
- Movimento top-down 8 direções usando as ações de input (move_*). Movimento normalizado (diagonal não
  é mais rápido). Velocidade vinda de uma variável `move_speed` (padrão 60, configurável).
- Movimento SUAVE: pequena aceleração/desaceleração (lerp) para não ser robótico, mas ainda responsivo.
- O Player guarda a "direção de facing" (última direção de movimento) — vamos usar para armas frontais.
- Camera2D filha do Player, com leve smoothing (position_smoothing_enabled), seguindo o player.
- Stats base num recurso ou dicionário (HP=100, etc., conforme docs/01 §5), mas só HP e move_speed por ora.

Crie um Mundo de teste (scenes/world/World.tscn) com um chão tileado/repetido (use um TileMap simples ou um
fundo que se repete) grande o suficiente para andar bastante, e coloque o Player nele. Faça World ser a cena
principal por enquanto.

Foque no FEEL: o movimento precisa ser fluido e gostoso. Explique como ajustar aceleração e velocidade.
```

🔬 **TESTE:** ande pelo mapa por 1 min. O movimento é fluido? Responsivo? A câmera acompanha bem?
Ajuste `move_speed`, smoothing e aceleração até ficar gostoso. **Não avance até estar bom.**
💾 **COMMIT:** `feat: player com movimento fluido e camera`

---

## PROMPT 2.2 — Inimigos que perseguem (com pooling)

```
Implemente o sistema de inimigos do tipo "Enxame" (placeholder: círculos vermelhos).

Requisitos:
- Cena scenes/enemies/Enemy.tscn (CharacterBody2D ou Area2D + movimento manual) + scripts/enemies/enemy.gd
- Comportamento: perseguir o Player (mover-se na direção dele a cada frame), velocidade configurável.
- Stats: HP (1 para enxame), dano de contato, velocidade. Vindos de um EnemyData (Resource .tres) para ficar
  fácil criar variações depois.
- IMPORTANTE: use OBJECT POOLING. Crie um autoload/manager EnemySpawner que mantém um pool de inimigos
  reutilizáveis (não instanciar/queue_free em loop). Inimigos "mortos" voltam ao pool.
- O EnemySpawner spawna inimigos em intervalos, em posições FORA da tela ao redor do Player (num anel), para
  eles entrarem na visão. Taxa de spawn configurável (comece com ~2/seg).
- Colisão inimigo↔player: o player toma dano (com pequeno cooldown de invencibilidade ~0.5s para não perder
  toda a vida de uma vez). Quando HP do player chega a 0, por ora só imprima "GAME OVER" e pause.
- Garanta performance para centenas de inimigos: evite _process pesado, use grupos/camadas de física.

Mostre na tela (label de debug) a contagem de inimigos ativos e o HP do player.
```

🔬 **TESTE:** os inimigos te perseguem? Tomar dano funciona? Suba a taxa de spawn pra 300+ inimigos —
o FPS aguenta? (Veja o monitor de performance do Godot.) Se cair muito, peça otimização.
💾 **COMMIT:** `feat: inimigos perseguidores com object pooling`

---

## PROMPT 2.3 — Primeira arma automática (Cipó Chicoteante)

```
Implemente o primeiro Encanto (arma): o "Cipó Chicoteante" do Curupira (placeholder: um retângulo/arco que
aparece rapidamente na direção de facing do player).

Requisitos:
- Ataque AUTOMÁTICO: dispara sozinho em intervalos (cooldown configurável, ~1.2s). O jogador NÃO aperta botão.
- Padrão: acerta numa área à frente do player, na direção de facing (igual ao chicote do Vampire Survivors).
- Causa dano aos inimigos na área; inimigo com HP<=0 morre (volta ao pool) e (próximo prompt) dropa XP.
- Arquitetura: crie uma base de Encanto reutilizável (classe/recurso) com campos: dano, cooldown, área,
  quantidade, nível. O Cipó é a primeira implementação concreta. Pense que teremos ~20 encantos diferentes,
  então a base deve ser extensível (projétil, orbital, área, etc. virão depois).
- Feedback de impacto (juice básico): inimigo pisca branco ao tomar dano e some com um pequeno efeito.

Não implemente XP ainda — só matar inimigos. Explique como ajustar dano/cooldown/área.
```

🔬 **TESTE:** a arma ataca sozinha? Mata inimigos? O impacto é satisfatório? Ajuste o "feel" do ataque.
💾 **COMMIT:** `feat: primeiro encanto automatico (cipo)`

---

## PROMPT 2.4 — Sementes de Luz, XP e barra de nível

```
Implemente o sistema de experiência (Sementes de Luz).

Requisitos:
- Quando um inimigo morre, dropa uma "Semente de Luz" (placeholder: pequeno losango/círculo brilhante). Use
  pooling também para os drops.
- O Player tem um raio de MAGNETISMO: sementes dentro do raio voam até ele e são coletadas. Coletar dá XP.
- Barra de XP na tela (HUD). Ao encher: SOBE DE NÍVEL.
- Curva de XP: cada nível exige mais (ex: base 5, crescendo ~20% por nível). Configurável em /data.
- Ao subir de nível: o jogo PAUSA (get_tree().paused, mas a UI continua) e mostra uma tela de Level Up.
  Por ora a tela mostra 3 cartas placeholder ("+Dano", "+Velocidade", "+Cipó nível"); escolher uma aplica
  o efeito e despausa. (No próximo arquivo de prompts isso vira o sistema real de cartas.)

Garanta que pausar/despausar não quebre o pooling nem os timers das armas.
```

🔬 **TESTE:** matar → semente cai → ela voa pra você → barra enche → level up pausa e mostra 3 opções →
escolher aplica e volta. O loop fecha?
💾 **COMMIT:** `feat: sementes de luz, xp e tela de level up`

---

## PROMPT 2.5 — Timer da run + HUD básico + fim de run

```
Implemente a estrutura de uma RUN.

Requisitos:
- Timer de run de 30 minutos (configurável; use 5 min em modo dev para testar rápido — exponha uma const).
- HUD: tempo decorrido (mm:ss), HP, barra de XP, nível atual, contador de inimigos mortos.
- Fim de run: quando o HP chega a 0 OU o tempo acaba, mostre uma tela de resumo (tempo sobrevivido,
  inimigos mortos, nível alcançado) com botão "Voltar ao início" (por ora recarrega a cena).
- Organize o estado da run no GameState (autoload): tempo, kills, nível, etc.

Explique como mudar a duração da run para testes.
```

🔬 **TESTE:** rode uma run de 5 min (modo dev). Tudo funciona do início ao fim? A tela de resumo aparece?
💾 **COMMIT:** `feat: estrutura de run, hud e tela de fim`

➡️ **CHECKPOINT IMPORTANTE:** agora você tem um Vampire Survivors minúsculo, mas COMPLETO e jogável.
Jogue por 5-10 min. É divertido? O que falta pro feel ficar bom? Ajuste ANTES de seguir para `03-sistemas.md`.
