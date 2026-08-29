# frozen_string_literal: true

require_relative 'base_generator'

module AgenticBootstrap
  module Generators
    # Gera o arquivo .clignore no diretório alvo, listando arquivos que
    # assistentes de IA não devem ler. Não sobrescreve um .clignore existente.
    class ClignoreGenerator < BaseGenerator
      TEMPLATE = load_template('clignore.erb')

      def generate
        write_file('.clignore', render(TEMPLATE))
      end
    end
  end
end
