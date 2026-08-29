# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_bootstrap/generators/claude_md_generator'

RSpec.describe AgenticBootstrap::Generators::ClaudeMdGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:generator) { described_class.new(target_dir: target_dir) }
  let(:claude_md_path) { File.join(target_dir, 'CLAUDE.md') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria o arquivo CLAUDE.md no diretório alvo' do
      generator.generate

      expect(File.exist?(claude_md_path)).to be true
    end

    it 'inclui as seções obrigatórias' do
      generator.generate
      content = File.read(claude_md_path)

      expect(content).to include('Spec-Driven Development')
      expect(content).to include('Decisões da IA')
      expect(content).to include('Decisões que Exigem Humano')
    end

    it 'não sobrescreve um CLAUDE.md já existente (idempotência)' do
      File.write(claude_md_path, 'conteúdo customizado pelo usuário')

      generator.generate

      expect(File.read(claude_md_path)).to eq('conteúdo customizado pelo usuário')
    end
  end
end
