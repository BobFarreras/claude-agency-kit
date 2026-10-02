# El bucle y su arquitectura (método — copiar tal cual)

## La decisión de arquitectura que hace que esto funcione

**Las skills son el motor (estables); el conocimiento vive en un playbook que evoluciona.**
Las skills NO se editan a sí mismas — eso corrompe el sistema con el tiempo. Lo único que
cambia semana a semana es el `playbook.md`, y solo con evidencia y con OK del dueño. Así
el sistema mejora sin volverse frágil.

## El bucle cerrado (los 6 pasos)

```
   IDEA
    │  (fuente del perfil: noticias / dudas / experiencia)
    ▼
1) GUION        reel-<slug>          → lee playbook, escribe guion + intención + hook
    ▼
2) EDICIÓN      reel-edita-<slug>    → lee playbook; al aprobar, escribe ficha en ledger
    ▼
3) PUBLICAR     reel-publica-<slug>  → caption/hora/UTM; completa ficha; humano sube
    ▼
4) MEDIR        reel-radar-<slug>    → snapshots de métricas al ledger (navegador o manual)
    ▼
5) ANALIZAR     reel-feedback-<slug> → KPI vs mediana, cruza ficha×datos, informe
    ▼
6) MEJORAR      → propone diffs al PLAYBOOK (≥3 reels, con OK) ──┐
    └───────────────────────────────────────────────────────────┘
        el playbook mejorado alimenta el próximo paso 1 y 2
```

El valor no está en ninguna skill suelta: está en que **el conocimiento de lo que funciona
vuelve al principio**. Un creador sin este bucle repite errores; con él, cada reel es un
experimento que deja aprendizaje.

## Los dos ganchos del editor (cablear en la skill de edición ya forjada)

1. **Antes de editar:** leer `_engine/playbook.md` (recetas de edición, densidad, cold
   open que rinden en esta cuenta).
2. **Al aprobar el corte final:** escribir/actualizar la ficha en
   `_engine/ledger/<slug>.json` — al menos `edicion.receta` y `cold_open`. Sin esto, el
   análisis semanal no puede aprender de la edición.

Si modificar el editor es delicado, basta con dejar estos dos pasos anotados al final de
su SKILL.md para que la skill los siga.

## Una sola fuente de verdad

Las 5 skills comparten el MISMO `_engine/`. El playbook es el cerebro; el ledger es la
memoria (una ficha por reel con su historia de métricas). Nada de conocimiento disperso en
cada skill.
