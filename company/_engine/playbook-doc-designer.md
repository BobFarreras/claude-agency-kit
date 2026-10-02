# Playbook — doc-designer

> El subagent `doc-designer` i les skills `/guia-visual`, `/presentacio`, `/portafoli` i
> `/proposta-client` llegeixen aquest fitxer abans de començar un document nou.
> Neix gairebé buit — es va omplint amb feina real. Cap regla sense evidència.

## Regles confirmades

> Dos tipus d'evidència poden confirmar una regla sense esperar tres casos:
> **(decisió)** — l'Adrià ho ha demanat explícitament.
> **(fet verificat)** — comportament d'una eina reproduït i comprovat en execució.
>
> La inferència a partir de resultats sí que necessita **≥3 casos** i comença com a hipòtesi.

### Format

1. **HTML autocontingut primer, PDF derivat d'aquest mateix HTML.** Un sol fitxer, sense CDN
   ni fonts externes, que funcioni amb doble clic i dins d'un correu.
   · *decisió, 2026-07-29*

2. **El cos del text va a 18 px també als documents**, no només a les webs. Res llegible per
   sota de 16 px, tampoc imprès.
   · *decisió — s'hereta de la regla d'empresa*

3. **Moviment que expliqui alguna cosa, i el contingut visible per defecte.** El que s'activa
   és el moviment: un script del `<head>` posa `.js` a l'arrel i **només les regles que
   amaguen porten el prefix**. Més `prefers-reduced-motion`.
   · *decisió + risc conegut de la tècnica de revelat; mecanisme corregit el 2026-07-30 (regla 11)*

### Eines

4. **Chrome headless genera el PDF correctament en aquesta màquina.**
   ```bash
   "/c/Program Files/Google/Chrome/Application/chrome.exe" --headless --disable-gpu --no-pdf-header-footer --print-to-pdf="out.pdf" "in.html"
   ```
   Sense `--no-pdf-header-footer` hi estampa la data i la ruta local del fitxer, cosa que en
   un document de client no hi pot anar.
   · *fet verificat — PDF generat des de la plantilla base (2026-07-29)*

5. **Els noms de línia de la graella han d'acabar en `-start` / `-end`.** Amb noms en català
   (`text-inici` / `text-fi`), `grid-column: text` no resol i tot el contingut cau a la
   primera columna. No dona cap error.
   · *fet verificat — trobat construint la plantilla base (2026-07-29)*

6. **Una diapositiva a pantalla completa que s'imprimeix amb `min-height` genera una pàgina
   en blanc darrere de cada una.** Cal `height: 167mm` (no `min-height`),
   `box-sizing: border-box` — si no, el `padding` se suma a l'alçada — i `break-after: page`
   només a `:not(:last-child)`. Compta sempre les pàgines del PDF resultant.
   · *fet verificat — 3 diapositives donaven 6 pàgines; amb la correcció, 3 (2026-07-29)*

7. **El panell del navegador ha d'estar visible per revisar res visual.** Amagat, la pestanya
   fa 0 fps: no hi ha captures, les animacions es queden a `currentTime: 0` i
   l'`IntersectionObserver` no dispara mai. Alternativa comprovada quan no es pot obrir:
   `chrome --headless --screenshot=out.png --window-size=1200,1000 --virtual-time-budget=3000`.
   · *fet verificat — la via headless sí que pinta i va servir per validar la plantilla base*

   Dues precisions sobre aquesta via: la captura només agafa el que cap dins de
   `--window-size`, i **el que queda fora del plec no s'ha revelat**, així que convé una
   finestra alta (`1200,3000`). Per veure-ho tot revelat d'una,
   `document.querySelectorAll('[data-reveal]').forEach(el => el.classList.add('vist'))` —
   i **no** `document.getAnimations()`, que amb la plantilla base no retorna res perquè el
   revelat és una transició disparada per la classe `.vist`, no una animació en curs.
   · *llegit del CSS de la plantilla base (línia `[data-reveal].vist`), pendent de comprovar
   en execució amb un document real*

   **Correcció del 2026-07-30 (primera passada real):** la causa no és que la pestanya vagi a
   0 fps. **El panell serveix el fitxer com una instantània estàtica i el JS no s'hi executa
   gens.** El mateix fitxer sortia en blanc al panell i sencer al navegador normal de l'Adrià.
   Conseqüències: al panell no hi haurà mai animació, per molt visible que estigui; captura
   sempre per headless; i **un document en blanc al panell no vol dir un document trencat**.
   · *fet verificat — observat per l'Adrià i pel subagent alhora, amb el mateix fitxer*

11. **`@media (scripting: none)` no protegeix del JS que no s'executa.** Només respon quan el
    navegador declara que *no admet* scripts; un entorn que els admet i no els corre (el
    panell, un client de correu, una CSP, un error abans de muntar l'observer) no la dispara i
    el document queda **en blanc**. La protecció bona és invertir-ho: **tot visible per
    defecte**, un script al `<head>` marca `document.documentElement.classList.add('js')`, i
    només les regles que amaguen van prefixades amb `.js`. Si l'script no corre, no s'amaga
    res. Plantilla base i sistema visual ja corregits.
    · *fet verificat — el document en blanc al panell tenia el `@media (scripting: none)` posat
    i no va servir de res (2026-07-30)*

### Procés

8. **Comporta visual abans d'entregar: obrint el document, no fabricant captures.** Un
   esquelet aprovat en text no és una pàgina aprovada, però mirar-la és feina de l'Adrià:
   se li obre l'HTML al panell i s'espera el vistiplau abans del PDF. Captures només per a un
   dubte concret i només d'aquella secció.
   · *decisió, 2026-07-30 — traslladada del `reels-producer`; **corregida el mateix dia**:
   fabricar 17 captures d'un document costava molt més que ensenyar-lo al navegador*

9. **Revisor independent només si el document surt de l'empresa** — propostes i portafolis.
   Per als documents interns, prou amb la llista de comprovacions passada amb comandes i el
   vistiplau de la comporta visual.
   · *decisió, 2026-07-30 — **corregida el mateix dia**: el revisor va costar 154.000 tokens
   per protegir un document que es refà amb una edició, i les comprovacions que importaven es
   van acabar fent amb quatre `grep`. Vegeu la regla general de comportes al
   `METODE-APRENENTATGE.md`*

9b. **Verificar amb comandes abans que amb els ulls.** El prefix `.js`, les peticions a
    internet i el nombre de pàgines del PDF es comproven amb un `grep` i quatre línies de
    Python, en un segon i sense equivocar-se. Els ulls es reserven per al que una comanda no
    pot veure.
    · *fet verificat, 2026-07-30 — la verificació sencera de la primera guia real es va fer
    així en deu segons, després que l'agent hi hagués dedicat molt més*

9c. **No et facis car.** No rellegeixis el document sencer per editar-lo (50-70 KB per
    lectura): llegeix per rangs. Val més una escriptura gran que deu edicions amb deu lectures
    pel mig. Per a documents llargs, **construeix per seccions en fitxers separats i concatena
    al final** — l'entrega segueix sent un sol fitxer.
    · *fet verificat, 2026-07-30 — 24 lectures i 10 edicions sobre un fitxer de 50 KB van ser
    el gruix real de la factura de la primera guia*

10. **Verificar amb captures, no per raonament.** Els defectes reals — text tallat, elements
    invisibles, coses descentrades, pàgines en blanc — només es veuen mirant fotogrames.
    · *decisió, 2026-07-30*

### Contingut

12. **El document no parla mai de si mateix.** Cap nota que expliqui de qui és la veu, què vol
    dir un bloc marcat, quina convenció tipogràfica s'ha fet servir, que l'autoria no consta
    o què s'ha retallat. Al lector — client, cap o soci — no li aporta res. Si un recurs
    visual necessita instruccions, està mal fet, igual que un diagrama que necessita llegenda.
    El que s'ha de dir sobre com s'ha fet el document va **al xat**.
    · *decisió, 2026-07-30 — sobre una nota de convenció que va sortir a la portada de la
    primera guia real*

13. **La informació entra abans pels ulls que pel text.** Icones dibuixades en línia a les
    llistes (traç uniforme, `currentColor`, cap icona decorativa) i **logotips reals de les
    tecnologies i plataformes que s'anomenin**, incrustats com a SVG o `data:` URI. Ordre de
    preferència per bloc: diagrama > taula amb icones > llista amb icones > text corregut.
    · *decisió, 2026-07-30 — «utilitzaria més icones i imatges i fluxos d'animació, perquè les
    coses entren més pels ulls que pel text»*

14. **La llegibilitat mana sobre el caràcter visual.** Un tema tècnic admetria un registre més
    marcat, però si el document existeix perquè algú hi prengui una decisió, guanya el que es
    llegeix. La tria del registre és de qui rep el document, no de l'agent: si dubtes, pregunta
    abans de construir.
    · *decisió, 2026-07-30 — sobre la guia de plataforma: «potser hagués fet algo més
    ciberpunk, però per ser una presentació per algú i que sigui llegible està bé»*

## Quant hauria de costar un document

Referència de la primera passada real, per tenir un número contra el qual comparar: la guia
de plataforma (informe de 17 KB → HTML de 70 KB amb 58 SVG + PDF de 16 pàgines) va costar
**~350.000 tokens a l'agent i ~155.000 més al revisor, i gairebé una hora**. Massa.

El repartiment: escriure l'HTML és inevitablement car (uns 20.000 tokens de sortida), però el
gruix se'n va anar en **rellegir el document per editar-lo**, en **fabricar captures** i en el
**revisor**. Les tres coses ja estan corregides a les regles 8, 9, 9b i 9c.

Amb aquestes regles, un document d'aquesta mida hauria de sortir per **una fracció d'això**.
Si la propera passada torna a acostar-se a aquest número, el problema no és el document: és
que alguna regla no s'està aplicant. Anota aquí el cost real de cada document nou.

| Document | Mida | Cost | Temps |
| --- | --- | --- | --- |
| Guia de plataforma (abans de les regles de cost) | 70 KB, 58 SVG, 16 pàg. | ~350.000 + 155.000 del revisor | ~1 h |
| Deck Control Hub (amb les regles aplicades) | 41 KB, 12 diapositives | **107.000** | ~10 min |

**El deck va costar una cinquena part**, amb comporta d'esquelet inclosa i sense revisor (és
intern). El repartiment va ser el que ha de ser: quatre lectures, **una escriptura gran**,
cinc edicions quirúrgiques i quatre comandes de verificació. La comporta d'esquelet limitada
a 400 paraules va costar 66.000 tokens i 54 s, contra els 72.000 i 223 s de l'equivalent sense
límit — i va sortir més útil, perquè era una llista revisable en comptes d'un informe.

Compte amb una cosa: **l'agent va informar de ~70.000 tokens quan el cost real van ser
107.000**. La seva autoestimació es queda curta; agafa el número del comptador, no el seu.

## On ho vam deixar (2026-07-30)

L'agent, el sistema visual, la plantilla base i les quatre skills (`/guia-visual`,
`/presentacio`, `/portafoli`, `/proposta-client`) estan escrits, les receptes verificades
(PDF per Chrome headless, paginació del deck) i les tres regles de procés que venien del
`reels-producer` ja instaurades a l'agent i a les quatre skills (comporta visual, revisor
independent, verificar amb captures).

**Encara no s'ha fet servir amb cap document real.** Següent pas: agafar una guia densa de
veritat i passar-hi `/guia-visual` de punta a punta, com es va fer amb el reel — i anotar
aquí què s'ha trencat, perquè la primera passada real d'un agent sempre en trenca alguna.

## Hipòtesis en prova

- **Serifa al cos i pal sec als titulars**, amb piles del sistema i sense fonts externes:
  llegeix millor en documents llargs i no s'assembla a la sortida per defecte de cap eina.
  · *n=1 (plantilla base)*
- **Un document dens sol tenir un 30-40 % de text que sobra**, i treure'l és la meitat de la
  feina d'una guia visual. · *n=0 — criteri de partida*
- **Tot el que és procés, jerarquia, comparació o cronologia s'entén millor dibuixat.**
  · *n=0 — criteri de partida*
- **Els diagrames van amb `overflow-x: auto` al contenidor**, mai deixant que es desplaci la
  pàgina sencera. · *n=1*

## Changelog

- **2026-07-29** · fitxer creat amb l'agent i el sistema visual. Tres regles per decisió i
  tres per fet verificat (PDF amb Chrome headless, trampa dels noms de graella, via headless
  per revisar quan el panell no es veu).
- **2026-07-30** · polida de l'agent. Les tres coses que venien del `reels-producer` i estaven
  pendents de provar pugen a regla per decisió (8, 9, 10) i queden instaurades a l'agent i a
  les quatre skills. Corregida la recepta per avançar les animacions a mà: `getAnimations()`
  no serveix amb la plantilla base, cal forçar la classe `.vist`. Res tret.
- **2026-07-30, més tard** · **primera passada amb material real** (informe d'assessorament de
  plataforma → guia visual). Quatre regles noves i una correcció important:
  la 11 substitueix el mecanisme de protecció del revelat, que **no protegia** (el document
  sortia en blanc al panell), i esmena la causa que la regla 7 donava per bona. Les 12, 13 i
  14 surten del que l'Adrià va veure al document construït i no estava escrit enlloc: fora el
  text que parla del document, més icones i logotips reals, i la llegibilitat per sobre del
  registre visual. La comporta visual va complir la seva funció: els quatre defectes es van
  trobar abans del PDF i abans del revisor.
- **2026-07-30, final de la primera passada** · el document va sortir bé però va costar mig
  milió de tokens i gairebé una hora. Les regles 8 i 9, escrites aquest mateix matí, es
  **corregeixen el mateix dia**: la comporta visual es fa obrint el document i no fabricant
  captures, i el revisor independent queda només per als documents que surten de l'empresa.
  Regles noves 9b (verificar amb comandes) i 9c (no et facis car), i una secció amb el cost de
  referència. La lliçó general —**una comporta ha de costar menys que el que protegeix**, i
  quan es transplanta d'un agent a un altre s'ha de recomprovar l'economia— puja al
  `METODE-APRENENTATGE.md`, perquè val per a tots els agents.
