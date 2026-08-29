# frozen_string_literal: true

require_relative 'base_generator'

module AgenticBootstrap
  module Generators
    # Gera um Dockerfile multi-stage (builder/development/production) no
    # diretório alvo. Não sobrescreve um Dockerfile existente.
    class DockerfileGenerator < BaseGenerator
      TEMPLATE = load_template('Dockerfile.erb')

      def generate
        write_file('Dockerfile', render(TEMPLATE))
      end
    end
  end
end
