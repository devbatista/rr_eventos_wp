// Página de manutenção da Ruby Rose Eventos.
//
// Verifica sozinha se o site voltou e recarrega quando voltar. É o que sustenta
// a promessa do texto: quem está esperando não precisa ficar apertando F5 sem
// saber se adianta.
//
// Sem JavaScript a página continua legível — o HTML já diz o que está
// acontecendo, e nada aqui é necessário para entender a mensagem.

(function () {
  'use strict';

  // Intervalo entre verificações. Um minuto é curto o bastante para quem está
  // esperando na frente da tela e longo o bastante para não martelar o servidor
  // que ainda está subindo.
  var INTERVALO_MS = 60 * 1000;

  // A verificação sai desta página e vai para a raiz do site, que é onde o
  // servidor volta a responder quando a manutenção termina.
  var ALVO = '/';

  var doc = document;
  var verificando = false;

  // ---------------------------------------------------------------------
  // Rodapé
  // ---------------------------------------------------------------------

  var ano = doc.getElementById('ano');
  if (ano) {
    ano.textContent = String(new Date().getFullYear());
  }

  // ---------------------------------------------------------------------
  // Verificação de retorno
  // ---------------------------------------------------------------------

  // Só roda com a aba visível. Numa aba de fundo esquecida ela bateria no
  // servidor a noite toda sem ninguém para ver o resultado.
  setInterval(function () {
    if (!doc.hidden) {
      verificar();
    }
  }, INTERVALO_MS);

  // Voltar para a aba é o momento em que a pessoa quer saber: verifica na hora,
  // em vez de esperar o próximo ciclo.
  doc.addEventListener('visibilitychange', function () {
    if (!doc.hidden) {
      verificar();
    }
  });

  // Pergunta ao servidor se o site voltou e recarrega se voltou. Falha em
  // silêncio: a página não tem o que dizer sobre uma tentativa que ninguém
  // pediu, e o texto já explica a situação.
  function verificar() {
    if (verificando) {
      return;
    }
    verificando = true;

    // O parâmetro derruba o cache do navegador e o de qualquer proxy no
    // caminho: sem ele a resposta de manutenção guardada mais cedo responderia
    // por todas as verificações seguintes, e a página nunca perceberia a volta.
    var url = ALVO + (ALVO.indexOf('?') === -1 ? '?' : '&') + '_probe=' + Date.now();

    fetch(url, { method: 'HEAD', cache: 'no-store' })
      .then(function (resposta) {
        // 503 é o que o servidor devolve enquanto a manutenção está de pé.
        // Qualquer resposta boa significa que ele voltou.
        if (resposta.ok) {
          location.replace(ALVO);
          return;
        }
        verificando = false;
      })
      .catch(function () {
        // Rede fora, servidor sem resposta, CORS: de qualquer forma o site
        // ainda não está de pé para quem está olhando.
        verificando = false;
      });
  }
})();
