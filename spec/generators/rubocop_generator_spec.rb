# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_dev_workflow/generators/rubocop_generator'

RSpec.describe AgenticDevWorkflow::Generators::RubocopGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:rubocop_path) { File.join(target_dir, '.rubocop.yml') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria o arquivo .rubocop.yml no diretório alvo (perfil padrão pragmatic)' do
      generator = described_class.new(target_dir: target_dir)

      generator.generate

      expect(File.exist?(rubocop_path)).to be true
      expect(File.read(rubocop_path)).to include('AllCops')
    end

    it 'aplica o perfil strict quando solicitado' do
      generator = described_class.new(target_dir: target_dir, profile: 'strict')

      generator.generate

      expect(File.read(rubocop_path)).to include('perfil: strict')
    end

    it 'rejeita um perfil inválido' do
      expect do
        described_class.new(target_dir: target_dir, profile: 'inexistente')
      end.to raise_error(ArgumentError)
    end

    it 'não sobrescreve um .rubocop.yml já existente (idempotência)' do
      File.write(rubocop_path, 'conteúdo customizado pelo usuário')

      described_class.new(target_dir: target_dir).generate

      expect(File.read(rubocop_path)).to eq('conteúdo customizado pelo usuário')
    end
  end
end
