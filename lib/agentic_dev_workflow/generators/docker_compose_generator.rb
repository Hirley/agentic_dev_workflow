# frozen_string_literal: true

require_relative 'base_generator'

module AgenticDevWorkflow
  module Generators
    # Gera docker-compose.yml no diretório alvo. Não sobrescreve um
    # docker-compose.yml existente.
    class DockerComposeGenerator < BaseGenerator
      TEMPLATE = load_template('docker-compose.yml.erb')

      def generate
        write_file('docker-compose.yml', render(TEMPLATE))
      end
    end
  end
end
