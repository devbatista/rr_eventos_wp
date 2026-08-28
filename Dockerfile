# Serve a página de manutenção e nada mais.
#
# A imagem oficial do Nginx roda `envsubst` sobre /etc/nginx/templates/*.template
# na subida e escreve o resultado em /etc/nginx/conf.d. É por ali que a porta do
# Railway entra na configuração — ele injeta PORT e espera que o processo escute
# nela, e um `listen 80` fixo faria o healthcheck falhar.
FROM nginx:1.27-alpine

# Vale para rodar local, onde ninguém define PORT. No Railway a variável do
# ambiente sobrescreve esta.
ENV PORT=80

COPY nginx.conf.template /etc/nginx/templates/default.conf.template
COPY index.html styles.css script.js /usr/share/nginx/html/
COPY assets/ /usr/share/nginx/html/assets/
