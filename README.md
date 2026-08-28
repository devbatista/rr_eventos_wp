# RR Eventos — página de manutenção

Página estática que responde no lugar de https://eventos.rubyrosemaquiagem.com.br/
enquanto o site está fora do ar.

O ambiente Docker do WordPress que vivia neste repositório foi removido; o
histórico do Git ainda o tem, se algum dia precisar.

## Arquivos

```txt
index.html                 o conteúdo
styles.css                 identidade visual da Ruby Rose
script.js                  verifica sozinho se o site voltou e recarrega
beauty-fair-example.html   página da Beauty Fair 2026, para aprovação
assets/                    logotipo, favicon, fontes e os banners
Dockerfile                 Nginx servindo o diretório
nginx.conf                 configuração do Nginx
```

O `beauty-fair-example.html` é um arquivo só: o CSS e o JS estão dentro dele,
inclusive o widget de credenciamento que roda no Elementor. Ele não faz parte
da manutenção — responde 200 num caminho próprio, ao lado dela.

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

Para testar do jeito que vai para o ar, com o 503 e tudo:

```sh
docker build -t rr-manutencao . && docker run --rm -p 8080:80 rr-manutencao
```

A manutenção fica em `http://localhost:8080/` e a página da Beauty Fair em
`http://localhost:8080/beauty-fair-example.html`.

## O 503

A página responde **503 Service Unavailable**, e não 200. São dois motivos:

- o buscador não indexa a página de manutenção no lugar do site;
- o `script.js` usa o status para saber se o site voltou. Com 200 na raiz ele
  concluiria que já voltou e recarregaria em cima de si mesmo, sem parar.

Os arquivos da própria página (`styles.css`, `script.js`, `assets/`) continuam
respondendo 200.

O `beauty-fair-example.html` também, num `location` próprio no `nginx.conf`.
Como enquanto a manutenção está de pé ela é a única página do domínio que
responde 200, o Nginx devolve `X-Robots-Tag: noindex, nofollow` junto — senão
ela viraria a candidata natural do buscador para representar o site inteiro.

## Identidade visual

As cores e fontes saem de `app/assets/stylesheets/_brand.scss`, no repositório
`rubyrose_eventos`, transcritas para custom properties no topo do `styles.css`
porque esta página é estática e não passa pelo Sass. Se a marca mudar lá, é no
`:root` que ela muda aqui.
