# Fase C — Generar el sistema

## Mapa de lo que se crea

El cerebro (una carpeta de trabajo del miembro, p. ej. en su proyecto de contenido) +
4 skills en `~/.claude/skills/`. El editor (`reel-edita-<slug>`) ya existe de forja-reel.

```
<carpeta-contenido>/_engine/
  playbook.md            ← desde assets/motor-refs/playbook-seed.md (esqueleto, SIN reglas ajenas)
  ledger/_schema.md      ← desde assets/motor-refs/ledger-schema.md
  ledger/                ← vacío; se llena un JSON por reel
  informes/              ← vacío; HTML/resumen semanal

~/.claude/skills/
  reel-<slug>/           ← guiones
  reel-publica-<slug>/   ← caption + ledger + preparar publicación
  reel-radar-<slug>/     ← métricas (navegador o manual) → snapshots al ledger
  reel-feedback-<slug>/  ← análisis semanal → diffs al playbook (con OK)
  reel-edita-<slug>/     ← YA EXISTE (forja-reel); solo se le añade el cableado (abajo)
```

## Las 4 skills (plantillas en 04-plantilla-skills-hijas.md)

Cada una se genera desde el `perfil.json` + su plantilla. Todas comparten dos verbos:
**LEEN** el playbook antes de trabajar y **ESCRIBEN/leen** el ledger.

1. **`reel-<slug>` (guiones):** parte de la fuente de ideas del perfil (noticias→verifica;
   dudas→parte de la pregunta). Lee el playbook (hooks que funcionan, ángulos ganadores,
   pecados a evitar) y produce guion + plan visual. Etiqueta cada guion con su `intencion`
   y `hook_familia`.
2. **`reel-publica-<slug>`:** genera caption + hashtags + hora sugerida según la intención;
   si es conversión, mete el CTA "comenta X" y su UTM; completa la ficha del reel en el
   ledger. PREPARA; el humano publica.
3. **`reel-radar-<slug>`:** según `metricas.modo`, lee Insights por navegador o pregunta
   las cifras; guarda snapshots con fecha en el ledger. Dato ausente = `null`, nunca
   inventado.
4. **`reel-feedback-<slug>`:** el cierre del bucle (ritual semanal). Corre el radar → calcula
   el KPI por intención (g+c/1k de salud, nunca views a secas) contra la mediana móvil →
   cruza con las fichas → (opcional) competidores → informe → propone **diffs al playbook**
   con la regla de ≥3 reels, **para que el dueño apruebe**. Ver `feedback-semanal.md`.

## Cablear el editor ya existente

En la skill de edición del miembro, añade (sin romper lo suyo) dos ganchos, explicados en
`assets/motor-refs/bucle-y-arquitectura.md`:
- **Antes de editar:** leer el playbook (recetas/estilo que funcionan).
- **Al aprobar el corte final:** escribir/actualizar la ficha del reel en el ledger
  (`edicion.receta`, `cold_open`, etc.). Es lo que alimenta el análisis.

Si tocar su editor es delicado, no lo reescribas: añade una nota clara al final de su
SKILL.md indicando estos dos pasos y deja que su skill los siga.

## Reglas de generación

1. **Método literal, identidad a medida.** Copia `bucle-y-arquitectura.md`,
   `playbook-seed.md`, `ledger-schema.md` y `feedback-semanal.md` tal cual al sistema del
   miembro; rellena las skills desde el perfil.
2. **El playbook nace SIN reglas confirmadas** propias ni datos de nadie. Solo el esqueleto,
   la disciplina (≥3 reels, KPI por intención) y, como mucho, hipótesis genéricas marcadas
   "punto de partida a validar con TUS datos".
3. **Neutralización total:** `grep -ri` de handle/nicho/paleta/reglas del autor = 0.
4. Las 4 skills nuevas + el editor comparten el MISMO `_engine/` (una sola fuente de verdad).
5. La `description` de cada skill hija dispara con el vocabulario del miembro.

## Smoke test

- Las 4 skills aparecen en `~/.claude/skills/` y su YAML parsea.
- El `_engine/` existe con `playbook.md` + `ledger/_schema.md` + carpetas vacías.
- El editor tiene el cableado (o la nota) al ledger/playbook.
- Neutralización = 0.
- Explícale el bucle en voz alta y confirma que lo reconoce como suyo.
