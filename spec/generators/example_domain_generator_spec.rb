# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_bootstrap/generators/example_domain_generator'

RSpec.describe AgenticBootstrap::Generators::ExampleDomainGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:generator) { described_class.new(target_dir: target_dir) }
  let(:domain_path) { File.join(target_dir, 'lib', 'domain', 'task.rb') }
  let(:port_path) { File.join(target_dir, 'lib', 'ports', 'task_repository.rb') }
  let(:adapter_path) { File.join(target_dir, 'lib', 'adapters', 'in_memory_task_repository.rb') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria os arquivos de domain, ports e adapters no diretório alvo' do
      generator.generate

      expect(File.exist?(domain_path)).to be true
      expect(File.exist?(port_path)).to be true
      expect(File.exist?(adapter_path)).to be true
    end

    it 'inclui as seções obrigatórias em cada camada' do
      generator.generate

      expect(File.read(domain_path)).to include('module Domain')
      expect(File.read(port_path)).to include('module Ports')
      expect(File.read(adapter_path)).to include('module Adapters')
    end

    it 'não sobrescreve arquivos já existentes (idempotência)' do
      FileUtils.mkdir_p(File.join(target_dir, 'lib', 'domain'))
      File.write(domain_path, 'conteúdo customizado pelo usuário')

      generator.generate

      expect(File.read(domain_path)).to eq('conteúdo customizado pelo usuário')
    end

    it 'nomeia os arquivos e classes a partir de entity_name' do
      custom_generator = described_class.new(target_dir: target_dir, entity_name: 'invoice')

      custom_generator.generate

      invoice_path = File.join(target_dir, 'lib', 'domain', 'invoice.rb')
      expect(File.exist?(invoice_path)).to be true
      expect(File.read(invoice_path)).to include('class Invoice')
    end
  end
end
