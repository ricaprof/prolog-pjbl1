% Executar em um PROCESSO SEPARADO; nao carregar junto dos testes normais.
:- ensure_loaded('../src/main.pl').
:- multifile prerequisito/2.

% Fecha: algoritmos1 -> compiladores -> analise_algoritmos
%        -> estrutura_dados -> algoritmos2 -> algoritmos1.
prerequisito(algoritmos1, compiladores).

executar_teste_ciclo :-
    existe_ciclo(algoritmos1),
    existe_ciclo(compiladores),
    \+ existe_ciclo(tcc2),
    findall(D-P, prerequisito_transitivo(D, P), Pares),
    length(Pares, N), N > 0,
    \+ base_valida,
    \+ trilha_valida(diego, 12, _),
    writeln('OK: ciclo detectado, fecho finito e planejamento recusado.').
