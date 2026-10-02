---
name: reel
description: Converteix una gravació en brut en un reel vertical acabat (1080×1920 amb subtítols cremats, motion graphics i so), passant per les tres comportes del motor. Fes-la servir amb /reel.
disable-model-invocation: true
---

Munta el reel a partir del material indicat a `$ARGUMENTS` (la ruta de la gravació en brut,
i les captures de pantalla o gravacions de suport si n'hi ha). Si no t'han dit quin material
és, demana'l.

**Entrega a** `%USERPROFILE%\Desktop\empresa\entregues\<client>\reels\AAAA-MM-DD-nom\` (o a
`entregues\empresa\...` si és nostra), mai a una carpeta temporal: el que es deixa al
`scratchpad` es perd, i un render val vuit minuts. Vegeu `entregues\README.md`.

Treballa com el subagent `reels-producer` i consulta
`~/.claude/company/_engine/playbook-reels-producer.md` abans de començar. El motor és a
`~/.claude/skills/forja-reel/assets/`.

> **En aquesta màquina:** crida `python`, mai `python3` (és un stub de la Store). Posa
> `PYTHONIOENCODING=utf-8` davant de qualsevol python que tregui accents. `GROQ_API_KEY`
> viu a les variables d'entorn d'usuari; si la sessió no la veu, passa-la per comanda sense
> imprimir-la mai.

Treballa dins d'una carpeta pròpia per al reel, amb `edicio/`, `motion/` i `entrega/`.

## Fase 1 — Tallar (comporta 1)

```bash
ffmpeg -v error -i BRUT.mkv -vn -ac 1 -b:a 64k -y edicio/brut-audio.m4a
bash ~/.claude/skills/forja-reel/assets/motor-scripts/transcribe-groq.sh edicio/brut-audio.m4a edicio/brut-word.json ca
python ~/.claude/skills/forja-reel/assets/motor-scripts/islands.py --media BRUT.mkv --transcript edicio/brut-word.json --out edicio/islands.json
```

Revisa la taula KEEP/DROP i **corregeix a mà els DROP que la heurística no veu**: la regla
d'última presa només caça la primera frase d'una presa abandonada, no la seva continuació.
Marca també els illots sense paraules (respiracions) i les frases que no acaben.

```bash
python ~/.claude/skills/forja-reel/assets/motor-scripts/cut.py --islands edicio/islands.json --out edicio/corte-final.mp4
ffmpeg -v error -i edicio/corte-final.mp4 -vn -ac 1 -b:a 64k -y edicio/cf.m4a
bash ~/.claude/skills/forja-reel/assets/motor-scripts/transcribe-groq.sh edicio/cf.m4a edicio/transcript-final.json ca
python ~/.claude/skills/forja-reel/assets/motor-scripts/verify-cut.py --media edicio/corte-final.mp4 --transcript edicio/transcript-final.json
```

Exit 0 o no continuïs. Però **exit 0 no vol dir que no hi hagi repeticions**: si l'ASR
col·lapsa una presa doblada en un sol token llarg, la comporta no la veu. Contrasta-ho
sempre contra el transcript **en brut**:

```bash
PYTHONIOENCODING=utf-8 python - <<'PY'
import json
brut=json.load(open('edicio/brut-word.json',encoding='utf-8'))['words']
illes=[i for i in json.load(open('edicio/islands.json',encoding='utf-8'))['islands'] if i['keep']]
for isla in illes:
    dins=[w for w in brut if w['start']>=isla['start'] and w['end']<=isla['end']]
    vistes={}
    for w in dins:
        k=w['word'].strip().lower().strip('.,!?')
        if len(k)>4 and k in vistes:
            print(f"REPETIDA dins l'illa #{isla['i']}: '{k}' a {vistes[k]:.2f} i {w['start']:.2f}")
        vistes[k]=w['start']
    for w in dins:
        if w['end']-w['start']>1.5:
            print(f"PARAULA ARROSSEGADA #{isla['i']}: '{w['word'].strip()}' {w['end']-w['start']:.2f}s")
PY
```

Una paraula de més d'1,5 s gairebé sempre amaga un silenci o una presa doblada.

**Ensenya el tall a l'Adrià amb la llista del que has tret i per què, i espera el seu OK.**
Un cop animis, retallar obliga a re-sincronitzar-ho tot.

## Fase 2 — Àudio

Si la gravació ve d'un micròfon de portàtil:

```bash
ffmpeg -i edicio/corte-final.mp4 -af "highpass=f=95,afftdn=nf=-24,equalizer=f=250:t=q:w=1.2:g=-3,equalizer=f=3200:t=q:w=1.5:g=3.5,acompressor=threshold=-19dB:ratio=3.2:attack=8:release=180,loudnorm=I=-14:TP=-1.5:LRA=11" -c:v copy -c:a aac -b:a 192k edicio/corte-net.mp4
```

Comprova els junts del tall: si cauen a -80 dB mentre entre paraules hi ha -46, la sala
"desapareix" a cada tall. Es tapa amb un llit de soroll rosa calibrat al terra real:

```bash
ffmpeg -v error -f lavfi -i "anoisesrc=d=<durada+1>:c=pink:a=0.5:r=48000" -af "highpass=f=110,lowpass=f=2000,volume=-22dB" -ac 2 -c:a pcm_s16le -y edicio/bed.wav
ffmpeg -v error -i edicio/corte-net.mp4 -i edicio/bed.wav -filter_complex "[0:a][1:a]amix=inputs=2:duration=first:normalize=0[a]" -map 0:v -map "[a]" -c:v copy -c:a aac -b:a 192k -y edicio/corte-net2.mp4
```

## Fase 3 — Subtítols

```bash
python ~/.claude/skills/forja-reel/assets/motor-scripts/captions.py --transcript edicio/transcript-final.json --out edicio/captions.json
```

**Corregeix-los a mà abans de res**: la transcripció s'equivoca amb noms propis, marques i
dominis, i això va cremat a la imatge. I recorda la regla: **on hi hagi un rètol amb la
paraula clau, el subtítol no l'ha de repetir**.

## Fase 4 — Muntatge

```bash
npx hyperframes init motion --video corte-net2.mp4 --non-interactive
```

Passa'l a vertical (`data-width="1080" data-height="1920"`) i segueix
`~/.claude/skills/forja-reel/assets/motor-refs/02-motion-graphics.md`. Coses que ja han
fallat un cop i no cal tornar a descobrir:

- Cada `<video>` necessita `id` propi, o **surt congelat al render**.
- Anima el PiP per `transform` (x/y/scale), no per `top/left`.
- Els estats inicials amagats van al CSS, no a un `tl.set` a t=0.
- Cada sortida de rètol necessita un `tl.set(opacity:0)` de tancament al final.
- Centra els rètols per amplada completa, no amb `translateX(-50%)`: GSAP reescriu el
  `transform` sencer quan anima `y`/`scale`.
- **Col·loca els rètols contra el `start` de la paraula al transcript**, 0,2 s abans.
- Fes servir tot el vocabulari d'animació, no quatre recursos.

Per ensenyar una web o un repositori, `npx hyperframes capture <URL>`; si el reel és fosc,
la captura l'has de fer en fosc:

```bash
"/c/Program Files/Google/Chrome/Application/chrome.exe" --headless --disable-gpu --window-size=1600,1000 --virtual-time-budget=9000 --enable-features=WebContentsForceDark --force-dark-mode --screenshot=out.png "<URL>"
```

## Fase 5 — Storyboard (comporta 2)

Abans de res, **dues comprovacions que cap eina fa per tu**:

```bash
# 1. forats entre clips de B-roll: `check` detecta solapaments, pero NO forats,
#    i on no hi ha clip es veu el fons pla de la composicio
PYTHONIOENCODING=utf-8 python -c "
B=[('b1',0.0,2.6),('b2',2.6,5.0)]  # posa-hi la teva llista (id, entrada, durada)
p=0.0
for n,s,d in B:
    if s-p>0.02: print(f'FORAT de {s-p:.2f}s abans de {n} (a {p:.2f})')
    p=s+d
"
# 2. l'ultim fotograma de cada tros: sovint acaben en pantalla de carrega o en fos
for f in motion/broll/*.mp4; do
  dur=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f")
  ffmpeg -v error -ss $(echo "$dur" | awk '{print $1-0.1}') -i "$f" -frames:v 1 -y "qc/fi-$(basename $f .mp4).jpg"
done
```

Mira aquestes últimes imatges una per una. Després:

```bash
npx hyperframes check          # 0 errors abans de res
python ~/.claude/skills/forja-reel/assets/motor-scripts/lint-timeline.py motion/index.html
npx hyperframes snapshot --at <un temps per escena> -o storyboard --no-end
```

Escriu `motion/STORYBOARD.md` amb, per escena: tram de temps, què es veu, què s'hi diu i
quins efectes. Entrega'l amb les fulles de contactes i **espera l'aprovació**. Cap render
abans d'això: renderitzar costa 6-8 minuts i canviar una escena aquí costa segons.

## Fase 6 — Render i so

```bash
npx hyperframes render --quality high --output renders/reel.mp4
bash ~/.claude/skills/forja-reel/assets/motor-scripts/make-sfx.sh sfx
python ~/.claude/skills/forja-reel/assets/motor-scripts/mix-sfx.py --base renders/reel.mp4 --sfx-dir sfx --out renders/reel-sfx.mp4 --events '[["boom",0.0], ...]'
ffmpeg -i renders/reel-sfx.mp4 -af "loudnorm=I=-14:TP=-1.5:LRA=11" -c:v copy -c:a aac -b:a 192k -ar 48000 renders/REEL-FINAL.mp4
```

Als canvis de secció, encadena `whoosh` que puja amb `boom` que cau exacte al tall. El
limitador va **després** de mesclar: la mescla es menja el marge de true peak.

## Fase 7 — Revisor independent (comporta 3)

Llança un subagent `general-purpose` que **no hagi vist com has muntat res**. Dona-li el
context mínim del producte, les rutes, la llista de comprovacions i —si és una revalidació—
els defectes que s'havien de corregir. Que torni un JSON amb `verdict`, `blockers` i
`warnings`. Si no és `PASS`, corregeix i torna a llançar-lo.

## Entrega

`reel.mp4`, `portada.jpg` (fotograma triat a mà), `text-publicacio.md` (primera línia sola,
variant per xarxa) i `guio.md`. **No publiquis res**: publicar necessita un sí explícit de
l'Adrià per a cada peça, i l'automatització recurrent la munta `n8n-architect`.
