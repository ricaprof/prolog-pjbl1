# Decisões de modelagem e limitações

## 1. Origem dos dados

O enunciado pede representar a grade do curso, mas não fornece a matriz curricular, créditos oficiais nem pré-requisitos oficiais. Foi criada uma base didática coerente de Ciência da Computação. Ela atende aos mínimos quantitativos, mas **não comprova fidelidade à grade real**. O nível máximo da rubrica relativo à base realista depende dessa confirmação externa.

São 28 disciplinas, 24 obrigatórias, 4 eletivas, 8 semestres sugeridos e 6 alunos fictícios. Os identificadores são átomos sem acentos, com sublinhado. `obrigatoria` e `eletiva` são átomos, não strings.

Cada par disciplina/pré-requisito é um fato `prerequisito/2`. Múltiplos pré-requisitos são uma conjunção: todos precisam estar concluídos, não apenas um deles. As disciplinas e os históricos são fatos, sem regras na Camada 1.

## 2. Cadastro de alunos e histórico

`aluno/1` permite representar Diego sem nenhum `cursou/2`. Sem esse cadastro separado, a ausência de histórico poderia ser confundida com aluno inexistente.

`perfil/2` apenas descreve cenários didáticos. `cursou/2` significa aprovação/conclusão, não simples matrícula ou reprovação. Créditos cursados são somados uma vez por disciplina: `historico/2` elimina duplicatas antes da soma.

Antes do planejamento, `historico_consistente/1` exige que os ancestrais de cada disciplina concluída também tenham sido concluídos. Aproveitamentos de estudos e dispensas não são representados; exigiriam novos fatos e uma política específica.

## 3. Formatura e eletivas

O enunciado exige cadastrar eletivas, mas não define quantidade ou carga mínima delas para a formatura. A interpretação adotada é:

- `disciplinas_liberadas/2` inclui obrigatórias e eletivas elegíveis;
- `disciplinas_pendentes/2` lista somente obrigatórias não concluídas;
- `trilha_valida/3` conclui todas as obrigatórias pendentes e eventuais ancestrais necessários, inclusive eletivos se a base for estendida dessa forma;
- eletivas que não sejam necessárias à conclusão das obrigatórias não são inseridas na trilha;
- aluno com todas as obrigatórias cursadas tem exatamente a trilha vazia `[]`.

Na base entregue nenhuma obrigatória depende de eletiva. Não foram acrescentadas regras de estágio, TCC além das duas disciplinas cadastradas, extensão ou horas complementares, pois elas não fazem parte do escopo adotado para este projeto.

## 4. Semestre sugerido não é restrição

O campo de semestre é informativo; não impede antecipação. Por exemplo, ética pode ficar liberada após introdução à computação, embora seu semestre sugerido seja o oitavo. Os semestres da trilha são períodos futuros relativos ao histórico atual, não necessariamente os semestres sugeridos da matriz.

Não há restrições de oferta por semestre par/ímpar, horário, vagas, choque de turmas ou número mínimo de créditos. Essas regras não foram exigidas no PDF.

## 5. Negação por falha e forall

`prerequisitos_ok/2` primeiro enumera fatos de aluno e disciplina, e então usa `forall(prerequisito(D,P), cursou(A,P))`. Quando não há pré-requisitos, a condição é verdadeira por vacuidade, comportamento desejado para disciplinas iniciais.

`pode_cursar/2` usa `\+ cursou(A,D)` somente depois dessa instanciação. O significado é “não há prova de conclusão na base”, não “foi provada a não conclusão”. A base é tratada como completa para o cenário modelado, hipótese de mundo fechado.

`forall/2` verifica uma propriedade e não devolve uma coleção de valores. A coleta é feita separadamente.

## 6. findall, bagof e setof

| Predicado | Sem soluções | Duplicatas | Variáveis livres fora do modelo |
|---|---|---|---|
| `findall/3` | Retorna `[]` | Mantém | Tratadas existencialmente |
| `bagof/3` | Falha | Mantém | Agrupa soluções; `^` permite quantificação existencial |
| `setof/3` | Falha | Remove e ordena | Agrupa como `bagof/3` |

Na implementação usa-se `findall/3` seguido de `sort/2` nas listas em que se quer comportamento de conjunto e retorno `[]` no caso vazio. Não se escolheu `setof/3`, pois ele exigiria tratar explicitamente a falha para produzir listas vazias. Nas consultas por aluno, `aluno(A)` vem antes da coleta, preservando uma resposta por aluno quando A é variável.

`bagof/3` aparece no teste de múltiplas trilhas e no README. `findall/3` também coleta todas as trilhas da instância pequena de Elisa. Não há necessidade de usar todos os agregadores no código principal: o PDF exige pelo menos `findall` ou `setof`.

## 7. Fecho transitivo e ciclos

`caminho_pre/3` tem caso base para uma aresta direta e caso recursivo com lista de visitados. Uma expansão não pode visitar novamente um nó já expandido, portanto a recursão termina em uma base finita mesmo com ciclos.

O caso base é verificado antes do bloqueio de visitados, permitindo reconhecer a aresta que volta à origem. Assim `prerequisito_transitivo(D,D)` reconhece um caminho de comprimento positivo e identifica um ciclo; não se inclui reflexividade automaticamente.

O predicado público enumera pares cadastrados e usa `once/1` apenas na comprovação de cada par. Isso evita ancestrais duplicados quando existem caminhos alternativos. O backtracking entre diferentes pares permanece possível.

Um nó que apenas depende de um ciclo não necessariamente pertence ao ciclo. A fixture verifica que `tcc2` não passa a ser membro do ciclo artificial, embora o planejamento da base inteira seja recusado.

## 8. Planejamento e pureza

O estado é transportado em listas: pendentes, concluídas e semestres restantes. Não há `assert/retract`, nem variáveis globais mutáveis. Ao retroceder, o Prolog desfaz as unificações e pode tentar outro subconjunto sem contaminar o histórico original.

Em cada passo:

1. Identifica disciplinas pendentes com todos os ancestrais no histórico anterior.
2. Enumera subconjuntos não vazios cujo total cabe no limite.
3. Remove as escolhidas das pendências.
4. Adiciona as escolhidas ao histórico somente para o próximo semestre.
5. Recursa com um semestre disponível a menos.

Pré-requisitos não podem ser cursados no mesmo semestre da disciplina dependente. A recursão encerra somente quando não restam objetivos.

Dentro de um semestre, a ordem alfabética é canônica: `[a,b]` e `[b,a]` não contam como duas soluções distintas. A ordem dos semestres, ao contrário, importa. Semestres vazios são excluídos porque não há restrições de oferta que tornem útil esperar.

## 9. Limites e custo

`trilha_valida/3` permite no máximo 12 semestres. A extensão `/4`, chamada `trilha_valida_limite/4`, aceita limite entre 0 e 12. O limite de créditos deve ser inteiro positivo.

Há duas podas seguras: créditos restantes não podem ultrapassar a capacidade agregada dos semestres restantes, e nenhuma disciplina necessária pode exceder sozinha o limite por semestre. A seleção do subconjunto também poda inclusões que ultrapassariam o saldo de créditos.

Essas podas não removem trilhas válidas sob a semântica escolhida. Ainda assim, enumerar todas as partições e ordens é combinatório. Limite de profundidade garante finitude, **não rapidez**. Não há promessa de caminho mais curto ou de plano ótimo. A primeira solução é influenciada pela ordem alfabética e por tentar incluir antes de excluir.

Para uma solução use `once(trilha_valida(...))`. `findall(T, once(trilha_valida(...)), Ts)` também retornaria no máximo uma, mas `once/1` sozinho é mais direto. `findall/3` sem esse controle não significa “primeiro resultado”.

## 10. Erros e modos suportados

| Consulta | Comportamento pretendido |
|---|---|
| Aluno/disciplina não cadastrado | `false`, sem exceção |
| Aluno válido, nenhuma pendência | `[]` |
| Aluno válido, zero créditos cursados | `0` |
| Aluno e/ou disciplina livres nas regras de elegibilidade | Enumeração por fatos positivos |
| Disciplina/ancestral livres no fecho | Enumeração de pares alcançáveis |
| `Max` livre, texto, negativo, zero ou fracionário | `false` |
| Limite livre, inválido ou maior que 12 | `false` |
| Trilha variável | Gera trilhas |
| Trilha como lista própria | Confronta com as soluções geradas; ordem canônica exigida |
| Trilha como átomo ou lista imprópria | `false` |
| Base com ciclo ou referência inválida | Planejamento recusado |
| Histórico incoerente | Planejamento recusado para o aluno |

O projeto pressupõe uma base finita de fatos ground como a entregue. Não é um validador universal de termos Prolog arbitrários ou programas maliciosos. A validação da base roda antes da geração, não em todas as consultas simples de elegibilidade. Consultas de baixo nível aos fatos preservam a semântica normal do Prolog.

## 11. Testes isolados e estado da verificação

As fixtures usam `multifile` para acrescentar fatos em arquivos separados. Cada uma deve rodar em seu próprio processo, garantindo isolamento sem mutações dinâmicas. `main.pl` declara os predicados multifile antes de carregar os fatos.

O teste normal compara resultados exatos, exercita variáveis, entradas inválidas, créditos, ordem temporal e múltiplas soluções. Um verificador separado da geração confere cobertura, pré-requisitos diretos, ausência de duplicatas e créditos das trilhas.

Na validação de 18/09/2026, o projeto foi carregado e testado com SWI-Prolog 10.0.2: os 53 casos da bateria principal e as duas fixtures isoladas passaram. A demonstração também foi executada sem erros ou avisos. Em complemento, o conferente Python aprovou 37 checagens independentes dos dados e resultados.
