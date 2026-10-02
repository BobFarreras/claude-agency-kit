# FASE C — Generar la skill hija

Construyes una skill nueva, autocontenida, a partir del `perfil.json`. Se llama
`reel-edita-<marca_slug>` (p. ej. `reel-edita-lucia-ia`).

## Principio: MOTOR se copia, IDENTIDAD se genera

- **MOTOR** = lo que hace bueno cualquier reel (universal). **Se copia tal cual**, no se reinventa.
- **IDENTIDAD** = lo que hace que el reel sea de ESA persona. **Se genera desde el perfil**, nunca se copia del autor original.

## Mapa de archivos de la skill hija

```
reel-edita-<slug>/
├── SKILL.md                       ← GENERAR desde references/04-plantilla-skill-hija.md + perfil
├── scripts/                       ← COPIAR de assets/motor-scripts/ (tal cual)
│   ├── transcribe-groq.sh         ← PASO 0: sin esto no hay corte automático
│   ├── islands.py  cut.py  verify-cut.py  captions.py
│   ├── lint-timeline.py  make-sfx.sh  mix-sfx.py
│   └── fal-gen.py                 (incluir solo si broll.ia == true)
└── references/
    ├── 01-corte-y-limpieza.md     ← MOTOR: copiar de assets/motor-refs/
    ├── 02-motion-graphics.md      ← MOTOR: copiar de assets/motor-refs/
    ├── 03-sfx-y-qc.md             ← MOTOR: copiar de assets/motor-refs/
    ├── 05-revisor.md              ← MOTOR: copiar de assets/motor-refs/
    ├── 04-recetas.md              ← IDENTIDAD: GENERAR desde perfil
    ├── 06-broll.md                ← IDENTIDAD: GENERAR (solo si broll.real o broll.propios)
    ├── 07-subtitulos.md           ← IDENTIDAD: GENERAR (solo si texto.subtitulos != "no")
    ├── 08-cold-open.md            ← IDENTIDAD: GENERAR (solo si ritmo.cold_open)
    └── estilo.md                  ← IDENTIDAD: GENERAR — la "hoja de marca" (colores, fuentes, framing)
```

Copia los archivos de motor con `cp`. **No los reescribas.** Si falta una dependencia (p. ej. fal),
omite su script y ajusta el doc de identidad correspondiente.

## Generar la IDENTIDAD desde el perfil

### `references/estilo.md` (la hoja de marca — el corazón de la personalización)
Escribe un documento corto y operativo que el motor consultará en cada vídeo:
- **Paleta** (`marca.colores`): base, fondo, **acento** (sustituye al violeta del autor), texto. Da los hex.
- **Tipografías** (`marca.fuentes`): display + texto, con import si son web-fonts libres.
- **Framing** (`pantalla.*`): cómo sale en pantalla (full / PiP en `pip_pos` / split / alternar; screenshare con o sin cara).
- **Logo/marca de agua** (`marca.logo`): si lo hay, dónde va (arriba, lejos del tercio inferior).
- **Estética** (`marca.estetica`) y **ritmo** (`ritmo.velocidad`): traduce a reglas ("punch alto", "con aire en conceptos densos").
- **Música/SFX** (`ritmo.*`).
- **Posición del texto:** SIEMPRE a nivel del micrófono/pecho (regla de motor, repítela aquí).

### `references/04-recetas.md` (tratamientos visuales)
Adapta el catálogo de tratamientos al perfil. Mantén el FRAMEWORK universal ("lee el vídeo →
elige/combina un tratamiento → no repitas molde fijo") y rellena los tratamientos que apliquen
a SU formato y estética: editor-pro, screenshare/demo, pantalla-partida, kinético, minimal, con
elementos aportados. Usa SUS colores y SU framing en los ejemplos, nunca los de nadie más.

Estructura de cada receta: **nombre · cuándo usarla · capas (full/PiP/split, B-roll, texto) ·
ritmo (ágil vs aire) · ejemplo de beat sheet**. El catálogo no es cerrado: la persona puede pedir
tratamientos nuevos. Lo universal es el framework "lee el vídeo → propón tratamiento → no repitas molde".

### `references/08-cold-open.md` (si `ritmo.cold_open`)
Estilos de apertura 0-3s según su estética: resultado-real (default), texto-hook, imagen IA
(solo si `broll.ia`), o split real-vs-IA. El cold open se monta como **clip aparte y se antepone
con `ffmpeg concat`** (no dentro del timeline, para no romper la sincronía).

### `references/07-subtitulos.md` (si lleva subtítulos)
Estilo de subtítulo con la palabra-clave en SU color de acento, a nivel del micro. Documenta cómo
pasar `--keywords` a `captions.py` según `texto.keywords_tipo`.

### `references/06-broll.md` (si `broll.real` o `broll.propios`)
Cómo conseguir/colocar B-roll: capturas reales (firecrawl, si lo tiene), assets propios (desde
`broll.propios.carpeta`), insertos en marco navegador con scroll, logos en insignia. Solo assets
reales/verificados, nunca inventados.

## Reglas de NEUTRALIZACIÓN (obligatorio)

Al generar, elimina cualquier rastro del autor original:
- **Nombre** del autor → el `marca_nombre` de la persona (o tercera persona neutra).
- **Paleta** (violeta/lila del autor) → la paleta del perfil.
- **Rutas** tipo `01-IA Masters/03-Contenido/...` → la `entrega.carpeta` del perfil (ruta relativa a SU proyecto).
- **`.env.local`** → el del proyecto de la persona (los scripts ya lo buscan hacia arriba desde el cwd).
- **Keywords de ejemplo** del autor (sus temas de IA) → vacío o las que diga el perfil.
- Referencias a skills privadas del autor → quitar. Solo `/watch` (pública) puede quedar como opcional.
- **Marcador `<SKILL>`**: los docs de motor citan los scripts como
  `~/.claude/skills/<SKILL>/scripts/…`. Sustituye `<SKILL>` por el nombre real de la carpeta
  hija (`reel-edita-<slug>`) en TODOS los archivos copiados. Si queda algún `<SKILL>`, los
  comandos del motor apuntan a una ruta que no existe.

## Piezas que NO vienen en este paquete (dilo claramente, no las inventes)

- **`detect-repeats.py`** — lo cita `01-corte-y-limpieza.md` como apoyo del flujo antiguo. No
  se distribuye. El flujo canónico (`islands` → `cut` → `verify-cut`) **no lo necesita**: lo que
  sigue siendo útil de esa sección es el catálogo de patrones de repetición, para decidir los
  DROP a mano en `islands.json`.
- **`/watch`** — QC visual del render. Es una skill aparte; si la persona no la tiene, el
  revisor (fase 5) hace sus comprobaciones 3 y 4 mirando el render y su transcripción, y se
  anota como limitación en la entrega. No bloquea.

> Verificación final: haz un grep del nombre del autor y de su paleta sobre la skill hija. Si aparece
> algo, no has neutralizado bien.

## Workspace de la skill hija

La hija trabaja en `<entrega.carpeta>/<slug-del-video>/` con `edicion/` (corte, transcripts) y
`motion/` (proyecto Hyperframes). **Nunca toca el bruto original.** Hereda la resolución del bruto
salvo que el perfil fuerce 1080×1920.

## Dónde dejar la skill hija e instalación

1. Genera la carpeta `reel-edita-<slug>/` en un sitio temporal o en el proyecto.
2. Para activarla en Claude Code: copiarla a `~/.claude/skills/reel-edita-<slug>/`.
   ```bash
   cp -R reel-edita-<slug> ~/.claude/skills/
   ```
3. Dile cómo invocarla (su `name` y frases de activación) y pasa a la Fase D (estreno).
