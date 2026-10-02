# Fase A — La entrevista (8 bloques)

Un bloque cada vez, lenguaje claro, ejemplos de SU nicho. En cada decisión, 2-3 opciones
con recomendación. Si algo ya salió en la conversación, confírmalo en vez de repetirlo.

## Bloque 1 — Tu editor forjado (enlace con forja-reel)

Confirma lo que el diagnóstico ya detectó: ¿cuál es su skill de edición (`reel-edita-<x>`)?
El bucle se cableará a ESA. Si no la tiene, no sigas — mándale a `/forja-reel` primero.

## Bloque 2 — Quién eres como creador

- ¿De qué va tu cuenta? Nicho y ángulo (ej. "IA para pymes", "recetas rápidas", "finanzas
  personales"). Una frase.
- ¿Tu @handle y plataformas? (Instagram / TikTok / YouTube Shorts — ¿una o varias?)
- ¿Tu voz? (cercana, técnica, gamberra, inspiracional…) Una frase que suene a ti.

## Bloque 3 — De dónde salen tus ideas

El bucle empieza por una idea. ¿Cómo llegan las tuyas?
- Noticias/novedades de tu sector (¿qué fuentes sigues?)
- Dudas recurrentes de tu audiencia
- Tu propia experiencia / casos
- Tendencias que ves en otros creadores

Esto define la skill de guiones: si trabajas con noticias, verificará fuentes; si con
dudas, partirá de preguntas reales.

## Bloque 4 — Cómo publicas

- ¿Cadencia realista? (2/semana, diario, cuando puedas…) Sé honesto: el bucle necesita
  constancia, no volumen heroico.
- ¿Publicas tú a mano o programas? ¿Con qué? (importante: las skills PREPARAN, nunca
  publican solas sin tu OK.)
- ¿Sueles crosspostear a Facebook u otras? (afecta a cómo se leen las métricas.)

## Bloque 5 — Intención de tus reels

Cada reel tiene un trabajo. ¿Cuáles haces?
- **Alcance / autoridad**: que te conozca gente nueva (reels de novedades, opinión).
- **Conversión**: meter gente en tu lista/comunidad (CTA "comenta X" → DM automation).

La mayoría hace una mezcla. Esto define cómo se mide cada reel (no todos por el mismo
número — ver el KPI por intención del playbook).

## Bloque 6 — Métricas: cómo las vas a mirar

- ¿Tienes un Claude con navegador y tu Instagram logueado? → radar automático (lee los
  Insights por el navegador; NO usa la API de Meta).
- ¿No? → **modo manual**: el radar te preguntará las cifras clave (views, alcance, %
  no seguidores, guardados, compartidos, comentarios) y las registrará igual.
- ¿Miras a competidores? (opcional) Si quieres, el análisis semanal puede aprender de
  reels de otros que tú le pegues.

## Bloque 7 — El ritual semanal

- ¿Qué día haces balance? (recomendado: lunes por la mañana.) El análisis semanal se
  apoya en ese momento.
- ¿Quieres informe visual (HTML) del análisis, o te basta un resumen en el chat?

## Bloque 8 — Marca y nombres

- ¿Prefijo de tus skills? Por defecto tu marca (ej. `/reel-acme`, `/reel-publica-acme`…).
- Estética de tus informes (colores/tono) — si tienes una identidad, dila; si no, una
  limpia y neutra.

## Cierre — perfil.json

Resume en tabla, confirma, y guarda `perfil.json`:

```json
{
  "editorSkill": "reel-edita-<slug>",
  "creador": { "nicho": "", "handle": "", "plataformas": [], "voz": "" },
  "ideas": { "fuente": "noticias | dudas | experiencia | tendencias", "detalle": "" },
  "publicacion": { "cadencia": "", "modo": "manual | programado", "crosspost": [] },
  "intencion": ["alcance", "autoridad", "conversion"],
  "metricas": { "modo": "navegador | manual", "competidores": false },
  "ritual": { "dia": "lunes", "informe": "html | chat" },
  "marca": { "prefijo": "", "estetica": "" },
  "pendientes": []
}
```
