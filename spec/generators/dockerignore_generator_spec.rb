# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_dev_workflow/generators/dockerignore_generator'

RSpec.describe AgenticDevWorkflow::Generators::DockerignoreGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:generator) { described_class.new(target_dir: target_dir) }
  let(:dockerignore_path) { File.join(target_dir, '.dockerignore') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria o arquivo .dockerignore no diretório alvo' do
      generator.generate

      expect(File.exist?(dockerignore_path)).to be true
    end

    it 'exclui segredos e o histórico do git do contexto de build' do
      generator.generate
      content = File.read(dockerignore_path)

      expect(content).to include('.git')
      expect(content).to include('.env')
      expect(content).to include('*.pem')
      expect(content).to include('*.key')
      expect(content).to include('config/master.key')
    end

    it 'não exclui spec/ (necessário para o estágio development rodar rspec no container)' do
      generator.generate
      content = File.read(dockerignore_path)

      expect(content).not_to include('/spec/')
    end

    it 'não sobrescreve um .dockerignore já existente (idempotência)' do
      File.write(dockerignore_path, 'conteúdo customizado pelo usuário')

      generator.generate

      expect(File.read(dockerignore_path)).to eq('conteúdo customizado pelo usuário')
    end
  end
end
