% CAMADA 1: somente fatos. Grade DIDATICA, nao e a matriz oficial da PUCPR.
% disciplina(Nome, Tipo, Creditos, SemestreSugerido).
disciplina(algoritmos1, obrigatoria, 4, 1).
disciplina(matematica_discreta, obrigatoria, 4, 1).
disciplina(introducao_computacao, obrigatoria, 4, 1).
disciplina(algoritmos2, obrigatoria, 4, 2).
disciplina(calculo1, obrigatoria, 4, 2).
disciplina(logica_computacao, obrigatoria, 4, 2).
disciplina(estrutura_dados, obrigatoria, 4, 3).
disciplina(algebra_linear, obrigatoria, 4, 3).
disciplina(arquitetura_computadores, obrigatoria, 4, 3).
disciplina(analise_algoritmos, obrigatoria, 4, 4).
disciplina(banco_dados1, obrigatoria, 4, 4).
disciplina(sistemas_operacionais, obrigatoria, 4, 4).
disciplina(compiladores, obrigatoria, 4, 5).
disciplina(banco_dados2, obrigatoria, 4, 5).
disciplina(redes_computadores, obrigatoria, 4, 5).
disciplina(inteligencia_artificial, obrigatoria, 4, 6).
disciplina(engenharia_software, obrigatoria, 4, 6).
disciplina(projeto_integrador, obrigatoria, 4, 6).
disciplina(seguranca_computacional, obrigatoria, 4, 7).
disciplina(sistemas_distribuidos, obrigatoria, 4, 7).
disciplina(tcc1, obrigatoria, 4, 7).
disciplina(etica_computacao, obrigatoria, 4, 8).
disciplina(gestao_projetos, obrigatoria, 4, 8).
disciplina(tcc2, obrigatoria, 4, 8).
disciplina(computacao_grafica, eletiva, 2, 5).
disciplina(robotica, eletiva, 2, 6).
disciplina(mineracao_dados, eletiva, 2, 7).
disciplina(processamento_imagens, eletiva, 2, 8).

% prerequisito(Disciplina, PreRequisito): um fato por aresta.
prerequisito(algoritmos2, algoritmos1).
prerequisito(calculo1, matematica_discreta).
prerequisito(logica_computacao, matematica_discreta).
prerequisito(estrutura_dados, algoritmos2).
prerequisito(algebra_linear, calculo1).
prerequisito(arquitetura_computadores, introducao_computacao).
prerequisito(arquitetura_computadores, algoritmos2).
prerequisito(analise_algoritmos, estrutura_dados).
prerequisito(analise_algoritmos, matematica_discreta).
prerequisito(banco_dados1, estrutura_dados).
prerequisito(sistemas_operacionais, arquitetura_computadores).
prerequisito(sistemas_operacionais, estrutura_dados).
prerequisito(compiladores, analise_algoritmos).
prerequisito(compiladores, logica_computacao).
prerequisito(banco_dados2, banco_dados1).
prerequisito(redes_computadores, sistemas_operacionais).
prerequisito(inteligencia_artificial, analise_algoritmos).
prerequisito(inteligencia_artificial, algebra_linear).
prerequisito(engenharia_software, banco_dados2).
prerequisito(projeto_integrador, compiladores).
prerequisito(projeto_integrador, banco_dados2).
prerequisito(seguranca_computacional, redes_computadores).
prerequisito(sistemas_distribuidos, redes_computadores).
prerequisito(sistemas_distribuidos, banco_dados2).
prerequisito(tcc1, projeto_integrador).
prerequisito(etica_computacao, introducao_computacao).
prerequisito(gestao_projetos, engenharia_software).
prerequisito(tcc2, tcc1).
prerequisito(computacao_grafica, algebra_linear).
prerequisito(computacao_grafica, estrutura_dados).
prerequisito(robotica, arquitetura_computadores).
prerequisito(robotica, algoritmos2).
prerequisito(mineracao_dados, banco_dados2).
prerequisito(processamento_imagens, algebra_linear).

% Cadastro separado permite distinguir aluno sem historico de inexistente.
aluno(ana).
aluno(bruno).
aluno(carla).
aluno(diego).
aluno(elisa).
aluno(fabio).
perfil(ana, adiantada).
perfil(bruno, ritmo_normal).
perfil(carla, atrasada_apos_trancamento).
perfil(diego, ingressante_sem_historico).
perfil(elisa, concluinte_com_duas_pendencias).
perfil(fabio, formado).

cursou(ana, algoritmos1).
cursou(ana, matematica_discreta).
cursou(ana, introducao_computacao).
cursou(ana, algoritmos2).
cursou(ana, calculo1).
cursou(ana, logica_computacao).
cursou(ana, estrutura_dados).
cursou(ana, algebra_linear).
cursou(ana, arquitetura_computadores).
cursou(ana, analise_algoritmos).
cursou(ana, banco_dados1).
cursou(ana, sistemas_operacionais).
cursou(ana, compiladores).
cursou(ana, banco_dados2).
cursou(ana, redes_computadores).
cursou(ana, inteligencia_artificial).
cursou(ana, engenharia_software).
cursou(ana, projeto_integrador).
cursou(bruno, algoritmos1).
cursou(bruno, matematica_discreta).
cursou(bruno, introducao_computacao).
cursou(bruno, algoritmos2).
cursou(bruno, calculo1).
cursou(bruno, logica_computacao).
cursou(bruno, estrutura_dados).
cursou(bruno, algebra_linear).
cursou(bruno, arquitetura_computadores).
cursou(carla, algoritmos1).
cursou(carla, introducao_computacao).
cursou(elisa, algoritmos1).
cursou(elisa, matematica_discreta).
cursou(elisa, introducao_computacao).
cursou(elisa, algoritmos2).
cursou(elisa, calculo1).
cursou(elisa, logica_computacao).
cursou(elisa, estrutura_dados).
cursou(elisa, algebra_linear).
cursou(elisa, arquitetura_computadores).
cursou(elisa, analise_algoritmos).
cursou(elisa, banco_dados1).
cursou(elisa, sistemas_operacionais).
cursou(elisa, compiladores).
cursou(elisa, banco_dados2).
cursou(elisa, redes_computadores).
cursou(elisa, inteligencia_artificial).
cursou(elisa, engenharia_software).
cursou(elisa, projeto_integrador).
cursou(elisa, seguranca_computacional).
cursou(elisa, sistemas_distribuidos).
cursou(elisa, tcc1).
cursou(elisa, etica_computacao).
cursou(fabio, algoritmos1).
cursou(fabio, matematica_discreta).
cursou(fabio, introducao_computacao).
cursou(fabio, algoritmos2).
cursou(fabio, calculo1).
cursou(fabio, logica_computacao).
cursou(fabio, estrutura_dados).
cursou(fabio, algebra_linear).
cursou(fabio, arquitetura_computadores).
cursou(fabio, analise_algoritmos).
cursou(fabio, banco_dados1).
cursou(fabio, sistemas_operacionais).
cursou(fabio, compiladores).
cursou(fabio, banco_dados2).
cursou(fabio, redes_computadores).
cursou(fabio, inteligencia_artificial).
cursou(fabio, engenharia_software).
cursou(fabio, projeto_integrador).
cursou(fabio, seguranca_computacional).
cursou(fabio, sistemas_distribuidos).
cursou(fabio, tcc1).
cursou(fabio, etica_computacao).
cursou(fabio, gestao_projetos).
cursou(fabio, tcc2).
