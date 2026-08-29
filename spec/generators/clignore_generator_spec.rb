# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_bootstrap/generators/clignore_generator'

RSpec.describe AgenticBootstrap::Generators::ClignoreGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:generator) { described_class.new(target_dir: target_dir) }
  let(:clignore_path) { File.join(target_dir, '.clignore') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria o arquivo .clignore no diretório alvo' do
      generator.generate

      expect(File.exist?(clignore_path)).to be true
    end

    it 'inclui os padrões obrigatórios' do
      generator.generate
      content = File.read(clignore_path)

      expect(content).to include('.env')
      expect(content).to include('*.key')
    end

    it 'não sobrescreve um .clignore já existente (idempotência)' do
      File.write(clignore_path, 'conteúdo customizado pelo usuário')

      generator.generate

      expect(File.read(clignore_path)).to eq('conteúdo customizado pelo usuário')
    end
  end
end
