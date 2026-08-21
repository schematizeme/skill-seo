# Changelog — schematize-seo

Todas as mudanças relevantes deste pacote, no formato [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
com versionamento [SemVer](https://semver.org/lang/pt-BR/).


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
