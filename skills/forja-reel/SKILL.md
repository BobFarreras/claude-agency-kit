---
name: forja-reel
description: META-SKILL que crea TU propio editor de reels personalizado. Te hace una entrevista sobre qué editas, cómo sales en pantalla, tus colores y tu estilo; comprueba e instala (opt-in) lo que necesitas (Hyperframes, ffmpeg, Groq, fal); y te genera una skill propia tipo "/reel-edita" con TU identidad pero con un motor de calidad probado dentro (corte determinista, ritmo, revisor anti-IA). Úsala cuando alguien diga "forja mi editor de reels", "quiero crear mi skill de edición", "monta mi reel-edita", "/forja-reel", "configura mi editor de vídeo", o acabe de instalar este paquete y quiera empezar. NO edita un vídeo concreto — eso lo hará la skill que ESTA genera.
---

# /forja-reel — Crea TU propio editor de reels (meta-skill)

Esta skill **no edita vídeos**. Crea **otra skill** — tu editor de reels personal — a tu medida.

La idea: hay un **motor de edición probado** (corte limpio determinista, ritmo, motion graphics, revisor que evita el look-IA). Ese motor es lo que hace bueno a cualquier reel y se comparte tal cual. Pero el **estilo** (colores, cómo sales en pantalla, tipo de B-roll, ritmo, cold open) lo decides TÚ en una entrevista. Así dos personas con esta misma meta-skill sacan editores **distintos** y vídeos que no se parecen.

> **Regla de oro de la meta-skill:** comparto el MOTOR, tú construyes la IDENTIDAD. Nunca embebas el estilo del autor original (su paleta, sus recetas, sus rutas) en la skill que generas. El estilo SIEMPRE sale de la entrevista.

## Qué necesita la persona (resumen honesto antes de empezar)

- **Imprescindible:** `ffmpeg`, `node`/`npx`, y **Hyperframes** (el motor de motion graphics).
- **Muy recomendado y GRATIS:** una API key de **Groq** (transcripción + verificación del corte + revisor). Sin ella el corte automático y el control de repeticiones no funcionan.
- **Opcional de pago:** **fal.ai** (`FAL_KEY`) solo si quieres portadas/cold-opens con imágenes IA.
- **Opcional:** **firecrawl** solo si quieres B-roll real (capturas de webs, logos).
- **Recomendado:** la skill **`/watch`** (QC visual del render).

La Fase B comprueba qué hay y **solo** propone instalar lo que tu estilo necesita. No instala nada sin tu "sí".

---

## Flujo (4 fases, en orden)

### FASE A — ENTREVISTA · `references/01-entrevista.md`
Haz la entrevista completa (8 bloques). **Una pregunta o un bloque cada vez**, en lenguaje claro (la persona puede no ser técnica). Da ejemplos y una opción recomendada en cada decisión. Al terminar, **resume el perfil** en una tabla y pide confirmación. Guarda el resultado como `perfil.json` (esquema en `01-entrevista.md`).

> No pases a la Fase B hasta tener el `perfil.json` confirmado. La entrevista define qué dependencias hacen falta.

### FASE B — DIAGNÓSTICO DE ENTORNO · `references/02-diagnostico-entorno.md`
Con el perfil en mano, comprueba qué está instalado y **qué hace falta para ESE perfil**. Por cada dependencia que falte: explica para qué sirve, si es gratis o de pago, y **pregunta sí/no** antes de instalar. Guía el paso a paso. Si dicen que no a algo opcional, anótalo y degrada esa capacidad en la skill generada (p. ej. sin fal → cold open sin imagen IA).

> Nada de pago ni ninguna API key se configura sin un "sí" explícito.

### FASE C — GENERAR LA SKILL · `references/03-generacion.md` + `references/04-plantilla-skill-hija.md`
Construye la skill hija `reel-edita-<su-marca>/`:
- **Copia el MOTOR tal cual** desde `assets/motor-scripts/` (corte, verify, captions, lint-timeline, sfx) y los docs de motor.
- **Genera la IDENTIDAD desde el perfil:** SKILL.md propio + references de estilo (paleta, recetas adaptadas, cold open, subtítulos, B-roll) escritos a su gusto.
- **Neutraliza** todo lo del autor original (nombre, paleta, rutas tipo `01-IA Masters/...`). Sigue el mapa de archivos y las reglas de neutralización de `03-generacion.md`.
- Deja la skill lista para instalar en `~/.claude/skills/` (o donde toque) e indícale cómo activarla.

### FASE D — ESTRENO
- Smoke test rápido: comprueba que la skill hija se lee y que sus scripts arrancan (`python3 ... --help`).
- Ofrece montar **su primer reel** guiándola con su nueva skill, o dejarle una chuleta de uso.
- Recuérdale las dependencias opcionales que dejó fuera y cómo añadirlas luego.

---

## Reglas que no se negocian

- **Motor sí, estilo no.** El estilo siempre sale de la entrevista; jamás se copia el del autor original.
- **Opt-in para todo lo que cueste o instale.** Pregunta sí/no por cada dependencia; aconseja según lo que la persona quiere hacer.
- **Groq se explica como GRATIS** y se prioriza (transcripción + compuerta de corte + revisor).
- **La skill generada es autocontenida:** sus scripts y references viven dentro de su propia carpeta; su única dependencia externa de skill es `/watch` (pública, opcional).
- **Conserva la disciplina del motor en la skill hija:** corte por silencedetect (no por timestamps de Whisper), compuerta dura `verify-cut.py` antes de animar, beat visual ≤4s (`lint-timeline.py`), revisor independiente antes de entregar, y "que no parezca hecho por IA".
- **Adaptarse al vídeo:** la skill hija debe proponer el tratamiento según el contenido de cada vídeo, no aplicar un molde fijo.
- **Lenguaje de la entrevista:** claro y sin jerga. La persona puede ser vibe-coder no técnico.
- **No se distribuye el estilo del autor original.** El paquete solo trae el MOTOR (scripts + docs técnicos neutralizados en `assets/`). Las recetas, paleta y cold-opens se generan desde cero según el perfil; no hay biblioteca de estilo ajeno que copiar.
