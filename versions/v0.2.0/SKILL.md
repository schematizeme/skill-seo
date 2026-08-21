---
name: schematize-seo
metadata:
  version: 0.2.0
description: Padrões normativos de SEO da casa — do técnico ao conteúdo, para rankear em busca E em resposta de IA. Cobre SEO técnico (crawl/index/render, robots, sitemaps, canonical, redirects, arquitetura, internal linking, Core Web Vitals, JS SEO), on-page (title/meta/headings/URL/semântica), keywords e conteúdo (intenção, topic clusters, briefs, anti-thin), dados estruturados (schema.org/JSON-LD, rich results), SEO internacional e MULTI-DOMÍNIO sem canibalização (ccTLD/gTLD, hreflang recíproco, self-canonical por propriedade), descoberta por IA (AIO/LLMO/GEO, llms.txt, conteúdo citável, E-E-A-T), autoridade/off-page e medição (GSC, analytics, rank, logs). Use SEMPRE que a tarefa envolver rankear, ser encontrado ou ser citado por IA — planejar, otimizar, revisar ou auditar página, landing, blog ou site —, mesmo que peça só "uma landing rápida". Pisos: nunca black-hat/cloaking; página indexável é self-canonical com UMA intenção; nunca canonical cruzado entre domínios da casa; hreflang recíproco; medir antes/depois.
---

# Padrões de SEO da Casa (schematize-seo)

Conjunto normativo que rege como a casa **rankeia e é encontrada** — em mecanismos de busca **e** em respostas de IA (AI Overviews, ChatGPT, Perplexity, etc.). É a contraparte de disciplina do `schematize-web`: o **como implementar** no frontend (RSC, build, Core Web Vitals na prática, a11y, deploy) **delega ao schematize-web**; o **o quê, por quê e com qual estratégia** de SEO — técnico, conteúdo, keywords, dados estruturados, multi-domínio, autoridade, medição — é governado aqui.

**Versão:** skill `schematize-seo` v0.2.0. Changelog em `CHANGELOG.md`.

## Comandos (Claude Code)

Digite `/seo-help` pra ver todos. Em resumo:

| Comando | O que faz |
|---|---|
| `/seo-help` | lista todos os comandos do schematize-seo |
| `/seo-audit` | auditoria SEO de um site/página: técnico, on-page, dados estruturados, CWV, internacional, AIO — plano → aprovação → relatório priorizado |
| `/seo-plan` | plano de SEO de uma propriedade: mapa de intenção, topic clusters, arquitetura de URL, estratégia multi-domínio (net/org/me/com.br), KPIs |
| `/seo-keywords` | pesquisa e mapa de keywords por intenção + agrupamento em clusters, com anti-canibalização (uma intenção por URL) |
| `/seo-review` | revisa uma página/PR pelo gate de SEO (title/meta/H1/URL/canonical/hreflang/schema/alt/internal links) e reprova o que quebra piso |
| `/seo-load` | carrega à força TODO o corpo normativo de SEO no contexto e passa a aplicá-lo como regra inegociável |
| `/seo-claude` | cria ou ATUALIZA o `CLAUDE.md` da raiz com o bloco sempre-on de SEO (mescla, com backup) |
| `/seo-cc` | context compact: grava o handoff **com o baseline medido** no archive e roda `/compact` |
| `/seo-handoff` | gera o handoff **sem** compactar — pra fim de sessão |

Os comandos ficam em `assets/commands/` e são instalados em `.claude/commands/`.

## Como usar esta skill

1. Identifique o domínio da tarefa e **leia o(s) reference(s) relevante(s)** antes de produzir plano, conteúdo, markup ou código. Não trabalhe de memória — táticas e thresholds mudam e estão nos arquivos.
2. **Sempre** aplique os pisos inegociáveis abaixo, independente do reference carregado.
3. Se a tarefa exigir implementação no frontend (rotas, RSC, `metadata`, sitemap autogerado, performance real, a11y), **carregue também o schematize-web** — esta skill diz *o que* e *por quê*; o web diz *como codar*.
4. Ao terminar, valide contra o `references/checklist-lp.md` (por página) e registre baseline/depois em `references/medicao.md`.

Mapa de references — leia o que casa com a tarefa:

| Tarefa | Reference |
|---|---|
| Como busca e resposta-de-IA rankeiam hoje, intenção, E-E-A-T, o funil crawl→index→rank→cita→converte, filosofia | `references/fundamentos.md` |
| SEO técnico: crawlability/indexação, robots.txt, sitemaps, canonical, status/redirects, arquitetura de site, internal linking, Core Web Vitals para SEO, mobile-first, HTTPS, JS/render SEO | `references/tecnico.md` |
| On-page: title, meta description, headings (um H1/uma intenção), desenho de URL, HTML semântico, mídia/alt, âncoras internas, snippets | `references/on-page.md` |
| Pesquisa de keywords, mapa por intenção, topic clusters + pillar pages, briefs de conteúdo, anti-thin/duplicado, cadência de refresh, canibalização | `references/keywords-conteudo.md` |
| Dados estruturados: catálogo schema.org (Organization, WebSite, SoftwareApplication, Product, Course, Article, BreadcrumbList, FAQ…), JSON-LD, rich results, validação | `references/dados-estruturados.md` |
| **Internacional e MULTI-DOMÍNIO sem canibalizar:** ccTLD vs gTLD, hreflang recíproco, self-canonical por propriedade, conteúdo distinto por domínio, split comercial/institucional/marca, estratégia de redirect dos "links que importam" pro domínio-âncora | `references/internacional-multidominio.md` |
| **Descoberta por IA: AIO/LLMO/GEO**, AI Overviews e answer engines, conteúdo extraível/citável, `llms.txt`, entidade/knowledge graph, E-E-A-T para IA | `references/aio-llmo-geo.md` |
| Autoridade e off-page: backlinks de qualidade, digital PR, sinais de marca/entidade, autoria/E-E-A-T, higiene de link tóxico | `references/autoridade-eeat.md` |
| Medição: Google Search Console, analytics, rank tracking, análise de log, KPIs por etapa do funil, experimentos, relatório | `references/medicao.md` |
| Filosofia e a lista completa de anti-padrões (black-hat + erros comuns: canibalização, over-canonical, thin, keyword stuffing, hreflang quebrado…) | `references/anti-padroes.md` |
| **Checklist de SEO por página/LP** (pré-publicação) — a ponte pro trabalho de landing page | `references/checklist-lp.md` |

## Pisos inegociáveis (vetam o atalho)

Independente do reference, estes limites nunca são cruzados:

1. **Zero black-hat.** Nada de cloaking, doorway pages, texto oculto, keyword stuffing, PBN, link comprado dissimulado, conteúdo gerado em massa sem valor. Queima o domínio — e domínio com autoridade (como `.me`/`.com.br` da casa) é ativo caro de reconstruir.
2. **Uma intenção por URL.** Toda página indexável responde a **uma** intenção de busca dominante. Duas páginas disputando a mesma intenção/keyword = **canibalização**: consolida, diferencia ou 301. Ver `keywords-conteudo.md` e `anti-padroes.md`.
3. **Self-canonical por padrão.** Toda página indexável aponta `rel=canonical` pra si mesma (URL absoluta, uma versão: https, com/sem www decidido, sem parâmetros de tracking na canônica).
4. **Nunca canonical cruzado entre os domínios distintos da casa.** `.net`, `.org`, `.me` e `.com.br` são propriedades com **conteúdo e intenção distintos** — cada uma é self-canonical. Canonicalizar `.me`→`.net` jogaria fora a autoridade do `.me`. Elas se diferenciam por conteúdo e se conectam por links (os "que importam" apontam pro `.net`), **não** por canonical. Ver `internacional-multidominio.md`.
5. **hreflang recíproco e completo** quando houver variação por idioma/região: todo conjunto inclui `x-default`, cada URL lista todas as alternativas (inclusive a si), e os apontamentos são recíprocos. hreflang quebrado é ignorado pelo Google.
6. **Indexabilidade intencional.** O que deve rankear é rastreável e indexável (não bloqueado por robots, sem `noindex` acidental, sem depender de JS que o crawler não executa); o que não deve (staging, filtros infinitos, carrinho) é `noindex`/bloqueado de propósito.
7. **Title, meta e H1 únicos e verdadeiros por página.** Nada de title duplicado no site, nada de meta genérica, nada de H1 que promete o que a página não entrega (o *pogo-stick* do usuário derruba o rank).
8. **Dados estruturados válidos e verdadeiros.** JSON-LD que reflete o conteúdo visível na página; passa no validador; sem marcar rich result que a página não mostra (é violação e vira penalização manual).
9. **Performance e a11y contam como SEO.** Core Web Vitals no verde e acessibilidade AA não são "extra" — são fator de rank e de extração por IA. A implementação delega ao `schematize-web`, mas o SEO **exige** o resultado.
10. **Medir antes e depois.** Toda mudança relevante de SEO tem baseline (GSC/analytics) e é reavaliada. Sem medição, é achismo — e achismo em SEO custa meses.

## Relação com as outras skills

- **schematize-web** — implementação de frontend: `metadata`/tags no App Router, sitemap/robots autogerados, i18n com URL por idioma, Core Web Vitals na prática, a11y, deploy. Esta skill define a estratégia; o web executa. Há sobreposição proposital em `seo-i18n.md`/`aio-llmo-geo.md` do web — aqui é a fonte canônica da **disciplina**; lá, do **código**.
- **schematize-engineering** — quando o SEO exige backend (renderização server-side de conteúdo, geração de sitemaps em escala, i18n de dados), delega o back ao `engineering`/`go`.

- **schematize-institutional** — o **inventário de páginas** de um site de empresa (quais páginas
  existem, o que cada uma prova, e as **páginas legais** obrigatórias). A fronteira: a
  `schematize-institutional` diz **quais páginas existem e o que dizem**; esta skill diz **como
  elas rankeiam e são citadas** (intenção, cluster, canibalização, hreflang, dados estruturados);
  a `schematize-web` diz **como são construídas**. Sitemap e robots seguem o piso desta skill —
  **autogerados**, nunca à mão: sitemap escrito à mão envelhece na primeira página nova e passa a
  **mentir para o crawler**, o que é pior que não ter. *(A `schematize-institutional` entregava um
  `sitemap.xml` à mão, que esta skill e a `schematize-web` vetam — achado da Classe F da vistoria
  de 2026-08-21.)*
