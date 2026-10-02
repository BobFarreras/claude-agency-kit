# Fase B — Diagnóstico de entorno

Con el `perfil.json` confirmado, comprueba lo que el sistema necesita. Opt-in para todo;
nada se instala ni configura sin un "sí".

## 1. Requisito duro — el editor forjado

Ya comprobado en Fase 0, reconfírmalo aquí: existe `~/.claude/skills/reel-edita-<slug>/`
con su motor (scripts de corte/revisor). Si no → PARA y manda a `/forja-reel`. El bucle no
tiene sentido sin el editor.

## 2. Acceso a métricas (define el modo del radar)

| Situación | Modo del radar | Nota |
|---|---|---|
| Claude con navegador + IG logueado | **automático** | Lee los Insights de IG en el navegador. NO se usa la API de Meta (decisión de diseño: más simple y sin permisos). Solo lectura. |
| No tiene navegador/login | **manual** | El radar pregunta las cifras y las registra igual. El bucle funciona idéntico, solo cambia cómo entran los números. |

Explícale que las plataformas cambian sus paneles: el radar debe ser tolerante (si no
encuentra un dato, lo deja como `null`, nunca lo inventa).

## 3. Skills auxiliares (según el perfil)

- **Competidores** (si lo activó): necesita una forma de transcribir/analizar reels de
  otros. Si el miembro tiene skills para eso, se cablean; si no, el análisis semanal
  funciona igual solo con sus propios datos.
- **Publicación**: si programa con alguna herramienta, anótalo — la skill de publicar
  PREPARA el post (caption+hashtags+hora) y deja el envío al humano.

## 4. Nada de claves ajenas ni comunicación automática

- Ninguna clave secreta se teclea por el miembro (si algo la pide, se guía a que la ponga
  él). 
- Publicar reels o mensajes = SIEMPRE con OK explícito del dueño. Las skills preparan.

## Salida de la fase

Tabla ✅ listo / 🔧 configurado ahora / ⏳ pendiente / ⛔ bloqueante. Añade el `modo` de
métricas y cualquier pendiente al `perfil.json` para que las skills hijas lo recuerden.
