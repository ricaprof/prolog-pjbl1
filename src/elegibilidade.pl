% CAMADA 2: geradores positivos instanciam aluno/disciplina antes de \+.
prerequisitos_ok(Aluno, Disciplina) :-
    aluno(Aluno),
    disciplina(Disciplina, _, _, _),
    forall(prerequisito(Disciplina, Pre), cursou(Aluno, Pre)).

pode_cursar(Aluno, Disciplina) :-
    prerequisitos_ok(Aluno, Disciplina),
    \+ cursou(Aluno, Disciplina).

disciplinas_liberadas(Aluno, Lista) :-
    aluno(Aluno),
    findall(D, pode_cursar(Aluno, D), Bruta),
    sort(Bruta, Lista).

disciplinas_pendentes(Aluno, Lista) :-
    aluno(Aluno),
    findall(D, (disciplina(D, obrigatoria, _, _), \+ cursou(Aluno, D)), Bruta),
    sort(Bruta, Lista).

historico(Aluno, Lista) :-
    aluno(Aluno),
    findall(D, cursou(Aluno, D), Bruta),
    sort(Bruta, Lista).

creditos_cursados(Aluno, Total) :-
    historico(Aluno, Lista),
    creditos_lista(Lista, Total).

% Auxiliares escritos aqui: nenhuma dependencia de bibliotecas de listas.
pertence(X, [X|_]).
pertence(X, [_|Cauda]) :- pertence(X, Cauda).

concatena([], Lista, Lista).
concatena([X|Xs], Ys, [X|Zs]) :- concatena(Xs, Ys, Zs).

creditos_lista([], 0).
creditos_lista([D|Ds], Total) :-
    disciplina(D, _, Creditos, _),
    creditos_lista(Ds, Parcial),
    Total is Creditos + Parcial.

retira_lista([], _, []).
retira_lista([D|Ds], Remover, Resultado) :-
    ( pertence(D, Remover) -> Resultado = Resto
    ; Resultado = [D|Resto]
    ),
    retira_lista(Ds, Remover, Resto).
