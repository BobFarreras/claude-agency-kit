# Prova abans de prometre res: veu, foto i avatar

> Mitja hora de feina per saber si els modes B i C de `MODES-PRODUCCIO.md` són reals **amb les
> vostres cares i la vostra veu**, o si el sistema es queda en el mode A. Es fa **una vegada**,
> i el resultat entra al playbook com a fet verificat.
>
> Estat: **pendent** de fer. Res del mode B o C es dissenya abans.

## Per què es fa abans i no després

Les eines de vídeo per IA canvien cada mes i totes ensenyen els seus millors exemples: cares
angleses, primers plans de mig cos, frases en anglès. El que decideix si us serveixen és el que
no ensenyen: **una cara concreta, en català, en un pla sencer**. Val més mitja hora de prova que
dissenyar quatre skills sobre una capacitat que després canta.

## Prova 1 — la veu (gratuïta, i la més important)

És la que resol el problema de debò: que a ningú us agrada gravar-vos.

1. Escriu **tres frases** del to de Nertel (una de problema, una de producte, una de crida).
2. Genera-les **amb la veu dels vostres propis agents**, en català. És el camí preferent: no és
   un truc de màrqueting, és el producte funcionant.
3. Alternativa de contrast: `media-use resolve --type voice` per la via gratuïta de HeyGen.
4. Escolta-les al mòbil, amb l'altaveu del telèfon, que és on es mirarà.

**Què mires:** si la prosòdia del català aguanta tres frases seguides, si les xifres i els
noms propis es diuen bé, i si la respiració entre frases sona humana o metrònom.

**Si passa:** el mode A queda tancat i ja no cal gravar mai més. És el resultat que més valor
té de tota la prova.

## Prova 2 — una foto vostra animada (de pagament, poc)

1. Tria **una foto bona**: cos sencer o mig cos, llum neutra, fons net, mirant a càmera.
2. Un clip de 5-6 s, vertical, sense parla:
   ```bash
   PYTHONIOENCODING=utf-8 python ~/.claude/skills/forja-reel/assets/motor-scripts/fal-gen.py animate \
     --image-url "<URL de la foto>" \
     --anim-prompt "slow cinematic push-in, subtle head turn, natural light" \
     --anim-extra-json '{"duration":"5","aspect_ratio":"9:16"}' \
     --out proves/clip-foto.mp4
   ```
3. Mira'l **fotograma a fotograma** als extrems, no només un del mig.

**Què mires:** si la cara segueix sent la mateixa persona al segon 5, les mans, les orelles i
les ulleres, i si el fons es deforma. Repeteix amb una segona foto i compara: **si les dues
versions de la mateixa persona no s'assemblen entre elles, el mode C no serveix per a vosaltres**
(serviria només per a escenes sense cara reconeixible).

## Prova 3 — l'avatar parlant (de pagament, i cal gravar una vegada)

Només si la prova 1 i la 2 van bé i encara voleu que hi hagi algú parlant.

1. **Una gravació de consentiment** d'uns dos minuts: de front, llum frontal, fons net, parlant
   amb normalitat. Es fa un sol dia i no es torna a fer.
2. Construir l'avatar amb HeyGen i generar **la mateixa frase en català** que la prova 1.
3. Comparar-la amb l'original.

**Què mires, i és el punt que ho decideix tot:** el **sincronisme de llavis en català**. Les
oclusives i la ela geminada són on es trenca. Mira-ho en un primer pla i en un pla mig: si només
aguanta el pla mig, l'avatar entra al sistema **només per a plans mitjans**, i això s'escriu.

## Abans de gastar un cèntim

Les proves 2 i 3 són de pagament. **Cap es llança sense un sí explícit de l'Adrià**, amb el cost
estimat davant. `FAL_KEY` i les claus de HeyGen van per variable d'entorn: mai en un repo, mai
impreses al terminal, mai enganxades al xat.

I una cosa que no és tècnica: **les fotos i la gravació són de persones reals.** Si surt l'Enric,
l'Enric ho ha de dir sí explícitament, i ha de saber que la seva cara quedarà reutilitzable.

## Com s'anota el resultat

Al playbook `playbook-social-strategist.md`, com a **fet verificat**, amb data i amb el fitxer de
prova a mà:

- Mode A → disponible / no disponible, i amb quina veu.
- Mode C → per a quins plans serveix i per a quins no.
- Mode B → sí o no, i si és només per a plans mitjans.

A partir d'aquí les skills ja poden prometre el que prometen.
