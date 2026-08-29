# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_bootstrap/generators/dockerfile_generator'

RSpec.describe AgenticBootstrap::Generators::DockerfileGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:generator) { described_class.new(target_dir: target_dir) }
  let(:dockerfile_path) { File.join(target_dir, 'Dockerfile') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria o Dockerfile no diretório alvo' do
      generator.generate

      expect(File.exist?(dockerfile_path)).to be true
    end

    it 'inclui os estágios obrigatórios (multi-stage)' do
      generator.generate
      content = File.read(dockerfile_path)

      expect(content).to include('AS builder')
      expect(content).to include('AS development')
      expect(content).to include('AS production')
    end

    it 'não sobrescreve um Dockerfile já existente (idempotência)' do
      File.write(dockerfile_path, 'conteúdo customizado pelo usuário')

      generator.generate

      expect(File.read(dockerfile_path)).to eq('conteúdo customizado pelo usuário')
    end
  end
end
