# Playbook — n8n-architect

> El subagent `n8n-architect` llegeix aquest fitxer abans de dissenyar o depurar un
> workflow. Neix buit de regles confirmades.

## Regles confirmades (evidència real ≥3 casos, o codi font verificat)

### GitHub — quina API fer servir per pujar fitxers

- **La Contents API (`PUT /repos/{o}/{r}/contents/{path}`) fa UN COMMIT PER FITXER.**
  Mai la facis servir per pujar més d'un grapat de fitxers. Amb N fitxers tens N commits
  encadenats: cada un mou la branca i deixa obsolet el `sha` que havies llegit per als
  següents. Símptoma: `409` amb `"<path> does not match <sha>"` o
  `"is at <sha> but expected <sha>"` (aquests dos últims són caps de branca, no fitxers).
- **Per a més d'un fitxer, Git Data API i un sol commit atòmic:**
  1. `GET /repos/{o}/{r}` → `default_branch`
  2. `GET /repos/{o}/{r}/commits/{branca}` → `.sha` (commit base) i `.commit.tree.sha`
  3. `POST /git/trees` amb `base_tree` i les entrades `{path, mode:'100644', type:'blob', content}`
     — el `content` va **inline en text pla**, no cal crear blobs ni base64
  4. `POST /git/commits` amb `{message, tree, parents:[commitBase]}`
  5. `PATCH /git/refs/heads/{branca}` amb `{sha, force:false}`
  Quatre crides, un commit, **cap `sha` per fitxer**. `force:false` fa que si algú ha
  mogut la branca, falli net en comptes de perdre feina.
- Llegeix i escriu **sempre a la mateixa branca explícita**. No confiïs en `HEAD` implícit.

### El batching d'n8n és PARAL·LEL

- Al node HTTP Request, `options.batching.batch.batchSize` és el nombre de peticions que
  es llancen **alhora**, no una cua. Per a qualsevol API on l'ordre importa o on cada
  crida modifica l'estat compartit (commits a una branca, contadors, locks), **`batchSize`
  ha de ser 1**. Amb 5 i amb 3 es van produir conflictes de concurrència reproduïbles.

### Una `operation` invàlida no dona error

- Verificat al codi font de `Github.node.js` (n8n 2.19.5): el dispatch només llança
  `NodeOperationError` quan el **resource** és desconegut. Si el resource és vàlid però
  l'**operation** no existeix, no hi ha cap `else`: `requestMethod` es queda a `'GET'`,
  `endpoint` es queda buit, i el node executa `githubApiRequest('GET','',{},{})` →
  `GET https://api.github.com`, que retorna 200. **El node no fa res, no falla, i el
  workflow es marca en èxit.**
- Corol·lari: **mai validis un workflow per "0 errors"**. Valida per l'efecte esperat
  (hi ha commit nou? hi ha fila nova? ha arribat el missatge?).

### `displayOptions` esborra paràmetres en silenci

- Els paràmetres amagats per `displayOptions` **no es persisteixen**. Si canvies
  l'`operation` d'un node, els camps que deixen de mostrar-se desapareixen del JSON al
  primer desat. Així és com `fileContent` i `commitMessage` es van evaporar del backup.
- Quan revisis un node sospitós, compara les claus de `parameters` amb les que hauria de
  tenir per a aquella operació. Una clau que falta no és un descuit: és una operació
  canviada.

### Telegram: el filtre del disparador NO serveix per a botons

- **`additionalFields.chatIds` i `userIds` del `telegramTrigger` només miren
  `bodyData.message`.** Verificat al codi font de `TelegramTrigger.node.js` (n8n 2.19.5):

  ```js
  if (!splitIds.includes(String(bodyData.message?.chat?.id))) return {};
  if (!splitIds.includes(String(bodyData.message?.from?.id))) return {};
  ```

  Un `callback_query` **no té `message` al primer nivell** (el té dins de
  `callback_query.message`). Amb aquells camps posats, el node **descarta totes les
  premudes de botó en silenci**: sense error, sense execució, sense rastre.
- **Conseqüència:** en un flux que reacciona a botons, la comprovació d'identitat ha
  d'anar a un node de codi que llegeixi `callback_query.from.id` i
  `callback_query.message.chat.id`. Posar-la al disparador el deixa mut.
- **Sempre `answerQuery` primer.** Sense resposta al `callback_query`, el rellotget de
  Telegram gira, la persona torna a prémer i l'acció s'executa dues vegades. Amb un
  `restart-n8n` això són dos reinicis seguits. A més, cal idempotència pel seu compte:
  Telegram reenvia callbacks si no rep resposta a temps.

### Respostes de l'API de Claude: `content[0]` no és el text

- Amb el raonament actiu, `content[0]` és un bloc de `type: "thinking"` **sense camp
  `text`**. Llegir `content[0].text` dona `undefined`. Cal buscar el **primer bloc amb
  `type === 'text'`**.
- Si no es fa, tot funciona *aparentment*: la crida respon 200, el JSON hi és, i el flux
  cau al camí de "no he pogut llegir la resposta". Silenci amb la resposta correcta al costat.

### Trampes del node IF i de les consultes

- **`operator: { type: 'boolean', operation: 'true' }` necessita `singleValue: true`.**
  Sense això peta amb `Wrong type: '' is a string but was expecting a boolean`, perquè
  intenta validar el `rightValue` buit.
- **Un node que no troba res no emet res, i la branca s'atura.** A les consultes de Data
  Table (i a qualsevol node de cerca) posa **`alwaysOutputData: true`** si el cas "no hi ha
  resultats" és normal. Sense això, un flux que consulta "hi ha incidències obertes?" es
  queda **mut per sempre** quan no n'hi ha cap — que és l'estat habitual.
- **Els nodes de registre han de referenciar el node d'origen, no `$json`.** Si el node
  anterior és un Telegram (que retorna `{ok:true}`), `$json.el_meu_camp` és `undefined` i
  escrius files buides. Fes servir `$('Node d origen').first().json.camp`.

### El node SSH afegeix `cd <cwd> ; ` davant de la comanda

- No envia la comanda pelada. Si a l'altra banda hi ha un embolcall que compara cadenes
  exactes, **totes les accions són rebutjades** i el flux rep sortida buida.
- Comprova sempre què arriba de veritat: `/home/bob/logs/n8n-ssh.log` registra la cadena
  literal amb IP d'origen.

## Costures amb altres agents

> Coses que un altre agent pot trencar sense saber-ho. **Abans de tocar-les, mira qui hi
> ha a l'altra banda.** Els tres casos d'aquesta taula són reals, tots del 2026-08-10.

| Superfície | Qui la pot trencar | Qui se'n ressent | Com se'n va assabentar |
| --- | --- | --- | --- |
| `~/bin/n8n-ssh-allowlist.sh` | `vps-guardian` | Tots els fluxos que envien SSH | En ampliar-lo es van perdre 4 coses. L'informe diari va quedar cec **i ningú ho va saber fins que es va provar un flux nou** |
| Les seccions `--- X ---` del bloc `monitor` | `vps-guardian` | El parser de l'informe, que les busca pel nom exacte | Van desaparèixer amb la reescriptura i l'informe les va reportar com a incidència |
| Format de `health.status` | `vps-guardian` | La signatura de deduplicació d'incidents | Canvi coordinat i sense incidents: es va avisar abans |
| Credencials i noms de node d'n8n | `n8n-architect` | Scripts de backup que en depenen | — |

**Regla:** qualsevol fitxer d'aquesta taula porta un avís al capdamunt amb qui en depèn.
Si l'has de tocar, llegeix-lo primer i actualitza'l després.

## Hipòtesis en prova

> (Marcades com a hipòtesi fins tenir-ne més casos.)

- **MCP builder i credencials** (2 casos, 2026-07-29): `create_workflow_from_code` i
  `update_workflow` **no vinculen credencials existents** als nodes HTTP Request —
  `newCredential('Nom')` deixa el node buit i s'ha de triar al desplegable. En un
  `update`, els nodes que **conserven el nom** mantenen la credencial ja vinculada; només
  els nodes nous o reanomenats la perden. Conseqüència pràctica: si has d'iterar sobre un
  workflow, **no reanomenis nodes** o faràs re-vincular credencials a cada volta.
- **L'assignació automàtica de credencials tria malament** (1 cas, greu): per a nodes amb
  credencial dedicada (Telegram, Drive...) l'MCP **sí** que n'assigna una sola, però agafa
  **qualsevol credencial del tipus correcte**, ignorant el nom demanat a `newCredential()`.
  En un cas va posar el bot `Fotos_a_drive` a un node d'alertes que havia de fer servir
  `Agent_error_n8n`. **Comprova sempre les credencials assignades després de crear un
  workflow**, amb `SELECT` sobre `workflow_entity` o node per node a la UI. Un workflow
  que envia alertes al canal equivocat és pitjor que un que no n'envia.
- **Sandbox de l'SDK** (1 cas): el codi del workflow SDK no admet certs mètodes
  (`.join()` va donar `Security violation`). Els blocs de codi dels Code node s'han
  d'escriure com a cadena literal amb `\n`, no construïts amb arrays.
- **Sortida de `get_execution`** (3 casos): amb payloads grans supera sempre el límit de
  tokens i es desa a fitxer. No la llegeixis sencera: parseja-la amb `node -e` i extreu
  només `resultData.error`, `lastNodeExecuted` i els comptadors per node.
- **Diagnòstic sense executar**: el registre `/home/node/.n8n/n8nEventLog.log` dins del
  contenidor n8n té esdeveniments `n8n.node.started` / `n8n.node.finished` per execució.
  Permet saber quins nodes s'han executat i quant han trigat **sense** engegar res, encara
  que `EXECUTIONS_DATA_SAVE_ON_SUCCESS=none`.

## Changelog

- **2026-07-28** · revisat en omplir els altres playbooks. **Res a afegir**: encara no
  s'ha fet cap feina d'n8n de la qual es pugui treure evidència. Es deixa buit a propòsit,
  no per oblit.
- **2026-07-29** · primera càrrega de regles reals, a partir de la reparació del workflow
  "Backup Pro de Fluxos n8n a GitHub" (`wtl6gHDmVBHjEBy0`). Van caldre tres execucions
  fallides per arribar a la Git Data API; les regles de GitHub i de `batchSize` hi són
  precisament perquè no torni a passar.
