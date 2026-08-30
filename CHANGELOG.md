# Changelog

Todas as mudanças notáveis deste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
e este projeto segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Added

- `GitignoreGenerator` → `.gitignore` (sempre gerado, faz parte da base) e
  `DockerignoreGenerator` → `.dockerignore` (parte do grupo `--no-docker`).
  Antes, a gem não gerava nenhum dos dois: um `git add .` logo após o `init`
  podia commitar `.env`, `coverage/`, `log/`, `tmp/` etc., e o `Dockerfile`
  gerado fazia `COPY . .` sem filtro nenhum — segredos e até o histórico do
  `.git` entravam nas camadas da imagem Docker. O `.clignore` já listava
  esses padrões como sensíveis para assistentes de IA, mas nada impedia de
  fato que fossem parar em `git`/imagem Docker. Novas specs:
  `spec/generators/gitignore_generator_spec.rb` e
  `spec/generators/dockerignore_generator_spec.rb`.

### Fixed

- **Segurança**: o estágio `production` do `Dockerfile.erb` rodava como
  root (nenhum estágio tinha diretiva `USER`). Adicionado usuário
  `app` não-root nesse estágio (`groupadd`/`useradd` + `COPY --chown`);
  os estágios `builder`/`development` continuam como root, de propósito,
  para não quebrar o bind mount de desenvolvimento (`docker-compose.yml`
  monta `.:/app`, e um usuário não-root ali gera conflito de permissão
  com o UID do host). Nova spec em
  `spec/generators/dockerfile_generator_spec.rb`.
- **Segurança**: `ExampleDomainGenerator` (usado por `--example-domain`) aceitava
  qualquer string como `entity_name` e a interpolava sem validação em caminhos
  de arquivo (`lib/domain/#{entity_name}.rb` etc.), permitindo path traversal
  (ex.: `--example-domain '../../../../tmp/evil'`) e escrita fora do diretório
  alvo. Também quebrava com `NoMethodError` para nomes com separador
  inicial/final/duplicado (ex.: `task_`, `_task`, `task__item`) e gerava
  constantes Ruby inválidas para nomes iniciados por dígito (ex.: `1task`).
  Adicionada validação (`VALID_ENTITY_NAME`) que rejeita esses casos com
  `ArgumentError` antes de qualquer escrita em disco. Nova spec:
  `spec/generators/example_domain_generator_spec.rb`.
- `CLI#init` tratava `--example-domain ''` (string vazia) como valor informado
  (truthy em Ruby), instanciando `ExampleDomainGenerator` desnecessariamente
  e, após o fix acima, propagando um `ArgumentError`. Agora string vazia é
  tratada como "não informado", igual a omitir a opção: nenhum gerador é
  instanciado, nenhum erro é levantado. Nova spec: `spec/cli_spec.rb`.
- CI (`.github/workflows/ruby.yml`) quebrado em todas as versões da matrix:
  o pin de `ruby/setup-ruby` estava em um SHA antigo (v1.146.0) cujo
  manifesto de versões não reconhece a imagem atual do runner `ubuntu-latest`
  (`ubuntu-24.04`) nem tem build de Ruby 3.3 para ela. Atualizado o pin para
  `95ef2b0` (v1.321.0).

## [0.1.0] - 2026-08-29

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

### Fixed

- **Crítico**: `agentic_dev_workflow.gemspec` empacotava apenas `lib/**/*.rb`,
  excluindo os 13 templates ERB usados pelos geradores
  (`lib/agentic_dev_workflow/templates/*.erb`). Um `gem install` real (fora
  da árvore-fonte) quebrava imediatamente com `Errno::ENOENT` ao tentar
  carregar qualquer template — bug não detectado antes porque toda
  verificação anterior rodava via `-Ilib` direto no código-fonte, nunca
  contra o `.gem` de fato instalado. Encontrado em revisão de código;
  corrigido incluindo `lib/**/*.erb` em `spec.files` e verificado via
  `gem build` + `gem install` + execução do binário instalado de verdade.
  Nova spec de regressão: `spec/gemspec_spec.rb`.
- `ci.yml.erb` (template gerado para projetos-alvo) não rodava nenhuma
  verificação de dependências — lacuna apontada desde `docs/prompt_gem_ruby_v2.md`
  e nunca endereçada. Adicionado passo `bundler-audit` ao workflow gerado.
- `docker-compose.observability.yml.erb` fixava
  `GF_SECURITY_ADMIN_PASSWORD=admin` no Grafana gerado para todo projeto-alvo.
  Substituído por `${GRAFANA_ADMIN_PASSWORD:?...}`, que falha alto se a
  variável não for definida em vez de usar uma senha fraca por padrão.

### Documented

- `--language` esclarecido como placeholder reservado para extensão futura:
  hoje só `ruby` é aceito e a opção não altera nenhum gerador. Decisão do
  mantenedor manter a opção (em vez de remover, o que mudaria o contrato
  público da CLI) — ver descrição atualizada em `--help` e no README.

Versão inicial. `gem push` (publicação no RubyGems.org) segue pendente de
aprovação humana explícita (ver [CLAUDE.md](CLAUDE.md#decisões-que-exigem-humano));
esta release disponibiliza o `.gem` como asset da GitHub Release.
