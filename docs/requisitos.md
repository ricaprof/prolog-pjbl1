# Correspondência com o enunciado

Referência: `PjBL 1.pdf`, sete páginas. Esta tabela registra a implementação e as evidências de validação; não é uma nota atribuída pelo professor.

| Requisito | Implementação/evidência | Status |
|---|---|---|
| Grupo de 4 integrantes | Identificação no README | Preencher apenas os nomes |
| Grade do curso | Base didática de Ciência da Computação | Escopo documentado |
| 20+ disciplinas, 6+ semestres e 3+ eletivas | 28 disciplinas, 8 semestres e 4 eletivas | Aprovado nos testes |
| Camada 1 somente fatos | `src/curriculum.pl` | Conferido pelo leitor de fatos |
| Um fato de pré-requisito por par | `prerequisito/2` | Dados sem duplicatas |
| Cadeia de profundidade >= 3 | De TCC2 até algoritmos1: 7 arestas | Dados conferidos |
| Três perfis de alunos | Ana, Bruno e Carla; mais três casos de borda | Dados conferidos |
| Cinco predicados de elegibilidade/créditos | `src/elegibilidade.pl` | Aprovados nos testes |
| Negação por falha e `forall/2` | `pode_cursar/2` e `prerequisitos_ok/2` | Implementados e documentados |
| `findall/3` ou `setof/3` | `findall/3` + `sort/2` | Escolha justificada |
| Fecho transitivo recursivo | `prerequisito_transitivo/2` e `caminho_pre/3` | Aprovado nos testes |
| Detecção de ciclo | `existe_ciclo/1` e fixture isolada | Aprovada nos testes |
| Geração via backtracking | `planejar/5`, `subconjunto_creditos/3` | Implementados |
| Respeitar pré-requisitos e créditos | Estado anterior + orçamento do subconjunto | Exemplos conferidos independentemente |
| Limite máximo de semestres | `limite_semestres(12)` | Implementado inclusive em base acíclica |
| Uma trilha do zero até formatura | Diego em `demo/0`, testes e resultados | Exemplo conferido independentemente |
| Múltiplas trilhas via findall/bagof | Elisa com duas pendências: três trilhas com limite 8 | Enumeração independente conferida |
| Sem efeitos de assert/retract | Estado em listas | Nenhuma mutação dinâmica no planejador |
| SWI-Prolog sem bibliotecas externas | Fontes sem `use_module` ou pacotes | Implementado |
| Carregar sem erro ou warning | Comando de carregamento no executor | Aprovado com SWI-Prolog 10.0.2 |
| `demo/0` com as três camadas | `src/main.pl` | Executado com sucesso |
| Aluno/disciplina inexistente | Falha por consulta aos fatos; testes específicos | Aprovado nos testes |
| Listar disciplinas de um semestre | Teste `semestre1` | Resultado conferido |
| Liberadas/pendentes de >= 2 alunos | Listas exatas para Ana e Bruno; outros cenários | Literais conferidos em Python |
| Caso decisivo de negação | Diego vs Carla + fixture de histórico | Implementado |
| Teste de ciclo em arquivo separado | `tests/ciclo_teste.pl` | Aprovado em processo isolado |
| Estrutura de entrega e documentação | Diretórios `src`, `tests`, `docs`, README e dados | Presentes no repositório |
| Justificativas e limitações | `docs/decisoes.md` | Documentadas |

## Escopo da garantia

O conferente independente lê a mesma base de fatos, checa referências, históricos, contagens, créditos, exemplos, listas esperadas e invariantes de trilhas. Ele complementa a bateria executada diretamente no SWI-Prolog.

A rubrica também pode avaliar o domínio individual do código, algo que não pode ser certificado automaticamente pelo projeto.
