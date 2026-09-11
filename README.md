# PjBL 1 - Sistema de Trilha de Disciplinas em Prolog

Implementação das três camadas do enunciado **PjBL 1.pdf**, com grade didática de Ciência da Computação, testes e resultados de referência.

## Avisos importantes antes da entrega

- A grade é **fictícia**, com 28 disciplinas em 8 semestres sugeridos. Não foi fornecida a matriz oficial do curso. Nomes, créditos e pré-requisitos não devem ser apresentados como dados oficiais da PUCPR.
- Há 24 obrigatórias (96 créditos) e 4 eletivas (8 créditos oferecidos). Cada obrigatória vale 4 créditos e cada eletiva vale 2; são escolhas didáticas.
- Formatura significa concluir todas as obrigatórias. O PDF não estabelece uma carga mínima de eletivas, estágio ou atividades complementares. A hipótese está justificada em `docs/decisoes.md` e deve ser confirmada com o professor.
- **O código não foi executado no SWI-Prolog neste ambiente**, pois o interpretador não estava disponível e sua instalação foi bloqueada. Foram realizadas conferências independentes em Python, que não substituem a execução em Prolog. Execute os testes abaixo antes de entregar.
- O enunciado exige grupo de quatro integrantes e domínio individual do código. Preencha a identificação e confira a política da disciplina sobre assistência por IA.

## Equipe

Preencher os quatro nomes e matrículas reais antes da entrega. Nenhum integrante foi presumido.

## Arquivos

| Arquivo | Finalidade |
|---|---|
| `src/curriculum.pl` | Camada 1: disciplinas, pré-requisitos, alunos e históricos, somente fatos |
| `src/elegibilidade.pl` | Camada 2: elegibilidade, pendências e créditos; auxiliares de listas |
| `src/trilhas.pl` | Camada 3: fecho transitivo, ciclos e planejamento por backtracking |
| `src/main.pl` | Carregamento e demonstração `demo/0` |
| `tests/consultas_teste.pl` | Bateria automatizada de consultas e resultados esperados |
| `tests/ciclo_teste.pl` | Fixture com ciclo real, executada isoladamente |
| `tests/historico_teste.pl` | Fixture com alteração real de histórico, executada isoladamente |
| `tests/executar.sh` | Executa as três baterias em processos separados |
| `tests/verificar_dados.py` | Conferente opcional independente, somente biblioteca padrão Python |
| `dados/dados.json` | Exportação completa da grade, arestas, históricos e resultados |
| `docs/decisoes.md` | Decisões de modelagem, semântica e limitações |
| `docs/explicacao.md` | Explicação do funcionamento e exemplos comentados |
| `docs/requisitos.md` | Correspondência entre requisitos do PDF e implementação |
| `docs/resultados_esperados.md` | Listas e trilhas calculadas a partir dos fatos, com status da conferência |

## Executar

Requisito principal: SWI-Prolog. O projeto Prolog não importa bibliotecas externas e não precisa de Python para funcionar.

Abra um terminal na pasta `projeto`:

```sh
swipl -q -s src/main.pl
```

No interpretador:

```prolog
?- demo.
?- disciplinas_liberadas(bruno, Lista).
?- disciplinas_pendentes(ana, Lista).
?- creditos_cursados(carla, Total).
?- prerequisito_transitivo(tcc2, Ancestral).
?- existe_ciclo(D).
?- once(trilha_valida(diego, 12, Trilha)).
?- halt.
```

O prefixo `?-` representa o prompt e não deve ser colado dentro do arquivo-fonte.

Para uma demonstração não interativa:

```sh
swipl -q -s src/main.pl -g demo -t halt
```

## Executar os testes

Linux/macOS, na pasta `projeto`:

```sh
sh tests/executar.sh
```

Sem shell POSIX, execute cada comando separadamente no terminal, sempre na pasta `projeto`:

```sh
swipl -q -s src/main.pl -g halt
swipl -q -s tests/consultas_teste.pl -g "(executar_testes -> halt(0) ; halt(1))"
swipl -q -s tests/ciclo_teste.pl -g "(executar_teste_ciclo -> halt(0) ; halt(1))"
swipl -q -s tests/historico_teste.pl -g "(executar_teste_historico -> halt(0) ; halt(1))"
```

Resultado esperado: primeiro comando sem erros/avisos, bateria normal sem falhas e confirmação `OK` nas duas fixtures. **Isso é um resultado esperado, não uma execução já realizada aqui.**

Não carregue as fixtures de ciclo/histórico na sessão normal: elas acrescentam fatos de teste. Encerre essa sessão e reabra `src/main.pl` para retornar à base original. Não se usa `assert/retract`.

A conferência independente já realizada pode ser reproduzida com Python 3:

```sh
python3 tests/verificar_dados.py
```

Esse comando relê os fatos, confere exemplos e regrava `dados/dados.json` e `docs/resultados_esperados.md`. Não executa o código Prolog.

## Uma trilha e múltiplas trilhas

```prolog
% Obter somente a primeira solução; once evita enumerar todo o espaço.
?- once(trilha_valida(diego, 12, T)).

% Enumerar manualmente: digite ; para pedir a próxima solução.
?- trilha_valida(ana, 12, T).

% Enumerar TODAS em uma instância pequena: Elisa só tem duas pendências.
?- findall(T, trilha_valida(elisa, 8, T), Ts).
Ts = [[[gestao_projetos,tcc2]],
      [[gestao_projetos],[tcc2]],
      [[tcc2],[gestao_projetos]]].

?- bagof(T, trilha_valida(elisa, 8, T), Ts).
% As mesmas três trilhas.

% Restrição adicional a somente um semestre.
?- findall(T, trilha_valida_limite(elisa, 8, 1, T), Ts).
Ts = [[[gestao_projetos,tcc2]]].
```

Evite `findall(T, trilha_valida(diego, 12, T), Ts)`: o espaço é finito, mas pode ser enorme. O limite de 12 semestres não garante execução rápida para enumerar todas as possibilidades.

## Dados de teste

| Aluno | Perfil fictício | Obrigatórias cursadas | Créditos |
|---|---|---:|---:|
| ana | Adiantada: concluiu as disciplinas sugeridas até o 6º semestre | 18 | 72 |
| bruno | Ritmo normal: concluiu até o 3º semestre | 9 | 36 |
| carla | Atrasada após trancamento: duas disciplinas iniciais concluídas | 2 | 8 |
| diego | Ingressante sem histórico | 0 | 0 |
| elisa | Concluinte: faltam gestão de projetos e TCC2 | 22 | 88 |
| fabio | Todas as obrigatórias concluídas | 24 | 96 |

Os perfis são cenários de teste; não há datas ou semestres de matrícula para inferir uma trajetória real.

## Revisão final pelo grupo

1. Executar o carregamento, a demonstração e as três baterias no SWI-Prolog.
2. Confirmar grade e hipótese de formatura com o professor; se necessário, substituir os fatos e atualizar testes/expectativas.
3. Preencher os quatro integrantes e estudar a explicação, especialmente a recursão, a negação por falha e o backtracking.
# prolog-pjbl1
