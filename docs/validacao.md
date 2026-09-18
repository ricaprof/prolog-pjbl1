# Registro de validação

## Ambiente

- Data: 18/09/2026
- SWI-Prolog 10.0.2 para x86_64-linux
- Python 3

## Resultados

O comando abaixo foi executado na raiz do projeto:

```sh
sh tests/executar.sh
```

Resultados observados:

- carregamento de `src/main.pl` sem erros ou avisos;
- 53 de 53 casos aprovados em `tests/consultas_teste.pl`;
- fixture de ciclo aprovada em processo isolado;
- fixture de alteração de histórico aprovada em processo isolado.

A demonstração completa também foi executada com sucesso:

```sh
swipl -q -s src/main.pl -g demo -t halt
```

Ela consultou as três camadas, exibiu os seis perfis, encontrou uma trilha de oito semestres para Diego e enumerou as três trilhas esperadas para Elisa.

## Conferência independente

Também foi executado:

```sh
python3 tests/verificar_dados.py
```

O resultado foi **37 de 37 checagens aprovadas**. O conferente validou contagens, referências, duplicatas, ausência de ciclos na base normal, coerência dos históricos, créditos, listas esperadas e invariantes das trilhas.

Foram verificadas até 20 trilhas por aluno com limite de 12 créditos por semestre. Para Elisa, a enumeração completa produziu três soluções com limite 8 e duas soluções com limite 4.

A lista de checagens e os resultados calculados estão em `docs/resultados_esperados.md` e `dados/dados.json`.

## Identificação da equipe

O único preenchimento restante é informar no README os nomes dos quatro integrantes.
