# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'agentic_dev_workflow/cli'

RSpec.describe AgenticDevWorkflow::CLI do
  include FakeFS::SpecHelpers

  let(:target_dir) { '/fake/project' }

  before { FileUtils.mkdir_p(target_dir) }

  def path_in_target(*parts)
    File.join(target_dir, *parts)
  end

  describe '#init' do
    it 'gera todos os arquivos esperados com as opções padrão' do
      described_class.start(['init', target_dir])

      expect(File.exist?(path_in_target('CLAUDE.md'))).to be true
      expect(File.exist?(path_in_target('ROADMAP.md'))).to be true
      expect(File.exist?(path_in_target('.clignore'))).to be true
      expect(File.exist?(path_in_target('.rspec'))).to be true
      expect(File.exist?(path_in_target('spec', 'spec_helper.rb'))).to be true
      expect(File.exist?(path_in_target('.rubocop.yml'))).to be true
      expect(File.exist?(path_in_target('Dockerfile'))).to be true
      expect(File.exist?(path_in_target('docker-compose.yml'))).to be true
      expect(File.exist?(path_in_target('.github', 'workflows', 'ci.yml'))).to be true
      expect(File.exist?(path_in_target('docker-compose.observability.yml'))).to be true
      expect(File.exist?(path_in_target('observability', 'prometheus.yml'))).to be true
    end

    it 'não gera a stack de observabilidade quando --no-observability' do
      described_class.start(['init', target_dir, '--no-observability'])

      expect(File.exist?(path_in_target('docker-compose.observability.yml'))).to be false
      expect(File.exist?(path_in_target('observability', 'prometheus.yml'))).to be false
    end

    it 'não gera Dockerfile nem docker-compose.yml quando --no-docker' do
      described_class.start(['init', target_dir, '--no-docker'])

      expect(File.exist?(path_in_target('Dockerfile'))).to be false
      expect(File.exist?(path_in_target('docker-compose.yml'))).to be false
    end

    it 'não gera .github/workflows/ci.yml quando --no-ci' do
      described_class.start(['init', target_dir, '--no-ci'])

      expect(File.exist?(path_in_target('.github', 'workflows', 'ci.yml'))).to be false
    end

    it 'gera o exemplo de domínio nomeado quando --example-domain é informado' do
      described_class.start(['init', target_dir, '--example-domain', 'invoice'])

      expect(File.exist?(path_in_target('lib', 'domain', 'invoice.rb'))).to be true
    end

    it 'não gera exemplo de domínio quando --example-domain não é informado' do
      described_class.start(['init', target_dir])

      expect(Dir.exist?(path_in_target('lib', 'domain'))).to be false
    end

    it 'aplica o perfil strict no .rubocop.yml quando --profile=strict' do
      described_class.start(['init', target_dir, '--profile', 'strict'])

      expect(File.read(path_in_target('.rubocop.yml'))).to include('perfil: strict')
    end

    it 'é idempotente: rodar duas vezes não altera um arquivo já customizado' do
      described_class.start(['init', target_dir])
      claude_md_path = path_in_target('CLAUDE.md')
      File.write(claude_md_path, 'conteúdo customizado pelo usuário')

      described_class.start(['init', target_dir])

      expect(File.read(claude_md_path)).to eq('conteúdo customizado pelo usuário')
    end
  end
end
