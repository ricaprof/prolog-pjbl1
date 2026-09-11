# Como o projeto funciona

## 1. Fatos: o que existe

```prolog
disciplina(algoritmos2, obrigatoria, 4, 2).
prerequisito(algoritmos2, algoritmos1).
cursou(carla, algoritmos1).
```

Os fatos dizem que algoritmos2 é obrigatória, vale quatro créditos, é sugerida para o segundo semestre e depende de algoritmos1. Carla concluiu algoritmos1.

Para listar as disciplinas sugeridas para o primeiro semestre:

```prolog
findall(D, disciplina(D, _, _, 1), Lista).
% Lista = [algoritmos1, matematica_discreta, introducao_computacao].
```

`D` recebe o nome a coletar. Cada `_` é uma variável anônima independente: não queremos filtrar tipo e créditos nessa consulta.

## 2. Regras: o que pode ser feito agora

`prerequisitos_ok(carla, algoritmos2)` verifica cada pré-requisito direto e encontra `cursou(carla, algoritmos1)`. Depois `pode_cursar/2` verifica que algoritmos2 ainda não foi concluída. Assim a disciplina fica liberada.

Já `pode_cursar(carla, algoritmos1)` falha: algoritmos1 não tem pré-requisitos, mas já está cursada. Esse é o papel de `\+`.

Diego é cadastrado, mas não tem histórico. Ele pode cursar algoritmos1. Na fixture `historico_teste.pl`, acrescentamos `cursou(diego, algoritmos1)` em outro processo: algoritmos1 deixa de estar liberada e algoritmos2 passa a estar.

## 3. Créditos por recursão

`creditos_cursados/2` primeiro obtém o histórico sem duplicatas. A soma tem caso base `creditos_lista([], 0)` e caso recursivo que soma os créditos da cabeça ao total da cauda.

Exemplo de Carla: `[algoritmos1, introducao_computacao]` gera `4 + (4 + 0) = 8`.

## 4. Dependências indiretas

A cadeia abaixo contém sete relações diretas:

`tcc2 → tcc1 → projeto_integrador → compiladores → analise_algoritmos → estrutura_dados → algoritmos2 → algoritmos1`

A seta significa “depende de”. Portanto algoritmos1 é ancestral de tcc2. Existem ainda ramos de matemática, lógica e banco de dados, que também são considerados.

`caminho_pre/3` tenta primeiro encontrar uma aresta direta. Se não basta, escolhe um pré-requisito intermediário, registra a visita e continua a busca a partir dele.

Na expressão `[Proximo|Visitados]`, `Proximo` é a cabeça e `Visitados` é a lista que vira a cauda. Equivale, para listas, à construção Python `[proximo] + visitados`, não a `[proximo, visitados]`.

## 5. Ciclos

A fixture acrescenta `prerequisito(algoritmos1, compiladores)`. Como compiladores já depende indiretamente de algoritmos1, forma-se um ciclo.

A lista de visitados impede expansão infinita. O caso direto permite reconhecer o retorno ao início, fazendo `existe_ciclo(algoritmos1)` ter sucesso. O planejamento recusa a base antes de começar.

## 6. Uma trilha é uma lista de semestres

```prolog
[[gestao_projetos, tcc2]]
```

Essa trilha tem um semestre com duas disciplinas. Já:

```prolog
[[gestao_projetos], [tcc2]]
```

tem dois semestres. Para Elisa, ambas são válidas com limite oito, porque os pré-requisitos das duas já estão concluídos. A terceira alternativa é inverter esses dois semestres.

## 7. Backtracking na prática

Com as pendências `[gestao_projetos,tcc2]`, o seletor tenta incluir cada disciplina se houver créditos. Primeiro encontra o subconjunto com ambas. Ao pedir outra resposta com `;`, volta a uma escolha anterior e experimenta excluir uma. Assim pode colocar uma agora e a outra depois.

Não se escolhe apenas o “maior subconjunto”: incluir e excluir são alternativas reais. Isso é importante para enumerar múltiplas trilhas.

O histórico original não muda. Em cada ramo são criadas novas listas por unificação. O retorno a outro ramo restaura automaticamente as variáveis daquela execução.

## 8. Separação entre semestres

Se TCC1 e TCC2 ainda estão pendentes, TCC2 não aparece entre as liberadas enquanto TCC1 não estiver no histórico anterior. Escolher TCC1 para o semestre corrente só a adiciona ao estado usado no próximo passo.

Por isso o programa não trata pré-requisito como correquisito, mesmo quando o limite de créditos permitir as duas disciplinas juntas.

## 9. Parada e limites

Sem pendências, a cauda da trilha é `[]`. Com pendências e nenhum semestre disponível, não há solução. Também se falha cedo quando faltam mais créditos do que o limite agregado permite.

O limite padrão é 12 semestres. Isso limita a profundidade, mas não elimina a quantidade combinatória de alternativas. Para inspecionar um exemplo completo de Diego, prefira `once/1`.

## 10. O que cada integrante deve conseguir explicar

- Por que há um fato para cada relação de pré-requisito.
- Por que as variáveis precisam estar instanciadas antes da negação por falha.
- Por que `forall` verifica e `findall` coleta.
- Qual é o caso base de cada recursão e como ela progride.
- Como a lista de visitados permite detectar ciclos sem entrar em loop.
- Onde o backtracking gera escolhas alternativas de semestre.
- Por que não usamos `assert/retract` e por que a ordem temporal é respeitada.
- Quais hipóteses são didáticas e quais aspectos de uma universidade real não foram modelados.
