# 01 — Setup do Projeto (Godot 4)

> Objetivo: projeto Godot rodando, estrutura de pastas limpa, input configurado, câmera pronta.
> Pré-requisito: Godot 4.x instalado, pasta do jogo criada, `CLAUDE.md` + `docs/` copiados pra dentro dela,
> Claude Code aberto nessa pasta.

---

## PROMPT 1.1 — Contexto inicial (rode UMA vez no começo de cada sessão)

```
Leia os arquivos CLAUDE.md e tudo dentro de docs/ (01 a 05) para entender o projeto RECONTO:
um jogo Godot 4 estilo Vampire Survivors com tema de folclore brasileiro. NÃO escreva código ainda.
Apenas confirme que entendeu: me devolva em 5 bullets (a) o core loop, (b) os pilares de design,
(c) as 4 inovações, (d) a stack técnica e princípios de código, (e) a ordem do roadmap.
Vamos construir uma feature por vez, testando no Godot a cada passo.
```

🔬 **TESTE:** o Claude deve resumir corretamente. Se ele errar nomes (ex: chamar XP de "ouro"), corrija
antes de continuar — significa que não leu os docs.

---

## PROMPT 1.2 — Criar a estrutura do projeto Godot

```
Crie a estrutura base do projeto Godot 4 para o RECONTO seguindo os princípios do CLAUDE.md.

1. Configure o project.godot:
   - Nome: "RECONTO"
   - Renderizador: Mobile (ou GL Compatibility) para boa performance 2D
   - Resolução base 1920x1080, modo de janela "canvas_items" com aspect "expand"
   - Importação de texturas com filtro Nearest (pixel art) por padrão

2. Crie esta estrutura de pastas dentro de res://:
   /scenes        (cenas: player, inimigos, mundo, UI)
   /scripts       (scripts GDScript organizados por domínio)
   /scripts/autoload  (singletons)
   /resources     (recursos .tres: encantos, amuletos, inimigos)
   /assets/sprites, /assets/audio, /assets/ui, /assets/fonts
   /data          (tabelas/dicionários de balanceamento)

3. Crie os autoloads (singletons) VAZIOS mas registrados no project.godot, com TODO comentado:
   - GameState (estado da run atual e dados persistentes)
   - EventBus (sinais globais para baixo acoplamento)
   - SaveManager (salvar/carregar progresso)
   (MoonCycleManager e EnemySpawner virão depois.)

4. Configure o Input Map com as ações:
   - move_up, move_down, move_left, move_right (WASD + setas + analógico)
   - pause (ESC + Start)
   - confirm (Enter + A do gamepad)

5. Crie uma cena Main.tscn vazia que apenas mostra um fundo de cor e um texto "RECONTO - dev build",
   e defina-a como cena principal.

Explique a estrutura criada e como rodar (F5).
```

🔬 **TESTE:** aperte F5 no Godot. Deve abrir uma janela com o fundo e o texto. Sem erros no console.
💾 **COMMIT:** `git init && git add -A && git commit -m "setup: estrutura inicial do projeto Godot"`
➡️ **PRÓXIMO:** `02-core-loop.md`

---

## PROMPT 1.3 — .gitignore do Godot

```
Crie um .gitignore apropriado para projeto Godot 4 (ignore .godot/, exports, .import quando aplicável,
arquivos de SO). Adicione também um README.md curto na raiz do projeto explicando que é o jogo RECONTO
e como rodar.
```

💾 **COMMIT:** `git add -A && git commit -m "chore: gitignore e readme"`
