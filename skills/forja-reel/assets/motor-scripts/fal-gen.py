#!/usr/bin/env python
"""Genera assets de COLD OPEN con fal.ai (imagen y/o image-to-video) para el hook del reel.

Solo plomeria de la cola de fal (submit -> poll -> descargar), identica para todos los
modelos. Los parametros propios de cada modelo van en --extra-json; asi el script no se
pudre cuando fal cambie defaults. VERIFICA endpoints/params en fal.ai/models.

Requiere FAL_KEY en el entorno o en un .env.local del proyecto (se busca hacia arriba
desde el directorio actual). fal.ai es de PAGO: solo se usa si elegiste imagenes IA en la
entrevista.

Modos:
  image    Genera una imagen. Imprime su URL (hosted en fal) y la descarga a --out.
  animate  Anima una imagen ya hosteada (--image-url) a video (image-to-video).
  both     image -> coge la URL devuelta -> animate, en una pasada.

Ejemplos:
  fal-gen.py image \
    --prompt "editorial magazine cover, vertical, huge bold headline 'TU TITULAR', clean layout, negative space" \
    --extra-json '{"aspect_ratio":"9:16","resolution":"2K","output_format":"jpeg"}' \
    --out motion/assets/coldopen.jpg

  fal-gen.py both --prompt "..." \
    --extra-json '{"aspect_ratio":"9:16","resolution":"2K"}' --out motion/assets/coldopen.mp4
"""
import os, sys, json, time, argparse, urllib.request, urllib.error

QUEUE = "https://queue.fal.run"


def _find_env_key(name):
    """Busca NAME= en .env.local subiendo desde el cwd hasta la raiz."""
    d = os.getcwd()
    while True:
        p = os.path.join(d, ".env.local")
        if os.path.isfile(p):
            try:
                for line in open(p, encoding="utf-8"):
                    if line.strip().startswith(f"{name}="):
                        return line.split("=", 1)[1].strip().strip('"').strip("'")
            except OSError:
                pass
        parent = os.path.dirname(d)
        if parent == d:
            return None
        d = parent


def _key():
    k = os.environ.get("FAL_KEY") or _find_env_key("FAL_KEY")
    if not k:
        sys.exit("ERROR: falta FAL_KEY (exporta la var o ponla en el .env.local de tu proyecto)")
    return k


def _req(url, key, method="GET", body=None):
    data = json.dumps(body).encode() if body is not None else None
    r = urllib.request.Request(url, data=data, method=method)
    r.add_header("Authorization", f"Key {key}")
    r.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(r, timeout=120) as resp:
            return json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        sys.exit(f"ERROR fal {e.code}: {e.read().decode()[:500]}")


def run(model, args, key, timeout=600):
    sub = _req(f"{QUEUE}/{model}", key, "POST", args)
    rid = sub.get("request_id")
    if not rid:
        sys.exit(f"ERROR: sin request_id en la respuesta: {sub}")
    base = f"{QUEUE}/{model}/requests/{rid}"
    print(f"  request_id={rid}  (poll...)", flush=True)
    t0 = time.time()
    while True:
        st = _req(f"{base}/status", key)
        status = st.get("status")
        if status == "COMPLETED":
            return _req(base, key)
        if status in ("FAILED", "ERROR"):
            sys.exit(f"ERROR: el job termino en {status}: {st}")
        if time.time() - t0 > timeout:
            sys.exit(f"ERROR: timeout ({timeout}s) esperando a fal")
        time.sleep(3)


def first_url(result):
    def walk(o):
        if isinstance(o, dict):
            if "url" in o and isinstance(o["url"], str):
                yield o["url"]
            for v in o.values():
                yield from walk(v)
        elif isinstance(o, list):
            for v in o:
                yield from walk(v)
    for u in walk(result):
        return u
    sys.exit(f"ERROR: no encuentro URL de media en el resultado: {json.dumps(result)[:500]}")


def download(url, out):
    os.makedirs(os.path.dirname(out) or ".", exist_ok=True)
    urllib.request.urlretrieve(url, out)
    print(f"  descargado -> {out}")


def build_args(prompt, extra, image_url=None):
    args = {}
    if prompt:
        args["prompt"] = prompt
    if image_url:
        args["image_url"] = image_url
    if extra:
        args.update(json.loads(extra))
    return args


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("mode", choices=["image", "animate", "both"])
    ap.add_argument("--model", default="fal-ai/nano-banana-2",
                    help="endpoint fal de imagen (default Nano Banana 2). Para animate, el i2v.")
    ap.add_argument("--anim-model", default="fal-ai/kling-video/v2.5-turbo/pro/image-to-video",
                    help="modelo i2v para mode=both")
    ap.add_argument("--prompt", default="")
    ap.add_argument("--anim-prompt", default="slow cinematic push-in, subtle parallax",
                    help="prompt de movimiento para mode=both")
    ap.add_argument("--image-url", default="", help="URL de la imagen a animar (mode=animate)")
    ap.add_argument("--extra-json", default="", help="params propios del modelo (JSON)")
    ap.add_argument("--anim-extra-json", default='{"duration":"5","aspect_ratio":"9:16"}',
                    help="params del modelo i2v en mode=both")
    ap.add_argument("--out", required=True)
    a = ap.parse_args()
    key = _key()

    if a.mode == "image":
        print(f"[fal] imagen con {a.model}")
        res = run(a.model, build_args(a.prompt, a.extra_json), key)
        url = first_url(res); print(f"  URL: {url}"); download(url, a.out)
    elif a.mode == "animate":
        if not a.image_url:
            sys.exit("ERROR: animate necesita --image-url")
        print(f"[fal] i2v con {a.model}")
        res = run(a.model, build_args(a.prompt, a.extra_json, a.image_url), key)
        url = first_url(res); print(f"  URL: {url}"); download(url, a.out)
    else:  # both
        print(f"[fal] imagen con {a.model}")
        res = run(a.model, build_args(a.prompt, a.extra_json), key)
        img_url = first_url(res); print(f"  imagen URL: {img_url}")
        print(f"[fal] i2v con {a.anim_model}")
        res2 = run(a.anim_model, build_args(a.anim_prompt, a.anim_extra_json, img_url), key)
        vid_url = first_url(res2); print(f"  video URL: {vid_url}"); download(vid_url, a.out)


if __name__ == "__main__":
    main()
