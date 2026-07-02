# RECONTO: Enquanto Eu Brilhar — Projeto do Jogo 2D (Bullet Heaven / Folclore Brasileiro)

> Jogo no estilo *Vampire Survivors* com identidade própria: você é uma **lenda do folclore brasileiro**
> defendendo a mata da **Corrupção** que avança. Sobreviva 30 minutos por bioma.
>
> **Nome:** *RECONTO: Enquanto Eu Brilhar* (pt-BR) · *RECONTO: While I Shine* (inglês/mundial).
> "Reconto" = recontar histórias, o tema central do jogo; o subtítulo vem do juramento do herói:
> *"Enquanto eu brilhar, a mata não cai."* Verificado sem colisões na Steam (jun/2026).

**Engine alvo:** Godot 4.x (GDScript) · **Plataforma alvo:** Steam (PC)
**Ferramenta de desenvolvimento:** Claude Code · **Arte:** itch.io (assets) + Higgs Field / IA (geração)

---

## 📁 Estrutura do projeto

```
Jogo-2D/
├── README.md                  ← você está aqui (índice geral)
├── CLAUDE.md                  ← contexto do projeto p/ o Claude Code (NÃO apagar)
│
├── docs/                      ← Documentação de design
│   ├── 01-game-design-document.md   ← CORE LOOP completo + pilares
│   ├── 02-lore.md                   ← Lore, worldbuilding e narrativa
│   ├── 03-mecanicas-detalhadas.md   ← As 4 inovações + armas + evoluções
│   ├── 04-conteudo.md               ← Lendas jogáveis, biomas, bosses, inimigos
│   └── 05-roadmap.md                ← Fases de desenvolvimento (ordem de build)
│
├── prompts/                   ← Prompts prontos pro Claude Code (copia e cola)
│   ├── 00-guia-de-uso.md            ← COMECE AQUI: como usar os prompts
│   ├── 01-setup-projeto.md          ← Criar projeto Godot + estrutura
│   ├── 02-core-loop.md              ← Movimento, câmera, spawn, XP, level up
│   ├── 03-sistemas.md               ← Armas, evolução, vida, dano, meta-progressão
│   ├── 04-conteudo.md               ← Lendas jogáveis, biomas, bosses
│   ├── 05-inovacoes.md              ← Ciclo da Lua, Encantar, Sincretismo, Bioma reativo
│   └── sprites-arte/
│       ├── 06-sprites-higgsfield.md ← Prompts de geração de arte (IA)
│       └── 07-itch-io-guia.md       ← Como achar/usar assets prontos + integrar no Godot
│
├── assets/                    ← Onde você joga os arquivos de arte/som
│   ├── sprites/                     ← personagens, monstros, projéteis
│   ├── audio/                       ← música e SFX
│   ├── ui/                          ← botões, ícones, fontes
│   └── backgrounds/                 ← fundos de menu e biomas
│
└── referencias/              ← Capturas, moodboards, links de referência
```

## 🚀 Por onde começar

1. Leia `docs/01-game-design-document.md` para entender o jogo na cabeça.
2. Leia `docs/02-lore.md` para a alma do jogo.
3. Abra `prompts/00-guia-de-uso.md` e siga a ordem dos prompts.
4. O Claude Code deve ser aberto **dentro da pasta do projeto Godot** que você criar (veja prompt 01).

## ⚠️ Nota de respeito cultural

O folclore brasileiro tem raízes afro-indígenas e populares. O jogo trata as lendas como **guardiãs heroicas**,
com cuidado e sem caricatura. Mecânicas e moedas usam termos de fantasia (ex: "Semente de Luz") em vez de
termos religiosos sagrados. Isso é decisão de design e selling-point — ver `docs/02-lore.md`.
