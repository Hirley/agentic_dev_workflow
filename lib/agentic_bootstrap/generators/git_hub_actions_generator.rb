# frozen_string_literal: true

require_relative 'base_generator'

module AgenticBootstrap
  module Generators
    # Gera .github/workflows/ci.yml no diretório alvo. Não sobrescreve um
    # ci.yml existente.
    class GitHubActionsGenerator < BaseGenerator
      TEMPLATE = load_template('ci.yml.erb')

      def generate
        write_file(File.join('.github', 'workflows', 'ci.yml'), render(TEMPLATE))
      end
    end
  end
end
