% Executor de testes sem plunit e sem bibliotecas externas.
:- ensure_loaded('../src/main.pl').

executar_testes :-
    findall(Nome, (caso(Nome, Objetivo),
        \+ verificar_caso(Nome, Objetivo)), Falhas),
    findall(Nome, caso(Nome, _), Casos), length(Casos, Total),
    length(Falhas, QuantidadeFalhas),
    format('~nTotal: ~d; falhas: ~d~n', [Total, QuantidadeFalhas]),
    ( Falhas = [] -> writeln('Todos os testes passaram.')
    ; format('Falharam: ~q~n', [Falhas]), fail
    ).

verificar_caso(Nome, Objetivo) :-
    ( catch(once(call(Objetivo)), Erro,
            (format('EXCECAO ~w: ~q~n', [Nome, Erro]), fail))
    -> format('OK ~w~n', [Nome])
    ; format('FALHA ~w~n', [Nome]), fail
    ).

caso(base_integra, base_valida).
caso(quantidade_disciplinas,
     (findall(D, disciplina(D, _, _, _), L), length(L, 28))).
caso(quantidade_obrigatorias,
     (findall(D, disciplina(D, obrigatoria, _, _), L), length(L, 24))).
caso(quantidade_eletivas,
     (findall(D, disciplina(D, eletiva, _, _), L), length(L, 4))).
caso(oito_semestres,
     (findall(S, disciplina(_, _, _, S), L), sort(L, [1,2,3,4,5,6,7,8]))).
caso(semestre1,
     findall(D, disciplina(D, _, _, 1),
             [algoritmos1,matematica_discreta,introducao_computacao])).
caso(historicos_coerentes, forall(aluno(A), historico_consistente(A))).
caso(creditos_ana, creditos_cursados(ana, 72)).
caso(creditos_bruno, creditos_cursados(bruno, 36)).
caso(creditos_carla, creditos_cursados(carla, 8)).
caso(creditos_diego, creditos_cursados(diego, 0)).
caso(creditos_elisa, creditos_cursados(elisa, 88)).
caso(creditos_fabio, creditos_cursados(fabio, 96)).
caso(liberadas_ana,
     disciplinas_liberadas(ana,
       [computacao_grafica,etica_computacao,gestao_projetos,mineracao_dados,
        processamento_imagens,robotica,seguranca_computacional,
        sistemas_distribuidos,tcc1])).
caso(liberadas_bruno,
     disciplinas_liberadas(bruno,
       [analise_algoritmos,banco_dados1,computacao_grafica,etica_computacao,
        processamento_imagens,robotica,sistemas_operacionais])).
caso(liberadas_carla,
     disciplinas_liberadas(carla, [algoritmos2,etica_computacao,matematica_discreta])).
caso(liberadas_diego,
     disciplinas_liberadas(diego, [algoritmos1,introducao_computacao,matematica_discreta])).
caso(pendentes_ana,
     disciplinas_pendentes(ana,
       [etica_computacao,gestao_projetos,seguranca_computacional,
        sistemas_distribuidos,tcc1,tcc2])).
caso(pendentes_bruno,
     disciplinas_pendentes(bruno,
       [analise_algoritmos,banco_dados1,banco_dados2,compiladores,
        engenharia_software,etica_computacao,gestao_projetos,
        inteligencia_artificial,projeto_integrador,redes_computadores,
        seguranca_computacional,sistemas_distribuidos,sistemas_operacionais,tcc1,tcc2])).
caso(pendentes_formado, disciplinas_pendentes(fabio, [])).
caso(negacao_decisiva,
     (prerequisitos_ok(diego, algoritmos1), pode_cursar(diego, algoritmos1),
      prerequisitos_ok(carla, algoritmos1), \+ pode_cursar(carla, algoritmos1))).
caso(multiplos_prerequisitos,
     (pode_cursar(bruno, sistemas_operacionais),
      \+ pode_cursar(carla, sistemas_operacionais))).
caso(eletiva_liberada, pode_cursar(bruno, computacao_grafica)).
caso(variaveis_enumeram,
     (findall(A, pode_cursar(A, algoritmos1), [diego]),
      findall(A-L, disciplinas_pendentes(A, L), Pares), length(Pares, 6))).
caso(aluno_inexistente,
     (\+ pode_cursar(desconhecido, algoritmos1),
      \+ disciplinas_liberadas(desconhecido, _),
      \+ disciplinas_pendentes(desconhecido, _),
      \+ creditos_cursados(desconhecido, _),
      \+ trilha_valida(desconhecido, 12, _))).
caso(disciplina_inexistente,
     (\+ pode_cursar(ana, desconhecida),
      \+ prerequisitos_ok(ana, desconhecida),
      \+ prerequisito_transitivo(desconhecida, _),
      \+ prerequisito_transitivo(tcc2, desconhecida),
      \+ existe_ciclo(desconhecida))).
caso(cadeia_profundidade_sete, prerequisito_transitivo(tcc2, algoritmos1)).
caso(sem_ciclo, \+ existe_ciclo(_)).
caso(sem_ancestral_duplicado,
     (findall(P, prerequisito_transitivo(tcc2, P), L),
      sort(L, S), length(L, N), length(S, N))).
caso(sem_ancestrais_na_raiz, \+ prerequisito_transitivo(algoritmos1, _)).
caso(trilha_zero_ate_formatura,
     (once(trilha_valida(diego, 12, T)), conferir_trilha(diego, 12, T))).
caso(trilha_para_todos,
     forall(aluno(A), (once(trilha_valida(A, 12, T)), conferir_trilha(A, 12, T)))).
caso(trilha_nao_muda_historico,
     (findall(A-D, cursou(A,D), Antes),
      findall(T, trilha_valida(elisa, 8, T), _),
      findall(A-D, cursou(A,D), Depois), Antes == Depois)).
caso(tres_trilhas_findall,
     (findall(T, trilha_valida(elisa, 8, T), Ts),
      sort(Ts, S), sort([[[gestao_projetos,tcc2]],
                        [[gestao_projetos],[tcc2]],
                        [[tcc2],[gestao_projetos]]], S), length(Ts, 3))).
caso(tres_trilhas_bagof,
     (bagof(T, trilha_valida(elisa, 8, T), Ts), length(Ts, 3))).
caso(duas_trilhas_limite_quatro,
     (findall(T, trilha_valida(elisa, 4, T), Ts), length(Ts, 2),
      forall(pertence(T, Ts), conferir_trilha(elisa, 4, T)))).
caso(um_semestre_elisa,
     findall(T, trilha_valida_limite(elisa, 8, 1, T), [[[gestao_projetos,tcc2]]])).
caso(limite_semestres_insuficiente,
     \+ trilha_valida_limite(diego, 12, 7, _)).
caso(teto_nao_pode_ser_ampliado,
     \+ trilha_valida_limite(diego, 12, 13, _)).
caso(credito_insuficiente, \+ trilha_valida(diego, 3, _)).
caso(poda_creditos_totais, \+ trilha_valida(diego, 4, _)).
caso(credito_invalido,
     (\+ trilha_valida(diego, 0, _), \+ trilha_valida(diego, -1, _),
      \+ trilha_valida(diego, abc, _), \+ trilha_valida(diego, 12.5, _),
      \+ trilha_valida(diego, _, _))).
caso(limite_invalido,
     (\+ trilha_valida_limite(diego, 12, -1, _),
      \+ trilha_valida_limite(diego, 12, abc, _))).
caso(trilha_malformada,
     (\+ trilha_valida(diego, 12, abc), \+ trilha_valida(diego, 12, [a|b]))).
caso(trilha_formado_vazia, findall(T, trilha_valida(fabio, 12, T), [[]])).
caso(formado_zero_semestres, trilha_valida_limite(fabio, 12, 0, [])).
caso(nao_formado_zero_semestres, \+ trilha_valida_limite(diego, 12, 0, _)).
caso(rejeita_correquisito,
     \+ trilha_valida(elisa, 8, [[gestao_projetos,tcc1,tcc2]])).
caso(rejeita_repeticao,
     \+ trilha_valida(elisa, 8, [[gestao_projetos],[gestao_projetos],[tcc2]])).
caso(rejeita_semestre_vazio,
     \+ trilha_valida(elisa, 8, [[],[gestao_projetos,tcc2]])).
caso(rejeita_trilha_incompleta, \+ trilha_valida(elisa, 8, [[gestao_projetos]])).
caso(rejeita_excesso_creditos,
     \+ trilha_valida(elisa, 4, [[gestao_projetos,tcc2]])).
caso(rejeita_ordem_temporal,
     \+ trilha_valida(ana, 24,
         [[etica_computacao,gestao_projetos,seguranca_computacional,
           sistemas_distribuidos,tcc1,tcc2]])).

% Verificador independente da busca: checa os pre-requisitos DIRETOS
% contra o estado anterior e atualiza o historico somente ao fim do semestre.
conferir_trilha(Aluno, Max, Trilha) :-
    length(Trilha, N), N =< 12,
    historico(Aluno, Inicial),
    conferir_semestres(Trilha, Max, Inicial, Final),
    forall(disciplina(D, obrigatoria, _, _), pertence(D, Final)).

conferir_semestres([], _, Historico, Historico).
conferir_semestres([S|Ss], Max, Antes, Final) :-
    S = [_|_], sort(S, Unicos), length(S, N), length(Unicos, N),
    creditos_lista(S, C), C =< Max,
    forall(pertence(D, S),
           (\+ pertence(D, Antes),
            forall(prerequisito(D, P), pertence(P, Antes)))),
    concatena(S, Antes, Depois),
    conferir_semestres(Ss, Max, Depois, Final).
