# agentic_dev_workflow

Gem CLI (Thor) que inicializa repositórios Ruby existentes com um ambiente
otimizado para colaboração entre humanos e IAs (Claude Code, Claude em
conversas normais, ou futuros agentes).

Rodada uma vez no diretório do projeto, a gem injeta:

1. Arquitetura Hexagonal pronta para uso, com exemplo concreto
2. TDD/BDD como cidadão de primeira classe
3. Guias e contratos explícitos para desenvolvimento com IA (`CLAUDE.md`)
4. Infraestrutura local (Docker) e em nuvem (CI/CD)
5. Observabilidade desde o início
6. Boas práticas de versionamento e changelog

Projeto inspirado nas decisões arquiteturais do
[AIAD — Assistente Inteligente de Análise de Documentos](https://github.com/Hirley/AIAD).

## Status

Em desenvolvimento inicial (`0.1.0`). Acompanhe o progresso no
[ROADMAP.md](ROADMAP.md) e no board do projeto no GitHub.

A especificação completa que guia esta implementação está em
[docs/prompt_gem_ruby_v2.md](docs/prompt_gem_ruby_v2.md).

## Instalação

```bash
# Local (enquanto em desenvolvimento)
gem build agentic_dev_workflow.gemspec
gem install ./agentic_dev_workflow-0.1.0.gem

# Ou via Gemfile
gem 'agentic_dev_workflow', '~> 0.1.0'
bundle install
```

## Uso

```bash
cd /caminho/para/seu/projeto/ruby

agentic_dev_workflow init
# → Cria CLAUDE.md, ROADMAP.md, .clignore, .rspec, spec_helper, etc.

agentic_dev_workflow init --profile pragmatic --no-ci
# → Sem GitHub Actions, RuboCop com perfil pragmático
```

### Opções do comando `init`

| Opção | Efeito |
|---|---|
| `--no-docker` | Pula `Dockerfile` e `docker-compose.yml` |
| `--no-ci` | Pula `.github/workflows/ci.yml` |
| `--no-observability` | Pula stack de observabilidade |
| `--profile [strict\|pragmatic]` | Escolhe o perfil do RuboCop |
| `--language [ruby]` | Linguagem alvo — placeholder reservado para o futuro; hoje só `ruby` é aceito e a opção não muda nenhum gerador |
| `--example-domain NAME` | Nomeia o exemplo de domínio gerado |

## Desenvolvimento

```bash
bundle install
bundle exec rspec
bundle exec rubocop
bundle exec rake      # roda specs + RuboCop (task padrão)
```

Este projeto segue TDD (Red → Green → Refactor). Veja [CLAUDE.md](CLAUDE.md)
para o workflow completo de colaboração com IA e [ROADMAP.md](ROADMAP.md)
para o plano de fases.

### Build da gem

```bash
gem build agentic_dev_workflow.gemspec
```

Gera o pacote `.gem` localmente para inspeção/instalação manual. Publicar no
RubyGems (`gem push`) é uma decisão que exige aprovação humana explícita
(veja [CLAUDE.md](CLAUDE.md)).

## Licença

MIT — veja [LICENSE](LICENSE).

## Autor

Hirley Esmeraldo Ribeiro
