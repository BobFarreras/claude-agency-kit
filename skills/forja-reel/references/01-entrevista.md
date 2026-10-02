# FASE A — Entrevista (8 bloques)

Objetivo: sacar el **perfil de estilo** que define la skill de edición personal. Reglas:

- **Una decisión cada vez.** No sueltes las 30 preguntas de golpe. Avanza bloque a bloque.
- **Lenguaje claro**, ejemplos concretos, y **una recomendación** en cada punto (la persona puede no ser técnica).
- Si alguien no sabe qué contestar (típico en colores/tipografías), **ofrece elegir por él** con 2-3 propuestas.
- Acepta respuestas en lenguaje natural y tradúcelas al esquema.
- Al final: **resume el perfil en una tabla**, confirma, y guarda `perfil.json`.

Cada pregunta indica **→ campo** del `perfil.json`.

---

## Bloque 1 · Qué editas

1. **¿Qué tipo de vídeos vas a editar principalmente?** → `contenido.tipo`
   - Cara a cámara (hablas tú) · Screenshare/demo (enseñas pantalla) · Faceless (sin cara: voz + visuales) · Mixto
2. **¿Para qué son?** → `contenido.finalidad`
   - Contenido orgánico (educar / marca personal) · Publicidad (ads UGC para vender) · Ambos
   - *Si elige publicidad:* pregunta si quiere **endcard/CTA** fijo (oferta, web, "link en bio") → `contenido.cta`
3. **¿Dónde los publicas?** → `contenido.plataformas` (Reels / TikTok / Shorts / varias)
4. **¿Cómo son tus grabaciones de partida?** → `contenido.bruto`
   - Largas con varias tomas y errores (necesitas corte fuerte, como el autor) · Ya bastante limpias · Clips sueltos que hay que ensamblar
5. **Idioma del contenido** → `contenido.idioma` (afecta a la transcripción y subtítulos)

## Bloque 2 · Cómo sales en pantalla

6. **¿Apareces tú en cámara?** → `pantalla.aparece` (sí / no / a veces)
7. **Si apareces, ¿cómo?** → `pantalla.formato`
   - Pantalla completa (full-frame) · **PiP** (tu cámara flotando en una esquina sobre un fondo/visual) · **Pantalla partida** (split: tú a un lado, visual al otro) · Alternar según el momento
8. **Si haces screenshare:** ¿tu cara en PiP encima, o solo la pantalla? → `pantalla.screenshare`
9. **¿Posición preferida del PiP?** → `pantalla.pip_pos` (abajo-dcha por defecto / otra)

## Bloque 3 · Identidad visual (lo que sustituye al violeta del autor)

10. **Tus colores de marca.** Dame 2-4 (puedes pegar hex, o decir "no sé"). → `marca.colores` (`{base, fondo, acento, texto}`)
    - Si no sabe: propón 2-3 paletas (p. ej. "oscuro cálido + acento ámbar", "claro editorial + acento azul", "alto contraste B/N + acento neón") y deja que elija.
11. **Tipografías.** ¿Tienes una display + una de texto, o te las recomiendo? → `marca.fuentes` (`{display, texto}`)
    - Recomendación segura si no sabe: display con carácter (p. ej. una serif moderna o una grotesca bold) + texto neutra (Inter/Helvetica). Usa fuentes con licencia libre.
12. **¿Tienes logo o marca de agua?** ¿Dónde quieres que aparezca? → `marca.logo` (`{tiene, archivo, posicion}`)
13. **Estética general** → `marca.estetica` (sobria-editorial / enérgica-punchy / minimal / colorida-pop)
14. **¿Hay algún creador cuyo MONTAJE te gusta** y quieres usar de referencia? → `marca.referencia`
    - Si da una URL y existe la skill `/analiza-edicion`, ofréce extraer ese estilo con ella y usarlo como base (sin copiarlo idéntico). Si no, anota la descripción.

## Bloque 4 · Ritmo y energía

15. **Velocidad de edición** → `ritmo.velocidad` (ágil-rápido / media / con aire-pausado)
16. **¿Quieres cold open de impacto** (los primeros 1-3s enseñan el resultado/gancho antes de saludar)? → `ritmo.cold_open` (sí recomendado / no)
17. **Música** → `ritmo.musica` (con música / **solo SFX sutiles** [estilo del autor] / nada)
18. **SFX (efectos de sonido)** → `ritmo.sfx` (sutiles / marcados / ninguno)

## Bloque 5 · Cómo ilustras lo que dices (B-roll / conocimiento)

19. **¿Quieres B-roll real** (capturas de webs, logos de marcas, fotos de producto que se ven en pantalla)? → `broll.real` (sí → activa firecrawl / no)
20. **¿Quieres imágenes generadas por IA** (portadas, metáforas visuales)? → `broll.ia` (sí → activa fal, **de pago** / no)
21. **¿Vas a aportar tú tus propios assets** (imágenes, clips, capturas)? ¿Cómo los entregarás (carpeta, rutas)? → `broll.propios` (`{usa, carpeta}`)
22. **Rótulos / texto cinético** (frases que aparecen animadas) → `broll.rotulos` (mucho / lo justo / nada)
23. **¿Diagramas o data-viz** (gráficas, esquemas)? → `broll.dataviz` (sí / no)

## Bloque 6 · Texto en pantalla

24. **Subtítulos** → `texto.subtitulos` (siempre, con palabra-clave resaltada en tu acento / siempre normales / no)
    - *Regla fija del motor (no se pregunta, se aplica):* todo el texto va **a la altura del micrófono/pecho**, nunca pegado al borde inferior — la UI de Reels/TikTok tapa el tercio de abajo.
25. **Si subtítulos con resaltado:** ¿qué tipo de palabras resaltas? → `texto.keywords_tipo` (cifras / nombres de marca / conceptos potentes / todas)

## Bloque 7 · Entrega

26. **Resolución de salida** → `entrega.resolucion` (heredar la del bruto = recomendado / forzar 1080×1920)
27. **¿Dónde quieres los resultados?** → `entrega.carpeta` (ruta del proyecto donde guardar `edicion/` y `motion/`)
28. **¿Cómo quieres revisar el reel final?** → `entrega.revision` (verlo en local / recibir aviso / etc.)

## Bloque 8 · Control y automatización

29. **¿Activamos la compuerta dura + revisor independiente** (garantía de que no salen repeticiones ni look-IA)? → `control.revisor` (**sí, recomendado** / no)
30. **¿Cuánto quieres que te pregunte la skill** vs decidir sola? → `control.autonomia` (me consulta en cada fase / decide y me enseña el resultado)

---

## Esquema `perfil.json`

Guarda en la carpeta de trabajo. Ejemplo con valores:

```json
{
  "marca_slug": "lucia-ia",
  "marca_nombre": "Lucía IA",
  "contenido": {
    "tipo": "cara-a-camara",
    "finalidad": "organico",
    "cta": null,
    "plataformas": ["reels", "tiktok"],
    "bruto": "largas-con-tomas",
    "idioma": "es"
  },
  "pantalla": {
    "aparece": "si",
    "formato": "pip",
    "screenshare": "pip-encima",
    "pip_pos": "abajo-dcha"
  },
  "marca": {
    "colores": { "base": "#0E1116", "fondo": "#0E1116", "acento": "#F5A623", "texto": "#F7F7F2" },
    "fuentes": { "display": "Fraunces", "texto": "Inter" },
    "logo": { "tiene": true, "archivo": "assets/logo.png", "posicion": "arriba-dcha" },
    "estetica": "sobria-editorial",
    "referencia": null
  },
  "ritmo": { "velocidad": "agil", "cold_open": true, "musica": "solo-sfx", "sfx": "sutiles" },
  "broll": {
    "real": true, "ia": false,
    "propios": { "usa": true, "carpeta": "assets/mios" },
    "rotulos": "lo-justo", "dataviz": false
  },
  "texto": { "subtitulos": "resaltado", "keywords_tipo": ["cifras", "marcas"] },
  "entrega": { "resolucion": "heredar", "carpeta": "reels", "revision": "local" },
  "control": { "revisor": true, "autonomia": "consulta" },
  "_deps_necesarias": ["ffmpeg", "node", "hyperframes", "groq", "watch"]
}
```

`_deps_necesarias` lo rellenas TÚ derivándolo de las respuestas (ver `02-diagnostico-entorno.md`): firecrawl solo si `broll.real`, fal solo si `broll.ia`.
