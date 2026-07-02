# Roadmap de Desenvolvimento — RECONTO

> A ORDEM importa. Não construa o jogo todo de uma vez. Cada fase deve resultar em algo **jogável e testado**
> antes de seguir. Esta ordem casa 1:1 com os arquivos de `prompts/`.

---

## Princípio: vertical slice primeiro

Construa **1 fatia vertical completa** (1 lenda, 1 bioma, poucos sistemas, mas polida e divertida) antes de
expandir em largura. Se a fatia não for divertida, expandir não resolve.

---

## Fase 0 — Setup (prompt `01-setup-projeto.md`)
- [ ] Instalar Godot 4.x.
- [ ] Criar projeto, estrutura de pastas, `CLAUDE.md` do projeto.
- [ ] Configurar input map (mover/pausar), resolução, câmera.
- **Resultado:** projeto vazio rodando, tela limpa.

## Fase 1 — Core Loop / Game Feel (prompt `02-core-loop.md`) ⭐ MAIS IMPORTANTE
- [ ] Player com movimento 8-direções fluido + câmera que segue.
- [ ] Mapa infinito/tileado (chão da Mata Atlântica).
- [ ] Spawner de inimigos "Enxame" que perseguem o player.
- [ ] Colisão inimigo→player = dano. HP e morte.
- [ ] 1 arma automática (Cipó) atacando sozinha.
- [ ] Inimigo morre → dropa Semente de Luz → coleta → barra de XP → level up (tela de 3 cartas).
- **Resultado:** um VS minúsculo, mas JOGÁVEL e GOSTOSO. **Teste o feel exaustivamente aqui.**
- 🔬 **Checkpoint:** "andar e matar é divertido por 2 minutos seguidos?" Se não, pare e ajuste.

## Fase 2 — Sistemas de Build (prompt `03-sistemas.md`)
- [ ] 3+ encantos com comportamentos diferentes + sistema de níveis 1→8.
- [ ] Amuletos (passivas) e stats globais.
- [ ] HUD completo (HP, XP, timer, ícones de armas, relógio da lua).
- [ ] Tela de fim de run + cálculo de Cristais de Luar.
- [ ] Meta-progressão básica (Árvore Sagrada) com save/load.
- **Resultado:** loop completo de 1 run + progressão entre runs.

## Fase 3 — Conteúdo Vertical (prompt `04-conteudo.md`)
- [ ] Mata Atlântica completa (tileset, variedade de inimigos, ambientação).
- [ ] 1 mini-boss + 1 boss (Onça Corrompida).
- [ ] Curupira com identidade (passiva + habilidade ativa).
- [ ] Menu principal + tela de seleção de lenda/bioma.
- **Resultado:** vertical slice jogável de ponta a ponta. **É isso que você mostra/testa com gente.**

## Fase 4 — Inovações (prompt `05-inovacoes.md`)
- [ ] 🌙 Ciclo da Lua (modificadores por fase + visual).
- [ ] 🔥 Ritual de Sincretismo (evolução de encantos).
- [ ] ✨ Encantar a horda (conversão de inimigos).
- [ ] 🌿 Bioma reativo (1 hazard, ex: queimada no Cerrado).
- **Resultado:** o jogo deixa de ser "clone" e vira RECONTO de verdade.

## Fase 5 — Arte e Áudio (prompts `sprites-arte/`)
- [ ] Substituir placeholders por sprites reais (itch.io + IA).
- [ ] Animações direcionais das lendas e inimigos.
- [ ] Menu animado (background + logo).
- [ ] Trilha sonora + SFX.
- **Resultado:** jogo bonito e com identidade audiovisual.

## Fase 6 — Expansão em largura
- [ ] Demais biomas (2→7).
- [ ] Demais lendas (2→10).
- [ ] Árvore de evolução completa.
- [ ] Simpatias (arcanas).
- [ ] Balanceamento geral.

## Fase 7 — Polimento e Steam
- [ ] Juice: screen shake, partículas, números de dano, hit-stop.
- [ ] Opções (áudio, vídeo, controles, acessibilidade).
- [ ] Localização (pt-BR / en).
- [ ] Conquistas Steam + nuvem.
- [ ] **Página na Steam + wishlist + demo (Next Fest)** ← faça isso CEDO, em paralelo à Fase 3-4.
- [ ] Export, build, testes em outras máquinas.

---

## Marco de validação (não pule)

Antes de investir meses na Fase 6+, valide demanda:
1. Suba a **página da Steam** com trailer/gifs da vertical slice + botão de wishlist.
2. Poste gifs em comunidades (r/brasil, r/gamedev, Twitter/Bluesky, TikTok).
3. **Wishlists são o termômetro real.** Se a fatia vertical gera buzz, vale ir fundo. Se não, ajuste o gancho.

---

## Dica de uso do Claude Code ao longo do roadmap

- Trabalhe **um prompt por vez**, teste, só então avance.
- Sempre que pedir algo, mande o Claude **ler o `CLAUDE.md` e os docs** antes (já está instruído lá).
- Faça commits git a cada feature funcionando ("checkpoint que volta se quebrar").
- Quando der bug, descreva o comportamento esperado vs o atual — não só "não funciona".
