# 07 — Assets Prontos (itch.io) + Integração no Godot

> Muitas vezes assets prontos de pixel art ficam MELHORES e mais rápidos que IA. Combine os dois:
> base pronta do itch.io + ajustes/complementos com IA.

---

## A. Onde achar assets

| Site | O que tem | Observação |
|---|---|---|
| **itch.io** (game assets) | Sprites, tilesets, UI, efeitos | Muitos grátis ou ~US$1-5. Filtre por "2D", "top-down", "pixel art". |
| **Kenney.nl** | Packs enormes GRÁTIS (CC0) | Ótimo para protótipo e UI. Sem atribuição obrigatória. |
| **OpenGameArt.org** | Variado, grátis | Confira a licença de cada um. |
| **CraftPix.net** | Packs temáticos (free + pago) | Bons inimigos/personagens top-down. |
| **Aseprite** (software) | Para editar/criar você mesmo | Pago barato; padrão da indústria de pixel art. |

### Buscas úteis no itch.io
- `top down character pixel art`
- `2D enemies pack pixel`
- `survivor / horde game asset`
- `magic effects pixel art`
- `nature tileset top down`
- `fantasy UI pixel`

---

## B. ⚖️ LICENÇA — leia antes de publicar na Steam (importante!)

Você vai VENDER o jogo, então a licença importa de verdade:
- ✅ **CC0 / Public Domain**: uso livre, inclusive comercial, sem atribuição. (Kenney é assim.)
- ✅ **"Free for commercial use"**: ok, mas confira se exige **atribuição** (creditar o autor).
- ⚠️ **CC-BY**: pode usar comercialmente, MAS precisa **dar crédito** (coloque nos créditos do jogo).
- ❌ **"Non-commercial" / "CC-BY-NC"**: NÃO pode usar em jogo pago. Evite.
- ❌ **Asset rippado de outro jogo**: nunca. Risco legal e de remoção da Steam.

**Guarde um registro:** crie `referencias/licencas-assets.md` anotando cada asset, autor, URL e licença.
Se ganhar dinheiro, considere doar aos autores (boa prática da comunidade).

---

## C. Fluxo recomendado de produção de arte

1. **Protótipo:** caixas coloridas (placeholders do Claude). Não gaste tempo com arte agora.
2. **Vertical slice:** assets grátis do Kenney/itch.io para ter "cara de jogo" rápido.
3. **Identidade:** substitua aos poucos por arte temática de folclore (itch.io pago + IA + ajustes no
   Aseprite) para o jogo ficar ÚNICO. A arte genérica não diferencia — a temática sim.
4. **Coerência:** mantenha UMA paleta e UM tamanho de pixel em todo o jogo (defina cedo: ex. 32x32 base).

---

## D. Integrar assets no Godot via Claude Code

Coloque os arquivos em `assets/sprites/` (ou subpastas) e use prompts como:

### Importar um personagem animado
```
Coloquei assets/sprites/heroi_topdown.png — é um sprite sheet de personagem top-down. Analise a imagem,
detecte o tamanho de cada frame e quantas animações há (idle, walk nas 4 direções). Configure import como
pixel art (Nearest), crie o SpriteFrames com as animações e ligue ao Player, tocando a animação certa
conforme a direção. Me diga se a leitura do grid está certa.
```

### Criar um TileSet de chão
```
Em assets/sprites/tileset_mata.png tenho um tileset de chão (grade de tiles de 32x32). Crie um TileSet
do Godot a partir dele, configure as colisões onde fizer sentido (ex: pedras/troncos bloqueiam) e pinte
o chão do bioma Mata Atlântica com variação visual. Mantenha pixel perfect.
```

### Bater pacote de inimigos em EnemyData
```
Tenho vários sprites de inimigos em assets/sprites/enemies/. Para cada um, crie o AnimatedSprite2D com
animação de caminhada e associe ao EnemyData correspondente (docs/04 §3), substituindo os placeholders.
```

### UI / HUD
```
Coloquei ícones de UI em assets/ui/. Substitua os placeholders do HUD (coração=vida, gema=XP, lua=ciclo)
e os botões do menu por esses assets, mantendo o layout responsivo.
```

---

## E. Áudio (não esqueça — é metade do "feel")

| Fonte | O quê |
|---|---|
| **Kenney (audio)** | SFX CC0 grátis |
| **freesound.org** | SFX (confira licença) |
| **OpenGameArt / itch.io (music)** | trilhas |
| **Suno / IA de música** | gerar trilha temática (confira termos de uso comercial) |

Prompt de integração:
```
Coloquei música em assets/audio/musica/ e efeitos em assets/audio/sfx/. Crie um AudioManager (autoload)
com buses de Música e SFX (volumes controláveis nas Opções), toque a trilha do bioma em loop e dispare
SFX para: acerto, morte de inimigo, coletar semente, level up, evolução e dano no player. Use pooling de
AudioStreamPlayer para não estourar vozes com muitos sons simultâneos.
```

> **Identidade sonora (docs/02 §8):** busque/gere sons com instrumentos brasileiros (berimbau, viola
> caipira, tambores, flautas) misturados a synth sombrio para a Corrupção. Isso reforça o tema.
