# `agentic_bootstrap` — Gem CLI para Desenvolvimento Agentic em Ruby

## Crítica Construtiva do `prompt_v1` (Advocate do Diabo)

### Pontos Fortes
- ✅ Propósito claro: standardizar ambientes para Claude Code
- ✅ Reconhece a importância de Arquitetura Hexagonal
- ✅ Força TDD desde o início (espíritual, não só código)
- ✅ Inclui infraestrutura (Docker, CI/CD, observabilidade)

### Lacunas e Riscos Críticos

#### 1. **Falta de Guia Explícito para Colaboração IA-Humano**
- Define `CLAUDE.md`, mas não ensina *como* a IA deve interagir com o repositório
- Não inclui regras de commit, nomenclatura de branches, ou workflow de PR
- Uma IA seguindo instruções incompletas cometerá erros repetitivos

**Solução**: `CLAUDE.md` deve ter seções sobre:
- Prompt inicial recomendado
- Quando usar `claude code` vs conversas normais
- Decisões que exigem humano, decisões que a IA pode tomar sozinha
- Como ler/atualizar o `ROADMAP.md` sem conflitos

#### 2. **Estrutura Hexagonal, Mas Sem Exemplo Concreto**
- Criar pastas vazias não educa; desenvolvedores (e IAs) não sabem o que vai onde
- A gem gera `lib/domain/`, `lib/adapters/`, mas qual é a primeira classe? Onde ela vive?

**Solução**: Gerar um exemplo completo:
```ruby
# lib/domain/example_entity.rb (entidade sem efeitos colaterais)
# lib/ports/example_port.rb (interface)
# lib/adapters/example_adapter.rb (implementação)
# spec/domain/example_entity_spec.rb (teste do domínio)
```
Pequeno o bastante para deletar, grande o bastante para entender o padrão.

#### 3. **RuboCop Sem Defaults Sensatos**
- `.rubocop.yml` "estritas" precisa de dados: quais regras? Qual estilo?
- "Estritas" para quem? Um CLI simples não precisa dos mesmos padrões de uma API REST

**Solução**: Oferecer dois profiles:
- `strict` (API, backend): max line length 100, 6 methods per class, documentação obrigatória
- `pragmatic` (CLI, scripts): max line length 120, mais tolerância com método simples

#### 4. **Docker Sem Decisão sobre Strategy de Build**
- `Dockerfile` "enxuto focado em desenvolvimento/testes" é vago
- Build em desenvolvimento = lento. Build para produção = sem ferramentas. Qual é o foco?

**Solução**: Dockerfile com dois stages:
- `development`: tudo (build tools, gems de teste, debugger)
- `production`: só runtime (ou não incluir, deixar pra quem deploy)

#### 5. **CI/CD Sem Verificação de Segurança**
- `.github/workflows/ci.yml` roda `rspec`, `rubocop`, build Docker
- Não roda verificação de dependências (bundler audit, dependabot)
- Não roda SAST (code analysis estático)
- Uma gem produzida aqui pode vazar vulnerabilidades

**Solução**: Adicionar ao CI:
```yaml
- bundle audit check --update
- bundle exec brakeman -q -z # SAST para Rails
- gem push --verbose # ou apenas notify que está pronto
```

#### 6. **Sem Guia sobre Versionamento da Gem**
- Depois de pronta, como atualizar? Semver? Changelog?
- Gem versionada sem CHANGELOG é gem sem histórico

**Solução**: Gerar:
- `CHANGELOG.md` com template semver
- `lib/<gem_name>/version.rb`
- Rake task para bump de versão

#### 7. **FakeFS para Testes — Sim, Mas Qual é o Contrato?**
- "use bibliotecas como `FakeFS` se necessário" não é instrução
- Testes de geração de arquivo precisam de clarezas: o que validar? Só existência? Conteúdo?

**Solução**: Especificar o contrato:
```ruby
# spec/generators/claude_md_generator_spec.rb
describe 'CLAUDE.md generation' do
  it 'creates CLAUDE.md with all required sections' do
    # Validar: arquivo existe, contém "Spec-Driven Development", contém comandos locais
  end
  it 'does not overwrite existing CLAUDE.md' do
    # Validar: idempotência
  end
end
```

#### 8. **Configuração do RSpec Sem Compartilhamento de Padrões**
- Gerar `spec/spec_helper.rb` padrão, mas qual é ele?
- Qual é o padrão de matcher? Que gems de teste adicionar?

**Solução**: `spec_helper.rb` incluir:
```ruby
require 'faker'
require 'shoulda-matchers'

RSpec.configure do |config|
  config.formatter = :documentation
  config.order = :random
  config.include Shoulda::Matchers::ActiveRecord # se Rails
end
```

---

## `prompt_gem_ruby` — Versão Aprimorada

Acima estão as críticas. Aqui está o prompt que a IA deve seguir para criar a gem *certa* da primeira vez.

---

# Prompt: Construir `agentic_bootstrap` com Agentic Development Workflow

## Contexto e Objetivo

Você é um **Engenheiro de Software Especialista em Ruby, Arquitetura Hexagonal e Agentic Development Workflow**. Seu objetivo é criar uma **gem CLI (Thor)** chamada `agentic_bootstrap` que inicializa repositórios Ruby existentes com um ambiente otimizado para **colaboração entre humanos e IAs (Claude Code, Claude em conversas normais, ou futuros agentes)**.

A gem funciona como um **bootstrap inteligente**: rodada uma vez no diretório do projeto, ela injeta:
1. Arquitetura Hexagonal pronta para uso
2. TDD/BDD como primeiro-class citizen
3. Guias e contatos explícitos para desenvolvimento com IA
4. Infraestrutura local (Docker) e em nuvem (CI/CD)
5. Observabilidade desde o início
6. Boas práticas de versionamento e changelog

**Contexto Real**: Este projeto nasceu observando [AIAD — Assistente Inteligente de Análise de Documentos](https://github.com/Hirley/AIAD), um sistema que implementa:
- RAG (Retrieval-Augmented Generation) + Agents (ReAct, PlanAndSolve)
- Arquitetura Hexagonal com injeção de dependência
- Testes de unidade (RSpec) + aceitação (Cucumber)
- Observabilidade produção-ready (Prometheus, Grafana, Loki, Langfuse)
- Docker multi-stage com perfis de desenvolvimento/teste/produção
- CI/CD robusto (GitHub Actions)

Você vai **aplicar as lições do AIAD** para criar a gem. Estude a decisões arquiteturais; reproduza as que funcionam.

---

## Especificações Técnicas

### 1. Gem CLI — Estrutura e Dependências

#### Dependências (Gemfile)
```ruby
gem 'thor', '~> 1.2'             # CLI framework
gem 'fileutils'                  # Standard lib, manipulação de arquivos
gem 'erb'                        # Templates (geração de arquivos)

# Development / Test
gem 'rspec', '~> 3.12'           # Testes unitários
gem 'rspec-core'                 # Core do RSpec
gem 'rubocop', '~> 1.50'         # Linter
gem 'rubocop-rspec'              # RuboCop para specs
gem 'rake', '~> 13.0'            # Task runner
gem 'bundler', '~> 2.0'          # Gerenciador de gems
gem 'faker', '~> 3.0'            # Dados fake para testes
gem 'shoulda-matchers', '~> 5.0' # Matchers RSpec
```

#### Estrutura de Pastas da Gem

```
agentic_bootstrap/
├── lib/
│   ├── agentic_bootstrap/
│   │   ├── version.rb
│   │   ├── cli.rb                       # Thor commands
│   │   ├── generators/
│   │   │   ├── base_generator.rb        # Classe base
│   │   │   ├── claude_md_generator.rb
│   │   │   ├── roadmap_generator.rb
│   │   │   ├── clignore_generator.rb
│   │   │   ├── rspec_generator.rb
│   │   │   ├── rubocop_generator.rb
│   │   │   ├── dockerfile_generator.rb
│   │   │   ├── docker_compose_generator.rb
│   │   │   ├── github_actions_generator.rb
│   │   │   └── example_domain_generator.rb  # NEW
│   │   ├── templates/
│   │   │   ├── claude.md.erb
│   │   │   ├── roadmap.md.erb
│   │   │   ├── .clignore.erb
│   │   │   ├── .rspec.erb
│   │   │   ├── spec_helper.rb.erb
│   │   │   ├── .rubocop.yml.erb
│   │   │   ├── Dockerfile.erb
│   │   │   ├── docker-compose.yml.erb
│   │   │   ├── ci.yml.erb
│   │   │   └── example_entity.rb.erb    # NEW
│   │   └── utils/
│   │       └── idempotency_checker.rb   # Verifica sobreescrita
│   └── agentic_bootstrap.rb             # Entrypoint
├── spec/
│   ├── spec_helper.rb
│   ├── agentic_bootstrap_spec.rb
│   ├── generators/
│   │   ├── base_generator_spec.rb
│   │   ├── claude_md_generator_spec.rb
│   │   ├── rspec_generator_spec.rb
│   │   ├── dockerfile_generator_spec.rb
│   │   └── ...
│   └── support/
│       └── file_helpers.rb              # Helpers para testes de arquivo
├── .rubocop.yml
├── .rspec
├── Rakefile
├── Gemfile
├── Gemfile.lock
├── README.md
├── CHANGELOG.md
├── LICENSE
└── agentic_bootstrap.gemspec
```

### 2. Comandos CLI (Thor)

```bash
# Inicialização completa
agentic_bootstrap init [OPTIONS]

# Opções
--no-docker             # Pula Docker, Dockerfile, docker-compose
--no-ci                 # Pula GitHub Actions
--no-observability      # Pula stack de observabilidade
--profile [strict|pragmatic]  # Escolhe RuboCop profile
--language [ruby|python] # Ruby ou Python (extensível)
--example-domain NAME   # Cria exemplo com NAME em vez de genérico

# Exemplo
agentic_bootstrap init --profile pragmatic --language ruby --example-domain User
```

---

## 3. Artefatos Gerados

### A. `CLAUDE.md` (Cérebro do Agente)

**Requisitos**:
- Ensine a IA sobre **Spec-Driven Development (SDD)**: Red → Green → Refactor
- Explique o workflow local: `bundle exec rspec`, `bundle exec rubocop -A`, `git flow`
- Defina **decisões que a IA pode tomar sozinha** vs **decisões que exigem humano**
  - ✅ Pode: escrever specs, implementar red-green-refactor, refatorar
  - ⚠️ Precisa de humano: mudar arquitetura, delete de API pública, mudança de gems
- Inclua **prompt inicial recomendado** (template que humano copia para iniciar trabalho)
- Mencione o `ROADMAP.md` e como mantê-lo atualizado
- Referencie `CLAUDE.md` → `ROADMAP.md` → specs → código como fluxo

**Exemplo de Seção de Decisões**:
```markdown
### Decisões da IA (Autoridade Total)
- [ ] Escrever e atualizar specs (RSpec)
- [ ] Implementar lógica de domínio (Red → Green → Refactor)
- [ ] Refatorar código existente se specs passarem
- [ ] Sugerir melhorias de design e estructura
- [ ] Criar métodos e classes privadas

### Decisões que Exigem Humano
- [ ] Adicionar/remover gems (impacto)
- [ ] Mudanças em contrato público (API)
- [ ] Deletar specs ou código funcional
- [ ] Mudar arquitetura (portas, adaptadores)
- [ ] Decisões de segurança ou performance crítica
```

### B. `ROADMAP.md` (Trilha de Aprendizagem)

**Requisitos**:
- Template de fases (Fase 1: Setup, Fase 2: Domain Core, etc.)
- Checkboxes para tarefas (`[ ] Tarefa`)
- Vinculado ao `CLAUDE.md`: é o `ROADMAP` que define o escopo
- Exemplo de primeira fase preenchida (para parecer real)

**Template Básico**:
```markdown
# Roadmap — Trilha de Desenvolvimento

## Fase 1: Setup e Fundação
- [x] Estrutura Hexagonal criada
- [x] Testes rodando (RSpec)
- [ ] Primeira entidade de domínio (spec + implementação)
- [ ] Docker local funcionando

## Fase 2: Core Domain
- [ ] Implementar porta para repositório
- [ ] Implementar adaptador (em memória primeiro)
- [ ] Testes de integração porta ↔ adapter

## Fase 3: Observabilidade
- [ ] Adicionar logs estruturados
- [ ] Adicionar métricas (Prometheus)
- [ ] Dashboard Grafana

## Fase 4: Deploy
- [ ] CI/CD rodando no GitHub Actions
- [ ] Imagem Docker pronta
- [ ] Documentação de deployment
```

### C. `.clignore`

**Conteúdo Padrão**:
```
coverage/
tmp/
log/
.git/
vendor/
.bundle/
*.gem
.DS_Store
node_modules/
public/assets/
spec/tmp/
.env.local
.env.*.local
```

**Lógica**: Economizar contexto da IA; são arquivos que a IA não deve ler.

### D. Configuração RSpec (`.rspec` e `spec/spec_helper.rb`)

#### `.rspec`
```
--require spec_helper
--format documentation
--color
--order random
```

#### `spec/spec_helper.rb`
```ruby
ENV['RACK_ENV'] ||= 'test'

require 'rspec'
require 'faker'
require 'shoulda-matchers'

# Injetar shared examples
Dir['spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  config.example_status_persistence_file_path = 'spec/examples.txt'

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end
end
```

### E. RuboCop (`.rubocop.yml`)

**Dois Profiles**: `strict` e `pragmatic`

#### Profile: `strict` (APIs, domínio crítico)
```yaml
require:
  - rubocop-rspec

AllCops:
  TargetRubyVersion: 3.1
  Exclude:
    - 'vendor/**/*'
    - 'bin/**/*'
    - 'db/schema.rb'

Metrics/LineLength:
  Max: 100
  Exclude:
    - 'spec/**/*'

Metrics/MethodLength:
  Max: 15
  Exclude:
    - 'spec/**/*'

Metrics/ClassLength:
  Max: 150

Metrics/AbcSize:
  Max: 20

Layout/DocStringFormatting:
  Enabled: true

RSpec/ExampleLength:
  Max: 10

# Forçar estilo
Style/StringLiterals:
  EnforcedStyle: double_quotes

Style/Documentation:
  Enabled: true
  Exclude:
    - 'spec/**/*'
```

#### Profile: `pragmatic` (CLIs, scripts)
```yaml
# Mesmo que strict, mas mais tolerante
Metrics/LineLength:
  Max: 120

Metrics/MethodLength:
  Max: 25

Metrics/ClassLength:
  Max: 250

Style/Documentation:
  Enabled: false
```

### F. Docker (`Dockerfile` Multi-Stage)

```dockerfile
# Stage 1: Builder
FROM ruby:3.1-slim as builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4

# Stage 2: Development (include test gems)
FROM ruby:3.1-slim as development

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . .

ENV PATH="/usr/local/bundle/bin:$PATH"
ENV BUNDLE_PATH=/usr/local/bundle

CMD ["bash"]

# Stage 3: Production
FROM ruby:3.1-slim as production

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 appuser

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --chown=appuser:appuser . .

USER appuser
ENV PATH="/usr/local/bundle/bin:$PATH"

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
```

### G. Docker Compose (`docker-compose.yml`)

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      target: development
    volumes:
      - .:/app
    environment:
      - BUNDLE_PATH=/usr/local/bundle
    command: bash
    stdin_open: true
    tty: true

  # Optional: Database (PostgreSQL)
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: ${DB_NAME:-app_development}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
```

### H. GitHub Actions (`.github/workflows/ci.yml`)

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: app_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
      - uses: actions/checkout@v3

      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.1
          bundler-cache: true

      - name: Run RuboCop
        run: bundle exec rubocop --display-cop-names --parallel

      - name: Check Dependencies
        run: bundle audit check --update

      - name: Run RSpec
        run: bundle exec rspec --format progress

      - name: Build Docker Image
        run: docker build -t app:test --target development .
```

### I. Exemplo de Domínio (NEW)

**Por que?** Pasta vazia não ensina; exemplo concreto mostra o padrão Hexagonal.

#### `lib/domain/example_entity.rb`
```ruby
# frozen_string_literal: true

module Domain
  class ExampleEntity
    attr_reader :id, :name

    def initialize(id:, name:)
      @id = id
      @name = name
    end

    # Métodos de domínio (lógica pura, sem I/O)
    def persisted?
      id.present?
    end

    def to_h
      { id:, name: }
    end
  end
end
```

#### `lib/ports/example_repository.rb`
```ruby
# frozen_string_literal: true

module Ports
  class ExampleRepository
    # Interface abstrata (contrato)
    def save(entity)
      raise NotImplementedError, "#{self.class} must implement #save"
    end

    def find(id)
      raise NotImplementedError, "#{self.class} must implement #find"
    end
  end
end
```

#### `lib/adapters/in_memory_example_repository.rb`
```ruby
# frozen_string_literal: true

module Adapters
  class InMemoryExampleRepository < Ports::ExampleRepository
    def initialize
      @store = {}
    end

    def save(entity)
      @store[entity.id] = entity
      entity
    end

    def find(id)
      @store[id]
    end
  end
end
```

#### `spec/domain/example_entity_spec.rb`
```ruby
# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/domain/example_entity'

describe Domain::ExampleEntity do
  describe '#persisted?' do
    context 'when id is present' do
      it 'returns true' do
        entity = described_class.new(id: 1, name: 'Test')
        expect(entity).to be_persisted
      end
    end

    context 'when id is nil' do
      it 'returns false' do
        entity = described_class.new(id: nil, name: 'Test')
        expect(entity).not_to be_persisted
      end
    end
  end
end
```

#### `spec/adapters/in_memory_example_repository_spec.rb`
```ruby
# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/domain/example_entity'
require_relative '../../lib/adapters/in_memory_example_repository'

describe Adapters::InMemoryExampleRepository do
  let(:repository) { described_class.new }
  let(:entity) { Domain::ExampleEntity.new(id: 1, name: 'Test') }

  describe '#save' do
    it 'stores entity' do
      repository.save(entity)
      expect(repository.find(1)).to eq(entity)
    end
  end

  describe '#find' do
    it 'returns nil for non-existent entity' do
      expect(repository.find(999)).to be_nil
    end
  end
end
```

---

## 4. Restrições de Desenvolvimento

### Construir com TDD (Test-First)

1. **Antes de escrever qualquer classe geradora**, escreva a spec que valida seu comportamento
2. Exemplo: antes de `CloudMdGenerator`, escreva `spec/generators/claude_md_generator_spec.rb`
3. Use **FakeFS** ou **Tempfile** para não poluir o filesystem
4. Valide:
   - ✅ Arquivo foi criado
   - ✅ Conteúdo contém seções obrigatórias
   - ✅ Idempotência (rodar 2x não duplica linhas)

### Padrões de Código

- **Modular**: Uma classe por responsabilidade
- **Injetável**: Dependências passadas no construtor, não globais
- **Testável**: Sem I/O real em specs (mock/stub)
- **Limpo**: RuboCop estrito (`--auto-gen-config` proibido)

### Versionamento

- Comece em `0.1.0` (ainda em desenvolvimento)
- `lib/agentic_bootstrap/version.rb`:
  ```ruby
  module AgenticBootstrap
    VERSION = '0.1.0'
  end
  ```
- `CHANGELOG.md` com template semver (Keep a Changelog)
- Rake task para bump de versão

---

## 5. Output Esperado — Fases

### **Fase 1: Estrutura Inicial + Primeiro Teste**
Entrega:
- [ ] Estrutura de pastas da gem
- [ ] `Gemfile` com dependências
- [ ] `spec/spec_helper.rb` configurado
- [ ] `.rspec` pronto
- [ ] **Primeiro teste**: `spec/generators/claude_md_generator_spec.rb`
  - Valida que `ClaudeMdGenerator` gera `CLAUDE.md`
  - Valida conteúdo mínimo (seções obrigatórias)
- [ ] Aguarda aprovação humana para continuar

### **Fase 2: Implementação de Geradores (Red → Green)**
Para cada gerador:
1. Escrever spec completa (Red)
2. Implementar classe geradora (Green)
3. Refatorar (extrair base comum)
4. Rodar `rubocop -A` (auto-fix, depois revisar)

Geradores:
- [ ] `ClaudeMdGenerator` → `CLAUDE.md`
- [ ] `RoadmapGenerator` → `ROADMAP.md`
- [ ] `ClignoreGenerator` → `.clignore`
- [ ] `RspecGenerator` → `.rspec` + `spec_helper.rb`
- [ ] `RubocopGenerator` → `.rubocop.yml` (profiles)
- [ ] `DockerfileGenerator` → `Dockerfile` (multi-stage)
- [ ] `DockerComposeGenerator` → `docker-compose.yml`
- [ ] `GitHubActionsGenerator` → `.github/workflows/ci.yml`
- [ ] `ExampleDomainGenerator` → pasta `lib/domain/` com exemplo

### **Fase 3: CLI (Thor) + Integração**
- [ ] `Cli` class com comando `init`
- [ ] Orquestrar geradores em sequência
- [ ] Suportar opções (`--no-docker`, `--profile`, etc.)
- [ ] Idempotência: rodar 2x não quebra nada
- [ ] Testes de integração (todos os geradores juntos)

### **Fase 4: Testes e Polimento**
- [ ] 100% cobertura de testes
- [ ] RuboCop limpo (zero offenses)
- [ ] `README.md` com instruções de uso
- [ ] `CHANGELOG.md` preenchido
- [ ] `agentic_bootstrap.gemspec` pronto

---

## 6. Como Usar a Gem (Output Final)

```bash
cd /caminho/para/seu/projeto/ruby

# Instalar (local)
gem install agentic_bootstrap

# Ou adicionar ao Gemfile
gem 'agentic_bootstrap', '~> 0.1.0'
bundle install

# Usar
agentic_bootstrap init
# → Cria CLAUDE.md, ROADMAP.md, .clignore, .rspec, spec_helper, etc.

agentic_bootstrap init --profile pragmatic --no-ci
# → Sem GitHub Actions, RuboCop com perfil pragmático

# Verificar o que foi criado
git status
# → Mostra arquivos novos gerados

# Rodar testes
bundle exec rspec
bundle exec rubocop
```

---

## 7. Lições do AIAD para Aplicar

| Lição | Aplicação |
|-------|-----------|
| **Injeção de Dependência** | Geradores recebem filesystem mock em testes |
| **Separação de Responsabilidades** | Uma classe por tipo de artefato |
| **Testes como Documentação** | Specs definem o contrato de cada gerador |
| **Idempotência** | Rodar `init` 2x não duplica/quebra nada |
| **Sem I/O em Testes** | Use FakeFS ou Tempfile, nunca toque no disco real |
| **Decisões Explícitas** | `CLAUDE.md` ensina quando a IA pode agir sozinha |
| **Exemplo Concreto** | Não deixar pasta vazia; dar um exemplo real |
| **Versionamento Claro** | Semver, CHANGELOG, version.rb sincronizados |

---

## Resumo: Por Que Este Prompt É Melhor

✅ **Explícito**: Define cada artefato, cada arquivo, cada linha de código esperada
✅ **Educacional**: Ensina Arquitetura Hexagonal com exemplo
✅ **Pragmático**: Oferece profiles (strict/pragmatic), opções (--no-docker, etc.)
✅ **Seguro para IA**: `CLAUDE.md` define o que a IA pode fazer sozinha
✅ **Pronto para Produção**: Docker, CI, observabilidade inclusos
✅ **TDD-First**: Força testes antes de código
✅ **Inspirado em Projeto Real**: Lições do AIAD aplicadas
✅ **Escalável**: Reutilizável em n repositórios (task_keeper_api, AIAD, etc.)

---

## Próximos Passos (Para Hirley)

1. **Revisar este prompt**: Faz sentido? Falta algo?
2. **Ativar Claude Code** com este prompt (copie `prompt_gem_ruby` completo)
3. **Fase 1**: Deixar a IA criar estrutura + primeiro teste (valide com `bundle exec rspec`)
4. **Fases 2-4**: Iterativa, com review humano a cada fase
5. **Publicar**: `gem push agentic_bootstrap` (depois de 0.1.0 pronto)
6. **Reutilizar**: `agentic_bootstrap init` em task_keeper_api, novos projetos, etc.

---

## Dúvidas Frequentes

**P: Por que não usar `rails new`?**
R: `rails new` é para Rails. Essa gem é agnóstica (funciona em Ruby puro, gems customizadas, etc.). Também ensina Hexagonal sem travas do Rails.

**P: Por que dois profiles de RuboCop?**
R: Uma API precisa de disciplina rigorosa. Um CLI pode ser pragmático. Forçar um em ambos desperdiça tempo.

**P: FakeFS vs Tempfile?**
R: FakeFS isola a teste inteira (sem tocar disco). Tempfile cria arquivo real (mais integrado). Use FakeFS por padrão, Tempfile se precisar validar permissões.

**P: Como a gem escala para Python/JavaScript?**
R: A estrutura CLI (Thor) fica, os templates mudam. `--language python` seria:
- Gera `pyproject.toml` em vez de `Gemfile`
- Gera `pytest.ini` em vez de `.rspec`
- Gera `Dockerfile` com Python 3.11
- Mesmo `CLAUDE.md`, mesmo `ROADMAP.md`

---

**Autor**: Hirley Esmeraldo Ribeiro
**Data**: Agosto 2026
**Inspiração**: Projeto AIAD — padrões comprovados em produção
