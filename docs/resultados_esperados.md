# Dados e resultados esperados

Origem: fatos de `src/curriculum.pl`. Grade e alunos inteiramente didáticos.

**Status:** resultados calculados e conferidos por Python. Não são um log de execução do SWI-Prolog.

As listas de elegibilidade incluem eletivas. Pendências e formatura consideram as obrigatórias.

| Aluno | Perfil | Créditos cursados | Obrigatórias pendentes |
|---|---|---:|---:|
| ana | adiantada | 72 | 6 |
| bruno | ritmo_normal | 36 | 15 |
| carla | atrasada_apos_trancamento | 8 | 22 |
| diego | ingressante_sem_historico | 0 | 24 |
| elisa | concluinte_com_duas_pendencias | 88 | 2 |
| fabio | formado | 96 | 0 |

## ana

```prolog
% Liberadas
[computacao_grafica, etica_computacao, gestao_projetos, mineracao_dados, processamento_imagens, robotica, seguranca_computacional, sistemas_distribuidos, tcc1].
% Pendentes obrigatorias
[etica_computacao, gestao_projetos, seguranca_computacional, sistemas_distribuidos, tcc1, tcc2].
```

Uma trilha válida com limite de 12 créditos por semestre:

| Semestre simulado | Disciplinas | Créditos |
|---:|---|---:|
| 1 | etica_computacao, gestao_projetos, seguranca_computacional | 12 |
| 2 | sistemas_distribuidos, tcc1 | 8 |
| 3 | tcc2 | 4 |

## bruno

```prolog
% Liberadas
[analise_algoritmos, banco_dados1, computacao_grafica, etica_computacao, processamento_imagens, robotica, sistemas_operacionais].
% Pendentes obrigatorias
[analise_algoritmos, banco_dados1, banco_dados2, compiladores, engenharia_software, etica_computacao, gestao_projetos, inteligencia_artificial, projeto_integrador, redes_computadores, seguranca_computacional, sistemas_distribuidos, sistemas_operacionais, tcc1, tcc2].
```

Uma trilha válida com limite de 12 créditos por semestre:

| Semestre simulado | Disciplinas | Créditos |
|---:|---|---:|
| 1 | analise_algoritmos, banco_dados1, etica_computacao | 12 |
| 2 | banco_dados2, compiladores, inteligencia_artificial | 12 |
| 3 | engenharia_software, projeto_integrador, sistemas_operacionais | 12 |
| 4 | gestao_projetos, redes_computadores, tcc1 | 12 |
| 5 | seguranca_computacional, sistemas_distribuidos, tcc2 | 12 |

## carla

```prolog
% Liberadas
[algoritmos2, etica_computacao, matematica_discreta].
% Pendentes obrigatorias
[algebra_linear, algoritmos2, analise_algoritmos, arquitetura_computadores, banco_dados1, banco_dados2, calculo1, compiladores, engenharia_software, estrutura_dados, etica_computacao, gestao_projetos, inteligencia_artificial, logica_computacao, matematica_discreta, projeto_integrador, redes_computadores, seguranca_computacional, sistemas_distribuidos, sistemas_operacionais, tcc1, tcc2].
```

Uma trilha válida com limite de 12 créditos por semestre:

| Semestre simulado | Disciplinas | Créditos |
|---:|---|---:|
| 1 | algoritmos2, etica_computacao, matematica_discreta | 12 |
| 2 | arquitetura_computadores, calculo1, estrutura_dados | 12 |
| 3 | algebra_linear, analise_algoritmos, banco_dados1 | 12 |
| 4 | banco_dados2, inteligencia_artificial, logica_computacao | 12 |
| 5 | compiladores, engenharia_software, sistemas_operacionais | 12 |
| 6 | gestao_projetos, projeto_integrador, redes_computadores | 12 |
| 7 | seguranca_computacional, sistemas_distribuidos, tcc1 | 12 |
| 8 | tcc2 | 4 |

## diego

```prolog
% Liberadas
[algoritmos1, introducao_computacao, matematica_discreta].
% Pendentes obrigatorias
[algebra_linear, algoritmos1, algoritmos2, analise_algoritmos, arquitetura_computadores, banco_dados1, banco_dados2, calculo1, compiladores, engenharia_software, estrutura_dados, etica_computacao, gestao_projetos, inteligencia_artificial, introducao_computacao, logica_computacao, matematica_discreta, projeto_integrador, redes_computadores, seguranca_computacional, sistemas_distribuidos, sistemas_operacionais, tcc1, tcc2].
```

Uma trilha válida com limite de 12 créditos por semestre:

| Semestre simulado | Disciplinas | Créditos |
|---:|---|---:|
| 1 | algoritmos1, introducao_computacao, matematica_discreta | 12 |
| 2 | algoritmos2, calculo1, etica_computacao | 12 |
| 3 | algebra_linear, arquitetura_computadores, estrutura_dados | 12 |
| 4 | analise_algoritmos, banco_dados1, logica_computacao | 12 |
| 5 | banco_dados2, compiladores, inteligencia_artificial | 12 |
| 6 | engenharia_software, projeto_integrador, sistemas_operacionais | 12 |
| 7 | gestao_projetos, redes_computadores, tcc1 | 12 |
| 8 | seguranca_computacional, sistemas_distribuidos, tcc2 | 12 |

## elisa

```prolog
% Liberadas
[computacao_grafica, gestao_projetos, mineracao_dados, processamento_imagens, robotica, tcc2].
% Pendentes obrigatorias
[gestao_projetos, tcc2].
```

Uma trilha válida com limite de 12 créditos por semestre:

| Semestre simulado | Disciplinas | Créditos |
|---:|---|---:|
| 1 | gestao_projetos, tcc2 | 8 |

## fabio

```prolog
% Liberadas
[computacao_grafica, mineracao_dados, processamento_imagens, robotica].
% Pendentes obrigatorias
[].
```

Uma trilha válida com limite de 12 créditos por semestre:

| Semestre simulado | Disciplinas | Créditos |
|---:|---|---:|
| - | Nenhuma: todas as obrigatórias concluídas | 0 |

## Enumeração completa em instância pequena

`findall(T, trilha_valida(elisa, 8, T), Ts).`

```prolog
Ts = [[[gestao_projetos, tcc2]], [[gestao_projetos], [tcc2]], [[tcc2], [gestao_projetos]]].
```

## Checagens independentes executadas

- OK: 28 disciplinas unicas.
- OK: 24 obrigatorias.
- OK: 4 eletivas.
- OK: 8 semestres.
- OK: 6 alunos unicos.
- OK: Creditos positivos.
- OK: Fatos sem duplicatas.
- OK: Semestres sugeridos respeitam arestas.
- OK: Grade aciclica.
- OK: Historicos completos quanto a pre-requisitos.
- OK: Cadeia de 7 arestas.
- OK: Trilhas de ana: 20 conferidas.
- OK: Trilhas de bruno: 20 conferidas.
- OK: Trilhas de carla: 20 conferidas.
- OK: Trilhas de diego: 20 conferidas.
- OK: Trilhas de elisa: 3 conferidas.
- OK: Trilhas de fabio: 1 conferidas.
- OK: Elisa: exatamente 3 trilhas com 8 creditos.
- OK: Elisa: exatamente 2 trilhas com 4 creditos.
- OK: Diego: 7 semestres insuficientes.
- OK: Diego: 4 creditos por 12 semestres insuficientes.
- OK: Fabio: somente trilha vazia.
- OK: Creditos exatos.
- OK: Fixture cria ciclo detectavel.
- OK: Descendente nao vira membro do ciclo.
- OK: Rejeita TCC1 e TCC2 simultaneos.
- OK: Rejeita repeticao.
- OK: Rejeita excesso de creditos.
- OK: Rejeita semestre vazio.
- OK: Rejeita trilha incompleta.
- OK: Literal de teste liberadas(ana).
- OK: Literal de teste liberadas(bruno).
- OK: Literal de teste liberadas(carla).
- OK: Literal de teste liberadas(diego).
- OK: Literal de teste pendentes(ana).
- OK: Literal de teste pendentes(bruno).
- OK: Literal de teste pendentes(fabio).

## Limite desta validação

O conferente lê os fatos e verifica dados, exemplos e invariantes por uma implementação independente.
Ele não interpreta o código Prolog. Execute `sh tests/executar.sh` para verificar carregamento,
avisos e comportamento no SWI-Prolog antes da entrega acadêmica.
