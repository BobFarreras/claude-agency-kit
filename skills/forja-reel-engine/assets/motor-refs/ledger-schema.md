# ledger/_schema.md — la ficha de cada reel (método)

Copia esto como `_engine/ledger/_schema.md`. Cada reel tiene UN archivo
`_engine/ledger/<slug>.json`: su ficha creativa (qué se decidió y por qué) + el historial
de snapshots de métricas. Es la memoria del sistema — lo que permite al análisis semanal
cruzar "qué hicimos" con "qué resultó".

```json
{
  "slug": "nombre-corto-del-reel",
  "fecha_publicacion": "AAAA-MM-DD | null",
  "url": "https://... | null",
  "guion": {
    "tema": "",
    "intencion": "alcance | autoridad | conversion",
    "hook_familia": "ej. cifra-bombazo, pregunta-dolor, para-si-usas",
    "hook_texto": "",
    "angulo": "ej. utilidad-accionable, actualidad, contradiccion",
    "duracion_s": null
  },
  "edicion": {
    "receta": "descripción corta del tratamiento (densidad, PiP/split, ritmo)",
    "cold_open": "qué se ve/dice en los primeros segundos"
  },
  "publicacion": {
    "caption": "",
    "hora": "",
    "cta": "ninguno | comenta-X",
    "utm": "si aplica"
  },
  "snapshots": [
    {
      "fecha": "AAAA-MM-DD",
      "views": null,
      "alcance_no_seguidores_pct": null,
      "guardados": null,
      "compartidos": null,
      "comentarios": null,
      "seguidores_ganados": null,
      "comentarios_trigger": null,
      "leads_dm": null
    }
  ]
}
```

Reglas:
- **Dato que no se conoce = `null`. Nunca se inventa.** (Muchas plataformas no exponen
  retención en el panel web → suele quedar `null`; es correcto.)
- Los snapshots son un **historial**: se añade uno nuevo cada vez que corre el radar, no se
  sobrescribe. Un reel se "asienta" con los días — verlo evolucionar es parte del análisis.
- El KPI de salud **`g+c/1k` = (guardados + comentarios) / views × 1000**. Se calcula, no
  se guarda a mano.
