# Changelog — schematize-seo

Todas as mudanças relevantes deste pacote, no formato [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
com versionamento [SemVer](https://semver.org/lang/pt-BR/).


## [0.3.0] — 2026-08-21
Segunda leva do saneamento: as lacunas de escopo e as contradições em MUST do inventário da vistoria.

### Adicionado
- **`tecnico.md` §2.1 — controlar o SNIPPET:** `nosnippet`, `max-snippet` (com `0` = nosnippet e **`-1`** = sem limite), **`data-nosnippet`** (que exclui **um pedaço** e é o que serve para conteúdo pago sem apagar a página da SERP), `max-image-preview:large`, `max-video-preview`, `noarchive` — *os únicos controles que afetam diretamente o que buscador e answer engine mostram*. Com as duas armadilhas: **`nosnippet` é faca de dois gumes** (sem trecho, o CTR cai e você some da resposta de IA) e o VETADO de usar `robots.txt` para "tirar do Google" (bloqueado = `noindex` **nunca lido**).
- **`tecnico.md` §9.1 — paginação e navegação facetada:** `rel=next/prev` aposentado, **self-canonical por página** (canonicalizar tudo para a página 1 faz o item da página 7 sumir), e a faceta tratada com `noindex,follow` **sem** link navegável — nunca só `Disallow`. Mais o sintoma de vazamento de crawl budget.
- **`tecnico.md` §11 — além do Google:** RFC 9309, **IndexNow** (*push* de mudança, não inventário; não é canal do Google), **Indexing API** só para `JobPosting`/vídeo ao vivo, **sitemap de imagem e vídeo**, e o **limite de 16 meses do GSC** — com a consequência: exporte mensalmente, porque descobrir isso no dia em que você precisa do dado de 18 meses atrás é tarde demais.

### Corrigido
- **Duas contradições em MUST.** (1) A **âncora da entidade** era `.org` no `dados-estruturados.md` e `.net` no `internacional-multidominio.md`: a fonte única passou a ser o reference central de domínios (`.net` no `@id`/`url`, os outros em `sameAs`), com o motivo escrito — *duas âncoras fazem o buscador ver **duas organizações** com o mesmo nome, e a autoridade que deveria somar se divide*. (2) O **idioma do `.net`**: a tabela define en, e os exemplos marcavam `inLanguage: "pt-BR"` em URL `.net`; corrigidos (o exemplo pt-BR foi para o `.com.br`), porque **markup errado é copiado com muito mais facilidade do que prosa certa**.
- **`llms.txt` virou SHOULD** (era MUST com gate de publicação): ✔ verificado — é proposta que **nenhum crawler grande adotou**, e travar release por um arquivo que ninguém consome **ensina o time a desligar gate**. A `schematize-web` já dizia SHOULD; agora as duas concordam.
- **`operatingSystem` deixou de ser a constante `"Linux"`** e passou a espelhar a **matriz de release** (✔ o updater da casa publica para Linux, macOS e Windows). Declarar menos SOs tira você do resultado; declarar mais é markup falso.
- **`§N` com dois sentidos** no checklist do `anti-padroes.md`: as remissões a **itens da tabela** viraram "item N" (a regra `item-por-numero` do lint existe por essa classe).
- **Baseline de medição** deixou de ser gravado dentro da reference: vai para o **archive do projeto**. *Gravar medição na skill faria o modelo editar a própria normativa a cada auditoria.*
- Thresholds de title/meta e Core Web Vitals com **fonte única**; `|` escapado na tabela de `on-page.md`; fence órfã removida em `dados-estruturados.md`; remissões de dados estruturados apontando `dados-estruturados.md` (o `tecnico.md` não trata de schema).

## [0.2.0] — 2026-08-21
Saneamento do catálogo conforme a vistoria de 2026-08-21.

### Corrigido
- **Core Web Vitals: uma fonte só.** Os números saíram do corpo (inclusive a última duplicata no checklist do `tecnico.md`) e ficaram **apenas** no anexo volátil da `schematize-web`, que tem `Verificado em:`. O corpo mantém o que não envelhece: o que cada métrica mede e a exigência de **verde em campo (CrUX/GSC, p75)**.
- **Thresholds de title/meta em um valor só:** `on-page.md` é a fonte (~50–60 chars / ≤ ~600px; ~150–160), e o `checklist-lp.md` **remete** em vez de repetir — com o que faz o número ser aproximado: **o corte na SERP é por pixel, não por caractere**.
- **Dados estruturados** deixaram de ser buscados no `tecnico.md` (que não tem uma linha sobre schema): as 4 remissões de `fundamentos.md` apontam `dados-estruturados.md`.
- **Tabela quebrada e fence órfã:** `|` dentro de código inline escapado em `on-page.md` (era justamente nos exemplos de título com sufixo de marca) e a ``` sobrando no fim de `dados-estruturados.md`, que fazia o checklist inteiro renderizar como código.

### Adicionado
- `assets/CLAUDE.md` e os comandos `/seo-load`, `/seo-cc`, `/seo-handoff`, `/seo-claude`; o `/seo-audit` ganhou os passos concretos de coleta (`curl`/`grep`) e a regra **"sem resposta HTTP, não há veredito"**.

## [0.1.0] — 2026-08-10

Primeira versão da skill de SEO da casa.

### Adicionado
- **SKILL.md** com 10 pisos inegociáveis (zero black-hat, uma intenção por URL,
  self-canonical, **nunca canonical cruzado entre os domínios da casa**, hreflang
  recíproco, indexabilidade intencional, title/meta/H1 únicos, dados estruturados
  válidos, performance/a11y como SEO, medir antes/depois).
- **references/**:
  - `fundamentos.md` — como busca e resposta-de-IA rankeiam, intenção, E-E-A-T, funil.
  - `tecnico.md` — crawl/index/render, robots, sitemaps, canonical, redirects,
    arquitetura, internal linking, Core Web Vitals para SEO, mobile-first, JS SEO.
  - `on-page.md` — title/meta/headings/URL/semântica/mídia/âncoras.
  - `keywords-conteudo.md` — pesquisa, intenção, topic clusters/pillar, briefs,
    anti-thin, canibalização, refresh.
  - `dados-estruturados.md` — schema.org/JSON-LD, rich results, validação.
  - `internacional-multidominio.md` — ccTLD/gTLD, hreflang, self-canonical por
    propriedade, conteúdo distinto por domínio, estratégia de redirect (net/org/me/com.br).
  - `aio-llmo-geo.md` — AI Overviews/answer engines, GEO, llms.txt, citabilidade, entidade.
  - `autoridade-eeat.md` — backlinks/digital PR, sinais de marca, autoria, link tóxico.
  - `medicao.md` — GSC, analytics, rank, log, KPIs, experimentos, relatório.
  - `anti-padroes.md` — black-hat + erros comuns.
  - `checklist-lp.md` — checklist de SEO por página/LP (pré-publicação).
- **assets/commands/**: `/seo-help`, `/seo-audit`, `/seo-plan`, `/seo-keywords`, `/seo-review`.
