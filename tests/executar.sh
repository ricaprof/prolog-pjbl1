#!/usr/bin/env sh
set -eu
cd "$(dirname "$0")/.."
if ! command -v swipl >/dev/null 2>&1; then
    echo 'SWI-Prolog nao encontrado. Instale-o e execute novamente.' >&2
    exit 127
fi
swipl --version
swipl -q -s src/main.pl -g halt
swipl -q -s tests/consultas_teste.pl -g '(executar_testes -> halt(0) ; halt(1))'
swipl -q -s tests/ciclo_teste.pl -g '(executar_teste_ciclo -> halt(0) ; halt(1))'
swipl -q -s tests/historico_teste.pl -g '(executar_teste_historico -> halt(0) ; halt(1))'
