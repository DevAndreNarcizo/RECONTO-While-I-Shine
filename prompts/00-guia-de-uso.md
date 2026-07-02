# 00 — Guia de Uso dos Prompts (COMECE AQUI)

> Estes arquivos contêm prompts **prontos para copiar e colar** no Claude Code, na ordem certa.
> Cada prompt está em um bloco de código. Copie o bloco inteiro.

---

## Antes de tudo: o que instalar

1. **Godot 4.x** — baixe em https://godotengine.org/download (versão Standard, GDScript).
2. **Git** — para versionar (https://git-scm.com). Permite voltar atrás quando algo quebrar.
3. **Claude Code** — você já tem.
4. (Opcional) **Python/Node** — só se algum prompt pedir tooling; o Claude avisa.

## Como usar (fluxo)

1. Crie uma pasta para o jogo (ex: `~/EncantadosGame`).
2. **Copie** o `CLAUDE.md` e a pasta `docs/` (de `/var/www/Jogo-2D/`) para dentro dessa pasta do jogo.
3. Abra o **Claude Code dentro da pasta do jogo** (modo *code*, não chat).
4. Siga os arquivos de prompt **NESTA ORDEM**:
   - `01-setup-projeto.md`
   - `02-core-loop.md`  ← a parte mais importante (game feel)
   - `03-sistemas.md`
   - `04-conteudo.md`
   - `05-inovacoes.md`
   - `sprites-arte/06-sprites-higgsfield.md` e `07-itch-io-guia.md`
5. **Um prompt por vez.** Teste no Godot, faça commit, só então o próximo.

## Regras de ouro (pra não dar errado como no vídeo do YouTube)

- ✅ **Vá devagar e teste.** Não cole 10 prompts seguidos. Cada feature → testar → commit.
- ✅ **Sempre mande o Claude ler os docs.** Os prompts já pedem isso; mantenha.
- ✅ **Descreva bugs com precisão:** "esperava X, aconteceu Y, nessa situação Z" — não só "tá bugado".
- ✅ **Faça commit a cada vitória.** `git add -A && git commit -m "core loop ok"`. É seu botão de desfazer.
- ✅ **Game feel primeiro, arte depois.** Caixas coloridas que se movem bem > arte linda que trava.
- ❌ **Não peça "crie o jogo inteiro".** Vira lixo. O valor está em construir camada por camada.

## Sobre o modelo do Claude Code

- Para **código e arquitetura**: use o modelo mais capaz disponível (Opus). Ótimo em Godot/GDScript.
- Para **pixel art**: o Claude **não** gera pixel art boa. Use itch.io (assets prontos) + Higgs Field/IA de
  imagem (ver pasta `sprites-arte/`). O Claude integra os assets no jogo.

## Convenção dos prompts

- `>>> PROMPT` = bloco para colar no Claude Code.
- `🔬 TESTE` = como verificar se funcionou.
- `💾 COMMIT` = sugestão de commit.
- `➡️ PRÓXIMO` = o que vem depois.
