# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_dev_workflow/generators/observability_generator'

RSpec.describe AgenticDevWorkflow::Generators::ObservabilityGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:generator) { described_class.new(target_dir: target_dir) }
  let(:compose_path) { File.join(target_dir, 'docker-compose.observability.yml') }
  let(:prometheus_path) { File.join(target_dir, 'observability', 'prometheus.yml') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria o docker-compose.observability.yml e o observability/prometheus.yml no diretório alvo' do
      generator.generate

      expect(File.exist?(compose_path)).to be true
      expect(File.exist?(prometheus_path)).to be true
    end

    it 'inclui os serviços obrigatórios de observabilidade' do
      generator.generate
      compose_content = File.read(compose_path)
      prometheus_content = File.read(prometheus_path)

      expect(compose_content).to include('prometheus')
      expect(compose_content).to include('grafana')
      expect(prometheus_content).to include('scrape_configs')
    end

    it 'não fixa uma senha padrão insegura para o Grafana' do
      generator.generate
      content = File.read(compose_path)

      expect(content).not_to include('GF_SECURITY_ADMIN_PASSWORD=admin')
      expect(content).to include('GRAFANA_ADMIN_PASSWORD')
    end

    it 'não sobrescreve arquivos já existentes (idempotência)' do
      FileUtils.mkdir_p(File.join(target_dir, 'observability'))
      File.write(compose_path, 'conteúdo customizado pelo usuário')
      File.write(prometheus_path, 'conteúdo customizado pelo usuário')

      generator.generate

      expect(File.read(compose_path)).to eq('conteúdo customizado pelo usuário')
      expect(File.read(prometheus_path)).to eq('conteúdo customizado pelo usuário')
    end
  end
end
