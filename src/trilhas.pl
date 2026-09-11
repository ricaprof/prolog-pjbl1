% CAMADA 3: fecho transitivo finito mesmo com ciclos.
% O par publico e enumerado uma vez; once evita repetir ancestrais quando
% ha dois caminhos distintos. O backtracking EXTERNO continua disponivel.
prerequisito_transitivo(Disciplina, Ancestral) :-
    disciplina(Disciplina, _, _, _),
    disciplina(Ancestral, _, _, _),
    once(caminho_pre(Disciplina, Ancestral, [Disciplina])).

% Testar a aresta direta antes de bloquear visitados permite fechar um ciclo.
caminho_pre(D, A, _) :- prerequisito(D, A).
caminho_pre(D, A, Visitados) :-
    prerequisito(D, Proximo),
    \+ pertence(Proximo, Visitados),
    caminho_pre(Proximo, A, [Proximo|Visitados]).

existe_ciclo(Disciplina) :-
    prerequisito_transitivo(Disciplina, Disciplina).

limite_semestres(12).

% Validacao anterior a busca: referencias, tipos, unicidade e ciclos.
base_valida :-
    findall(D, disciplina(D, _, _, _), Ds),
    Ds = [_|_], sort(Ds, Unicos), length(Ds, N), length(Unicos, N),
    forall(disciplina(D, Tipo, C, S),
           (atom(D), pertence(Tipo, [obrigatoria,eletiva]),
            integer(C), C > 0, integer(S), S > 0)),
    findall(A, aluno(A), As),
    sort(As, Au), length(As, Na), length(Au, Na),
    forall(aluno(A), atom(A)),
    forall(prerequisito(D, P),
           (ground(D-P), disciplina(D, _, _, _), disciplina(P, _, _, _))),
    forall(cursou(A, D),
           (ground(A-D), aluno(A), disciplina(D, _, _, _))),
    \+ existe_ciclo(_).

historico_consistente(Aluno) :-
    aluno(Aluno),
    forall(cursou(Aluno, D),
           forall(prerequisito_transitivo(D, P), cursou(Aluno, P))).

trilha_valida(Aluno, MaxCreditosPorSemestre, Trilha) :-
    limite_semestres(Limite),
    trilha_valida_limite(Aluno, MaxCreditosPorSemestre, Limite, Trilha).

% Extensao: aceita limite menor, nunca maior que a seguranca global (12).
trilha_valida_limite(Aluno, Max, Limite, Trilha) :-
    integer(Max), Max > 0,
    integer(Limite), Limite >= 0,
    limite_semestres(Teto), Limite =< Teto,
    ( var(Trilha) ; is_list(Trilha) ),
    base_valida,
    aluno(Aluno), historico_consistente(Aluno),
    historico(Aluno, Cursadas),
    disciplinas_pendentes(Aluno, Obrigatorias),
    % Inclui eventuais eletivas que sejam ancestrais de obrigatorias.
    findall(P, (pertence(D, Obrigatorias), prerequisito_transitivo(D, P),
                \+ pertence(P, Cursadas)), PreRequisitos),
    concatena(Obrigatorias, PreRequisitos, Todas),
    sort(Todas, Pendentes),
    planejar(Pendentes, Cursadas, Max, Limite, Trilha).

planejar([], _, _, _, []).
planejar([D|Ds], Cursadas, Max, Restantes, [Semestre|Trilha]) :-
    Restantes > 0,
    Pendentes = [D|Ds],
    % Podas necessarias, nao heuristicas que descartem solucoes validas.
    creditos_lista(Pendentes, Total), Total =< Max * Restantes,
    forall(pertence(P, Pendentes), (disciplina(P, _, C, _), C =< Max)),
    findall(P, (pertence(P, Pendentes), liberada_no_estado(P, Cursadas)), Liberadas),
    subconjunto_creditos(Liberadas, Max, Semestre),
    Semestre = [_|_],
    retira_lista(Pendentes, Semestre, NovasPendentes),
    concatena(Semestre, Cursadas, NovasCursadas),
    Proximo is Restantes - 1,
    planejar(NovasPendentes, NovasCursadas, Max, Proximo, Trilha).

liberada_no_estado(D, Cursadas) :-
    forall(prerequisito_transitivo(D, Pre), pertence(Pre, Cursadas)).

% Inclui primeiro, exclui depois: enumera TODOS os subconjuntos admissiveis.
% A ordem alfabetica da entrada impede permutacoes redundantes no semestre.
subconjunto_creditos([], _, []).
subconjunto_creditos([D|Ds], Restante, [D|Escolhidas]) :-
    disciplina(D, _, Creditos, _),
    Creditos =< Restante,
    NovoRestante is Restante - Creditos,
    subconjunto_creditos(Ds, NovoRestante, Escolhidas).
subconjunto_creditos([_|Ds], Restante, Escolhidas) :-
    subconjunto_creditos(Ds, Restante, Escolhidas).
