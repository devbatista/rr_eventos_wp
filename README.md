# RR Eventos WordPress

Ambiente Docker com WordPress, MySQL, PHP-FPM, Nginx e Supervisor.

## Imagem WordPress

O servico `wordpress` usa o [Dockerfile](/Users/devbatista/dev/wp/rr_eventos/Dockerfile) local, baseado em `php:8.2-fpm-alpine`.

Essa imagem instala Nginx e Supervisor no mesmo container da aplicacao.

## Subir o ambiente

```sh
docker compose up -d
```

Depois acesse:

```txt
http://localhost:8080
```

## Parar o ambiente

```sh
docker compose down
```

## Dados persistentes

Os dados ficam nos volumes Docker:

- `rr_eventos_mysql_data`: banco MySQL
- `rr_eventos_wordpress`: arquivos do WordPress

Para remover tudo, incluindo dados:

```sh
docker compose down -v
```

## Configuracao

As credenciais ficam no arquivo `.env`. Para uso fora de desenvolvimento local, troque as senhas antes de subir o ambiente.
