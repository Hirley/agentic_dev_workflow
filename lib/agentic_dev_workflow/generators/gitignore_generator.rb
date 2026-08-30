# frozen_string_literal: true

require_relative 'base_generator'

module AgenticDevWorkflow
  module Generators
    # Gera o arquivo .gitignore no diretório alvo, cobrindo os mesmos
    # padrões sensíveis listados em .clignore (segredos, credenciais) mais
    # os artefatos padrão de um projeto Ruby. Não sobrescreve um .gitignore
    # existente.
    class GitignoreGenerator < BaseGenerator
      TEMPLATE = load_template('gitignore.erb')

      def generate
        write_file('.gitignore', render(TEMPLATE))
      end
    end
  end
end
