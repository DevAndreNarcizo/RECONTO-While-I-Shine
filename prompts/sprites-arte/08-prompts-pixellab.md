# 08 — Prompts para o PixelLab (sprites do jogo)

> Prompts em INGLÊS (o PixelLab responde melhor). Fluxo: gerar ~20 variações →
> escolher → refinar no Aseprite. Rotação em 4 direções e animação (walk/attack)
> são CONFIGURAÇÃO da ferramenta, não parte do prompt.
> Salve os PNGs em `game/assets/sprites/` — o Claude Code integra no Godot.
> Checklist do que falta: `09-checklist-sprites.md`.

## 0. RECEITA do prompt que sai certo de primeira 🎯

Os prompts curtos exigem muitas tentativas. Estruture SEMPRE nesta ordem
(o PixelLab pesa mais o começo da frase):

```
[1 CRIATURA + material]  [2 SILHUETA/proporção]  [3 CORES exatas]
[4 DETALHE ÚNICO que identifica]  [5 POSE]  [6 bloco de estilo]
```

Regras que economizam gerações:
1. **Proporção explícita**: "chibi proportions, big head" (lendas) ou "low wide
   body, short legs" (bichos) — sem isso ele varia o corpo a cada tentativa.
2. **Cores nomeadas + onde**: "dark emerald green scales, BELLY pale cream,
   eyes glowing violet" — cor sem lugar = cor no lugar errado.
3. **UM detalhe único por criatura** (o que a torna reconhecível a 20px):
   mandíbulas do formigão, olho único do Mapinguari. Mais de dois detalhes = bagunça.
4. **Negativas no fim**: "no background, no shadow, no border, single character".
5. **Consistência**: gere na MESMA sessão e reutilize o personagem aprovado como
   referência (feature de character reference do PixelLab) para variações.
6. Se sair "fofo demais": adicione "menacing, feral"; se sair "realista demais":
   adicione "simple readable game sprite, low detail".

**Exemplo aplicando a receita (Jacaré-Açu):**
```
corrupted black caiman, low wide body with short legs and long powerful tail,
dark emerald green cracked scales with pale cream belly, glowing violet eyes
and purple corruption veins along the spine, low predator crawl pose,
high top-down game sprite, Brazilian rainforest dark fantasy, Resurrect-64
palette, transparent background, no shadow, single character
```

## Configuração no PixelLab

- **Tamanho:** 32x32 (lendas/inimigos médios) · 16x16 (enxames/pickups) · 64x64 (bosses)
- **Paleta:** Resurrect-64 (citar no prompt) — a MESMA em tudo
- **Direções:** 4 (top-down) para tudo que anda · **Walk:** 4-6 frames · Bosses: + pose de ataque
- Gerar tudo na mesma sessão/estilo para consistência

## Bloco de estilo (colar no fim de TODOS os prompts)

```
top-down game sprite, vibrant Brazilian rainforest folklore theme, dark fantasy
but colorful, clean readable silhouette, Resurrect-64 palette, transparent background
```

## Lendas (32x32, 4 direções + walk)

| Lenda | Prompt |
|---|---|
| Curupira | `small forest guardian boy, wild flame-like orange-red hair, green skin, feet turned backwards, amber glowing eyes, leaf loincloth, mischievous brave expression` |
| Saci | `one-legged trickster boy, bright red magic cap, dark skin, small smoke pipe, standing on a mini whirlwind of wind and leaves, playful grin` |

## Inimigos — Mata Atlântica

| Inimigo (tamanho) | Prompt |
|---|---|
| Vaga-lume Sombrio (16) | `corrupted firefly, small dark insect with sickly purple glow instead of yellow, tattered wings, hollow eyes` |
| Cutia Oca (24) | `hollow corrupted agouti rodent, brown fur cracked like dry wood, glowing purple eyes, skittish pose` |
| Macaco-Prego (32) | `corrupted capuchin monkey, purple-tinted matted fur, long limbs, aggressive hunched pose, glowing violet eyes` |
| Sapo-Cururu (32) | `bloated corrupted cane toad, sickly green skin with purple pustules, wide toxic mouth, ready to spit` |
| Tamanduá Casca-Grossa (32) | `giant anteater with armor of thick tree bark plates, slow heavy stance, long snout, purple corruption veins between bark` |
| Corrompido Especial (32) | `elite corrupted forest beast, deep purple body with bright violet aura and floating dark particles, menacing glow` |

## Bosses (64x64, 4 direções + pose de ataque)

| Boss | Prompt |
|---|---|
| Bicho-Preguiça Desperto | `massive ancient sloth, moss and vines growing on fur, long hooked claws, sleepy but menacing face, vines extending from arms like whips, earthy green-brown tones` |
| Onça Corrompida (+ frame agachada p/ bote) | `large corrupted jaguar, orange fur with black rosette spots, glowing purple corruption veins across body, bright violet eyes, powerful crouched predator stance` |

## Pickups e itens (16x16, 2 frames de brilho)

| Item | Prompt |
|---|---|
| Semente de Luz | `glowing golden seed of light, diamond shape, warm radiant sparkle` |
| Fragmento de Luar | `pale blue moonlight crystal shard, cold silver glow, faceted` |
| Baú de Luz | `small wooden chest overflowing with golden light rays, ornate leaf carvings` |

## Projéteis/efeitos (16x16, sem direções)

| Efeito | Prompt |
|---|---|
| Cusparada do sapo | `toxic green venom glob projectile, dripping, small purple bubbles` |
| Pedra do Saci | `small round gray stone with faint wind swirl trail` |
| Vaga-lume Guardião (aliado) | `friendly firefly of pure golden light, warm bright glow, tiny wings` |

## Animações de ATAQUE (VFX dos encantos e ativas)

> Modo de ANIMAÇÃO DE EFEITO do PixelLab: strip horizontal de frames, transparente,
> **só 1 direção (apontando para a DIREITA)** — a rotação é feita no Godot.
> Estilo p/ efeitos: `pixel art game VFX animation frames, vibrant magical folklore
> energy, transparent background, Resurrect-64 palette`
> Regra de cor: golpes das lendas = verde/dourado/azul-luz · Corrupção = roxo.
> Loops (auras/orbes): pedir "seamless loop". Impactos: último frame em fade out.

### Já no jogo ✅

| Encanto | Prompt | Tam/frames |
|---|---|---|
| Cipó Chicoteante | `whip slash effect of a living green vine with small leaves, horizontal arc swing, motion trail` | 64x32 · 5 |
| Cipó da Mãe-da-Mata | `thorny ancient roots bursting upward from the ground, dark green with golden sap glow, dirt particles` | 32x48 · 6 |
| Cipó Sagrado | `sacred golden-green vine whip slash, holy light sparkles, warm healing glow trail` | 64x32 · 5 |
| Vaga-lumes Guardiões | `tiny orb of warm golden firefly light, pulsing glow, soft trail` | 16x16 · 4 loop |
| Pedra do Saci | `spinning round stone with wind swirl lines around it, bouncing motion blur` | 16x16 · 4 loop |
| Relâmpago do Trovão | `vertical lightning bolt striking down, white-blue jagged electric arc, bright impact flash at bottom` | 32x96 · 5 |
| Canto da Iara | `expanding circles of magical song, water-blue musical notes and ripples radiating outward` | 48x48 · 6 |
| Pés Invertidos (ativa) | `expanding ring of glowing green backwards footprints on the ground, leaves swirling` | 96x96 · 6 |

### Próximas lendas (docs/04 §1 e 06 §2)

| Lenda | Arma/Ativa | Prompt | Tam/frames |
|---|---|---|---|
| Saci | Dash de Vento | `small tornado whirlwind of wind, leaves and red cap sparks, spiral motion` | 32x48 · 6 loop |
| Boitatá | Roda do Boitatá | `ring of living fire circling around empty center, orange-blue serpent-shaped flames` | 96x96 · 6 loop |
| Boitatá | Explosão Ígnea | `radial fire explosion nova, expanding ring of flames with ember particles` | 96x96 · 7 |
| Boto | Dança Encantadora | `charming pink-white musical hearts and water droplets swirling in a wave pattern` | 48x48 · 6 loop |
| Lobisomem | Garras Lunares | `triple claw slash marks glowing pale moonlight silver-blue, fierce diagonal strikes` | 48x48 · 4 |
| Negrinho | Vela do Pastoreio | `small warm candle flame spirit, gentle golden halo, floating wisp of light` | 16x24 · 4 loop |
| Negrinho | Chamado (tropilha) | `ghostly glowing horse made of golden light galloping, ethereal mane trailing sparkles` | 48x32 · 6 |
| Mula-sem-Cabeça | Coice Flamejante | `powerful double kick fire burst, orange flame shockwave with hoof shapes` | 48x48 · 5 |
| Cuca | Maldição | `bubbling dark curse cloud, sickly green-purple magic smoke with tiny skull wisps` | 48x48 · 6 loop |
| Cuca | Feitiço do Sono | `expanding circle of drowsy magic, floating purple Z symbols and sparkling dust` | 96x96 · 6 |
| Caipora | Matilha | `charging wild peccary boar with dust cloud trail, determined eyes, motion lines` | 32x24 · 4 loop |

## Inimigos — Amazônia (8 rotações; prompts DETALHADOS no formato da Receita §0)

**Formigão de Correição (16px):**
```
giant corrupted army ant, low segmented insect body with six legs, dark
red-brown chitin carapace, oversized black serrated mandibles as the main
feature, tiny purple glow between body segments, aggressive marching pose,
high top-down game sprite, Brazilian rainforest dark fantasy, Resurrect-64
palette, transparent background, no shadow, single character
```

**Mosquito da Praga (16px):**
```
corrupted swamp mosquito, small round body with long thin crooked legs
hanging down, translucent tattered gray wings, one long needle proboscis as
the main feature, sickly gray-purple body with faint violet glow, hovering
flight pose, high top-down game sprite, Brazilian rainforest dark fantasy,
Resurrect-64 palette, transparent background, no shadow, single character
```

**Jacaré-Açu Oco (32px):**
```
corrupted black caiman, low wide body with short legs and long powerful tail,
dark emerald green cracked scales with pale cream belly, glowing violet eyes
and purple corruption veins along the spine ridge, low predator crawl pose,
high top-down game sprite, Brazilian rainforest dark fantasy, Resurrect-64
palette, transparent background, no shadow, single character
```

**Tatu-Canastra Blindado (32px):**
```
giant armadillo tank creature, round compact body dominated by thick
segmented armor plates like overlapping stone shields, earthy gray-brown
shell with purple corruption glow seeping between the plate cracks, small
head low to the ground, slow heavy walking pose, high top-down game sprite,
Brazilian rainforest dark fantasy, Resurrect-64 palette, transparent
background, no shadow, single character
```

**Sucuri de Lama (mini-boss, 64px):**
```
massive anaconda snake coiled in a spiral, thick muscular body covered in
dripping wet mud, muddy brown scales with darker diamond patterns, glowing
violet eyes and mud constantly sliding off the coils as the main feature,
head raised in striking pose above the coil, high top-down game sprite,
Brazilian rainforest dark fantasy, Resurrect-64 palette, transparent
background, no shadow, single character
```

**Mapinguari (boss, 96px):**
```
towering mythical sloth-beast from Brazilian Amazon legend, hulking
bipedal body wider than tall with long arms and huge curved claws, shaggy
matted dark brown fur with moss and vines growing on the shoulders, ONE
single giant glowing red eye in the center of the face, a second gaping
fanged mouth opening vertically on its belly as the main feature, heavy
menacing stance with arms open, high top-down game sprite, Brazilian
rainforest dark fantasy, Resurrect-64 palette, transparent background,
no shadow, single character
```

## Ícones de encantos e amuletos (cartas + HUD)

> Formato: **item icon**, 32x32, frame único, sem direções. Estilo:
> `pixel art game item icon, centered, clean silhouette on transparent background,
> subtle glow, Resurrect-64 palette`

| Item | Prompt |
|---|---|
| Cipó Chicoteante | `coiled green living vine whip with small leaves` |
| Cipó da Mãe-da-Mata | `ancient thorned root coil with golden sap glow` |
| Cipó Sagrado | `golden-green vine coil with holy light sparkles` |
| Vaga-lumes Guardiões | `three golden fireflies in triangle formation, warm glow` |
| Pedra do Saci | `round gray stone wrapped in a small wind swirl` |
| Relâmpago do Trovão | `blue-white lightning bolt inside a storm cloud` |
| Canto da Iara | `water-blue musical note with ripple rings` |
| Peixeira Voadora | `silver fish-gutting knife with worn wooden handle` |
| Revoada de Peixeiras | `fan of seven silver blades spread like feathers` |
| Roda do Boitatá | `ring of orange serpent-shaped fire` |
| Fogaréu | `blazing fire ring with blue-hot core` |
| Figa | `carved dark wood figa hand charm on a cord` |
| Fita do Bonfim | `ribbon tied in three knots, warm yellow` |
| Galho de Arruda | `small green rue herb branch` |
| Sal Grosso | `small burlap pouch spilling coarse salt crystals` |
| Pena de Tucano | `vibrant toucan feather, orange and black` |
| Chocalho | `indigenous gourd rattle with carved patterns` |
| Semente/XP (HUD) | `tiny glowing golden seed` |
| Cristal de Luar (HUD) | `tiny pale blue moon crystal` |

## Ordem de produção recomendada

1. Curupira + 6 inimigos da Mata + 3 pickups (~10 sprites) → integrar e validar o visual
2. VFX dos ataques já no jogo (tabela acima) + bosses (Preguiça, Onça)
3. Saci + tilesets (estes melhor no itch.io — ver `07-itch-io-guia.md`)
