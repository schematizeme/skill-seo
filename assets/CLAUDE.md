# CLAUDE.md — SEO da Casa (sempre on)

> Copie para a **raiz do repositório** do site e ajuste `<domínio>`. Fica pinado no contexto de
> toda tarefa e garante o piso mesmo quando a skill `schematize-seo` não dispara sozinha. Em repo
> multi-skill, use **junto** com o `CLAUDE.md` da `schematize-web` (rode `/seo-claude`, que mescla
> sem sobrescrever os outros blocos).

## Regra mestre

Toda página publicada neste repo é uma **aposta de descoberta**: alguém vai (ou não vai) encontrá-la
na busca e na resposta de IA. A skill `schematize-seo` rege como essa aposta é feita. Em conflito
entre "publica logo" e estes pisos, **os pisos vencem** — porque o custo de errar aqui não aparece
no deploy, aparece três meses depois, num gráfico que ninguém sabe explicar.

## Pisos inegociáveis (VETADO — sem exceção)

1. **Nunca black-hat.** Cloaking (servir ao crawler algo diferente do que o usuário vê), texto
   oculto, doorway page, link comprado sem `rel="sponsored"`, conteúdo em massa sem valor. Não é
   questão de ética abstrata: **queima o domínio**, e domínio queimado leva meses para voltar — se
   voltar. Vale igual para conteúdo gerado por IA.
2. **Toda página indexável é self-canonical, com UMA intenção.** O canônico de uma página é **ela
   mesma**, na URL limpa. Duas páginas disputando a mesma intenção é **canibalização**: as duas
   perdem.
3. **NUNCA canonical cruzando os domínios da casa.** Apontar o canônico de um domínio para outro
   **entrega o ranking do primeiro ao segundo**, e é irreversível na prática. A estratégia
   multi-domínio é **conteúdo distinto por domínio**, com `hreflang` recíproco — nunca canônico
   cruzado.
4. **`hreflang` recíproco, com `x-default`.** A aponta B **e** B aponta A. Unilateral é ignorado.
5. **Nada de fato datado no corpo normativo do site sem data.** Estado de produto do Google muda
   (rich result some, relatório é desativado): o que tem prazo vive no anexo, com data de
   verificação.
6. **Medir antes e depois.** Mudança de SEO sem baseline não é otimização, é opinião. GSC + campo
   (CrUX), não só Lighthouse.

## O que já morreu (não marque, e remova se estiver marcado)

`FAQPage`, `HowTo` e o **sitelinks searchbox** (`SearchAction`) saíram da galeria de rich results.
O **conteúdo** (Q&A, passo a passo, busca interna) continua valendo — pelo usuário e pela citação
por IA. O que sai é a marcação e a expectativa. Confira a galeria antes de prescrever um tipo novo:
ela **encolhe**, e o que encolheu não avisa quem já tinha escrito.

## Fronteiras

- **`schematize-web`** — a **implementação**: onde o `metadata`/`<head>` é gerado, como o JSON-LD
  entra na página, como o `sitemap.xml` é **autogerado** (nunca à mão), roteamento por idioma, e os
  thresholds de Core Web Vitals (que vivem no anexo volátil **dela**, não aqui).
- **`schematize-institutional`** — **quais páginas existem** num site de empresa e o que cada uma
  prova, incluindo as páginas legais.

**Regra prática:** *"o que a página deve dizer e por quê" é SEO; "onde o atributo é escrito" é web;
"quais páginas existem" é institutional.*

## Definition of Done (SEO)

Nada é "publicado" sem: **uma intenção** declarada e sem canibalização com página existente;
`title`/`description`/`H1` únicos e verdadeiros; **self-canonical**; `hreflang` recíproco quando
multilíngue; dados estruturados **válidos** e sem tipo morto; conteúdo **citável** (resposta direta
perto do topo, no HTML servido); CWV no verde na página que importa; e **baseline registrado** para
comparar depois.
