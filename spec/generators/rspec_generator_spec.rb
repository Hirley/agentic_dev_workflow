# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_bootstrap/generators/rspec_generator'

RSpec.describe AgenticBootstrap::Generators::RspecGenerator do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }
  let(:generator) { described_class.new(target_dir: target_dir) }
  let(:dot_rspec_path) { File.join(target_dir, '.rspec') }
  let(:spec_helper_path) { File.join(target_dir, 'spec', 'spec_helper.rb') }

  before { FileUtils.mkdir_p(target_dir) }

  describe '#generate' do
    it 'cria o arquivo .rspec e spec/spec_helper.rb no diretório alvo' do
      generator.generate

      expect(File.exist?(dot_rspec_path)).to be true
      expect(File.exist?(spec_helper_path)).to be true
    end

    it 'inclui as configurações obrigatórias' do
      generator.generate

      expect(File.read(dot_rspec_path)).to include('--require spec_helper')
      expect(File.read(spec_helper_path)).to include('RSpec.configure')
    end

    it 'não sobrescreve arquivos já existentes (idempotência)' do
      FileUtils.mkdir_p(File.join(target_dir, 'spec'))
      File.write(dot_rspec_path, 'conteúdo customizado')
      File.write(spec_helper_path, 'conteúdo customizado')

      generator.generate

      expect(File.read(dot_rspec_path)).to eq('conteúdo customizado')
      expect(File.read(spec_helper_path)).to eq('conteúdo customizado')
    end
  end
end
