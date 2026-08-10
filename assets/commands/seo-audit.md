---
description: Auditoria SEO (técnico, on-page, schema, CWV, multi-domínio, AIO) plan-first
argument-hint: "[url ou caminho do projeto]"
---

Faça uma **auditoria de SEO** de $ARGUMENTS (ou do site/projeto atual), plan-first.

1. **Planeje** o escopo e mostre antes de rodar: quais propriedades/URLs, e quais
   frentes serão checadas. Peça aprovação.
2. **Rode a auditoria** por frente, lendo o reference correspondente antes de cada uma:
   - **Técnico** (`references/tecnico.md`): robots.txt, sitemap, canonical (self,
     absoluto, sem cross-domain indevido), status/redirects (sem cadeia/soft-404),
     indexabilidade (noindex/disallow corretos), arquitetura/profundidade, internal
     linking/orphans, HTTPS, mobile-first, JS/render (conteúdo visível ao crawler).
   - **On-page** (`references/on-page.md`): title único keyword-first, meta com CTA,
     UM H1/uma intenção, URL limpa, HTML semântico, alt, âncoras internas.
   - **Keywords/conteúdo** (`references/keywords-conteudo.md`): intenção por URL,
     **canibalização** (URLs disputando a mesma query), thin/duplicado.
   - **Dados estruturados** (`references/dados-estruturados.md`): JSON-LD do tipo
     certo, válido, refletindo o conteúdo visível.
   - **Internacional/multi-domínio** (`references/internacional-multidominio.md`):
     domínio certo pro propósito, self-canonical, hreflang recíproco só se tradução,
     conversão apontando pro `.net`, marca como entidade única (`sameAs`).
   - **AIO/IA** (`references/aio-llmo-geo.md`): conteúdo extraível/citável, `llms.txt`,
     política de crawler de IA, entidade.
   - **Core Web Vitals & a11y** (delega ao `schematize-web`): exija o resultado (verde).
3. **Relatório priorizado**: liste achados como `BLOQUEIA` (viola piso — ver
   `SKILL.md`) e `ATENÇÃO` (melhoria), cada um com o conserto concreto e o impacto
   estimado (alcance × esforço). Feche com a ordem recomendada de execução.

Seja específico e acionável. Se faltar acesso a GSC/analytics, diga o que medir
depois (`references/medicao.md`) pra fechar o baseline.
