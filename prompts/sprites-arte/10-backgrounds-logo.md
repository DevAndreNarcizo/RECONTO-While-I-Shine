# 10 — Backgrounds, Ambientação e Logo (arte ilustrativa)

> Estes NÃO são pixel art de sprite — são artes grandes (fundos de menu, logo,
> capsule Steam). Melhor gerar em **Midjourney / Higgsfield / DALL·E / Leonardo**,
> não no PixelLab. Sempre em INGLÊS. Onde salvar: `game/assets/backgrounds/` e
> `game/assets/ui/`. Avise o Claude Code que ele integra (fundo de menu, logo).

## Paleta e regras do mundo (colar/lembrar em todo prompt)

- **Mata saudável:** verdes vivos, dourado quente, luz de vaga-lume, lua sempre no céu.
- **Corrupção:** roxo-escuro oleoso, preto, verde-pústula, fumaça.
- **Tom:** mítico, caloroso, épico, respeitoso — homenagem ao folclore, nunca caricato.
- Estilo recomendado: `painterly digital illustration, rich lighting, game key art`
  (pedir "pixel art" em fundo grande costuma sair pobre — deixe ilustrativo).

---

## 1. LOGO com as 5 lendas 🎯 (o pedido principal)

**As 5 lendas da logo:** Curupira (centro), Saci, Iara, Boitatá, Lobisomem.
Proporção **16:9** ou **1:1**. Gere o título e as lendas juntos; se o texto sair
torto, gere só a arte das 5 lendas em arco e adicione o texto depois (Canva/Photopea).

```
Epic game logo key art titled "RECONTO" in large ornate golden letters with a
smaller subtitle ribbon "Enquanto Eu Brilhar", Brazilian folklore theme. Five
mythical guardians arranged in a heroic arc around the title: in the center a
small fierce forest boy with wild flame-red hair and backward-facing feet
(Curupira); to his left a one-legged trickster boy with a glowing red cap
riding a whirlwind (Saci); a mermaid with long green hair rising from glowing
river water (Iara); a giant fire serpent coiling with orange-blue flames
(Boitatá); and a proud silver werewolf under a full moon (Lobisomem). Warm
golden and emerald green palette, magical fireflies, big glowing moon behind
the title, painterly digital illustration, dramatic cinematic lighting, rich
detail, epic fantasy game key art, dark background --ar 16:9
```

**Variante vertical (capsule/ícone, 1:1):** troque o final por `--ar 1:1` e
adicione `centered composition, characters tighter around the title`.

**Dica:** se o modelo bagunçar as 5 figuras, gere em 2 etapas —
(a) só o letreiro dourado com lua e vaga-lumes; (b) as 5 lendas em arco sem
texto — e componha. Cinco personagens numa imagem só é o pedido mais difícil
para qualquer IA; 3-4 tentativas é normal.

---

## 2. Fundo do MENU PRINCIPAL (16:9, loop suave opcional)

```
Atmospheric title screen background for a Brazilian folklore game, deep
enchanted rainforest at night seen from a clearing, a colossal ancient
jabuticaba tree glowing softly in the center (the sacred tree), hundreds of
golden fireflies floating, huge luminous full moon in a starry sky, layers of
misty foliage receding into darkness, warm golden light against cool blue
shadows, faint purple corruption creeping at the far edges, painterly digital
illustration, cinematic depth, no characters, no text, space for a logo at the
top --ar 16:9
```

> Para animar (parallax/loop): leve o PNG a um image-to-video (Higgsfield/Kling)
> com *"subtle loop: fireflies drift, leaves sway, moonlight pulses, mist moves"*.

---

## 3. Fundos de AMBIENTAÇÃO por bioma (16:9 — telas de carregamento / seleção)

**Mata Atlântica (ato 1):**
```
Lush Brazilian Atlantic Forest at dusk, dense green canopy, golden god-rays
piercing through leaves, hanging vines and bromeliads, a clear mossy ground,
fireflies, warm and alive, a faint hint of purple corruption on distant trees,
painterly game background, no characters, no text --ar 16:9
```

**Amazônia (ato 1, chuva):**
```
Deep dark Amazon rainforest in heavy rain at night, towering ancient trees,
thick wet foliage, rain streaks and puddles reflecting a pale moon, mist
between trunks, bioluminescent plants glowing faint green, oppressive and
mysterious, distant purple corruption glow, painterly game background, no
characters, no text --ar 16:9
```

**Pantanal (águas que transbordam):**
```
Brazilian Pantanal wetlands at golden hour, flooded grasslands with mirror-like
water, scattered palm trees, a big orange sunset sky reflected on the water,
distant water lilies, herons silhouettes, humid and vast, subtle purple
corruption staining the far water, painterly game background, no characters,
no text --ar 16:9
```

**Caatinga (sertão — próximo bioma):**
```
Brazilian Caatinga dry backlands under a blood-red moon, cracked ochre earth
with deep fissures, twisted leafless white mandacaru cactus, scattered bones,
heat haze and embers in the air, harsh and desolate, purple corruption seeping
from the cracks, painterly game background, no characters, no text --ar 16:9
```

**Cerrado, Fundo do Rio e Cidade Assombrada:** seguir o mesmo molde trocando o
cenário — savana dourada em chamas; reino submerso bioluminescente envenenado;
cidade cinza com neon doente e sombras. (Prompts completos quando chegarmos neles.)

---

## 4. Molduras e detalhes de UI (opcional, deixa "mais legal")

**Moldura de painel/carta (PNG transparente, 9-slice):**
```
Ornate wooden frame border for a game UI panel, carved vines and leaves in the
corners, warm brown wood with subtle golden inlay, empty transparent center,
folk art style, top-down flat view, transparent background --ar 1:1
```

**Fundo de carta de level-up (retrato 3:4):**
```
Vertical fantasy card background, dark green parchment with golden vine border
and a soft glowing center, Brazilian folk art motifs, empty center for an icon,
painterly, transparent edges --ar 3:4
```

---

## 5. Onde cada arte entra no jogo (para o Claude integrar)

| Arte | Arquivo sugerido | Uso |
|---|---|---|
| Logo | `assets/ui/logo.png` | topo do menu principal (substitui o texto "RECONTO") |
| Fundo do menu | `assets/backgrounds/menu.png` | atrás do menu principal |
| Fundo Mata/Amazônia/Pantanal | `assets/backgrounds/<bioma>.png` | tela de seleção / carregamento do bioma |
| Moldura de painel | `assets/ui/frame.png` | 9-slice nos painéis (troca o StyleBox atual) |

> Quando subir qualquer uma, avise: eu ligo no menu/seleção e ajusto o
> `theme.tres` para usar as molduras de imagem no lugar dos StyleBox atuais.
