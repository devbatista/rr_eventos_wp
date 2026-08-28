# RR Eventos — página de manutenção

Página estática que responde no lugar de https://eventos.rubyrosemaquiagem.com.br/
enquanto o site está fora do ar.

O ambiente Docker do WordPress que vivia neste repositório foi removido; o
histórico do Git ainda o tem, se algum dia precisar.

## Arquivos

```txt
index.html          o conteúdo
styles.css          identidade visual da Ruby Rose
script.js           verifica sozinho se o site voltou e recarrega
assets/             logotipo, favicon e as fontes da marca
Dockerfile          Nginx servindo o diretório
nginx.conf.template configuração — a porta vem do ambiente
```

## Ver local

Qualquer servidor estático serve para conferir o visual:

```sh
python3 -m http.server 4173
```

Para testar do jeito que vai para o ar, com o 503 e tudo:

```sh
docker build -t rr-manutencao . && docker run --rm -p 8080:80 rr-manutencao
```

## O 503

A página responde **503 Service Unavailable**, e não 200. São dois motivos:

- o buscador não indexa a página de manutenção no lugar do site;
- o `script.js` usa o status para saber se o site voltou. Com 200 na raiz ele
  concluiria que já voltou e recarregaria em cima de si mesmo, sem parar.

Os arquivos da própria página (`styles.css`, `script.js`, `assets/`) continuam
respondendo 200.

## Identidade visual

As cores e fontes saem de `app/assets/stylesheets/_brand.scss`, no repositório
`rubyrose_eventos`, transcritas para custom properties no topo do `styles.css`
porque esta página é estática e não passa pelo Sass. Se a marca mudar lá, é no
`:root` que ela muda aqui.
