# frozen_string_literal: true

require 'erb'
require 'fileutils'

module AgenticBootstrap
  module Generators
    # Classe base para geradores de arquivos: garante idempotência
    # (nunca sobrescreve um arquivo já existente) e centraliza a
    # renderização de templates ERB.
    class BaseGenerator
      TEMPLATES_DIR = File.expand_path('../templates', __dir__)

      def initialize(target_dir:)
        @target_dir = target_dir
      end

      # Lê o template do disco real. Deve ser chamado no corpo da classe
      # (ex.: `TEMPLATE = load_template('foo.erb')`) para que a leitura
      # aconteça no `require`, antes de qualquer FakeFS ser ativado pelas specs.
      def self.load_template(template_name)
        File.read(File.join(TEMPLATES_DIR, template_name))
      end

      private

      attr_reader :target_dir

      def write_file(relative_path, content)
        full_path = File.join(target_dir, relative_path)
        return if File.exist?(full_path)

        FileUtils.mkdir_p(File.dirname(full_path))
        File.write(full_path, content)
      end

      def render(template_source, locals = {})
        ERB.new(template_source).result_with_hash(locals)
      end
    end
  end
end
