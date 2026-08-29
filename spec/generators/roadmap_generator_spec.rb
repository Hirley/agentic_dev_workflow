# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_dev_workflow/generators/roadmap_generator'

RSpec.describe AgenticDevWorkflow::Generators::RoadmapGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:generator) { described_class.new(target_dir: target_dir) }
  let(:roadmap_path) { File.join(target_dir, 'ROADMAP.md') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria o arquivo ROADMAP.md no diretório alvo' do
      generator.generate

      expect(File.exist?(roadmap_path)).to be true
    end

    it 'inclui as seções obrigatórias' do
      generator.generate
      content = File.read(roadmap_path)

      expect(content).to include('Roadmap')
      expect(content).to include('Fase 1')
      expect(content).to include('CLAUDE.md')
    end

    it 'não sobrescreve um ROADMAP.md já existente (idempotência)' do
      File.write(roadmap_path, 'conteúdo customizado pelo usuário')

      generator.generate

      expect(File.read(roadmap_path)).to eq('conteúdo customizado pelo usuário')
    end
  end
end
