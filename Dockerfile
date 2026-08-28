# Serve a página de manutenção e a página de exemplo da Beauty Fair.
FROM nginx:1.27-alpine

# O Railway descobre para qual porta encaminhar lendo o `EXPOSE` da imagem,
# quando não existe variável `PORT` no serviço — e neste não existe.
EXPOSE 80

# Direto em conf.d, e não em templates/: sem `${PORT}` para resolver, não há o
# que o envsubst faça aqui. Vale lembrar por que isso importa — o script que
# habilita IPv6 na imagem roda *antes* do envsubst e edita este mesmo arquivo,
# então um template sobrescreveria o trabalho dele e derrubaria o roteamento.
COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY index.html styles.css script.js /usr/share/nginx/html/

# A página de exemplo é um arquivo só — o CSS e o JS dela moram dentro do
# próprio HTML, então não há mais nada para copiar junto além dos assets.
COPY beauty-fair-example.html /usr/share/nginx/html/

COPY assets/ /usr/share/nginx/html/assets/
