# CLAUDE.md — Guia de Colaboração IA-Humano

Este arquivo é o "cérebro" para qualquer IA (Claude Code, Claude em conversa
normal, ou outro agente) trabalhando neste repositório. Leia antes de
começar qualquer tarefa.

## Contexto do Projeto

`agentic_bootstrap` é uma gem CLI (Thor) que inicializa repositórios Ruby
com um ambiente pronto para desenvolvimento agentic: Arquitetura Hexagonal,
TDD-first, Docker, CI/CD e observabilidade. Veja o [README.md](README.md)
para visão geral e o [ROADMAP.md](ROADMAP.md) para o plano de fases atual.

## Fluxo de Trabalho (Spec-Driven Development)

Este projeto segue **Red → Green → Refactor** estritamente:

1. **Red**: escreva a spec (RSpec) que descreve o comportamento esperado.
   Rode `bundle exec rspec` e confirme que falha pelo motivo certo.
2. **Green**: implemente o mínimo necessário para a spec passar.
3. **Refactor**: limpe o código com as specs verdes como rede de segurança.
   Rode `bundle exec rubocop -A` e revise o que foi alterado automaticamente.

Nunca escreva uma classe geradora (`lib/agentic_bootstrap/generators/*`)
sem a spec correspondente já existir em `spec/generators/`.

### Comandos locais

```bash
bundle exec rspec              # roda toda a suíte
bundle exec rspec spec/path    # roda um arquivo específico
bundle exec rubocop            # lint (sem autofix)
bundle exec rubocop -A         # lint com autofix — revisar antes de commitar
bundle exec rake               # tarefa padrão (specs + rubocop)
```

## Fluxo com `ROADMAP.md`

- O `ROADMAP.md` define o escopo atual: fases e tarefas com checkboxes.
- Antes de iniciar uma tarefa nova, confira se ela está no `ROADMAP.md`.
- Ao concluir uma tarefa, marque o checkbox correspondente no mesmo commit
  que a implementa (evita divergência entre roadmap e código real).
- Não reordene ou remova fases já concluídas sem aprovação humana — adicione
  novas fases ao final ou peça revisão.

Fluxo: `CLAUDE.md` → `ROADMAP.md` → specs → código.

## Prompt Inicial Recomendado

Ao iniciar uma sessão nova sobre este projeto, um humano pode colar:

> Leia CLAUDE.md e ROADMAP.md. Pegue a próxima tarefa não concluída da fase
> atual, escreva a spec primeiro (Red), implemente (Green), rode rubocop e
> rspec, e pare para revisão antes de seguir para a próxima tarefa.

## Quando usar Claude Code vs. conversa normal

- **Claude Code** (com acesso ao filesystem e shell): implementação real,
  rodar specs/rubocop, criar/editar arquivos, commits.
- **Conversa normal**: discutir design, revisar trade-offs de arquitetura,
  planejar uma fase antes de implementar, revisar PRs sem executar código.

## Decisões da IA (Autoridade Total)

- [x] Escrever e atualizar specs (RSpec)
- [x] Implementar lógica de domínio (Red → Green → Refactor)
- [x] Refatorar código existente se as specs passarem
- [x] Sugerir melhorias de design e estrutura
- [x] Criar métodos e classes privadas
- [x] Marcar checkboxes concluídos no `ROADMAP.md`

## Decisões que Exigem Humano

- [ ] Adicionar ou remover gems (impacto em dependências)
- [ ] Mudanças em contrato público (API da gem, comandos Thor, opções CLI)
- [ ] Deletar specs ou código funcional
- [ ] Mudar arquitetura (portas, adaptadores, estrutura de pastas)
- [ ] Decisões de segurança ou performance crítica
- [ ] Publicar a gem (`gem push`)
- [ ] Criar/fechar issues e PRs, mudar o board do projeto

## Padrões de Código

- Modular: uma classe por responsabilidade.
- Injetável: dependências passadas no construtor, nunca globais.
- Testável: sem I/O real em specs — use `FakeFS` por padrão, `Tempfile`
  apenas quando for necessário validar permissões de arquivo reais.
- `--auto-gen-config` do RuboCop é proibido: corrija o código, não a config.

## Contrato de Testes para Geradores

Todo gerador (`*_generator.rb`) precisa de uma spec que valide, no mínimo:

```ruby
describe 'Geração de <arquivo>' do
  it 'cria o arquivo com as seções obrigatórias'
  it 'não sobrescreve um arquivo já existente (idempotência)'
end
```

## Versionamento

- Semver, começando em `0.1.0`.
- Toda mudança relevante entra no `CHANGELOG.md` (formato Keep a Changelog)
  no mesmo commit/PR que a introduz.
