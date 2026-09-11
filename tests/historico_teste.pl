% Demonstra mudanca REAL do historico em processo isolado, sem assert/retract.
:- ensure_loaded('../src/main.pl').
:- multifile cursou/2.
cursou(diego, algoritmos1).

executar_teste_historico :-
    prerequisitos_ok(diego, algoritmos1),
    \+ pode_cursar(diego, algoritmos1),
    pode_cursar(diego, algoritmos2),
    creditos_cursados(diego, 4),
    writeln('OK: incluir cursou(diego, algoritmos1) muda a elegibilidade.').
