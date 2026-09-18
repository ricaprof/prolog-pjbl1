"""Conferencia independente dos dados. NAO executa nem certifica o Prolog.

Python 3, apenas biblioteca padrao. Gera dados.json e resultados_esperados.md
diretamente dos fatos de curriculum.pl, sem cadastrar uma segunda grade.
"""
from pathlib import Path
from itertools import islice
import json
import re

ROOT = Path(__file__).resolve().parents[1]
SOURCE = (ROOT / 'src' / 'curriculum.pl').read_text(encoding='utf-8')
FACT = re.compile(r'^(\w+)\(([^()]*)\)\.$')
facts = {}
for line in SOURCE.splitlines():
    line = line.split('%', 1)[0].strip()
    if not line:
        continue
    match = FACT.fullmatch(line)
    assert match, f'Camada 1 nao contem apenas fatos: {line}'
    name, body = match.groups()
    facts.setdefault(name, []).append(tuple(x.strip() for x in body.split(',')))

subjects = {d: {'tipo': t, 'creditos': int(c), 'semestre_sugerido': int(s)}
            for d, t, c, s in facts['disciplina']}
students = [a for (a,) in facts['aluno']]
profiles = dict(facts['perfil'])
pre = {d: set() for d in subjects}
history = {a: set() for a in students}
checks = []


def check(name, condition):
    assert condition, name
    checks.append(name)


check('28 disciplinas unicas', len(subjects) == len(facts['disciplina']) == 28)
check('24 obrigatorias', sum(d['tipo'] == 'obrigatoria' for d in subjects.values()) == 24)
check('4 eletivas', sum(d['tipo'] == 'eletiva' for d in subjects.values()) == 4)
check('8 semestres', {d['semestre_sugerido'] for d in subjects.values()} == set(range(1, 9)))
check('6 alunos unicos', len(students) == len(set(students)) == 6)
check('Creditos positivos', all(d['creditos'] > 0 for d in subjects.values()))
for d, p in facts['prerequisito']:
    assert d in subjects and p in subjects
    pre[d].add(p)
for a, d in facts['cursou']:
    assert a in history and d in subjects
    history[a].add(d)
check('Fatos sem duplicatas', all(len(xs) == len(set(xs)) for xs in facts.values()))
check('Semestres sugeridos respeitam arestas',
      all(subjects[p]['semestre_sugerido'] < subjects[d]['semestre_sugerido']
          for d in pre for p in pre[d]))


def ancestors(d, graph):
    seen, pending = set(), list(graph[d])
    while pending:
        p = pending.pop()
        if p not in seen:
            seen.add(p)
            pending.extend(graph[p])
    return seen


check('Grade aciclica', all(d not in ancestors(d, pre) for d in subjects))
check('Historicos completos quanto a pre-requisitos',
      all(ancestors(d, pre) <= h for h in history.values() for d in h))
chain = ['tcc2', 'tcc1', 'projeto_integrador', 'compiladores',
         'analise_algoritmos', 'estrutura_dados', 'algoritmos2', 'algoritmos1']
check('Cadeia de 7 arestas', all(b in pre[a] for a, b in zip(chain, chain[1:])))
required = {d for d in subjects if subjects[d]['tipo'] == 'obrigatoria'}


def credits(ds):
    return sum(subjects[d]['creditos'] for d in ds)


def subsets(items, budget):
    if not items:
        yield []
        return
    d, *rest = items
    cost = subjects[d]['creditos']
    if cost <= budget:
        for tail in subsets(rest, budget - cost):
            yield [d] + tail
    yield from subsets(rest, budget)


def schedules(done, pending, budget, limit):
    if not pending:
        yield []
        return
    if limit == 0 or credits(pending) > budget * limit:
        return
    if any(subjects[d]['creditos'] > budget for d in pending):
        return
    available = sorted(d for d in pending if pre[d] <= done)
    for term in subsets(available, budget):
        if term:
            for tail in schedules(done | set(term), pending - set(term), budget, limit - 1):
                yield [term] + tail


def valid_schedule(a, budget, terms):
    """Verificador separado, checa temporalidade, cobertura e nao repeticao."""
    done = history[a].copy()
    if len(terms) > 12:
        return False
    for term in terms:
        if not term or len(term) != len(set(term)) or credits(term) > budget:
            return False
        if any(d in done or not pre[d] <= done for d in term):
            return False
        done.update(term)
    return required <= done


results = {}
for a, h in history.items():
    available = sorted(d for d in subjects if d not in h and pre[d] <= h)
    pending = required - h
    candidates = list(islice(schedules(h, pending, 12, 12), 20))
    check(f'Trilhas de {a}: {len(candidates)} conferidas',
          bool(candidates) and all(valid_schedule(a, 12, t) for t in candidates))
    results[a] = {'perfil': profiles[a], 'historico': sorted(h),
                  'creditos_cursados': credits(h), 'liberadas': available,
                  'pendentes_obrigatorias': sorted(pending),
                  'uma_trilha_max_12': candidates[0]}

elisa8 = list(schedules(history['elisa'], required - history['elisa'], 8, 12))
expected = [[['gestao_projetos', 'tcc2']], [['gestao_projetos'], ['tcc2']],
            [['tcc2'], ['gestao_projetos']]]
check('Elisa: exatamente 3 trilhas com 8 creditos', elisa8 == expected)
check('Elisa: exatamente 2 trilhas com 4 creditos',
      len(list(schedules(history['elisa'], required - history['elisa'], 4, 12))) == 2)
check('Diego: 7 semestres insuficientes',
      next(schedules(set(), required, 12, 7), None) is None)
check('Diego: 4 creditos por 12 semestres insuficientes',
      next(schedules(set(), required, 4, 12), None) is None)
check('Fabio: somente trilha vazia', results['fabio']['uma_trilha_max_12'] == [])
check('Creditos exatos', [results[a]['creditos_cursados'] for a in students] == [72,36,8,0,88,96])
changed = {d: ps.copy() for d, ps in pre.items()}
changed['algoritmos1'].add('compiladores')
check('Fixture cria ciclo detectavel', 'algoritmos1' in ancestors('algoritmos1', changed))
check('Descendente nao vira membro do ciclo', 'tcc2' not in ancestors('tcc2', changed))
check('Rejeita TCC1 e TCC2 simultaneos',
      not valid_schedule('ana', 24, [sorted(required - history['ana'])]))
check('Rejeita repeticao', not valid_schedule('elisa', 8,
      [['gestao_projetos'], ['gestao_projetos'], ['tcc2']]))
check('Rejeita excesso de creditos', not valid_schedule('elisa', 4, [['gestao_projetos','tcc2']]))
check('Rejeita semestre vazio', not valid_schedule('elisa', 8, [[], ['gestao_projetos','tcc2']]))
check('Rejeita trilha incompleta', not valid_schedule('elisa', 8, [['gestao_projetos']]))

# Confere automaticamente as listas literais esperadas nos testes Prolog.
test_text = (ROOT / 'tests' / 'consultas_teste.pl').read_text(encoding='utf-8')
for operation, a, literal in re.findall(
        r'disciplinas_(liberadas|pendentes)\((\w+),\s*\[([\w,\s]*)\]\)', test_text):
    actual = results[a]['liberadas' if operation == 'liberadas' else 'pendentes_obrigatorias']
    expected_list = [d.strip() for d in literal.split(',') if d.strip()]
    check(f'Literal de teste {operation}({a})', actual == expected_list)

output = ROOT / 'dados'
output.mkdir(exist_ok=True)
payload = {'origem': 'Grade e alunos ficticios; nao e a matriz oficial da PUCPR.',
           'validacao': 'Conferencia independente executada em Python; a bateria Prolog e registrada em docs/validacao.md.',
           'disciplinas': subjects,
           'prerequisitos': {d: sorted(ps) for d, ps in pre.items()},
           'alunos': results, 'trilhas_elisa_max_8': elisa8,
           'checagens_independentes': checks}
(output / 'dados.json').write_text(json.dumps(payload, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def pl(value):
    if isinstance(value, list):
        return '[' + ', '.join(pl(v) for v in value) + ']'
    return str(value)


lines = ['# Dados e resultados esperados', '',
         'Origem: fatos de `src/curriculum.pl`. Grade e alunos inteiramente didáticos.', '',
         '**Status:** resultados calculados e conferidos por Python. A execução do SWI-Prolog está registrada em `validacao.md`.', '',
         'As listas de elegibilidade incluem eletivas. Pendências e formatura consideram as obrigatórias.', '',
         '| Aluno | Perfil | Créditos cursados | Obrigatórias pendentes |',
         '|---|---|---:|---:|']
for a, r in results.items():
    lines.append(f"| {a} | {r['perfil']} | {r['creditos_cursados']} | {len(r['pendentes_obrigatorias'])} |")
for a, r in results.items():
    lines += ['', f'## {a}', '', '```prolog', f"% Liberadas\n{pl(r['liberadas'])}.",
              f"% Pendentes obrigatorias\n{pl(r['pendentes_obrigatorias'])}.", '```', '',
              'Uma trilha válida com limite de 12 créditos por semestre:', '',
              '| Semestre simulado | Disciplinas | Créditos |', '|---:|---|---:|']
    for i, term in enumerate(r['uma_trilha_max_12'], 1):
        lines.append(f"| {i} | {', '.join(term)} | {credits(term)} |")
    if not r['uma_trilha_max_12']:
        lines.append('| - | Nenhuma: todas as obrigatórias concluídas | 0 |')
lines += ['', '## Enumeração completa em instância pequena', '',
          '`findall(T, trilha_valida(elisa, 8, T), Ts).`', '', '```prolog',
          'Ts = ' + pl(elisa8) + '.', '```', '', '## Checagens independentes executadas', '']
lines.extend(f'- OK: {name}.' for name in checks)
lines += ['', '## Limite desta validação', '',
          'O conferente lê os fatos e verifica dados, exemplos e invariantes por uma implementação independente.',
          'Ele não interpreta o código Prolog e, por isso, complementa a bateria executada diretamente no SWI-Prolog.', '']
(ROOT / 'docs' / 'resultados_esperados.md').write_text('\n'.join(lines), encoding='utf-8')
print(f'OK: {len(checks)} checagens independentes em Python.')
for a, r in results.items():
    print(f"{a}: {r['creditos_cursados']} creditos; {len(r['pendentes_obrigatorias'])} pendentes; "
          f"{len(r['uma_trilha_max_12'])} semestres na trilha-exemplo")
