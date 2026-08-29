# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_bootstrap/generators/docker_compose_generator'

RSpec.describe AgenticBootstrap::Generators::DockerComposeGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:generator) { described_class.new(target_dir: target_dir) }
  let(:compose_path) { File.join(target_dir, 'docker-compose.yml') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria o docker-compose.yml no diretório alvo' do
      generator.generate

      expect(File.exist?(compose_path)).to be true
    end

    it 'inclui as seções obrigatórias' do
      generator.generate
      content = File.read(compose_path)

      expect(content).to include('services')
      expect(content).to include('build')
    end

    it 'não sobrescreve um docker-compose.yml já existente (idempotência)' do
      File.write(compose_path, 'conteúdo customizado pelo usuário')

      generator.generate

      expect(File.read(compose_path)).to eq('conteúdo customizado pelo usuário')
    end
  end
end
