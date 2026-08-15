# schematize-seo

> Padrões normativos de **SEO** da casa — a disciplina inteira, do técnico ao conteúdo, pra rankear em busca **e** em respostas de IA. Técnico, on-page, keywords/conteúdo, dados estruturados, **internacional/multi-domínio sem canibalizar**, AIO/LLMO/GEO, autoridade/E-E-A-T e medição.

Pacote de **skill normativa para [Claude Code](https://claude.com/claude-code)**.
Parte do catálogo **schematize skills**.

> **Co-autoria / patrocínio:** [**Hextorn**](https://hextorn.com) — parceira de SEO da casa.

## Instalar

### Pelo app schematize (recomendado)

```bash
schematize install seo      # requer o CLI schematize instalado
```

### Última versão (a partir de um clone)

```bash
git clone https://github.com/schematizeme/skill-seo.git
cd skill-seo && ./install.sh            # instala no projeto atual
# ./install.sh /caminho/do/projeto        # ou aponte para outro projeto
```

Ou baixe o `.zip` da última release e descompacte em `.claude/skills/`:

```bash
curl -L -o skill-seo.zip \
  https://github.com/schematizeme/skill-seo/releases/latest/download/skill-seo.zip
unzip skill-seo.zip -d .claude/skills/
```

## O que tem dentro

- **SKILL.md** — o contrato: 10 pisos inegociáveis (zero black-hat, uma intenção por
  URL, self-canonical, **nunca canonical cruzado entre os domínios da casa**, hreflang
  recíproco, indexabilidade intencional, title/meta/H1 únicos, dados estruturados
  válidos, performance/a11y como SEO, medir antes/depois) + mapa de references.
- **references/** — `fundamentos`, `tecnico`, `on-page`, `keywords-conteudo`,
  `dados-estruturados`, `internacional-multidominio`, `aio-llmo-geo`, `autoridade-eeat`,
  `medicao`, `anti-padroes`, `checklist-lp`.
- **assets/commands/** — `/seo-help`, `/seo-audit`, `/seo-plan`, `/seo-keywords`, `/seo-review`.

## Relação com as outras skills

A **implementação** de frontend (metadata/sitemap/robots no App Router, Core Web Vitals
na prática, a11y, i18n com URL por idioma, deploy) é escopo do **schematize-web** — esta
skill define a **disciplina** de SEO; o web executa. Backend delega ao **schematize-engineering**.

MIT.
