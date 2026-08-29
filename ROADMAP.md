# Roadmap — Trilha de Desenvolvimento

Este roadmap espelha o board do projeto no GitHub (Projects v2). Cada fase
abaixo corresponde a uma coluna/milestone no board. Ao concluir uma tarefa,
marque o checkbox aqui e mova o item correspondente no board.

Veja [CLAUDE.md](CLAUDE.md) para o fluxo de trabalho (Red → Green → Refactor)
e as regras de quando marcar uma tarefa como concluída.

## Fase 1: Estrutura Inicial + Primeiro Teste

- [x] Estrutura de pastas da gem (`lib/`, `spec/`, etc.)
- [x] `Gemfile` com dependências (thor, rspec, rubocop, faker, shoulda-matchers, fakefs)
- [x] `spec/spec_helper.rb` configurado
- [x] `.rspec` pronto
- [x] Primeiro teste: `spec/generators/claude_md_generator_spec.rb`
      (valida que `ClaudeMdGenerator` gera `CLAUDE.md` com seções obrigatórias;
      Red confirmado via `bundle exec rspec` — `LoadError` esperado, classe
      ainda não implementada)
- [x] Aguardar aprovação humana antes de seguir para a Fase 2

## Fase 2: Implementação de Geradores (Red → Green → Refactor)

- [x] `ClaudeMdGenerator` → `CLAUDE.md`
- [x] `RoadmapGenerator` → `ROADMAP.md`
- [x] `ClignoreGenerator` → `.clignore`
- [x] `RspecGenerator` → `.rspec` + `spec_helper.rb`
- [x] `RubocopGenerator` → `.rubocop.yml` (profiles `strict`/`pragmatic`)
- [x] `DockerfileGenerator` → `Dockerfile` (multi-stage: builder/development/production)
- [x] `DockerComposeGenerator` → `docker-compose.yml`
- [x] `GitHubActionsGenerator` → `.github/workflows/ci.yml`
- [x] `ExampleDomainGenerator` → `lib/domain/`, `lib/ports/`, `lib/adapters/` com exemplo

## Fase 3: CLI (Thor) + Integração

- [x] Classe `Cli` com comando `init`
- [x] Orquestrar geradores em sequência
- [x] Suportar opções (`--no-docker`, `--no-ci`, `--no-observability`,
      `--profile`, `--language`, `--example-domain`)
- [x] Garantir idempotência: rodar `init` 2x não quebra nada
- [x] Testes de integração (todos os geradores juntos)

## Fase 4: Testes e Polimento

- [ ] 100% de cobertura de testes
- [ ] RuboCop limpo (zero offenses, sem `--auto-gen-config`)
- [ ] `README.md` com instruções de uso completas
- [ ] `CHANGELOG.md` preenchido
- [ ] `agentic_bootstrap.gemspec` pronto para `gem push`

## Fase 5: Observabilidade

- [x] `ObservabilityGenerator` → `docker-compose.observability.yml`
      (Prometheus + Grafana) e `observability/prometheus.yml`
- [x] Associar `--no-observability` a `ObservabilityGenerator` na `CLI`
- [x] Testes de integração cobrindo `--no-observability`
