# Changelog

Todas as mudanças notáveis deste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Added

- Estrutura inicial do repositório: `README.md`, `CLAUDE.md`, `ROADMAP.md`,
  `CHANGELOG.md`.
- Estrutura de pastas da gem (`lib/agentic_bootstrap/`, `spec/`).
- `Gemfile` com dependências de desenvolvimento/teste (thor, rspec, rubocop,
  rubocop-rspec, faker, shoulda-matchers, fakefs).
- `.rspec` e `spec/spec_helper.rb` configurados.
- Primeira spec (Red): `spec/generators/claude_md_generator_spec.rb`,
  definindo o contrato de `AgenticBootstrap::Generators::ClaudeMdGenerator`.
- `AgenticBootstrap::Generators::BaseGenerator`: classe base com escrita
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

## [0.1.0] - Unreleased

- Versão inicial em desenvolvimento. Ainda não publicada.
