---
name: video-ia
description: Munta un reel o una story vertical sense gravar ningú: narració amb veu, captures reals del producte, diagrames i motion graphics, renderitzat i amb so. Fes-la servir amb /video-ia.
disable-model-invocation: true
---

Munta la peça descrita a `$ARGUMENTS`. Si no t'han dit de què va ni per a quina marca, demana-ho.

Això **no és** `/reel`. `/reel` parteix d'una gravació d'algú parlant; aquí **no hi ha càmera**:
la veu es genera i tot el que es veu es fabrica. La resta del motor és el mateix, i les seves
comportes manen igual.

**Entrega a** `%USERPROFILE%\Desktop\empresa\entregues\<marca>\reels\AAAA-MM-DD-nom\`, mai a una
carpeta temporal: el que es deixa al `scratchpad` es perd i un render val vuit minuts.

Treballa com el subagent `social-strategist` i carrega
`~/.claude/company/marketing/MARCA-<marca>.md`, `MODES-PRODUCCIO.md` i
`~/.claude/company/_engine/playbook-reels-producer.md` (les 20 regles del motor valen aquí
senceres).

> **En aquesta màquina:** crida `python`, mai `python3`. Posa `PYTHONIOENCODING=utf-8` davant de
> qualsevol python que tregui accents. `GROQ_API_KEY` viu a les variables d'entorn: no la
> imprimeixis mai.

Carpeta de treball amb `edicio/`, `motion/`, `qc/`, `entrega/`.

## Fase 1 — Guió i narració (comporta 1)

El guió es mesura en paraules, no en idees: **en català es diuen unes 2,5 paraules per segon**.
Un reel de 20 s són 45-55 paraules. Si no hi caben, sobra una idea.

1. Escriu el guió amb temps i **el mode de producció de cada tram** (A/B/C).
2. Genera la narració, per l'ordre de preferència de `MODES-PRODUCCIO.md`:
   - **la veu dels agents de Nertel** — és el producte funcionant;
   - `media-use resolve --type voice --intent "<veu>" --project .` com a alternativa.
3. Escolta-la sencera **abans de muntar res**. Els noms propis, els dominis i les xifres són on
   la síntesi falla; es corregeixen reescrivint el text, no retocant l'àudio.

Després **transcriu la narració** per tenir els temps exactes de cada paraula. És el que fa que
els rètols i els subtítols caiguin al lloc en comptes de col·locar-los a ull:

```bash
ffmpeg -v error -i edicio/veu.wav -vn -ac 1 -b:a 64k -y edicio/veu.m4a
bash ~/.claude/skills/forja-reel/assets/motor-scripts/transcribe-groq.sh edicio/veu.m4a edicio/transcript-final.json ca
```

**Ensenya el guió i la narració a l'Adrià i espera l'OK.** Canviar una frase aquí costa segons;
després d'animar, obliga a resincronitzar-ho tot.

## Fase 2 — Àudio

La veu sintètica no necessita neteja de sala, però sí nivell:

```bash
ffmpeg -i edicio/veu.wav -af "loudnorm=I=-14:TP=-1.5:LRA=11" -ar 48000 -c:a pcm_s16le -y edicio/veu-net.wav
```

Si la narració queda plana i freda, un llit de música molt baix ajuda
(`media-use resolve --type bgm`), **sempre sota la veu** i mai per tapar-la. No és obligatori:
una veu neta amb efectes sona més professional que una peça amb música genèrica.

## Fase 3 — Subtítols

```bash
python ~/.claude/skills/forja-reel/assets/motor-scripts/captions.py --transcript edicio/transcript-final.json --out edicio/captions.json
```

Aquí hi ha un avantatge: **el text de la narració el saps exactament**, així que els subtítols no
han de patir errors de transcripció. Compara'ls igualment amb el guió i corregeix els noms
propis. I val la regla de sempre: **on hi hagi un rètol amb la paraula clau, el subtítol no la
repeteix**. Corregir el text desplaça l'agrupació — retemporitza després.

## Fase 4 — Muntatge

```bash
npx hyperframes init motion --non-interactive
```

Arrel a `data-width="1080" data-height="1920"`, `data-duration` = durada de la narració, i
l'àudio com a pista separada. Segueix
`~/.claude/skills/forja-reel/assets/motor-refs/02-motion-graphics.md`.

**Sense càmera, les capes canvien:** no hi ha `#camera` ni PiP, i per tant el B-roll i les
escenes van a pantalla completa i manen. Això té una conseqüència de ritme: **sense una cara que
ompli el quadre, un tram sense moviment és un tram mort immediatament.** La regla dura es torna
més exigent: **res de 4 s sense un beat**, i els subtítols no compten.

Trampes verificades que no cal tornar a descobrir:

- Cada `<video>` necessita `id` propi, o **surt congelat al render**.
- Anima per `transform` (x/y/scale), **mai** per `top/left`.
- Els estats inicials amagats van al CSS, no a un `tl.set` a t=0.
- Cada sortida de rètol necessita un `tl.set(opacity:0)` de tancament.
- No centris amb `translateX(-50%)`: GSAP reescriu el `transform` sencer. Contenidor d'amplada
  completa amb un fill `inline-block`.
- **Col·loca cada rètol contra el `start` de la seva paraula** al transcript, 0,15-0,3 s abans.
- Fes servir tot el vocabulari d'animació, no tres recursos.

Paleta, tipografia i fons: els de `MARCA-<marca>.md`. Per a Nertel, fosc sobre `#080c16` amb
accent `#0b87c1`, i mai un fons pla.

**El B-roll que val**, per ordre: una captura de pantalla del producte funcionant, un diagrama
SVG del flux, un rètol animat. Les imatges generades, les últimes, i només si la imatge és el
missatge. Per a una web o un repositori:

```bash
npx hyperframes capture <URL> -o motion/broll --max-screenshots 6
"/c/Program Files/Google/Chrome/Application/chrome.exe" --headless --disable-gpu --window-size=1600,1000 --virtual-time-budget=9000 --enable-features=WebContentsForceDark --force-dark-mode --screenshot=out.png "<URL>"
```

Retalla sempre a la part que es llegeix.

## Fase 5 — Storyboard (comporta 2)

Dues comprovacions que cap eina fa per tu: **forats entre clips** (suma entrada + durada; `check`
detecta solapaments però no forats) i **l'últim fotograma de cada clip** (els clips generats
acaben sovint en un fos). Després:

```bash
npx hyperframes check
python ~/.claude/skills/forja-reel/assets/motor-scripts/lint-timeline.py motion/index.html
npx hyperframes snapshot --at <un temps per escena> -o storyboard --no-end
```

Escriu `motion/STORYBOARD.md` (per escena: temps, què es veu, què es diu, efectes) i **espera
l'aprovació**. Cap render abans.

## Fase 6 — Render i so

```bash
npx hyperframes render --quality high --output renders/reel.mp4
bash ~/.claude/skills/forja-reel/assets/motor-scripts/make-sfx.sh sfx
python ~/.claude/skills/forja-reel/assets/motor-scripts/mix-sfx.py --base renders/reel.mp4 --sfx-dir sfx --out renders/reel-sfx.mp4 --events "<llista JSON d'esdeveniments>"
ffmpeg -i renders/reel-sfx.mp4 -af "loudnorm=I=-14:TP=-1.5:LRA=11" -c:v copy -c:a aac -b:a 192k -ar 48000 renders/REEL-FINAL.mp4
```

El limitador va **després** de mesclar. Comprova amb `ffprobe`: 1080×1920, 30 fps, àudio a
48 kHz.

## Fase 7 — Revisor independent (comporta 3)

Un subagent `general-purpose` que **no hagi vist com has muntat res**. Dona-li només el context
mínim, les rutes i la llista de comprovacions; si és revalidació, els defectes a verificar un per
un. Que torni `{"verdict","blockers","warnings"}`. Si no és `PASS`, corregeix i torna a
llançar-lo.

Dues comprovacions pròpies d'aquesta skill, a més de les del motor:

- **Cap dada en pantalla que la narració no digui.**
- **Si la veu o alguna imatge són sintètiques, la peça ho diu** i el text de publicació porta
  l'etiqueta que demana la plataforma.

## Entrega

`reel.mp4`, `portada.jpg`, `text-publicacio.md` (primera línia sola, variant per xarxa,
etiquetatge d'IA si toca) i `guio.md`. **No publiquis res.**
