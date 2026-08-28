# Serve a página de manutenção e nada mais.
#
# A imagem oficial do Nginx roda `envsubst` sobre /etc/nginx/templates/*.template
# na subida e escreve o resultado em /etc/nginx/conf.d. É por ali que a porta do
# Railway entra na configuração — ele injeta PORT e espera que o processo escute
# nela, e um `listen 80` fixo faria o healthcheck falhar.
FROM nginx:1.27-alpine

# Vale para rodar local, onde ninguém define PORT. Se o ambiente definir a
# variável, ela sobrescreve esta.
ENV PORT=80

# O Railway descobre para qual porta encaminhar lendo o `EXPOSE` da imagem,
# quando não existe variável `PORT` no serviço — e neste não existe. Sem esta
# linha o Nginx sobe normalmente, o serviço aparece "Online", e mesmo assim o
# domínio devolve 502 com `x-railway-fallback: true`: o edge não tem para onde
# mandar a requisição. Foi exatamente o que aconteceu no primeiro deploy.
EXPOSE 80

COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY index.html styles.css script.js /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/
