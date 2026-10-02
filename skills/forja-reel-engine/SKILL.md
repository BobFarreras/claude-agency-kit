---
name: forja-reel-engine
description: >
  META-SKILL que monta TU Reel Engine: el bucle de mejora continua para tus reels.
  Da por hecho que ya forjaste tu editor con /forja-reel; sobre él, te entrevista
  (tu nicho, tus plataformas, tu cadencia, tu voz, de dónde sacas ideas, cómo miras
  métricas) y te genera las OTRAS 4 skills del sistema — guiones, publicar, radar de
  métricas y análisis semanal — más el "cerebro" (_engine/: un playbook que evoluciona
  con tus datos + un ledger por reel). Cablea las 5 skills en un bucle que aprende de lo
  que de verdad funciona en TU cuenta. Úsala cuando alguien diga "forja mi reel engine",
  "/forja-reel-engine", "monta mi sistema de reels", "quiero el bucle completo de reels",
  "crea mis skills de contenido", o ya tenga su /reel-edita forjado y quiera el sistema
  entero. NO edita ni escribe reels — eso lo harán las skills que ESTA genera.
---

# /forja-reel-engine — Monta TU Reel Engine (meta-skill)

Esta skill **no hace reels**. Crea el **sistema** que los mejora solo con el tiempo: las
4 skills que te faltan + el cerebro que las conecta.

La idea: publicar reels sueltos no te hace mejorar. Lo que te hace mejorar es un **bucle
cerrado** — cada reel se registra, se miden sus métricas reales, y una vez por semana
analizas qué funcionó y lo conviertes en reglas que tus próximos guiones y ediciones
aplican. Ese método —el bucle, la disciplina de evidencia, el KPI honesto— se comparte
tal cual. Pero **tu nicho, tu voz, tu ritmo y, sobre todo, las reglas que descubras**
son tuyos: nacen vacíos y se llenan con TUS datos.

> **Regla de oro:** comparto el MÉTODO (el bucle y su disciplina), tú generas tu SISTEMA
> con tu identidad. Jamás se copian las reglas confirmadas, el nicho ni los datos del
> autor de este paquete. El playbook del miembro empieza SIN reglas propias.

## Requisito previo (se comprueba en Fase 0)

Este motor gira alrededor de **5 skills**, y una de ellas es tu **editor** (`/reel-edita`),
que se crea con la otra meta-skill, **`/forja-reel`**. Antes de nada:

- Comprueba si existe una skill de edición forjada del miembro (una carpeta tipo
  `reel-edita-<algo>/` en `~/.claude/skills/`, con su motor de corte/revisor).
- **Si NO existe → PARA.** Explícale con cariño: "El Reel Engine necesita tu editor
  primero. Ve a `/forja-reel`, fórjalo, y cuando lo tengas vuelve aquí." No construyas un
  medio-motor roto.
- Si existe, anota su nombre y ruta: el bucle se cableará a ESE editor.

## Qué necesita la persona (resumen honesto)

- **Imprescindible:** su `/reel-edita` ya forjado (requisito de arriba).
- **Para el radar de métricas:** un Claude con **navegador** y su **Instagram logueado**
  (las métricas se leen de los Insights de IG en el navegador — no se usa la API de Meta).
  Si no lo tiene, el radar cae a **modo manual**: el miembro teclea las cifras. Se degrada,
  no se rompe.
- **Recomendado:** una fuente de ideas/noticias de su nicho, y decidir sus plataformas
  (IG/TikTok/YouTube Shorts) y su cadencia.

> Aviso importante que debes darle: **el bucle da fruto a las semanas**, cuando su
> playbook acumula evidencia (regla de ≥3 reels). El día 1 tendrá el sistema montado y el
> playbook casi vacío. Es normal y es lo correcto — cero supersticiones.

---

## Flujo (4 fases, en orden)

### FASE A — ENTREVISTA · `references/01-entrevista.md`
Entrevista (8 bloques), un bloque cada vez, con ejemplos de su nicho. Define su identidad
de creador y cómo va a alimentar el bucle. Termina en un `perfil.json` confirmado.

### FASE B — DIAGNÓSTICO · `references/02-diagnostico-entorno.md`
Confirma el requisito (su editor forjado), comprueba el acceso a métricas (navegador +
IG logueado, o fallback manual) y las skills auxiliares que use (transcripción/análisis
de competidores, publicación). Opt-in para todo.

### FASE C — GENERAR EL SISTEMA · `references/03-generacion.md` + `references/04-plantilla-skills-hijas.md`
Genera las **4 skills** que faltan (`reel-<slug>`, `reel-publica-<slug>`,
`reel-radar-<slug>`, `reel-feedback-<slug>`) + el **cerebro `_engine/`** (playbook semilla
+ ledger + informes), copiando el método de `assets/motor-refs/` y cableando las 5 skills
(incluido su editor) para que LEAN y ESCRIBAN el playbook y el ledger.

### FASE D — ESTRENO
Smoke test del sistema, y explícale el **ciclo semanal** (idea → guion → editar →
publicar+registrar → medir → analizar → mejorar el playbook → repetir). Ofrécele arrancar
su primer reel o dejarle una chuleta del bucle.

---

## Reglas que no se negocian

- **Skills estables, conocimiento vivo.** Las skills son el motor y no se editan a sí
  mismas; lo que evoluciona es el **playbook**. Esto evita que el sistema se corrompa solo.
- **Disciplina de evidencia:** nada entra en "reglas confirmadas" del playbook sin **≥3
  reels** en la misma dirección contra la mediana móvil. Lo demás es "hipótesis". Cero
  supersticiones.
- **El KPI no son las views.** Se juzga por intención del reel (alcance/autoridad vs
  conversión) y, de salud, por **guardados+comentarios / 1k views**. Detalle en
  `playbook-seed.md`.
- **El feedback PROPONE, el humano APRUEBA.** Los cambios al playbook siempre pasan por el
  OK del dueño. Nunca se auto-aplican.
- **Método sí, IP no.** El playbook del miembro nace sin reglas propias ni datos ajenos.
- **Neutralización:** cero rastro del autor del paquete (nicho, @handle, paleta, rutas,
  reglas confirmadas). Compruébalo: `grep -ri` de esos términos = 0.
- **Nada de comunicación externa automática:** publicar reels o mensajes siempre con OK
  explícito del dueño (las skills preparan, el humano confirma).
- **Lenguaje claro:** el miembro puede no ser técnico. Ejemplos siempre.
