# SEO Técnico — Crawl, Índice, Render e Arquitetura

> Parte da skill **schematize-seo**. Cobre a camada técnica: o que o crawler consegue **rastrear**, o que o buscador escolhe **indexar**, como ele **renderiza** o HTML e como a **arquitetura** do site distribui autoridade. É o piso sobre o qual `on-page.md`, `keywords-conteudo.md` e `dados-estruturados.md` operam — conteúdo excelente numa página que o Googlebot não rastreia, não indexa ou não renderiza **não rankeia**.
>
> A **estratégia multi-domínio** da casa (net/org/me/com.br sem canibalizar, sem canonical cruzado) vive em `internacional-multidominio.md` — aqui só aplicamos a regra técnica. A **implementação no frontend** (rotas do App Router, `metadata`, sitemap/robots autogerados, Core Web Vitals na prática, SSR/SSG) **delega ao `schematize-web`** — esta skill diz *o que exigir*; o web diz *como codar*.

## Como ler

- **MUST / Obrigatório** — regra. Desvio bloqueia publicação ou exige ADR.
- **SHOULD / Recomendado** — padrão. Desvio precisa de justificativa.
- **VETADO / Proibido** — piso. Não tem ADR de exceção. Burlar é incidente.

Os thresholds abaixo são concretos e verificáveis. "Está bom" não é status — ou passa o número, ou tem ADR.

---

## 1. Crawlability — deixar o crawler entrar e não desperdiçar

O funil começa em **rastrear**. Se o Googlebot não chega na URL, nada mais importa.

### 1.1 robots.txt

**MUST**
- Existe **um** `robots.txt` na raiz de **cada** propriedade (`https://schematize.net/robots.txt`, `https://schematize.org/robots.txt`, etc.), servido com `200` e `Content-Type: text/plain`.
- Declara a directive `Sitemap:` com **URL absoluta** do sitemap (ou do sitemap index) — uma linha por sitemap.
- Sintaxe correta: `User-agent`, `Disallow`, `Allow`. Path é case-sensitive e relativo à raiz. `Disallow:` vazio = libera tudo; `Disallow: /` = bloqueia tudo.

**Sintaxe de referência:**

| Objetivo | Linha |
|---|---|
| Todos os bots | `User-agent: *` |
| Bloquear uma pasta | `Disallow: /admin/` |
| Bloquear por padrão | `Disallow: /*?sessionid=` |
| Abrir exceção dentro de bloqueio | `Allow: /admin/public/` |
| Apontar o sitemap | `Sitemap: https://schematize.net/sitemap.xml` |

**O que bloquear vs. liberar:**

| Bloquear no robots.txt | Liberar (nunca bloquear) |
|---|---|
| Áreas privadas/admin, carrinho, checkout, conta | Páginas que devem rankear |
| Busca interna e facetas infinitas (crawl trap) | **CSS e JS** — o Googlebot precisa deles pra renderizar (ver §6) |
| Endpoints de API internos sem valor de busca | Imagens que devem aparecer no Google Imagens |
| Ambientes de staging/preview (idealmente atrás de auth) | O próprio sitemap |

**VETADO**
- **Bloquear CSS/JS no robots.txt.** Impede o render e derruba mobile-first e Core Web Vitals aos olhos do Google.
- **Usar robots.txt para "esconder" uma página do índice.** Ele controla *rastreio*, não *indexação* — ver §2.1, a diferença é crítica.
- **`Disallow: /` em produção** (bloqueia o site inteiro — o clássico "esqueceu de tirar do deploy de staging").

### 1.2 Crawl budget

**SHOULD**
- Tratar crawl budget só é relevante em site **grande** (dezenas de milhares de URLs) ou com muita URL de baixo valor. Site pequeno/médio não tem problema de budget — tem problema de qualidade.
- Reduzir desperdício: eliminar crawl traps (facetas/ordenações infinitas via parâmetro), consolidar redirects (§3.2), servir `304 Not Modified` quando cabível, e evitar milhares de URLs quase-duplicadas.
- Não gastar rastreio com URL que retorna `noindex` repetidamente — a longo prazo o Google rastreia menos, o que atrasa descoberta do que importa.

---

## 2. Indexação — controlar o que entra no índice

### 2.1 `noindex` vs `Disallow` — a diferença CRÍTICA

Esta é a confusão que mais quebra SEO técnico. Os dois **não** são intercambiáveis:

| | `Disallow` (robots.txt) | `noindex` (meta/header) |
|---|---|---|
| Controla | **Rastreio** (o bot não busca a página) | **Indexação** (o bot busca, mas não indexa) |
| A página aparece no índice? | **Pode aparecer** (sem snippet, "descoberta por links") | **Não aparece** |
| O bot lê o conteúdo? | Não | Sim |
| Uso correto | Poupar budget em massa de URLs sem valor | Tirar UMA página específica do índice |

**Regra de ouro (MUST):** para **remover uma página do índice**, use `noindex` e **deixe o robots.txt LIBERAR o rastreio dessa URL**. Se você bloqueia no robots.txt, o Google **nunca lê** a tag `noindex` — e a URL pode continuar indexada (aparecendo como resultado sem descrição, "descoberta por links externos"). São mutuamente excludentes na prática: `noindex` só funciona se a página for rastreável.

**Como aplicar `noindex`:**
- HTML: `<meta name="robots" content="noindex, follow">` no `<head>`.
- Header (para PDF, imagens, respostas não-HTML): `X-Robots-Tag: noindex`.
- `follow` mantém o fluxo de link saindo da página; use `noindex, follow` salvo motivo pra `nofollow`.

**Quando usar `noindex`:** busca interna, páginas de agradecimento/confirmação, paginação duplicada, filtros que geram thin content, versões de impressão. **Quando usar `Disallow`:** áreas privadas, admin, seções sem qualquer valor de busca onde nem queremos gastar rastreio.

**VETADO**
- `noindex` **e** `Disallow` na mesma URL esperando remoção — o `Disallow` cega o bot pro `noindex` e a página pode ficar presa no índice.
- `noindex` acidental em página que deveria rankear (o erro mais caro do deploy — sempre auditar antes de publicar).

### 2.2 Indexabilidade intencional

**MUST**
- Toda página que **deve** rankear é: rastreável (não bloqueada), indexável (sem `noindex`), self-canonical pra si (§4), com resposta `200`, e com conteúdo no HTML servido (§6).
- Toda página que **não deve** rankear (staging, carrinho, filtros infinitos, duplicatas) é explicitamente `noindex` ou bloqueada — nunca "por acaso".

---

## 2.1 Controlar o SNIPPET — o que aparece na SERP e o que a IA pode citar

Indexar e **exibir** são coisas diferentes, e a maioria dos times só conhece a primeira. Estes são
**os únicos controles que afetam diretamente o que os buscadores e os answer engines mostram** do
seu conteúdo — e eles vivem na mesma `<meta name="robots">` / header `X-Robots-Tag`:

| Diretiva | O que faz |
|---|---|
| `nosnippet` | **nenhum** trecho na SERP (e, na prática, remove o texto que alimentaria a resposta de IA daquela página) |
| `max-snippet:[n]` | teto de **caracteres** do trecho. `0` equivale a `nosnippet`; **`-1`** = sem limite |
| `data-nosnippet` | **atributo HTML** (`<span data-nosnippet>`) que exclui **um pedaço** da página — o resto continua elegível |
| `max-image-preview:[none\|standard\|large]` | tamanho da miniatura; **`large` é requisito prático** para aparecer bem em Discover e em resultado visual |
| `max-video-preview:[n]` | segundos de preview de vídeo |
| `noarchive` | sem cópia em cache |

**MUST**
- **Decida por tipo de página**, e escreva a decisão: conteúdo de topo de funil normalmente quer
  **`max-snippet:-1` + `max-image-preview:large`** (ser citado é o objetivo); conteúdo **pago ou
  sob login** usa `max-snippet:[n]` curto ou `data-nosnippet` no bloco premium — **e é aí que
  `data-nosnippet` ganha do `nosnippet`**: você esconde o trecho pago sem apagar a página da SERP.
- **`nosnippet` é uma faca de dois gumes:** sem trecho, o CTR cai — e, com AI Overviews, sem texto
  citável você some da resposta em vez de aparecer melhor.
- **Estas diretivas são de EXIBIÇÃO, não de indexação.** Nenhuma delas tira a página do índice
  (isso é `noindex`), e nenhuma delas impede o crawl (isso é `robots.txt` — que, aliás, **não** é
  como se tira algo do índice).
- **Crawler de IA é outra decisão**, e ela é de negócio: bloquear `GPTBot`/`ClaudeBot`/`PerplexityBot`
  no `robots.txt` protege o conteúdo **e** o remove das respostas onde ele seria citado. Registre em
  ADR — em `aio-llmo-geo.md` está o detalhe.

**VETADO**
- Usar `robots.txt` para "tirar do Google": página bloqueada **não pode ser lida**, logo o `noindex`
  dela **nunca é visto** — e ela pode continuar aparecendo, só que sem trecho. Para remover, deixe
  rastrear e use `noindex`.

## 3. Status HTTP e redirects

### 3.1 Códigos de status e o que o SEO faz com eles

| Código | Significado | Efeito no índice |
|---|---|---|
| `200` | OK | Indexável (se não houver `noindex`/canonical apontando pra fora) |
| `301` | Movido permanente | **Para mover URL.** Consolida sinais no destino. É o redirect de SEO |
| `302` | Movido temporário | Mantém a URL antiga no índice. Só pra movimento realmente temporário |
| `304` | Not Modified | Economiza budget; conteúdo inalterado desde o `If-Modified-Since` |
| `404` | Não encontrado | Sai do índice com o tempo. Correto pra conteúdo que não existe |
| `410` | Gone | Como `404`, porém sinaliza remoção **definitiva** — sai mais rápido |
| `5xx` | Erro de servidor | Grave: repetido, o Google reduz rastreio e pode desindexar. Monitorar |

**MUST**
- Mover URL permanentemente → **`301`**. Nunca deixar a URL antiga responder `200` com o mesmo conteúdo em duas URLs (duplicação).
- Conteúdo removido de vez → **`410`** (ou `404`). Nunca `301` em massa de páginas mortas pra home — isso é *soft-404* mascarado (ver abaixo).
- `5xx` recorrente é incidente de SEO, não só de infra — alertar.

### 3.2 Regras de redirect

**MUST**
- **Uma versão canônica do host, sempre `301` para ela:** decidir HTTPS (obrigatório, §5), `www` ou apex, e redirecionar todas as outras variantes pra ela. Ex.: `http://`, `www.`, e trailing-slash inconsistente convergem pra **uma** forma.
- **Nunca cadeia de redirect** (`A→B→C`). Aponte a origem direto pro destino final (`A→C`). Cada salto perde sinal e budget.
- **Nunca loop de redirect** (`A→B→A`). Quebra o rastreio.

**VETADO**
- **Soft-404** — página que responde `200` mas diz "não encontrado"/"produto indisponível" no corpo, ou `301` de conteúdo morto pra home. O Google trata como erro e desconfia do site inteiro. Conteúdo que não existe responde `404`/`410`; página vazia legítima mostra estado vazio útil **e** responde o status certo.
- Redirecionar em massa páginas descontinuadas pra home "pra não perder o 404" — pior que o 404.

> A **estratégia de "links que importam"** (quando `.org`/`.me`/`.com.br` remetem tráfego/autoridade pro `.net` de conversão) é feita por **link**, não por redirect nem canonical cruzado. Ver `internacional-multidominio.md`.

---

## 4. Canonical

**MUST**
- **Toda página indexável tem `<link rel="canonical">` self-referente** (aponta pra si mesma), com **URL absoluta** (`https://schematize.net/pagina`, não `/pagina`).
- A canônica usa **uma versão só**: HTTPS, host decidido (www vs apex), **sem parâmetros de tracking** (`utm_*`, `gclid`, `fbclid`, `sessionid`) e sem barra final inconsistente.
- Variações da mesma página (por query de tracking, ordenação, filtro leve) apontam canonical pra versão limpa.
- Canonical é **dica forte**, não ordem — reforce com sitemap, internal linking e `301` coerentes. Contradizer o canonical com um `301` ou um `noindex` confunde o Google.

**VETADO — piso da casa**
- **Canonical cruzado entre os domínios distintos da casa.** `.net`, `.org`, `.me` e `.com.br` têm conteúdo e intenção **distintos**; cada um é **self-canonical**. Canonicalizar `.me`→`.net` jogaria fora a autoridade do `.me`. As propriedades se diferenciam por conteúdo e se conectam por **links**, nunca por canonical. Detalhe e exceções (versões idênticas, sindicação) em `internacional-multidominio.md`.
- Canonical apontando pra URL que retorna `404`, `noindex` ou redirect — sinal quebrado, ignorado.
- Página com canonical pra outra e ao mesmo tempo no sitemap como canônica — contradição.

---

## 5. HTTPS

**MUST**
- Site **inteiro** em HTTPS. HTTP é fator de rank negativo e marca "não seguro" no browser.
- Todo HTTP → `301` pra HTTPS. Sem *mixed content* (recurso HTTP dentro de página HTTPS).
- `Strict-Transport-Security` (HSTS) com `max-age` longo. Certificado válido e renovado automaticamente (implementação no `schematize-web`/ops).

---

## 6. JS e render SEO

O Googlebot **rasteia**, depois **renderiza** (executa JS numa fila, com atraso). O que não estiver no HTML **servido** depende dessa segunda passada — que pode demorar, falhar ou não acontecer para outros bots (incl. muitos crawlers de IA, ver `aio-llmo-geo.md`).

**MUST**
- **Conteúdo que precisa rankear vem no HTML do servidor** — **SSR** ou **SSG**. Título, H1, corpo, links internos e dados estruturados presentes na resposta inicial, sem depender de execução de JS no cliente.
- Testar o que o crawler realmente vê: "Inspeção de URL" no GSC (HTML renderizado), `curl` da página, ou visualizar com JS desabilitado. Se o conteúdo some sem JS, é problema de SEO.

**VETADO**
- **Conteúdo só-em-JS (CSR puro)** para páginas que devem rankear — SPA que serve `<div id="root"></div>` vazio e monta tudo no cliente. Corpo, links e metadados ficam invisíveis na primeira passada e frágeis para bots que não renderizam.
- **Links de navegação por `onClick`/JS** sem `<a href>` real — o crawler não os segue. Todo link rastreável é `<a href>` com URL de verdade (liga com a11y no `schematize-web`).
- Injetar `<title>`/canonical/hreflang **só** via JS no cliente — declarar no HTML servido.

| Estratégia | Rankeia bem? | Uso |
|---|---|---|
| **SSG** (estático) | Sim | Conteúdo estável: landing, blog, docs, institucional |
| **SSR** | Sim | Conteúdo dinâmico/personalizado que ainda precisa indexar |
| **ISR / SSG + revalidate** | Sim | Grande volume que atualiza periodicamente |
| **CSR puro** (SPA) | **Não** para conteúdo público | App logado atrás de auth — que nem deve indexar |

> Escolha de SSG vs SSR vs ISR e implementação: `schematize-web`.

---

## 7. Core Web Vitals como fator de SEO

Core Web Vitals são **fator de rank** (page experience) e afetam extração por IA. O SEO **exige o resultado no verde**; a **implementação delega ao `schematize-web`**.

| Métrica | O que mede |
|---|---|
| **LCP** (Largest Contentful Paint) | Carregamento do maior elemento |
| **INP** (Interaction to Next Paint) | Resposta à interação |
| **CLS** (Cumulative Layout Shift) | Estabilidade visual |

> **Os NÚMEROS não moram aqui.** Threshold de CWV é fato com prazo de validade (o INP substituiu o
> FID em 2024; os valores são revistos pelo Google), e ele já vivia no **anexo volátil da
> `schematize-web`** (`references/stack-versoes.md`, com data de verificação). Duplicá-los aqui
> significava **duas fontes divergindo em silêncio** — e a desta skill, sem data, apodrecendo
> primeiro (achado da Classe F da vistoria de 2026-08-21). **Fonte única:** `schematize-web` →
> `references/stack-versoes.md`, seção "Core Web Vitals".

**MUST**
- Medir com **dados de campo** (CrUX/GSC), não só lab (Lighthouse). O rank usa campo.
- CWV fora do verde em página que importa é dívida de SEO — abre tarefa no `schematize-web` (imagem de LCP com prioridade, sem lazy no herói; JS enxuto pra INP; dimensões declaradas pra CLS — ver anti-padrões de performance do web).

---

## 8. Mobile-first indexing

**MUST**
- O Google indexa a versão **mobile** do site. O que valer pra SEO — conteúdo, headings, links internos, dados estruturados, metadados — **existe e é idêntico no mobile**. Nada de "versão mobile enxuta" que corta conteúdo ou links.
- Sem viewport quebrada, sem conteúdo escondido em accordion que não vem no HTML, sem alvos de toque inviáveis (liga com `schematize-web`, mobile utilizável como gate).

---

## 9. Arquitetura do site

### 9.1 Profundidade e silos

**MUST**
- **Profundidade ≤ 3 cliques** da home a qualquer página importante. Quanto mais fundo, menos autoridade chega e mais tarde é rastreada.
- **Silos hub-and-spoke:** uma **pillar page** (hub) por tema linka pros artigos de apoio (spokes), e os spokes linkam de volta pro hub e entre si dentro do mesmo tema. Concentra relevância temática (topic clusters em `keywords-conteudo.md`).

**SHOULD**
- **Breadcrumb** em conteúdo hierárquico, visual **e** com `BreadcrumbList` estruturado (`dados-estruturados.md`). Ajuda usuário, crawler e o snippet.
- URL refletindo a hierarquia do silo (`/tema/subtema/pagina`) — desenho de URL em `on-page.md`.

### 9.2 Internal linking

**MUST**
- **Âncora descritiva** — o texto do link diz o destino ("guia de deploy em Rust"), nunca "clique aqui"/"saiba mais". A âncora é sinal de relevância pro Google e acessibilidade pro leitor de tela.
- **Zero orphan pages** — toda página indexável recebe pelo menos um link interno de outra página rastreável. Página só no sitemap, sem link de entrada, é órfã e rankeia mal.
- **Fluxo de autoridade dirigido:** páginas fortes (home, pillars) linkam pras que precisam subir; as "que importam" pra conversão recebem mais links internos.

**SHOULD**
- Poucos e bons links contextuais > dezenas de links de rodapé. Link no corpo do conteúdo pesa mais.
- Links **entre os domínios da casa** (`.org`→`.net`, `.me`→`.net`) são a forma correta de conectar propriedades e direcionar conversão pro `.net` — feito por link, não por canonical (§4, `internacional-multidominio.md`).

**VETADO**
- Orphan pages em produção; âncora genérica repetida; navegação principal só-JS que o crawler não segue (§6).

---

## 9.1 Paginação e navegação facetada — onde o crawl budget vaza

Duas fontes de URL infinita, e as duas são de arquitetura, não de conteúdo:

- **Paginação.** `rel=next/prev` **não é mais usado pelo Google** (foi aposentado como sinal de
  indexação) — o que funciona hoje: cada página da série é **self-canonical** (nunca canonical para
  a página 1, que é o erro clássico e faz o item da página 7 sumir do índice), todas linkadas com
  `<a href>` real, e a página 1 sem parâmetro. Se existir uma **"ver tudo"** que carregue bem, ela
  pode ser a canônica.
- **Navegação facetada** (filtros combináveis: cor × tamanho × preço × ordenação) é a máquina de
  gerar **milhões de URLs quase iguais**. O piso: decida **quais facetas são indexáveis** (as que
  têm demanda de busca real e conteúdo distinto) e trate o resto com **`noindex,follow` + link sem
  `href` navegável** (ou POST/JS), **nunca** só `Disallow` — bloquear no `robots.txt` impede o
  crawler de **ler** o `noindex`, e a URL fica no índice sem trecho. Ordenação e paginação de
  faceta nunca são indexáveis.
- **Sintoma de que vazou:** o GSC mostra muito mais "Rastreada — não indexada" do que páginas reais,
  e o log de acesso mostra o bot passando o dia em combinação de filtro.

## 10. Sitemaps XML

> A regra da casa é: **sitemap nunca é mantido à mão** — é **gerado** da fonte da verdade (varredura do build ou inventário de rotas/CMS) a cada deploy. Implementação e scaffold no `schematize-web` (`references/seo-i18n.md`, `scripts/gen-sitemap.mjs`). Aqui está o *o quê* incluir.

**MUST**
- Sitemap XML válido listando as URLs **canônicas** que devem ser indexadas.
- **`<loc>`** com URL absoluta, HTTPS, forma canônica (sem tracking, host decidido).
- **`<lastmod>`** com a data **real** da última modificação relevante do conteúdo (ISO 8601). `<lastmod>` mentiroso (mudar em todo deploy sem mudar conteúdo) faz o Google ignorá-lo.
- **Sitemap index** (`<sitemapindex>`) quando passar de **50.000 URLs** ou **50 MB** (descomprimido) por arquivo — quebrar em vários e referenciar por um índice.
- Registrar o sitemap no `robots.txt` (§1.1) e **submeter no Google Search Console**.

**O que incluir vs. excluir:**

| Incluir no sitemap | Excluir do sitemap |
|---|---|
| URLs canônicas, `200`, indexáveis | URLs com `noindex` |
| Conteúdo publicado que deve rankear | URLs bloqueadas por robots.txt |
| — | Não-canônicas (que apontam canonical pra outra) |
| — | Redirects (`301`/`302`), `404`/`410`, parâmetros de tracking |

**MUST — i18n no sitemap**
- Em site multilíngue, cada URL lista suas alternativas por idioma com `xhtml:link rel="alternate" hreflang="..."`, **recíprocas** e com `x-default`. hreflang e multi-domínio em `internacional-multidominio.md`.

**VETADO**
- Sitemap com URL `noindex`, redirecionada ou `404` (sinal contraditório — a URL do sitemap "quer" indexar, a página diz o contrário).
- Sitemap estático mantido à mão que dessincroniza do site (`anti-padroes.md`).

---

## 11. Além do Google — e os limites das ferramentas

- **`robots.txt` é padrão (RFC 9309)**, não convenção de um buscador: sintaxe, precedência do grupo
  mais específico e o fato de que **bloquear ≠ remover do índice** valem para todos. O que **não** é
  padronizado (`Crawl-delay`, wildcard em alguns crawlers) precisa ser verificado por bot.
- **Bing/IndexNow:** o **IndexNow** notifica Bing, Yandex e parceiros quando uma URL **muda** — é
  barato (um `POST` com a chave hospedada no domínio) e vale para site com publicação frequente.
  **Não** é canal do Google, e **não** substitui sitemap: é *push* de mudança, não inventário.
- **Google Indexing API** só é sancionada pelo Google para **`JobPosting`** e **vídeo ao vivo
  (`BroadcastEvent`)** — usá-la para conteúdo comum é uso fora da política, com risco de ação
  manual; para o resto, o caminho é sitemap + link interno.
- **Sitemap de imagem e de vídeo** (extensões `image:`/`video:`) são o que faz mídia entrar na busca
  vertical; num site com catálogo visual, é a diferença entre aparecer e não aparecer em
  Imagens/Vídeo.
- **O GSC guarda 16 meses de dados de desempenho — e só.** Comparação ano a ano **morre** aos 16
  meses; se a medição da casa depende de série histórica (e ela depende — `medicao.md`), **exporte
  mensalmente** para armazenamento próprio. Descobrir isso no dia em que você precisa do dado de 18
  meses atrás é descobrir tarde demais.

## Checklist técnico (pré-publicação / auditoria)

Rode por propriedade (`.net`, `.org`, `.me`, `.com.br`) — cada uma é independente e self-canonical.

**Crawl & índice**
- [ ] `robots.txt` existe na raiz, responde `200`, sintaxe válida, com `Sitemap:` absoluto
- [ ] robots.txt **não** bloqueia CSS/JS nem páginas que devem rankear
- [ ] Staging/preview bloqueado ou atrás de auth (sem `Disallow: /` vazado em prod)
- [ ] Páginas que devem rankear: rastreáveis, indexáveis, sem `noindex` acidental
- [ ] Páginas que não devem rankear: `noindex` (rastreável) **ou** `Disallow` — nunca os dois juntos esperando remoção

**Status & redirects**
- [ ] Uma versão canônica do host; HTTP→HTTPS, www/apex e trailing-slash convergem por `301`
- [ ] Sem cadeia (`A→B→C`) nem loop de redirect
- [ ] Conteúdo removido responde `404`/`410`; zero soft-404; `301` só pra destino equivalente
- [ ] Sem `5xx` recorrente

**Canonical**
- [ ] Toda página indexável com `<link rel=canonical>` self-referente, URL absoluta, sem tracking
- [ ] **Zero canonical cruzado** entre os domínios da casa (piso)
- [ ] Nenhum canonical aponta pra `404`/`noindex`/redirect

**HTTPS**
- [ ] Site 100% HTTPS, HSTS ativo, sem mixed content, certificado válido/auto-renovado

**Render / JS SEO**
- [ ] Conteúdo, H1, links internos e JSON-LD presentes no HTML **servido** (SSR/SSG)
- [ ] Página legível com JS desabilitado / "Inspeção de URL" do GSC mostra o conteúdo
- [ ] Links de navegação são `<a href>` reais, não `onClick` só-JS

**Core Web Vitals (campo, p75)**
- [ ] As três métricas no **verde**, medidas em **campo** (CrUX/GSC), no p75 — senão, tarefa no
      `schematize-web`. **Os números estão no anexo volátil da `schematize-web`**
      (`references/stack-versoes.md`, seção "Core Web Vitals", com data de verificação): repeti-los
      aqui recriaria a segunda fonte que esta skill acabou de eliminar — e seria a fonte sem data,
      a que apodrece primeiro.

**Snippet e exibição**
- [ ] A política de snippet foi **decidida por tipo de página** (`max-snippet`, `max-image-preview`,
      `data-nosnippet` no bloco pago) — e não herdada do default sem ninguém olhar.
- [ ] Nenhuma tentativa de tirar página do índice via `robots.txt` (bloqueado = `noindex` nunca lido).

**Mobile-first**
- [ ] Conteúdo/links/metadados/JSON-LD idênticos no mobile; viewport correta

**Arquitetura & internal linking**
- [ ] Profundidade ≤ 3 cliques até qualquer página importante
- [ ] Silos hub-spoke coerentes; breadcrumb visual + `BreadcrumbList`
- [ ] Âncoras descritivas; **zero orphan pages**; links pro `.net` onde há conversão

**Sitemaps**
- [ ] Sitemap gerado (não à mão), só URLs canônicas/`200`/indexáveis
- [ ] `<loc>` absoluto canônico, `<lastmod>` real, index acima de 50k URLs/50 MB
- [ ] Registrado no robots.txt e submetido no GSC; `hreflang`+`x-default` se multilíngue

---

**References irmãos:** `fundamentos.md` (como busca/IA rankeiam, o funil), `on-page.md` (title/meta/H1/URL/semântica), `keywords-conteudo.md` (intenção, topic clusters, anti-canibalização), `dados-estruturados.md` (schema.org/JSON-LD), `internacional-multidominio.md` (hreflang, self-canonical por propriedade, links que importam), `aio-llmo-geo.md` (descoberta por IA), `medicao.md` (GSC, logs, KPIs) e `anti-padroes.md` (black-hat + erros comuns). Implementação de frontend: **`schematize-web`**.
