# Playbook — social-strategist

> El subagent `social-strategist` llegeix aquest fitxer abans de cada peça.
> Neix gairebé buit — s'omple amb feina real publicada. Cap regla sense evidència.

## Regles confirmades

> Dos tipus d'evidència poden confirmar una regla sense esperar tres casos:
> **(decisió)** — l'Adrià ho ha demanat explícitament.
> **(fet verificat)** — comportament d'una eina reproduït i comprovat en execució.
>
> La inferència a partir de resultats ("aquest angle funciona") necessita **≥3 casos** i comença
> sempre com a hipòtesi.

### Abast i marca

1. **Avui hi ha una sola marca: Nertel AI.** L'estructura està parametritzada per marca
   (`MARCA-<marca>.md`) perquè demà hi càpiga un client, però no s'inventa un segon client ni es
   generalitza abans d'hora.
   · *decisió, 2026-10-02*

2. **Prioritat de plataformes: Instagram, TikTok, YouTube, LinkedIn, stories.**
   · *decisió, 2026-10-02*

3. **El to de Nertel és el del seu web: sobri i anti-fum.** El web diu literalment que el que
   ensenya no són casos d'èxit ni estimacions, i el contingut social ha de sonar igual.
   · *fet verificat — tokens i text de nertel.ai llegits el 2026-10-02*

4. **La IA diu que és IA.** Si la veu, la cara o una imatge són sintètiques, la peça ho diu i
   s'etiqueta a la plataforma. És coherent amb el producte, que ja es presenta com a IA en cada
   trucada.
   · *decisió, 2026-10-02 — reforçat per la regla de producte que el web exhibeix*

5. **Cap persona generada pot fer de client ni donar un testimoni.** Cap xifra en pantalla que no
   consti. Cap dada de tercers en una captura.
   · *decisió, 2026-10-02*

### Producció

6. **Mode A (sense cara) és el per defecte.** Veu + captures + motion graphics. Els modes B
   (avatar) i C (escenes generades) no es prometen fins que passin `PROVA-AVATAR.md`.
   · *decisió, 2026-10-02 — l'Adrià ha dit que no us agrada gravar-vos*

7. **La veu dels agents de Nertel és el primer camí per a la narració.** No és un truc de
   màrqueting: és el producte funcionant, i resol el problema de la gravació.
   · *decisió, 2026-10-02*

8. **Un avatar parlant no surt d'una bateria de fotos.** Les fotos donen clips curts sense parla;
   un presentador necessita una gravació de consentiment d'uns dos minuts, una sola vegada.
   · *estat de les eines el 2026-10-02 — a confirmar amb la prova*

9. **Les 20 regles del `playbook-reels-producer.md` valen senceres** per a qualsevol peça de
   vídeo, amb càmera o sense: comportes, rètols contra el transcript, `hyperframes check`,
   limitador després de mesclar, 48 kHz, revisor independent.
   · *fet verificat — primer reel real, 2026-07-30*

10. **Publicar exigeix un sí explícit per peça.** L'agent no publica mai pel seu compte;
    l'automatització recurrent la munta `n8n-architect`.
    · *decisió — s'hereta de la regla de l'empresa*

11. **Nertel ven cinc productes i tots cinc tenen pàgina**: agents de veu, agents de
    WhatsApp, chatbots, automatitzacions i programari a mida. A més hi ha 5 pàgines de solució,
    12 sectors i **9 casos d'èxit publicats i anonimitzats**. Tota peça aterra a una pàgina
    concreta — producte, sector o cas — mai a la portada.
    · *fet verificat — nertel.ai navegat el 2026-10-02*

12. **Un cas ja publicat al web és material lliure.** Ja està aprovat i ja va anònim per
    sector, així que una peça que l'expliqui no necessita cap permís nou — i no hi afegeix cap
    detall que permeti identificar l'empresa.
    · *decisió — 2026-10-02*

13. **Abans de dir què hi ha o no hi ha en un web, es navega el web.** Menú i peu inclosos. Una
    portada llegida en text pla s'ha deixat l'aparador sencer, i un pla construït sobre això
    arriba a conclusions al revés de la realitat.
    · *fet verificat a la pell — va passar el 2026-10-02 amb nertel.ai*

14. **Tres pilars, i el pla del mes ha de tenir-ne dels tres**: benefici d'un servei ·
    divulgació d'IA i tecnologia · feina feta. El de divulgació és l'únic que no depèn de
    permisos ni de material de ningú, i per això és el que sosté el calendari quan la resta
    s'encalla.
    · *decisió — 2026-10-02*

15. **Cap captura d'un projecte de client amb dades a dins**: ni correus, ni telèfons, ni noms,
    ni el panell d'n8n amb execucions reals. Es munta una pantalla de demostració.
    · *decisió — surt de la regla de l'empresa sobre dades de tercers*

## Hipòtesis en prova

- **Sense una cara que ompli el quadre, un tram sense moviment és mort de seguida**, així que la
  regla dels 4 s és més exigent al mode A que en un talking-head. · *n=0*
- **Els angles de sector concret ("una immobiliària") funcionen millor que els genèrics
  ("qualsevol empresa").** · *n=0 — criteri de partida*
- **Les dotze veus en dotze idiomes són una peça que es queda i es comparteix.** · *n=0*
- **Una captura del producte funcionant ven més que qualsevol imatge generada.** · *n=0 — criteri
  de partida, i a més és gratuïta*
- **El sincronisme de llavis en català és el punt feble de l'avatar** i potser només aguanta
  plans mitjans. · *n=0 — ho decideix `PROVA-AVATAR.md`*
- **Retenció als 3 s i desades manen sobre els "m'agrada".** · *n=0*

## Pendent de decidir

- **YouTube: curt o llarg?** El llarg és el pipeline més car i no s'ha fet mai. Mentre no es
  decideixi, `/youtube` ho pregunta cada vegada.
- **Política de subtítols** (heretada del playbook de reels): fidelitat literal o correcció
  silenciosa dels castellanismes.

## Changelog

- **2026-10-02** · fitxer creat amb l'agent `social-strategist` i les skills `/pla-social`,
  `/video-ia`, `/youtube` i `/radar-social`. Cinc regles per decisió, una per fet verificat (el
  to i la paleta, llegits del web) i sis hipòtesis. **Res d'això s'ha provat encara amb una peça
  real**: el primer `/video-ia` ha de confirmar o tombar les hipòtesis de producció, i
  `PROVA-AVATAR.md` decideix si els modes B i C existeixen.

- **2026-10-02** (segon apunt, després del primer `/pla-social`) · `MARCA-NERTEL.md` reescrit:
  estava escrit com si l'empresa fos només el producte d'agents de veu, i Nertel ven cinc
  serveis. Dues coses que el pla d'octubre ha fet sortir i que no es resolen amb contingut: el
  **web no té aparador** per a tres dels cinc serveis, i la **publicació no està resolta**
  (els comptes són de Nertel i en aquesta màquina no hi ha sessió). El pla queda **a mig fer a
  posta**, amb el banc d'angles esperant que l'Adrià en triï 6-8.

- **2026-10-02** (tercer apunt, correcció) · L'Adrià va avisar que no m'havia mirat bé el web, i
  tenia raó. Havia llegit nertel.ai amb una eina que n'extreu el `<main>` de la portada, i el
  menú —cinc productes, cinc solucions, dotze sectors, nou casos, veus, integracions,
  seguretat, novetats— no hi sortia. D'aquí les regles 11 i 13, i el pla d'octubre reescrit: el
  problema no és que falti aparador, és que **hi ha nou casos publicats que ningú ha vist**.
  Vuit de les onze peces del banc no depenen de ningú.
