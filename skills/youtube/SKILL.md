---
name: youtube
description: Prepara un vídeo de YouTube de punta a punta — títol, miniatura, estructura amb capítols, muntatge i retenció — tant en format curt com en llarg. Fes-la servir amb /youtube.
disable-model-invocation: true
---

Prepara el vídeo descrit a `$ARGUMENTS`.

**Primera pregunta, i no continuïs sense resposta: curt (vertical, menys d'un minut) o llarg
(horitzontal, 8-15 minuts)?** Són dos productes diferents. Si és curt, això és un reel: fes
servir `/reel` o `/video-ia` i torna aquí només per al títol i la miniatura.

> **Estat honest:** el format llarg **no s'ha produït mai amb aquest sistema.** El tall, el
> render i el revisor són els del motor validat, però l'estructura de 12 minuts, els capítols i
> la miniatura són nous. Digues-ho a l'entrega i anota al playbook què falla la primera vegada.

**Entrega a** `%USERPROFILE%\Desktop\empresa\entregues\<marca>\youtube\AAAA-MM-DD-nom\`.

Treballa com el subagent `social-strategist`, amb `MARCA-<marca>.md` i `MODES-PRODUCCIO.md`.

## 1. El títol i la miniatura es decideixen PRIMER

A YouTube el vídeo es tria abans de veure'l. Si el títol i la miniatura no funcionen, el muntatge
és igual.

- **Títol**: una promesa concreta i comprovable, sense majúscules cridaneres ni esquer. El to de
  la marca manda: a Nertel, "Com atén el telèfon un agent de veu" i no "Això canviarà la teva
  empresa".
- **Miniatura**: una idea, llegible a 120 px d'ample al mòbil. Tres paraules com a màxim, si en
  porta. La maqueta el subagent `doc-designer` (HTML → PNG a 1280×720) amb la paleta de la marca.
- **Escriu tots dos abans del guió** i deixa que l'Adrià els aprovi. Si no saps posar-hi títol,
  el vídeo encara no té tema.

## 2. Estructura del format llarg

| Tram | Què hi va |
|---|---|
| 0-15 s | La promesa del títol, complida d'entrada. Res de careta ni de "benvinguts al canal" |
| 15-60 s | Per què això importa, amb el problema concret |
| Cos | **Un capítol per idea**, i cada capítol obre i tanca sol |
| Final | Una sola acció: parlar amb Nertus o demanar la demo |

- **Capítols de debò**, amb marques de temps a la descripció (`0:00`, `1:24`…). YouTube els
  mostra i la gent hi salta: un vídeo sense capítols perd la meitat del valor de cerca.
- **Cap tram de més de 60 s sense un canvi visual** (captura, diagrama, rètol, canvi de pla). És
  la versió llarga de la regla dels 4 s: a YouTube es tolera més aire, però no un pla fix de dos
  minuts.
- **La descripció no és un resum**: les dues primeres línies es llegeixen, la resta serveix per a
  la cerca. Capítols, enllaç a la demo i prou.

## 3. Producció

Amb gravació: Fase 1 del motor (`islands.py` → `cut.py` → `verify-cut.py` exit 0), igual que
`/reel`; funciona a qualsevol durada, i amb 12 minuts la revisió dels DROP a mà és la part cara —
fes-la per blocs i no d'una tirada.

Sense gravació: narració com a `/video-ia`.

Motion graphics en horitzontal: `data-width="1920" data-height="1080"`. Les insercions (títols de
capítol, diagrames, dades) es munten com a composicions curtes de Hyperframes i s'intercalen;
**no muntis 12 minuts dins d'una sola composició** — renderitzar-la seria inviable i qualsevol
canvi costaria una hora.

## 4. Comportes

Les tres mateixes: **tall aprovat** → **storyboard o guió il·lustrat aprovat** → **revisor
independent en PASS**. A més, per a YouTube:

- Miniatura i títol aprovats abans de muntar.
- `ffprobe` final: 1920×1080, àudio a 48 kHz, -14 LUFS.
- Subtítols: puja'ls com a fitxer (`.srt`), no cremats — a YouTube es llegeix en pantalla gran i
  els cremats molesten. Al format curt, cremats com sempre.

## 5. Entrega

`video.mp4`, `miniatura.png` (1280×720), `titol-i-descripcio.md` (amb els capítols),
`subtitols.srt` i `guio.md`. **No publiquis ni programis res**: publicar necessita un sí explícit
de l'Adrià per a cada peça.
