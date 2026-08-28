# Serve a página da Beauty Fair, que é a raiz do site, e guarda a página de
# manutenção ao lado dela para quando precisar voltar ao ar.
FROM nginx:1.27-alpine

# O Railway descobre para qual porta encaminhar lendo o `EXPOSE` da imagem,
# quando não existe variável `PORT` no serviço — e neste não existe.
EXPOSE 80

# Direto em conf.d, e não em templates/: sem `${PORT}` para resolver, não há o
# que o envsubst faça aqui. Vale lembrar por que isso importa — o script que
# habilita IPv6 na imagem roda *antes* do envsubst e edita este mesmo arquivo,
# então um template sobrescreveria o trabalho dele e derrubaria o roteamento.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# A página da Beauty Fair é um arquivo só: o CSS e o JS dela moram dentro do
# próprio HTML, então não há um par de arquivos para copiar junto.
COPY index.html /usr/share/nginx/html/

# A manutenção, dormente. Estes três andam juntos — o HTML dela é o único que
# usa o styles.css e o script.js, e sem eles a página voltaria sem estilo e sem
# a verificação que recarrega sozinha quando o site sobe.
COPY index-manut.html styles.css script.js /usr/share/nginx/html/

COPY assets/ /usr/share/nginx/html/assets/
