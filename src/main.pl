% Ponto unico de entrada. multifile permite a fixture de ciclo separada.
:- multifile prerequisito/2.
:- multifile cursou/2.
:- ensure_loaded('curriculum.pl').
:- ensure_loaded('elegibilidade.pl').
:- ensure_loaded('trilhas.pl').

demo :-
    writeln('GRADE DIDATICA - Curriculum Advisor'),
    findall(D, disciplina(D, _, _, 1), Semestre1),
    format('Disciplinas do semestre sugerido 1: ~q~n', [Semestre1]),
    forall(aluno(A), demo_aluno(A)),
    findall(P, prerequisito_transitivo(tcc2, P), Ancestrais),
    format('Ancestrais de tcc2: ~q~n', [Ancestrais]),
    once(trilha_valida(diego, 12, Trilha)),
    writeln('Uma trilha do zero, maximo de 12 creditos por semestre:'),
    mostrar_trilha(Trilha, 1),
    findall(T, trilha_valida(elisa, 8, T), Trilhas),
    format('Todas as trilhas de Elisa (instancia pequena): ~q~n', [Trilhas]).

demo_aluno(A) :-
    perfil(A, Perfil), creditos_cursados(A, Creditos),
    disciplinas_liberadas(A, Liberadas), disciplinas_pendentes(A, Pendentes),
    format('~n~w (~w), creditos cursados: ~d~n', [A, Perfil, Creditos]),
    format('  Liberadas: ~q~n  Pendentes obrigatorias: ~q~n', [Liberadas, Pendentes]).

mostrar_trilha([], _).
mostrar_trilha([S|Ss], N) :-
    creditos_lista(S, C),
    format('  Semestre ~d (~d creditos): ~q~n', [N, C, S]),
    Proximo is N + 1,
    mostrar_trilha(Ss, Proximo).
