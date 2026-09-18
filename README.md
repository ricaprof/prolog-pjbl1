# Sistema de Trilhas de Disciplinas em Prolog

Projeto do PjBL 1 que representa uma grade didática de Ciência da Computação e gera trilhas de disciplinas até a formatura, respeitando pré-requisitos, limite de créditos e ordem entre semestres.

## Integrantes

1. Ricardo Vinicius Moreira Vianna
2. Isabelle Duarte Santos
3. Daniel Langner Jager
4. Vitor Luis da Silva Ferreira

## Funcionalidades

- cadastro de disciplinas obrigatórias e eletivas, pré-requisitos, alunos e históricos;
- consulta de disciplinas liberadas e obrigatórias pendentes;
- cálculo dos créditos já cursados;
- busca recursiva de pré-requisitos diretos e indiretos;
- detecção de ciclos na grade;
- geração de uma ou várias trilhas por backtracking;
- validação de créditos, histórico, referências e limite de semestres.

## Estrutura

| Caminho | Conteúdo |
|---|---|
| `src/curriculum.pl` | Camada 1: fatos da grade, alunos e históricos |
| `src/elegibilidade.pl` | Camada 2: elegibilidade, pendências e créditos |
| `src/trilhas.pl` | Camada 3: dependências, ciclos e planejamento |
| `src/main.pl` | Ponto de entrada e demonstração `demo/0` |
| `tests/` | Testes Prolog e conferência independente em Python |
| `dados/dados.json` | Dados e resultados exportados |
| `docs/` | Explicação, decisões, requisitos e validação |

## Requisitos

- SWI-Prolog;
- Python 3 apenas para a conferência independente dos dados.

O programa Prolog não usa bibliotecas ou pacotes externos.

## Executar

Na raiz do projeto, inicie o interpretador:

```sh
swipl -q -s src/main.pl
```

Algumas consultas disponíveis:

```prolog
?- demo.
?- disciplinas_liberadas(bruno, Lista).
?- disciplinas_pendentes(ana, Lista).
?- creditos_cursados(carla, Total).
?- prerequisito_transitivo(tcc2, Ancestral).
?- existe_ciclo(Disciplina).
?- once(trilha_valida(diego, 12, Trilha)).
?- halt.
```

Para executar a demonstração diretamente pelo terminal:

```sh
swipl -q -s src/main.pl -g demo -t halt
```

## Testes

Execute a bateria Prolog completa:

```sh
sh tests/executar.sh
```

Ela carrega o projeto e executa 53 casos, um cenário de ciclo e um cenário de alteração de histórico, cada fixture no processo adequado.

Execute também a conferência independente dos fatos e resultados:

```sh
python3 tests/verificar_dados.py
```

Na última validação, realizada com SWI-Prolog 10.0.2 e Python 3, foram aprovados:

- 53 de 53 casos Prolog;
- as duas fixtures isoladas;
- 37 de 37 checagens independentes;
- o carregamento e a demonstração, sem erros ou avisos.

## Múltiplas trilhas

Para obter apenas a primeira solução, use `once/1`:

```prolog
?- once(trilha_valida(diego, 12, Trilha)).
```

Para enumerar todas as soluções de uma instância pequena:

```prolog
?- findall(T, trilha_valida(elisa, 8, T), Ts).
Ts = [[[gestao_projetos,tcc2]],
      [[gestao_projetos],[tcc2]],
      [[tcc2],[gestao_projetos]]].
```

Não é recomendado enumerar todas as trilhas de um aluno com muitas pendências, pois o espaço de busca é combinatório.

## Decisões de modelagem

A grade possui 28 disciplinas distribuídas em oito semestres sugeridos: 24 obrigatórias de quatro créditos e quatro eletivas de dois créditos. Os dados são didáticos e não representam uma matriz oficial da PUCPR.

Neste projeto, a formatura corresponde à conclusão de todas as disciplinas obrigatórias. As eletivas são consideradas nas consultas de elegibilidade, mas só entram no planejamento se forem pré-requisitos de uma obrigatória. Os semestres cadastrados são sugestões, não restrições de oferta.

As justificativas completas estão em [`docs/decisoes.md`](docs/decisoes.md), e os resultados conferidos estão em [`docs/validacao.md`](docs/validacao.md).
