# Plantillas de las 4 skills hijas

Rellena `{{...}}` desde el `perfil.json`. Todas viven en `~/.claude/skills/` y apuntan al
MISMO `_engine/` del miembro. Mantén cada SKILL.md corto; el detalle del método está en
los motor-refs copiados al `_engine/` (o referéncialos).

Patrón común a las 4: **(1)** leer `_engine/playbook.md` antes de trabajar; **(2)** leer/
escribir la ficha en `_engine/ledger/<slug>.json`; **(3)** nunca publicar ni enviar nada
sin OK del dueño.

---

## 1. `reel-{{prefijo}}` — guiones

```markdown
---
name: reel-{{prefijo}}
description: >
  Escribe guiones de reels para {{handle}} ({{nicho}}) a partir de {{fuenteIdeas}}.
  Lee el playbook del Reel Engine antes de escribir (hooks y ángulos que funcionan en
  ESTA cuenta) y devuelve guion + plan visual, etiquetado por intención y familia de hook.
  Úsala para "guion para reel", "{{disparadoresNicho}}", "hazme un reel de esto".
---
# reel-{{prefijo}} — guiones para {{handle}}
1. Lee `_engine/playbook.md`: KPI por intención, reglas confirmadas, hooks del leaderboard, pecados a evitar.
2. Parte de la fuente de ideas: {{si noticias}} verifica con ≥2 fuentes (anti-humo) {{si dudas}} arranca de la pregunta real de la audiencia.
3. Devuelve: hook (2-3 variantes), guion 60-120s en la voz {{voz}}, plan visual, y CTA según intención.
4. Etiqueta el guion con `intencion` ({{intencion}}) y `hook_familia`. Eso viaja al ledger.
```

## 2. `reel-publica-{{prefijo}}` — publicar + ledger

```markdown
---
name: reel-publica-{{prefijo}}
description: >
  Prepara la publicación de un reel ya editado de {{handle}} y registra su ficha en el
  Reel Engine: caption + hashtags + hora en la voz de la marca, intención, UTM si es
  conversión. NO publica sola: deja el post listo para que {{nombre}} lo suba/programe.
  Úsala para "caption para el reel", "prepara la publicación", "ya subí el reel" (+URL).
---
# reel-publica-{{prefijo}}
1. Lee el playbook (qué caption/hora rinde por intención).
2. Genera caption + hashtags + hora sugerida. Si `intencion=conversion`: CTA "comenta {{palabra}}" + UTM.
3. Completa la ficha en `_engine/ledger/<slug>.json` (guion, edición, publicación).
4. Modo vincular: cuando {{nombre}} pega la URL del post publicado, la ata al slug del ledger.
5. Publicar/programar de verdad = solo con OK explícito.
```

## 3. `reel-radar-{{prefijo}}` — métricas

```markdown
---
name: reel-radar-{{prefijo}}
description: >
  Recoge las métricas de los reels publicados de {{handle}} y las guarda como snapshots
  en el ledger del Reel Engine. Solo lectura. Úsala para "métricas de mis reels", "cómo
  van", "actualiza las cifras", o como primer paso del análisis semanal.
---
# reel-radar-{{prefijo}} — modo {{metricas.modo}}
- **navegador:** abre los Insights de IG (sesión logueada), lee views, alcance, % no
  seguidores, guardados, compartidos, comentarios. Dato que no encuentre = `null`.
- **manual:** pregunta esas cifras una a una y las registra.
Guarda un snapshot con fecha en `_engine/ledger/<slug>.json`. Nunca inventa un número.
```

## 4. `reel-feedback-{{prefijo}}` — análisis semanal (cierra el bucle)

```markdown
---
name: reel-feedback-{{prefijo}}
description: >
  Análisis semanal que CIERRA el bucle del Reel Engine de {{handle}}: actualiza métricas
  (vía radar), calcula el KPI por intención vs la mediana, cruza ficha × resultados,
  {{si competidores}} aprende de reels de otros que le pegues, genera informe y propone
  cambios al playbook — que {{nombre}} aprueba. Úsala los {{dia}}, o "análisis de reels",
  "qué está funcionando", "revisa mi contenido".
---
# reel-feedback-{{prefijo}} — ritual de los {{dia}}
Sigue `_engine/feedback-semanal.md`. Resumen:
1. Corre el radar (métricas frescas).
2. KPI por intención (g+c/1k de salud, NUNCA views a secas) vs mediana móvil 30d.
3. Cruza con las fichas del ledger (ángulo, hook, edición).
4. (opcional) competidores que pegue el dueño.
5. Informe ({{ritual.informe}}).
6. Propón diffs al playbook con la regla ≥3 reels. **Compuerta dura: el dueño aprueba
   cada cambio.** Registra el cambio en el changelog del playbook.
```
