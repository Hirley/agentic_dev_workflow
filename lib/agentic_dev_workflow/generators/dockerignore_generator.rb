# frozen_string_literal: true

require_relative 'base_generator'

module AgenticDevWorkflow
  module Generators
    # Gera o arquivo .dockerignore no diretório alvo, evitando que segredos
    # (.env, *.pem, *.key) e o histórico do .git entrem no contexto de build
    # e, por consequência, nas camadas da imagem gerada pelo Dockerfile. Não
    # sobrescreve um .dockerignore existente.
    class DockerignoreGenerator < BaseGenerator
      TEMPLATE = load_template('dockerignore.erb')

      def generate
        write_file('.dockerignore', render(TEMPLATE))
      end
    end
  end
end
