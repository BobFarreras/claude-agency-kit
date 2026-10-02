# Plantilla del SKILL.md de la skill hija

Rellena los `{{placeholders}}` desde `perfil.json`. Las secciones marcadas *(condicional)* se
incluyen solo si el perfil lo pide. El resultado va en `reel-edita-{{marca_slug}}/SKILL.md`.

---

```markdown
---
name: reel-edita-{{marca_slug}}
description: Convierte un vídeo bruto VERTICAL en un reel/TikTok producido con el estilo de {{marca_nombre}} — corta repeticiones/silencios/errores, propone un tratamiento adaptado al contenido, monta {{resumen_framing}} + B-roll + texto + SFX y lo deja listo para subir. Úsala cuando se diga "edita este vídeo a reel", "hazme el reel de este vídeo", "/reel-{{marca_slug}}", o se pase la ruta de un MP4 vertical para publicar en Reels/TikTok.
---

# reel-edita-{{marca_nombre}} — Bruto vertical → reel producido

Coges un bruto vertical y lo conviertes en un reel muy visual con el estilo de {{marca_nombre}}.
**No hay un estilo fijo por vídeo:** tras limpiar el corte, lees el vídeo y propones el tratamiento
que mejor encaja con ESE contenido (evita la fatiga de hacer siempre lo mismo). Tu identidad visual
está en `references/estilo.md`.

## Reglas de oro (léelas antes que nada)

1. **El corte de audio se BLOQUEA y se aprueba ANTES de tocar una sola animación.** Las animaciones
   se sincronizan a timestamps del corte; si recortas después, toda la línea de tiempo se desplaza y
   hay que re-sincronizar todo.
2. **El corte se decide por SILENCEDETECT, no por timestamps de Whisper** (imprecisos ±0.2-0.3s).
   Detecta los islotes de voz por energía de audio, quédate con la ÚLTIMA toma de cada frase y pega
   los islotes sin pausas. Whisper solo etiqueta/verifica/sincroniza.
3. **Nada se entrega sin pasar la COMPUERTA DURA y el REVISOR.** `verify-cut.py` exit 0 antes de
   animar; revisor PASS antes de entregar. {{si control.revisor=false: "(revisor desactivado en tu perfil)"}}

## Entrada y workspace

Input: ruta del bruto vertical + un slug corto. Trabaja en `{{entrega.carpeta}}/<slug>/` con
`edicion/` (corte, transcripts) y `motion/` (proyecto Hyperframes). **Nunca toques el bruto original.**
Verifica al empezar: `ffmpeg`, `npx hyperframes`, `GROQ_API_KEY` en `.env.local`{{si broll.ia: ", `FAL_KEY`"}}, y `/watch`.
Resolución de la composición = {{entrega.resolucion: "la del bruto" | "1080×1920"}}.

---

## FASE 1 — BLOQUEAR EL CORTE (determinista) · `references/01-corte-y-limpieza.md`

Corte ágil sin silencios, sin errores, sin repeticiones:
1. Transcribe el bruto una vez word-level (Groq). Reutilízalo.
2. `python scripts/islands.py --media <bruto> --transcript <word.json> --out islands.json` → revisa
   la tabla KEEP/DROP y ajusta los `keep` (bloopers, falsos arranques, tangentes). Regla: última toma.
3. `python scripts/cut.py --islands islands.json --out edicion/corte-final.mp4`.
4. **COMPUERTA DURA:** re-transcribe el corte y `python scripts/verify-cut.py --media edicion/corte-final.mp4 --transcript edicion/transcript-final.json`. exit 0 = pasa; itera hasta exit 0.
5. **LECTURA HUMANA:** imprime el texto corrido del corte y léelo entero buscando repeticiones/reinicios.
6. Presenta el corte limpio (duración, qué se quitó).

## FASE 1.5 — LEER EL VÍDEO Y PROPONER TRATAMIENTO · `references/04-recetas.md`

1. Mira el corte con `/watch` para entender qué tipo de vídeo es y su estructura.
2. Elige/combina un tratamiento de `references/04-recetas.md`.
3. {{si ritmo.cold_open: "Decide el COLD OPEN (1-3s) según el contenido · `references/08-cold-open.md`."}}
4. Propón a {{marca_nombre}} 2-3 opciones con tu recomendación. {{si control.autonomia=consulta: "Espera que elija." | "Elige la mejor y enséñala montada."}}

## FASE 2 — PLANIFICAR EL MONTAJE · `references/02-motion-graphics.md`

Re-transcribe el corte aprobado → saca segment timings → **beat sheet**: mapea cada tramo, marca
ritmo (ágil en gancho/listas, aire en conceptos densos) y qué es full-frame / B-roll / {{framing}}.

## FASE 3 — CONSTRUIR (Hyperframes) · `references/02-motion-graphics.md` + estilo + identidad

`npx hyperframes init` → `index.html` a la resolución correcta con las capas:
1. Cámara {{pantalla.formato}} + escenas B-roll · `02-motion-graphics.md`
{{si broll.real o broll.propios: "2. B-roll real/propio (capturas, logos, insertos) · `references/06-broll.md`"}}
{{si texto.subtitulos!=no: "3. Subtítulos a nivel del micro (`scripts/captions.py`, palabra-clave en {{marca.colores.acento}}) · `references/07-subtitulos.md`"}}
4. Rótulos y texto a nivel del micro; logo según `references/estilo.md`.
{{si ritmo.cold_open: "5. COLD OPEN como clip separado, antepuesto con `ffmpeg concat` (no dentro del timeline) · `references/08-cold-open.md`"}}
`lint` + `inspect` a 0 errores, y `python scripts/lint-timeline.py motion/index.html` sin gaps >4s antes de renderizar.

## FASE 4 — SFX, QC Y ENTREGA · `references/03-sfx-y-qc.md`

{{si ritmo.sfx!=ninguno: "1. SFX con `scripts/make-sfx.sh`."}}
2. Render `--quality standard` → QC con `/watch` (huecos, solapes, sincronía, legibilidad) → arreglar.
{{si ritmo.sfx!=ninguno: "3. Mezcla SFX en post (`scripts/mix-sfx.py`)."}}
4. Render `--quality high` final{{si ritmo.sfx!=ninguno: " + re-mezcla SFX"}}.

{{si control.revisor: "## FASE 5 — REVISOR (subagente independiente, OBLIGATORIO) · `references/05-revisor.md`

Spawnea un subagente revisor (tool `Agent`) que NO montó el reel. Re-transcribe el AUDIO DEL RENDER
FINAL desde cero y lee el texto entero buscando repeticiones (lo que más falla). Corre `verify-cut.py`
y `lint-timeline.py --json` sobre el render. Devuelve PASS/FAIL. Solo se entrega si PASS y sin blockers."}}

## Reglas que no se negocian

- Brutos intactos. Output a `edicion/` y `motion/`.
- Corte por silencedetect (islands→cut→verify), nunca por timestamps de Whisper.
- COMPUERTA `verify-cut.py` (exit 0) antes de animar.{{si control.revisor: " REVISOR (PASS) antes de entregar."}}
- Tratamiento propuesto según el contenido, no molde fijo.
- TEXTO/SUBTÍTULOS/rótulos a NIVEL DEL MICRÓFONO, nunca pegados al borde inferior (la UI tapa el tercio de abajo).
- Beat visual ≤4s (`scripts/lint-timeline.py`, gap>4s = error).
- Cero repeticiones y cero silencios en el cuerpo. Última toma siempre.
- Que NO parezca hecho por IA: evita clichés (píldoras "EL PROBLEMA/LA SOLUCIÓN", etiquetas-capítulo genéricas).
- Determinismo Hyperframes: sin `Math.random()`/`Date.now()`; `repeat` finito; timelines `paused`.
```

---

## Notas de relleno

- `{{resumen_framing}}` / `{{framing}}`: de `pantalla.formato` → "cámara PiP", "pantalla partida", "full-frame", etc.
- Las líneas `{{si condición: "texto"}}` son condicionales: inclúyelas solo si se cumple; si no, bórralas.
- El `name` debe ser único y en kebab-case. Las frases de activación, claras y en su idioma.
- Tras generar, relee el SKILL.md y borra cualquier placeholder que haya quedado sin resolver.
