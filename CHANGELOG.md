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
- `AgenticBootstrap::CLI` (Thor), comando `init [DIR]`, orquestrando os 9
  geradores com as opções `--no-docker`, `--no-ci`, `--no-observability`,
  `--profile [strict|pragmatic]`, `--language [ruby]` e
  `--example-domain NAME`. Testes de integração cobrindo o comando `init`
  e sua idempotência (rodar 2x não altera arquivos já customizados).
- `ExampleDomainGenerator` passa a aceitar `entity_name:` (usado por
  `--example-domain`), nomeando classes e arquivos gerados a partir do
  nome informado (mantendo `task` como padrão).
- `.gitattributes` (`* text=auto eol=lf`) para evitar que o `core.autocrlf`
  do Windows introduza CRLF nos arquivos do repositório.

### Known gaps

- `--no-observability` é aceito pela CLI mas ainda não está associado a
  nenhum gerador (stack de observabilidade ainda não implementada).

## [0.1.0] - Unreleased

- Versão inicial em desenvolvimento. Ainda não publicada.
