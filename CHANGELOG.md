# Changelog

Todas as mudanças notáveis deste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Added

- Estrutura inicial do repositório: `README.md`, `CLAUDE.md`, `ROADMAP.md`,
  `CHANGELOG.md`.
- Estrutura de pastas da gem (`lib/agentic_dev_workflow/`, `spec/`).
- `Gemfile` com dependências de desenvolvimento/teste (thor, rspec, rubocop,
  rubocop-rspec, faker, shoulda-matchers, fakefs).
- `.rspec` e `spec/spec_helper.rb` configurados.
- Primeira spec (Red): `spec/generators/claude_md_generator_spec.rb`,
  definindo o contrato de `AgenticDevWorkflow::Generators::ClaudeMdGenerator`.
- `AgenticDevWorkflow::Generators::BaseGenerator`: classe base com escrita
  idempotente de arquivos e carregamento de templates ERB.
- Geradores da Fase 2 (Red → Green → Refactor, todos com spec e 100% verdes):
  `ClaudeMdGenerator`, `RoadmapGenerator`, `ClignoreGenerator`,
  `RspecGenerator`, `RubocopGenerator` (perfis `strict`/`pragmatic`),
  `DockerfileGenerator` (multi-stage builder/development/production),
  `DockerComposeGenerator`, `GitHubActionsGenerator` e
  `ExampleDomainGenerator` (exemplo de Arquitetura Hexagonal com
  domain/ports/adapters).
- `.rubocop.yml` do próprio repositório da gem (não confundir com o
  template gerado para projetos-alvo).
- `AgenticDevWorkflow::CLI` (Thor), comando `init [DIR]`, orquestrando os 9
  geradores com as opções `--no-docker`, `--no-ci`, `--no-observability`,
  `--profile [strict|pragmatic]`, `--language [ruby]` e
  `--example-domain NAME`. Testes de integração cobrindo o comando `init`
  e sua idempotência (rodar 2x não altera arquivos já customizados).
- `ExampleDomainGenerator` passa a aceitar `entity_name:` (usado por
  `--example-domain`), nomeando classes e arquivos gerados a partir do
  nome informado (mantendo `task` como padrão).
- `.gitattributes` (`* text=auto eol=lf`) para evitar que o `core.autocrlf`
  do Windows introduza CRLF nos arquivos do repositório.
- `AgenticDevWorkflow::Generators::ObservabilityGenerator` (Fase 5): gera
  `docker-compose.observability.yml` (Prometheus + Grafana) e
  `observability/prometheus.yml` no projeto-alvo. `--no-observability`
  agora efetivamente pula esses arquivos na `CLI`.
- `lib/agentic_dev_workflow/version.rb` e `lib/agentic_dev_workflow.rb`
  (entrypoint da gem).
- `exe/agentic_dev_workflow`: executável do comando `agentic_dev_workflow`.
- `agentic_dev_workflow.gemspec` (Fase 4), pronto para `gem build`.
  `Gemfile` passa a usar `gemspec` em vez de declarar `thor` diretamente.
- `Rakefile` com a task padrão (`bundle exec rake` roda specs + RuboCop),
  documentada em `CLAUDE.md` mas ausente até agora.
- `simplecov` (dev/test) para medir cobertura de testes; `spec/spec_helper.rb`
  exige `minimum_coverage 100`. Cobertura atual: 100% (149/149 linhas).

### Changed

- Gem renomeada de `agentic_bootstrap` para `agentic_dev_workflow` (módulo
  `AgenticBootstrap` → `AgenticDevWorkflow`), para ficar consistente com o
  nome do repositório no GitHub. Como a gem ainda não foi publicada, o
  histórico deste changelog já reflete o novo nome.

## [0.1.0] - Ainda não publicada

Versão inicial em desenvolvimento. `gem push` pendente de aprovação humana
(ver [CLAUDE.md](CLAUDE.md#decisões-que-exigem-humano)).
