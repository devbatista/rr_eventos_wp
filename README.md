# RR Eventos — https://eventos.rubyrosemaquiagem.com.br/

Site estático servido por Nginx. A raiz é a página da **Beauty Fair 2026**, com o
formulário de credenciamento; a página de manutenção continua no repositório,
dormente, para quando o site precisar sair do ar de novo.

O ambiente Docker do WordPress que vivia neste repositório foi removido; o
histórico do Git ainda o tem, se algum dia precisar.

## Arquivos

```txt
index.html         a página da Beauty Fair 2026 — a raiz do site
index-manut.html   a página de manutenção, dormente
styles.css         identidade visual — usada só pela manutenção
script.js          verifica se o site voltou — usado só pela manutenção
assets/            logotipo, sacola, favicon, fontes e os banners
Dockerfile         Nginx servindo o diretório
nginx.conf         configuração do Nginx
```

O `index.html` é um arquivo só: o CSS e o JS estão dentro dele, inclusive o
widget de credenciamento que também roda no Elementor. Ele não usa o
`styles.css` nem o `script.js` — esses dois pertencem à manutenção e andam com
ela.

## Voltar a página de manutenção

O `nginx.conf` traz, no rodapé e comentado, o bloco que faz o domínio inteiro
responder 503 com o `index-manut.html`. É substituir o `location /` por ele.

Junto vão os três detalhes que custaram a ser descobertos — por que o status
tem de ser 503 e não 200, por que o `styles.css` e o `script.js` precisam de
`location` próprio, e por que o corpo do erro sai de um `location` nomeado.
Vale ler antes de mexer.

## IPv6

O `nginx.conf` tem `listen 80` **e** `listen [::]:80`. A segunda linha não é
enfeite: o Railway alcança o container por IPv6, e sem ela o container sobe, o
serviço aparece "Online" e todo domínio devolve 502 com `x-railway-fallback`.

Por isso também a configuração é copiada direto para `conf.d/`, e não para
`templates/`. O script `10-listen-on-ipv6-by-default.sh` da imagem roda *antes*
do `20-envsubst-on-templates.sh`: um template sobrescreveria o arquivo que ele
acabou de corrigir, que foi exatamente como esse 502 apareceu.

## Ver local

Qualquer servidor estático serve para conferir o visual:

```sh
python3 -m http.server 4173
```

Para testar do jeito que vai para o ar:

```sh
docker build -t rr-site . && docker run --rm -p 8080:80 rr-site
```

A Beauty Fair fica em `http://localhost:8080/` e a manutenção em
`http://localhost:8080/index-manut.html`.

## O formulário

O widget dentro do `index.html` fala com a API em `rubyroseeventos-production-…`
para buscar as datas do evento e gravar o credenciamento. Sendo outra origem, o
domínio da página precisa constar em `CORS_ORIGINS` na aplicação Rails —
`https://eventos.rubyrosemaquiagem.com.br` já consta.

O `localhost` **não** consta, e é por isso que ao abrir a página local o campo
de data mostra "Datas indisponíveis" com um erro de rede. Em produção funciona.

## Indexação

O `index.html` ainda traz `<meta name="robots" content="noindex, nofollow">`, de
quando ele era uma página de aprovação. Agora que é a raiz do site, é essa linha
que decide se o Google indexa a página — retire-a quando quiser que ele indexe.

## Identidade visual

As cores e fontes saem de `app/assets/stylesheets/_brand.scss`, no repositório
`rubyrose_eventos`. Estão transcritas para custom properties no `:root` de cada
arquivo, porque estas páginas são estáticas e não passam pelo Sass.

O rosa diverge entre as duas de propósito: a manutenção usa o `#f03a77` do
manual e a Beauty Fair usa o `#e95374`, que é o do widget de credenciamento
exibido dentro dela.
