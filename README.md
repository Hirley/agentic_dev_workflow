# agentic_bootstrap

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
gem build agentic_bootstrap.gemspec
gem install ./agentic_bootstrap-0.1.0.gem

# Ou via Gemfile
gem 'agentic_bootstrap', '~> 0.1.0'
bundle install
```

## Uso

```bash
cd /caminho/para/seu/projeto/ruby

agentic_bootstrap init
# → Cria CLAUDE.md, ROADMAP.md, .clignore, .rspec, spec_helper, etc.

agentic_bootstrap init --profile pragmatic --no-ci
# → Sem GitHub Actions, RuboCop com perfil pragmático
```

### Opções do comando `init`

| Opção | Efeito |
|---|---|
| `--no-docker` | Pula `Dockerfile` e `docker-compose.yml` |
| `--no-ci` | Pula `.github/workflows/ci.yml` |
| `--no-observability` | Pula stack de observabilidade |
| `--profile [strict\|pragmatic]` | Escolhe o perfil do RuboCop |
| `--language [ruby\|python]` | Linguagem alvo (extensível) |
| `--example-domain NAME` | Nomeia o exemplo de domínio gerado |

## Desenvolvimento

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

Este projeto segue TDD (Red → Green → Refactor). Veja [CLAUDE.md](CLAUDE.md)
para o workflow completo de colaboração com IA e [ROADMAP.md](ROADMAP.md)
para o plano de fases.

## Licença

MIT — veja [LICENSE](LICENSE).

## Autor

Hirley Esmeraldo Ribeiro
