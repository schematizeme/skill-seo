#!/usr/bin/env bash
# Vermelho primeiro do gate check-seo.sh. Cada caso é um mini-site com UM defeito (ou nenhum): o gate
# tem de reprovar o defeito certo (exit 1 + id da regra) e aprovar o site limpo (exit 0, caso verde).
# Sem rede, sem segredo: HTML de mentira montado em diretório temporário.
#
# EXCEÇÃO DECLARADA (piso da schematize-shell, strict mode): harness de teste roda `set -u` sem `-e` —
# precisa continuar depois de um caso vermelho para reportar todos, em vez de parar no primeiro.
set -u
AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
G="$AQUI/check-seo.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "${TMP:?}"' EXIT INT TERM
ok=0; fail=0; D=""; NOME=""

novo() { NOME="$1"; D="$TMP/$1"; mkdir -p "$D"
  printf 'User-agent: *\nDisallow:\nSitemap: https://exemplo.net/sitemap.xml\n' > "$D/robots.txt"
  printf '<?xml version="1.0"?><urlset></urlset>\n' > "$D/sitemap.xml"; }
# pagina <arquivo> <title> <desc> <canonical> [extra no head]
pagina() { mkdir -p "$(dirname "$D/$1")"
  { printf '<!doctype html><html lang="pt-BR"><head>'
    [ -n "$2" ] && printf '<title>%s</title>' "$2"
    [ -n "$3" ] && printf '<meta name="description" content="%s">' "$3"
    [ -n "$4" ] && printf '<link rel="canonical" href="%s">' "$4"
    printf '%s</head><body><h1>%s</h1></body></html>\n' "${5:-}" "${2:-sem}"; } > "$D/$1"; }
esperar() { # exit-esperado agulha
  local esp="$1" agulha="${2:-}" saida rc
  saida="$(bash "$G" "$D" 2>&1)"; rc=$?
  if [ "$rc" != "$esp" ]; then echo "  FALHA $NOME: exit $rc, esperado $esp"; sed 's/^/      /' <<<"$saida"; fail=$((fail+1)); return; fi
  if [ -n "$agulha" ] && ! grep -qF -- "$agulha" <<<"$saida"; then echo "  FALHA $NOME: exit certo, saída sem \"$agulha\""; sed 's/^/      /' <<<"$saida"; fail=$((fail+1)); return; fi
  echo "  ok $NOME"; ok=$((ok+1)); }

# ---- VERDE (esperar 0) -------------------------------------------------------------------------
novo verde-limpo
pagina index.html "Loja de bicicletas" "Compre bicicletas com garantia." "https://exemplo.net/"
pagina sobre/index.html "Sobre a loja" "Quem somos e como trabalhamos." "https://exemplo.net/sobre/"
esperar 0 "check-seo: ok"

novo verde-hreflang-reciproco
H1='<link rel="alternate" hreflang="pt-BR" href="https://exemplo.net/"><link rel="alternate" hreflang="en" href="https://exemplo.net/en/"><link rel="alternate" hreflang="x-default" href="https://exemplo.net/">'
H2='<link rel="alternate" hreflang="pt-BR" href="https://exemplo.net/"><link rel="alternate" hreflang="en" href="https://exemplo.net/en/"><link rel="alternate" hreflang="x-default" href="https://exemplo.net/">'
pagina index.html "Início" "Descrição da home." "https://exemplo.net/" "$H1"
pagina en/index.html "Home" "Home description." "https://exemplo.net/en/" "$H2"
esperar 0 "check-seo: ok"

novo verde-noindex-fora-das-regras
pagina index.html "Início" "Descrição da home." "https://exemplo.net/"
mkdir -p "$D/carrinho"; printf '<html><head><meta name="robots" content="noindex,follow"></head><body>carrinho</body></html>\n' > "$D/carrinho/index.html"
esperar 0 "check-seo: ok"

# ---- VERMELHO (esperar 1 com a regra certa) ----------------------------------------------------
novo vermelho-canonical-cruzado
pagina index.html "Início" "Descrição da home." "https://exemplo.net/"
pagina a/index.html "Outra" "Outra descrição." "https://exemplo.me/a/"
pagina b/index.html "Terceira" "Terceira descrição." "https://exemplo.net/b/"
esperar 1 "canonical-cruzado"

novo vermelho-canonical-ausente
pagina index.html "Início" "Descrição da home." ""
esperar 1 "canonical-ausente"

novo vermelho-canonical-relativa
pagina index.html "Início" "Descrição da home." "/"
esperar 1 "canonical-relativa"

novo vermelho-canonical-com-tracking
pagina index.html "Início" "Descrição da home." "https://exemplo.net/?utm_source=x"
esperar 1 "canonical-parametro"

novo vermelho-title-duplicado
pagina index.html "Mesmo título" "Descrição um." "https://exemplo.net/"
pagina b/index.html "Mesmo título" "Descrição dois." "https://exemplo.net/b/"
esperar 1 "title-duplicado"

novo vermelho-description-duplicada
pagina index.html "Título um" "Mesma descrição." "https://exemplo.net/"
pagina b/index.html "Título dois" "Mesma descrição." "https://exemplo.net/b/"
esperar 1 "description-duplicada"

novo vermelho-sem-title-e-description
pagina index.html "" "" "https://exemplo.net/"
esperar 1 "title-ausente"

novo vermelho-hreflang-sem-reciproco
pagina index.html "Início" "Descrição da home." "https://exemplo.net/" \
  '<link rel="alternate" hreflang="pt-BR" href="https://exemplo.net/"><link rel="alternate" hreflang="en" href="https://exemplo.net/en/"><link rel="alternate" hreflang="x-default" href="https://exemplo.net/">'
pagina en/index.html "Home" "Home description." "https://exemplo.net/en/" \
  '<link rel="alternate" hreflang="en" href="https://exemplo.net/en/"><link rel="alternate" hreflang="x-default" href="https://exemplo.net/en/">'
esperar 1 "hreflang-sem-reciproco"

novo vermelho-hreflang-sem-xdefault
pagina index.html "Início" "Descrição da home." "https://exemplo.net/" \
  '<link rel="alternate" hreflang="pt-BR" href="https://exemplo.net/">'
esperar 1 "hreflang-sem-xdefault"

novo vermelho-robots-bloqueia-tudo
pagina index.html "Início" "Descrição da home." "https://exemplo.net/"
printf 'User-agent: *\nDisallow: /\nSitemap: https://exemplo.net/sitemap.xml\n' > "$D/robots.txt"
esperar 1 "robots-bloqueia-tudo"

novo vermelho-sem-robots-nem-sitemap
pagina index.html "Início" "Descrição da home." "https://exemplo.net/"
rm -f "$D/robots.txt" "$D/sitemap.xml"
esperar 1 "robots-ausente"

# ---- NADA A VERIFICAR (esperar 2): diretório sem HTML não é aprovação ---------------------------
novo vazio
esperar 2 "nada verificado"

echo; echo "check-seo: $ok ok, $fail falha(s)"; [ "$fail" = 0 ]
