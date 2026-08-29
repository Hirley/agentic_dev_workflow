# Roadmap — Trilha de Desenvolvimento

Este roadmap espelha o board do projeto no GitHub (Projects v2). Cada fase
abaixo corresponde a uma coluna/milestone no board. Ao concluir uma tarefa,
marque o checkbox aqui e mova o item correspondente no board.

Veja [CLAUDE.md](CLAUDE.md) para o fluxo de trabalho (Red → Green → Refactor)
e as regras de quando marcar uma tarefa como concluída.

## Fase 1: Estrutura Inicial + Primeiro Teste

- [ ] Estrutura de pastas da gem (`lib/`, `spec/`, etc.)
- [ ] `Gemfile` com dependências (thor, rspec, rubocop, faker, shoulda-matchers)
- [ ] `spec/spec_helper.rb` configurado
- [ ] `.rspec` pronto
- [ ] Primeiro teste: `spec/generators/claude_md_generator_spec.rb`
      (valida que `ClaudeMdGenerator` gera `CLAUDE.md` com seções obrigatórias)
- [ ] Aguardar aprovação humana antes de seguir para a Fase 2

## Fase 2: Implementação de Geradores (Red → Green → Refactor)

- [ ] `ClaudeMdGenerator` → `CLAUDE.md`
- [ ] `RoadmapGenerator` → `ROADMAP.md`
- [ ] `ClignoreGenerator` → `.clignore`
- [ ] `RspecGenerator` → `.rspec` + `spec_helper.rb`
- [ ] `RubocopGenerator` → `.rubocop.yml` (profiles `strict`/`pragmatic`)
- [ ] `DockerfileGenerator` → `Dockerfile` (multi-stage: builder/development/production)
- [ ] `DockerComposeGenerator` → `docker-compose.yml`
- [ ] `GitHubActionsGenerator` → `.github/workflows/ci.yml`
- [ ] `ExampleDomainGenerator` → `lib/domain/`, `lib/ports/`, `lib/adapters/` com exemplo

## Fase 3: CLI (Thor) + Integração

- [ ] Classe `Cli` com comando `init`
- [ ] Orquestrar geradores em sequência
- [ ] Suportar opções (`--no-docker`, `--no-ci`, `--no-observability`,
      `--profile`, `--language`, `--example-domain`)
- [ ] Garantir idempotência: rodar `init` 2x não quebra nada
- [ ] Testes de integração (todos os geradores juntos)

## Fase 4: Testes e Polimento

- [ ] 100% de cobertura de testes
- [ ] RuboCop limpo (zero offenses, sem `--auto-gen-config`)
- [ ] `README.md` com instruções de uso completas
- [ ] `CHANGELOG.md` preenchido
- [ ] `agentic_bootstrap.gemspec` pronto para `gem push`
