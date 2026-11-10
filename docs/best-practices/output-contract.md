# Contrato de saída

Todo token devolvido por um subagent entra no contexto de quem chamou e é pago de
novo a cada turno seguinte. Este contrato define o que agentes e skills devolvem.

## Regras gerais

1. **Referência, não conteúdo.** Devolva caminhos (`arquivo:linha`), nunca código,
   diff ou arquivo colado. Quem chamou lê o que precisar.
2. **Saída de comando resumida.** Testes, lint e build entram como contagem e falhas:
   `tests: 42 ok, 1 falhou — auth.test.ts:88 expected 401 got 200`. Nada de log inteiro.
3. **Sem narrativa.** Nada de "primeiro eu li…", nada de repetir a tarefa, nada de
   conclusão educada no fim.
4. **Teto.** O retorno de um subagent cabe em **~20 linhas**. Passou disso, corte o
   que quem chamou consegue obter sozinho (`git diff`, ler o arquivo).
5. **Bloqueio vem primeiro.** Se parou por dúvida ou erro, a primeira linha diz isso.

## Bloco padrão (agentes que alteram código)

```
status: ok | falhou | bloqueado
files: caminho/a.ts, caminho/b.ts
tests: <N ok, M falharam> — <falhas em arquivo:linha + 1 linha de motivo>
decisions: <só as não óbvias, 1 linha cada>   (omita se nenhuma)
risks/doubts: <1 linha cada>                  (omita se nenhum)
```

Campos vazios são omitidos, não preenchidos com "nenhum".

## Por agente

| agent | returns | cap |
|---|---|---|
| implementer-fast | bloco padrão sem `decisions` | ~10 linhas |
| implementer | bloco padrão | ~20 linhas |
| phase-planner | tabela + lotes + perguntas (já definido no agente) | a tabela |
| architect | o spec é o produto: grave em arquivo quando houver destino e devolva o caminho + resumo de 5 linhas | spec completo só se não houver arquivo |
| pr-reviewer | bloqueantes, sugestões, perguntas — 1 item por linha com `arquivo:linha` | sem elogios, sem resumo do diff |

## Lado do orquestrador (run-phase e afins)

- Passe ao subagent só o necessário: tarefa, arquivos, critério de pronto, comando de
  teste e "retorne no bloco padrão". Nada de JSON bruto ou histórico da conversa.
- Ao receber, confira com `git diff --stat` e o resultado dos testes; abra o diff
  completo só quando algo falhou ou parece errado.
- Para o usuário, uma linha por tarefa: `✔/✖ T<#> <agente> (<modelo>) — <resumo>`.

## Skills que falam com o usuário

Resposta final curta: o que mudou, onde está (link/caminho), o que falta. Detalhe só
quando pedido.
