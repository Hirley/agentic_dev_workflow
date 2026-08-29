# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_bootstrap/generators/git_hub_actions_generator'

RSpec.describe AgenticBootstrap::Generators::GitHubActionsGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:generator) { described_class.new(target_dir: target_dir) }
  let(:ci_path) { File.join(target_dir, '.github', 'workflows', 'ci.yml') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria o arquivo .github/workflows/ci.yml no diretório alvo' do
      generator.generate

      expect(File.exist?(ci_path)).to be true
    end

    it 'inclui os passos obrigatórios' do
      generator.generate
      content = File.read(ci_path)

      expect(content).to include('bundle exec rspec')
      expect(content).to include('bundle exec rubocop')
    end

    it 'não sobrescreve um ci.yml já existente (idempotência)' do
      FileUtils.mkdir_p(File.join(target_dir, '.github', 'workflows'))
      File.write(ci_path, 'conteúdo customizado pelo usuário')

      generator.generate

      expect(File.read(ci_path)).to eq('conteúdo customizado pelo usuário')
    end
  end
end
