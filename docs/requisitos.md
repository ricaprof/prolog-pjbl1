# Correspondência com o enunciado

Referência: `PjBL 1.pdf`, sete páginas. Esta tabela registra implementação e pontos a confirmar; não é uma nota atribuída pelo professor.

| Requisito | Implementação/evidência | Status |
|---|---|---|
| Grupo de 4 integrantes | Identificação no README | Preencher pelo grupo |
| Grade do próprio curso | Base didática de Computação | Matriz oficial não fornecida; confirmar/substituir |
| 20+ disciplinas, 6+ semestres e 3+ eletivas | 28 disciplinas, 8 semestres e 4 eletivas | Dados conferidos em Python |
| Camada 1 somente fatos | `src/curriculum.pl` | Conferido pelo leitor de fatos |
| Um fato de pré-requisito por par | `prerequisito/2` | Dados sem duplicatas |
| Cadeia de profundidade >= 3 | De TCC2 até algoritmos1: 7 arestas | Dados conferidos |
| Três perfis de alunos | Ana, Bruno e Carla; mais três casos de borda | Dados conferidos |
| Cinco predicados de elegibilidade/créditos | `src/elegibilidade.pl` | Implementados; execução SWI pendente |
| Negação por falha e `forall/2` | `pode_cursar/2` e `prerequisitos_ok/2` | Implementados e documentados |
| `findall/3` ou `setof/3` | `findall/3` + `sort/2` | Escolha justificada |
| Fecho transitivo recursivo | `prerequisito_transitivo/2` e `caminho_pre/3` | Implementados; execução SWI pendente |
| Detecção de ciclo | `existe_ciclo/1` e fixture isolada | Implementados; execução SWI pendente |
| Geração via backtracking | `planejar/5`, `subconjunto_creditos/3` | Implementados |
| Respeitar pré-requisitos e créditos | Estado anterior + orçamento do subconjunto | Exemplos conferidos independentemente |
| Limite máximo de semestres | `limite_semestres(12)` | Implementado inclusive em base acíclica |
| Uma trilha do zero até formatura | Diego em `demo/0`, testes e resultados | Exemplo conferido independentemente |
| Múltiplas trilhas via findall/bagof | Elisa com duas pendências: três trilhas com limite 8 | Enumeração independente conferida |
| Sem efeitos de assert/retract | Estado em listas | Nenhuma mutação dinâmica no planejador |
| SWI-Prolog sem bibliotecas externas | Fontes sem `use_module` ou pacotes | Implementado |
| Carregar sem erro ou warning | Comando de carregamento no executor | **Pendente executar em SWI-Prolog** |
| `demo/0` com as três camadas | `src/main.pl` | Implementado |
| Aluno/disciplina inexistente | Falha por consulta aos fatos; testes específicos | Implementado; execução SWI pendente |
| Listar disciplinas de um semestre | Teste `semestre1` | Resultado conferido |
| Liberadas/pendentes de >= 2 alunos | Listas exatas para Ana e Bruno; outros cenários | Literais conferidos em Python |
| Caso decisivo de negação | Diego vs Carla + fixture de histórico | Implementado |
| Teste de ciclo em arquivo separado | `tests/ciclo_teste.pl` | Executar em processo isolado |
| Estrutura de entrega e documentação | Diretórios `src`, `tests`, `docs`, README e dados | Incluídos no ZIP |
| Justificativas e limitações | `docs/decisoes.md` | Documentadas |

## Escopo da garantia

O conferente independente lê a mesma base de fatos, checa referências, históricos, contagens, créditos, exemplos, listas esperadas e invariantes de trilhas. Isso oferece evidência sobre os dados e a modelagem, mas **não substitui a execução do código Prolog**.

A rubrica também avalia domínio individual e fidelidade da grade. Esses itens não podem ser certificados por este pacote. Não se presume nota 10 nem aprovação automática.
