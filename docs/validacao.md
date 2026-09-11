# Registro de validação

## Executado neste ambiente

Comando: `python3 tests/verificar_dados.py`.

Resultado observado: **37 checagens independentes aprovadas**. A lista nominal de checagens está em `resultados_esperados.md` e em `dados/dados.json`.

O conferente leu os fatos Prolog e confirmou contagens, referências, ausência de duplicatas/ciclos na base normal, coerência dos históricos, cadeia de sete arestas, créditos, listas literais esperadas dos testes e invariantes das trilhas geradas por uma implementação independente.

Foram conferidas até 20 trilhas por aluno (menos quando a instância possui menos soluções) com limite de 12 créditos por semestre. Para Elisa também foi feita a enumeração completa com limites 8 e 4, resultando em 3 e 2 soluções, respectivamente. A conferência não enumera todas as trilhas dos alunos com muitas pendências.

## Preparado, mas não executado

- 53 casos na bateria `tests/consultas_teste.pl`.
- Uma fixture isolada de ciclo em `tests/ciclo_teste.pl`.
- Uma fixture isolada de alteração de histórico em `tests/historico_teste.pl`.
- Carregamento de `src/main.pl` e execução de `demo/0` no SWI-Prolog.

O SWI-Prolog não estava instalado. A tentativa de instalação foi bloqueada por permissões do ambiente e não se contornou essa restrição. Portanto **não se afirma que o programa carregou sem warnings ou que os testes Prolog passaram**.

## Como concluir a validação

Em uma máquina com SWI-Prolog, abra a pasta `projeto` e execute:

```sh
sh tests/executar.sh
swipl -q -s src/main.pl -g demo -t halt
```

Se houver falha, preserve a saída completa para diagnóstico. A existência de resultados de referência calculados em Python não elimina a possibilidade de erros específicos de sintaxe, carregamento ou semântica no Prolog.

## Pendências acadêmicas

- Confirmar a matriz curricular real: a entregue é didática, não oficial.
- Confirmar a regra de formatura, especialmente eletivas.
- Preencher os quatro integrantes e matrículas reais.
- Revisar o código em grupo e observar as regras da disciplina sobre ferramentas de IA.
