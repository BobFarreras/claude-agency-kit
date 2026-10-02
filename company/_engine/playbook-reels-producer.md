# Playbook — reels-producer

> El subagent `reels-producer` llegeix aquest fitxer abans de començar una peça nova.
> Neix gairebé buit — es va omplint amb feina real. Cap regla sense evidència.

## Regles confirmades

> Dos tipus d'evidència poden confirmar una regla sense esperar tres casos:
> **(decisió)** — l'Adrià ho ha demanat explícitament.
> **(fet verificat)** — comportament d'una eina reproduït i comprovat en execució.
>
> La inferència a partir de resultats ("aquest tipus de ganxo funciona millor") sí que
> necessita **≥3 casos** i comença sempre com a hipòtesi.

### Entrega

1. **La feina acaba amb el fitxer renderitzat, no amb el guió.** L'entrega és `reel.mp4`
   (1080×1920, subtítols cremats), `portada.jpg`, `text-publicacio.md` i `guio.md`.
   · *decisió, 2026-07-29*

2. **Res que soni a demo ni a plantilla d'IA**, igual que a les webs: paleta i tipografia
   del client, cap gradient blau-violeta genèric.
   · *decisió — s'hereta de la regla d'empresa del CLAUDE.md*

3. **Publicar exigeix un sí explícit per cada peça.** L'agent no publica mai pel seu compte, i
   l'automatització recurrent la munta `n8n-architect`.
   · *decisió, 2026-07-29*

### Eines

4. **Aquesta màquina pot renderitzar vídeo sense res més: Node v22.16.0 i ffmpeg al `PATH`.**
   · *fet verificat — `node --version` i `ffmpeg -version` responen (2026-07-29)*

5. **El pipeline és el motor de `/forja-reel`, no una via pròpia.** Transcripció →
   `islands.py` → `cut.py` → comporta `verify-cut.py` (exit 0) → Hyperframes → revisor
   independent. Remotion queda descartat: aquest motor és lliure de llicència i està provat
   en producció per qui el va escriure.
   · *decisió, 2026-07-29 — l'Adrià va aportar els paquets `forja-reel` i `forja-reel-engine`*

6. **`python3` en aquesta màquina és l'stub de la Microsoft Store i no executa res.** Tots
   els `python3 ...` dels docs originals fallaven amb un missatge sobre la Store. Els docs
   del motor s'han corregit a `python`.
   · *fet verificat — `python3 --version` retorna el missatge de la Store (2026-07-29)*

7. **Dues peces citades pel motor no venien al paquet:** `transcribe-groq.sh` (pas 0, escrit
   de nou i afegit) i `detect-repeats.py` (via antiga, no cal). La skill `/watch` tampoc hi
   és: el revisor ha de degradar les seves comprovacions 3 i 4 i dir-ho a l'entrega.
   · *fet verificat — comparació entre scripts citats i scripts inclosos (2026-07-29)*

### Muntatge — tot això surt del primer reel real (AI-GI-OH, 2026-07-30)

8. **Els rètols es col·loquen contra el timestamp de la paraula al transcript, mai
   "a ull".** Amb 0,15-0,3 s d'avançament (J-cut) i prou.
   · *fet verificat — col·locats per estimació, `MERCAT` va sortir 0,86 s abans d'hora,
   `ARENA` 1,50 s tard i `MULTIJUGADOR` 1,22 s tard; dos contradeien el subtítol cremat
   que hi havia a la mateixa pantalla*

9. **GSAP reescriu el `transform` sencer.** Un rètol centrat amb `translateX(-50%)` es
   descentra en el moment que se li anima `y` o `scale`. Centra per amplada completa
   (`left: 0; width: <ample>; text-align: center`) i posa la caixa visible en un fill
   `inline-block`.
   · *fet verificat — un rètol mesurava el centre a 511 px en comptes de 540; els subtítols,
   que ja feien servir amplada completa, mesuraven 540 correctament*

10. **`hyperframes check` és comporta obligatòria abans de renderitzar.** En una tarda va
    caçar: `<video>` sense `id` (haurien sortit **congelats** al render), animació per
    `top/left` que fa saltirons, un `tl.set` a t=0 que no s'aplica al fotograma 0,
    sortides sense tancament dur que deixen rètols encallats, i solapaments de rètols i
    de clips.
    · *fet verificat*

11. **Cap `open()` sense `encoding="utf-8"` als scripts del motor.** A Windows el defecte és
    cp1252: es llegeix malament la transcripció i es torna a escriure trencada. `captions.py`
    hauria cremat els subtítols amb tots els accents destrossats.
    · *fet verificat — set obertures corregides*

12. **La mescla d'efectes es menja el marge de true peak.** El corte entrava a -1,4 dBTP i el
    render final sortia a -0,6. El limitador va **després** de mesclar els SFX, no abans.
    · *fet verificat*

13. **El revisor ha de ser un subagent independent de veritat.** No val que el revisi qui l'ha
    muntat.
    · *fet verificat, i és la regla que més va costar: l'autorevisió va donar per bo un reel
    amb sis blockers, tres dels quals eren rètols fora de sincronia que contradeien el text
    de la mateixa pantalla. El subagent els va trobar tots*

14. **Comporta de storyboard abans de renderitzar.** `check` → `snapshot` amb un fotograma per
    escena → `STORYBOARD.md` → aprovació de l'Adrià → només llavors, render.
    · *decisió de l'Adrià, 2026-07-30 — "abans de crear el reel, que es facin els guions i les
    escenes amb imatge, així tinc context de com serà i puc retocar-ho"*

15. **Si una paraula clau ja surt com a rètol, el subtítol no l'ha de repetir.** Els dos
    elements competeixen per la mateixa atenció i el rètol perd força.
    · *decisió de l'Adrià, 2026-07-30 — "moltes vegades no caldrien els subtítols, ja que
    ja van sortint paraules clau durant el reel"*

### La comporta de tall pot donar fals negatiu — verificat el 2026-07-30

16. **`verify-cut.py` en exit 0 NO vol dir que no hi hagi repeticions.** Si en re-transcriure
    el tall l'ASR col·lapsa una presa doblada en un sol token llarg, la comporta no la veu i
    diu que tot està net.
    · *fet verificat — «multijugador … multijugador» amb 0,9 s de vacil·lació entremig va
    passar la comporta i va arribar al render; l'ASR post-tall l'havia col·lapsat en un
    token `per` d'1,9 s*

    **Contrast obligatori**, i el motor ja ho deia sense que jo li fes cas: al transcript
    **en brut** (`brut-word.json`), busca paraules repetides dins d'una mateixa illa
    conservada, i tracta com a sospitosa qualsevol paraula de **més d'1,5 s** — una paraula
    que dura tant gairebé sempre amaga un silenci o una presa doblada.

    **Patró propi de l'Adrià, a vigilar sempre:** es corregeix d'idioma. Diu la paraula en
    castellà, s'atura, i la repeteix en català. Per a l'ASR és la mateixa paraula dues
    vegades amb una vacil·lació entremig, i la traducció al català la fa idèntica — o sigui
    que la detecció per similitud no la distingeix d'una presa doblada normal. En una
    gravació seva, revisa expressament les repeticions que tinguin una pausa curta entremig.
    · *explicat per ell mateix, 2026-07-30*

17. **Comprova l'últim fotograma de cada tros de B-roll, no només un del mig.** Els talls de
    gameplay acaben sovint en pantalles de càrrega o en fosos.
    · *fet verificat — un tros del multijugador acabava en «CARGANDO HUB…» 1,27 s, i un altre
    en un degradat congelat de 0,5 s; mirant només un fotograma central no es veu*

18. **Suma entrada + durada de cada clip i comprova que no queda cap forat.**
    `hyperframes check` detecta solapaments però **no forats**: on no hi ha clip es veu el
    fons pla de la composició.
    · *fet verificat — 0,47 s de negre pla perquè un clip acabava a 30,35 i el següent entrava
    a 30,85*

19. **Entrega l'àudio a 48 kHz.** Instagram i TikTok esperen 44,1 o 48 kHz; a 96 kHz forcen un
    reencodatge i el bitrate es malgasta.
    · *fet verificat*

20. **Corregir el text d'un subtítol en desplaça l'agrupació.** Si afegeixes o treus paraules
    respecte de la transcripció, els beats següents es desincronitzen (fins a 0,48 s mesurats).
    Després de corregir, torna a repartir els temps.
    · *fet verificat*

## Hipòtesis en prova

- **El ganxo es juga als primers 1,5 s** i el logotip o la careta al principi els mata.
  · *n=0 — criteri de partida, s'ha de confirmar amb retenció real*
- **La gravació de l'Adrià talla el senyal a zero a les pauses llargues.** No hi ha to de
  sala per collir dels junts: s'ha de sintetitzar un llit al nivell del soroll real que hi
  ha entre paraules (mesurat: -46 dB). · *n=1*
- **Els subtítols fidels a la parla es llegeixen com a errors un cop cremats**
  (*«va de que»*, *«desmadrat»*, *«una gent que»*). Cal decidir política: fidelitat literal
  o correcció silenciosa. · *n=1 — pendent que l'Adrià decideixi*
- **Els subtítols cremats no són opcionals** perquè la majoria mira sense so.
  · *n=0 — criteri de partida*
- **Zones segures de 220 px dalt i 420 px baix** perquè la interfície d'Instagram i TikTok no
  tapi text. · *n=0 — s'ha de verificar amb una captura real de cada xarxa*
- **Mirar retenció als 3 s i desades abans que els "m'agrada"** per decidir què repetir.
  · *n=0*

## Changelog

- **2026-07-29** · fitxer creat amb l'agent. Tres regles per decisió, una per fet verificat i
  una nota de llicència; la resta són criteris de partida sense evidència pròpia encara —
  marcats com a hipòtesi expressament perquè les primeres peces els confirmin o els tombin.
- **2026-07-30** · vuit regles noves (sis per fet verificat, dues per decisió) i dues
  hipòtesis, totes del primer reel real de punta a punta: el projecte AI-GI-OH, muntat des
  d'una gravació de 115 s i tres captures de joc. El reel no es publica —la gravació no
  donava— però el recorregut sí que va servir: va destapar quatre errors del motor i sis
  del muntatge. Aprovat per l'Adrià.
