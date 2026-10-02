# Fase 4 — SFX, QC y entrega

## SFX (sintéticos, sin descargar nada)

el creador quiere SFX sutiles, **sin música**. Se sintetizan con ffmpeg y se mezclan en POST (no dentro de Hyperframes — más simple y desacoplado).

Genera la paleta una vez por proyecto:
```bash
bash ~/.claude/skills/<SKILL>/scripts/make-sfx.sh motion/sfx
```
Crea: `whoosh` (transiciones), `pop` (chips), `type` (tecleo terminal), `buzz` (error), `boom` (impacto/reveal), `ding` (check / cifra clavada), `riser` (subida antes de un reveal).

Mezcla los SFX en el render con una lista de eventos `[ [sfx, tiempo], ... ]`:
```bash
python ~/.claude/skills/<SKILL>/scripts/mix-sfx.py \
  --base motion/renders/reel-full.mp4 \
  --sfx-dir motion/sfx \
  --out motion/renders/REEL-FINAL.mp4 \
  --events '[["boom",0.0],["riser",0.2],["whoosh",0.8],["pop",0.98],["whoosh",6.5],["ding",8.6], ...]'
```
Pon un evento donde haya una entrada/transición/impacto. Volúmenes ya vienen bajos (acentos bajo la voz) y la mezcla aplica un `alimiter` para no saturar. Si re-cortas o re-sincronizas, **re-temporiza también los eventos** (sus tiempos cambian con la duración).

**Impact-landing en cambios de sección (v9):** una transición se siente "producida" cuando el whoosh **aterriza** en un golpe corto justo en el corte. En los cambios de sección fuertes (y en el corte del cold open al cuerpo) encadena `riser`/`whoosh` que sube → `boom`/`ding` que cae EXACTO en el frame del cambio: `[["whoosh",t-0.4],["boom",t]]`. No en cada corte (cansa); solo en los beats que marcan sección. SFX siempre bajo la voz.

## QC con la skill `/watch` (obligatorio)

No te fíes de mirar 3 frames sueltos: extrae frames de TODO el render y míralos. `/watch` (en `~/.claude/skills/watch/`) hace justo eso.
```bash
python ~/.claude/skills/watch/scripts/watch.py motion/renders/reel-full.mp4 --no-whisper --max-frames 30 --out-dir motion/qc/watch
```
Luego `Read` los frames y revisa: **huecos vacíos** en el B-roll (rellénalos), **solapes** de texto, **sincronía** (cada chip/escena con lo que dice en ese momento), **legibilidad**, que la cara no quede tapada y que los títulos estén a la altura del micro. Esto reveló en su día que las escenas B-roll quedaban medio vacías.

**Chequeo de ritmo medible (v9):** cuenta los cambios visuales (corte, movimiento de cámara, aparición de chip, zoom, escena B-roll, reveal) por cada 10s. Diana: **5-7 cambios/10s** en los tramos ágiles. <4 = se lee lento (mete movimiento/B-roll); >8 = ruido (quita). **Excepción deliberada:** los tramos "denso → aire" (ver `04-recetas.md`) van por debajo a propósito — no los infles a fuerza de cortes.

**🔴 REGLA DURA DE RITMO (el creador, sí o sí, 2026-06-23): nunca más de 3-4 s sin que pase algo visual.** Cada ≤4 s tiene que entrar un beat: animación, B-roll, zoom/punch (`snap`), chip/rótulo cinético, sello, movimiento de cámara (PiP/full), reveal o un float continuo perceptible. **Los subtítulos NO cuentan** como beat — son base permanente del vídeo, están siempre, así que un tramo con solo talking-head + captions = tramo muerto aunque haya texto en pantalla. QC obligatorio: recorre la timeline listando los beats no-subtítulo y mide los huecos; cualquier hueco >4 s se rellena (un `snap` o un sello cinético sincronizado con una palabra-ancla basta). Caso real: el tramo 59-65 s del reel SpecKit (post-terminal, solo hablando) se rellenó con `snap` + sello "ABISMAL". Ver [[feedback_reel_beat_cada_4s]].

Si re-sincronizaste tras un re-corte, verifica con frames exactos los puntos que se desplazaron:
```bash
for t in 62 75 90 93.4; do ffmpeg -ss $t -i render.mp4 -frames:v 1 -y qc/chk_$t.jpg -loglevel error; done
```

## Render

```bash
npx hyperframes render --quality standard --output renders/reel-full.mp4   # para QC
npx hyperframes render --quality high     --output renders/reel-full-hi.mp4 # entrega final
```
`draft` para iterar rápido un trozo; `standard` para revisar; `high` para entregar. El render de ~100s tarda ~2 min. Verifica duración con `ffprobe`.

**Truco de eficiencia:** para validar un look nuevo, renderiza solo los primeros ~20s (baja `data-duration` temporalmente) como proof-of-concept antes de renderizar el minuto y medio entero.

## Orden final de la Fase 4

1. `make-sfx.sh` (una vez).
2. Render `standard` → `/watch` QC → arreglar → re-render hasta que esté pulido.
3. Render `high` final.
4. `mix-sfx.py` sobre el render high → `REEL-FINAL.mp4`.
5. Última pasada de `/watch` sobre el final.

## Entrega

Deja `REEL-<slug>-FINAL.mp4` (alta calidad, 1080×1920) en `motion/renders/`. Avisa a el creador con la ruta.

**🔴 Al APROBAR (el creador dice "esto ya está bien" / "me vale"): mover el BRUTO a editados.** Las carpetas de brutos son `Empresa/Videos/Sin Editar/` y `Empresa/Videos/Editados/`. En cuanto el creador da el OK final a un reel, mueve su vídeo bruto de `Sin Editar/` → `Editados/` (`mv`, no copia — es su forma de saber qué queda por editar). Solo al aprobar, no antes. Ver [[feedback_reel_bruto_a_editados]].

**WhatsApp (solo si el creador lo pide y confirma explícitamente — es comunicación externa):**

**Enviar como DOCUMENTO, no como vídeo.** Si se envía como vídeo (`mediatype:"video"`), WhatsApp lo recomprime y baja la resolución (un 2K cae a Full HD). Como documento (`mediatype:"document"`) el archivo llega intacto. el creador quiere máxima calidad.

Límite de documento en WhatsApp ≈ 100MB. Si el final pesa más, genera una versión documento de alta calidad (visualmente casi sin pérdida) por debajo del límite, manteniendo la resolución del bruto:
```bash
ffmpeg -y -i REEL-FINAL.mp4 -c:v libx264 -crf 19 -preset slow -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart REEL-DOC.mp4
# comprueba el tamaño; si >~95MB sube el crf (20-22). Mantiene la resolución original (no reescalar).
```
## Loop de retención (post-publicación, v9)

El reel no acaba al entregarlo: cierra el loop con los datos. Cuando el creador publique, recuérdale (o revisa si compartió captura de Insights) la **retención a 3s**:
- Caída en el **segundo 1** → el cold open visual/sonoro es débil (primer frame más fuerte, más contraste/impacto).
- Caída en el **segundo 3** → paró el scroll pero la **promesa es floja** (reescribir la frase-gancho del cold open).
- Caída a mitad → mete un cambio visual fuerte (B-roll, punch-in, rótulo grande) en el segundo donde cae.

Esto alimenta el cold open y el ritmo del SIGUIENTE reel. Es el mecanismo que sube el techo a medio plazo. Ver `08-cold-open.md`.

## Entrega por WhatsApp (detalle)

Envía con la skill `/whatsapp` vía Evolution API `sendMedia`, pero con `"mediatype":"document"`, `"mimetype":"video/mp4"` y `"fileName":"REEL-....mp4"`. El base64 del archivo es enorme: **escríbelo a un fichero temporal y construye el payload JSON en Python**; NO pases el base64 como argumento de shell (peta por longitud "argument list too long"). Patrón que funciona:
```bash
base64 -i REEL-DOC.mp4 | tr -d '\n' > /tmp/b64.txt
NUM="$EVOLUTION_MY_NUMBER" python -c "import json,os;b=open('/tmp/b64.txt').read().strip();json.dump({'number':os.environ['NUM'],'mediatype':'document','mimetype':'video/mp4','fileName':'REEL.mp4','caption':'...','media':b},open('/tmp/wa.json','w'))"
curl -s -X POST \"$EVOLUTION_API_URL/message/sendMedia/$EVOLUTION_INSTANCE\" -H \"apikey: $EVOLUTION_API_KEY\" -H 'Content-Type: application/json' -d @/tmp/wa.json
```
Credenciales en `Empresa/.env.local` (EVOLUTION_API_URL, EVOLUTION_API_KEY, EVOLUTION_INSTANCE, EVOLUTION_MY_NUMBER).
