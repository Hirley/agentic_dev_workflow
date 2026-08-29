# frozen_string_literal: true

require 'thor'
require_relative 'generators/claude_md_generator'
require_relative 'generators/roadmap_generator'
require_relative 'generators/clignore_generator'
require_relative 'generators/rspec_generator'
require_relative 'generators/rubocop_generator'
require_relative 'generators/dockerfile_generator'
require_relative 'generators/docker_compose_generator'
require_relative 'generators/git_hub_actions_generator'
require_relative 'generators/example_domain_generator'
require_relative 'generators/observability_generator'

module AgenticBootstrap
  # CLI (Thor) da gem. Orquestra os geradores para montar o ambiente
  # agentic_bootstrap no diretório alvo. Rodar `init` mais de uma vez é
  # seguro: cada gerador é idempotente e não sobrescreve arquivos existentes.
  class CLI < Thor
    desc 'init [DIR]', 'Inicializa DIR (padrão: diretório atual) com o ambiente agentic_bootstrap'
    method_option :docker, type: :boolean, default: true, desc: 'Gera Dockerfile e docker-compose.yml'
    method_option :ci, type: :boolean, default: true, desc: 'Gera .github/workflows/ci.yml'
    method_option :observability, type: :boolean, default: true, desc: 'Gera stack de observabilidade'
    method_option :profile, type: :string, default: 'pragmatic', enum: %w[strict pragmatic],
                            desc: 'Perfil do RuboCop'
    method_option :language, type: :string, default: 'ruby', enum: %w[ruby], desc: 'Linguagem alvo'
    method_option :example_domain, type: :string, default: nil, desc: 'Nomeia o exemplo de domínio gerado'
    def init(dir = '.')
      target_dir = File.expand_path(dir)

      build_generators(target_dir).each(&:generate)
    end

    private

    def build_generators(target_dir)
      base_generators(target_dir) + optional_generators(target_dir)
    end

    def base_generators(target_dir)
      [
        Generators::ClaudeMdGenerator.new(target_dir: target_dir),
        Generators::RoadmapGenerator.new(target_dir: target_dir),
        Generators::ClignoreGenerator.new(target_dir: target_dir),
        Generators::RspecGenerator.new(target_dir: target_dir),
        Generators::RubocopGenerator.new(target_dir: target_dir, profile: options['profile'])
      ]
    end

    def optional_generators(target_dir)
      generators = []
      generators.concat(docker_generators(target_dir)) if options['docker']
      generators << Generators::GitHubActionsGenerator.new(target_dir: target_dir) if options['ci']
      generators << example_domain_generator(target_dir) if options['example_domain']
      generators << Generators::ObservabilityGenerator.new(target_dir: target_dir) if options['observability']
      generators
    end

    def docker_generators(target_dir)
      [
        Generators::DockerfileGenerator.new(target_dir: target_dir),
        Generators::DockerComposeGenerator.new(target_dir: target_dir)
      ]
    end

    def example_domain_generator(target_dir)
      Generators::ExampleDomainGenerator.new(target_dir: target_dir, entity_name: options['example_domain'])
    end
  end
end
