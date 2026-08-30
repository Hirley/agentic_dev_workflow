# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_dev_workflow/generators/gitignore_generator'

RSpec.describe AgenticDevWorkflow::Generators::GitignoreGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:generator) { described_class.new(target_dir: target_dir) }
  let(:gitignore_path) { File.join(target_dir, '.gitignore') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria o arquivo .gitignore no diretório alvo' do
      generator.generate

      expect(File.exist?(gitignore_path)).to be true
    end

    it 'inclui os padrões de segredos e credenciais' do
      generator.generate
      content = File.read(gitignore_path)

      expect(content).to include('.env')
      expect(content).to include('*.pem')
      expect(content).to include('*.key')
      expect(content).to include('config/master.key')
    end

    it 'inclui os artefatos padrão de um projeto Ruby' do
      generator.generate
      content = File.read(gitignore_path)

      expect(content).to include('/coverage/')
      expect(content).to include('/tmp/')
      expect(content).to include('/log/')
      expect(content).to include('*.gem')
    end

    it 'não sobrescreve um .gitignore já existente (idempotência)' do
      File.write(gitignore_path, 'conteúdo customizado pelo usuário')

      generator.generate

      expect(File.read(gitignore_path)).to eq('conteúdo customizado pelo usuário')
    end
  end
end
