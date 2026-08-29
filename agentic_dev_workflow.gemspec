# frozen_string_literal: true

require_relative 'lib/agentic_dev_workflow/version'

Gem::Specification.new do |spec|
  spec.name = 'agentic_dev_workflow'
  spec.version = AgenticDevWorkflow::VERSION
  spec.authors = ['Hirley Esmeraldo Ribeiro']

  spec.summary = 'Gem CLI (Thor) que inicializa repositórios Ruby com um ambiente agentic-ready.'
  spec.description = 'Inicializa repositórios Ruby existentes com Arquitetura Hexagonal, ' \
                     'TDD-first, guias de colaboração IA-humano (CLAUDE.md/ROADMAP.md), ' \
                     'Docker, CI/CD e observabilidade (Prometheus/Grafana).'
  spec.homepage = 'https://github.com/Hirley/agentic_dev_workflow'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    Dir['lib/**/*.rb', 'lib/**/*.erb', 'exe/*', 'README.md', 'CHANGELOG.md', 'LICENSE',
        'agentic_dev_workflow.gemspec']
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 1.2'
end
