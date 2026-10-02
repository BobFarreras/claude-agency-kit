# Sistema visual dels documents

> El llegeixen el subagent `doc-designer` i les skills `/guia-visual`, `/presentacio`,
> `/portafoli` i `/proposta-client`. Serveix perquè tot el que surt de l'empresa s'assembli
> entre si, i perquè no s'hagi de decidir la tipografia des de zero cada vegada.

## Principis

1. **La comprensió mana sobre la decoració.** Cada element visual ha de fer entendre alguna
   cosa. Si només omple, fora.
2. **El document es llegeix, no s'admira.** Mesura d'èxit: algú que no hi entén arriba al
   final i sap explicar la idea principal.
3. **Un sol fitxer.** Autocontingut, sense CDN ni fonts externes. Ha de funcionar amb doble
   clic i dins d'un correu.
4. **Tot el que es veu a la pantalla ha de sobreviure a la impressió.** El PDF no és una
   segona versió: és el mateix document sense moviment.

## Tipografia

- **Cos a 18 px** (`1.125rem`), interlineat `1.65`. Res llegible per sota de 16 px.
- **Amplada de lectura màxima 68 caràcters** (`max-width: 34rem` per al text corregut). Un
  paràgraf que travessa tota la pantalla no es llegeix.
- Escala: `2.986rem / 2.074rem / 1.44rem / 1.2rem / 1.125rem / 0.875rem` (raó 1,2). No
  facis servir més de quatre nivells en un mateix document.
- Titulars amb interlineat curt (`1.1`) i `letter-spacing: -0.02em`. El cos, sense tocar.
- **Pila tipogràfica sense dependències externes** — a Windows i Mac dona un resultat molt
  millor que `sans-serif` a seques:
  ```css
  --font-text: "Charter", "Bitstream Charter", "Sitka Text", Cambria, Georgia, serif;
  --font-titol: "Inter", "Segoe UI Variable Display", "Segoe UI", -apple-system, sans-serif;
  --font-codi: "Cascadia Code", "SF Mono", Consolas, monospace;
  ```
  Serifa al cos i pal sec als titulars llegeix millor en documents llargs i no s'assembla a
  la sortida per defecte de cap eina. Si el client té tipografia pròpia, mana la seva.

## Color

- **Un color d'accent per document**, el de la marca de qui el rep. Tot el que no és accent
  és tinta sobre paper.
- Fons de paper càlid (`#faf8f5`), mai blanc pur: cansa menys i no sembla un editor de text.
- Tinta a `#1a1a1a`, mai negre pur.
- Els grisos surten de la tinta amb transparència (`color-mix`), no de valors inventats.
- Contrast mínim 4.5:1 per al text. Comprova-ho abans d'entregar, sobretot amb l'accent sobre
  el paper.
- **Per a gràfics de dades, carrega la skill `dataviz`** i fes servir la seva paleta. No
  n'inventis una.

```css
:root {
  --paper: #faf8f5;
  --ink: #1a1a1a;
  --ink-60: color-mix(in srgb, var(--ink) 60%, transparent);
  --ink-30: color-mix(in srgb, var(--ink) 30%, transparent);
  --rule: color-mix(in srgb, var(--ink) 12%, transparent);
  --accent: #b4451f;          /* substituir pel color del client */
  --accent-soft: color-mix(in srgb, var(--accent) 12%, var(--paper));
}
```

## Ritme i espai

- Escala d'espais múltiple de `0.5rem`: `0.5 / 1 / 1.5 / 2.5 / 4 / 6.5rem`.
- L'espai **abans** d'un titular sempre més gran que el de després: així el títol s'enganxa al
  que titula. És el que fa que un document llarg es pugui recórrer amb la vista.
- Entre seccions grans, `6.5rem` i, si convé, un filet fi — mai una caixa amb ombra.

## Moviment

Serveix per dirigir l'atenció i per explicar ordre. Mai per decorar.

- **Entrada esglaonada** dels blocs en fer scroll (`IntersectionObserver`, retards de 60-80 ms
  entre germans). Una sola vegada: `observer.unobserve()` en disparar.
- **Diagrames que es construeixen**: traços amb `stroke-dasharray` / `stroke-dashoffset`
  animant-se en l'ordre en què s'explica el procés.
- **Xifres que compten** quan la dada és el missatge de la secció.
- Durades entre 400 i 700 ms, amb `cubic-bezier(0.2, 0.7, 0.2, 1)`. Res que faci esperar.
- **El contingut es veu per defecte; el moviment és el que s'ha d'activar.** Mai a l'inrevés.
  Un script al `<head>` marca l'arrel, i **només les regles que amaguen porten el prefix**:

  ```html
  <script>document.documentElement.classList.add('js');</script>
  ```
  ```css
  .js [data-reveal] { opacity: 0; transform: translateY(14px); }
  .js [data-reveal].vist { opacity: 1; transform: none; transition: opacity .55s var(--easing), transform .55s var(--easing); }

  @media (prefers-reduced-motion: reduce) {
    *, *::before, *::after { animation: none !important; transition: none !important; }
    .js [data-reveal] { opacity: 1; transform: none; }
  }
  ```

  I una xarxa de seguretat per l'altra banda, perquè el revelat ha de fallar obert en totes
  dues direccions — el cas contrari és que el JS **sí** que corri però l'`IntersectionObserver`
  no dispari mai (pestanya amagada a 0 fps):

  ```js
  setTimeout(() => {
    document.querySelectorAll('[data-reveal]:not(.vist)').forEach(el => el.classList.add('vist'));
  }, 4000);
  ```

  **No ho resolguis amb `@media (scripting: none)`.** Aquesta consulta només respon quan el
  navegador declara que *no admet* scripts. Un entorn que els admet però no els executa — el
  panell del navegador de Claude, que serveix el fitxer com a instantània estàtica, però
  també un client de correu, una CSP que bloqueja l'script o un error de JS abans de muntar
  l'observer — **no la dispara, i el document queda en blanc**. Amb el prefix `.js` no hi ha
  cap d'aquests casos: si l'script no corre, no s'amaga res.
  · *comprovat el 2026-07-30: el mateix fitxer, blanc al panell i correcte al navegador
  normal de l'Adrià.*

## Diagrames

- **SVG en línia** per a tot el que ha de ser autocontingut i imprimible. Amb `currentColor`
  agafa el color del context i no cal mantenir dues versions.
- **Mermaid** només quan el destí el renderitza de forma nativa (Artifacts). En un fitxer
  autocontingut, no.
- Etiqueta **sobre** les formes. Un diagrama que necessita llegenda està mal fet.
- `viewBox` sempre, `width`/`height` fixos mai: així escala al mòbil i al PDF.
- Els diagrames amples van dins d'un contenidor amb `overflow-x: auto`. La pàgina no es
  desplaça mai en horitzontal.

## El document no parla de si mateix

Res del que expliqui **com està fet** el document hi pot sortir. Ni una nota que digui de qui
és la veu, ni què vol dir un bloc marcat, ni quina convenció tipogràfica s'ha fet servir, ni
que l'autoria no consta, ni quines seccions s'han retallat. Al lector — un client, un cap, un
soci — això no li aporta res i el distreu de l'única cosa que ha d'entendre.

Si has fet servir un recurs visual per distingir dues coses, **ha de ser evident sense
explicar-lo**. Un recurs que necessita una nota d'instruccions és exactament el mateix que un
diagrama que necessita llegenda: està mal fet.

El que sí que s'explica va **al xat, no al document**: què s'ha tret, quines decisions has
pres i què queda pendent.

· *decisió de l'Adrià, 2026-07-30, sobre una nota de convenció que havia sortit a la portada.*

## Icones, logotips i densitat visual

**La informació entra abans pels ulls que pel text.** Una llista de deu vinyetes i la mateixa
llista amb una icona per fila no es llegeixen igual, encara que diguin el mateix.

- **Icones dibuixades en línia (SVG), no una llibreria enganxada.** Traç d'1,5-2 px,
  `currentColor`, mida entre 20 i 28 px, la mateixa família de traç a tot el document. Han de
  representar la cosa concreta de la seva fila; si te n'has d'inventar una perquè "quedi
  bé", aquella fila no en necessita. Segueix valent que no hi hagi icones de farciment: el
  criteri no és quantes n'hi ha, és si cadascuna diu alguna cosa.
- **Els logotips reals de les tecnologies i les plataformes, quan es parlin.** Next.js,
  Supabase, PostgreSQL, n8n, Docker, Redis, Traefik, WhatsApp: un lector reconeix el logotip
  abans d'haver llegit el nom, i una taula d'stack amb logotips s'escaneja en un terç del
  temps. Incrusta'ls com a **SVG en línia o `data:` URI** — la regla del fitxer únic no
  s'excepciona per a un logotip. En documents interns, sense problema. Si el document surt
  a fora o és comercial, respecta les normes d'ús de cada marca i no els deformis ni els
  recoloreixis.
- **Preferència d'ordre a cada bloc**: si es pot dir amb un diagrama, diagrama; si no, taula
  amb icones; si no, llista amb icones; text corregut només per al que és argument.
- **Moviment on hi ha seqüència.** Un procés que s'anima en el seu ordre explica l'ordre sense
  numerar-lo. Val la mateixa regla de sempre: si el moviment no explica res, fora.

· *decisió de l'Adrià, 2026-07-30.*

## Registre visual

El to visual s'adapta al tema, però **la llegibilitat mana sobre el caràcter**. Un document
tècnic admet un registre més marcat que un de comercial; ara bé, si el document existeix
perquè algú hi prengui una decisió, guanya el que es llegeix. Si dubtes, pregunta abans de
construir — és una decisió de qui rep el document, no teva.

## Impressió (el PDF surt d'aquí)

```css
@media print {
  :root { --paper: #fff; }
  @page { size: A4; margin: 18mm 16mm; }
  [data-reveal] { opacity: 1 !important; transform: none !important; }
  h1, h2, h3 { break-after: avoid; }
  figure, table, .diagrama { break-inside: avoid; }
  a[href^="http"]::after { content: " (" attr(href) ")"; font-size: 0.75em; color: #555; }
  nav, .nomes-pantalla { display: none; }
}
```

Comprova sempre el PDF obert, no només que el fitxer existeixi. Els dos errors que es
repeteixen: blocs animats que s'imprimeixen invisibles i diagrames tallats a mitges.

## Generar el PDF

```bash
"/c/Program Files/Google/Chrome/Application/chrome.exe" --headless --disable-gpu --no-pdf-header-footer --print-to-pdf="sortida.pdf" "document.html"
```

Verificat en aquesta màquina el 2026-07-29. Sense `--no-pdf-header-footer`, Chrome hi
estampa la data i la URL del fitxer local — cosa que en un document de client no hi pot anar.

## Llista de comprovació abans d'entregar

- [ ] La idea principal s'entén als primers 10 segons de mirar la pàgina.
- [ ] Cos a 18 px i cap text important per sota de 16 px.
- [ ] Cap gradient blau-violeta genèric, cap text de farciment, cap "demo".
- [ ] **El document no parla de si mateix**: cap nota sobre convencions, veus, autoria ni
      retallades.
- [ ] Les tecnologies i plataformes que s'anomenen porten el seu logotip, i els blocs de
      llista porten icona pròpia. Cap fila d'icona decorativa.
- [ ] **Amb el JS desactivat el document es veu sencer** (obre'l amb els scripts bloquejats o
      treu la classe `.js` de l'arrel i mira'l). Si queda en blanc, tens el prefix `.js` al
      revés.
- [ ] Es llegeix igual amb `prefers-reduced-motion`.
- [ ] El PDF obert: res invisible, res tallat, cap pàgina en blanc, i **el nombre de pàgines
      és el que esperaves**.
- [ ] Un revisor independent (subagent que no ha muntat el document) ha donat `PASS`.
- [ ] Amplada de mòbil: la pàgina no es desplaça en horitzontal.
- [ ] Un sol fitxer HTML, sense cap petició a internet.
